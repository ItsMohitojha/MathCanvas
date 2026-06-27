import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/core/utils/uuid_generator.dart';
import 'package:mathcanvas/shared/database/database_provider.dart';
import 'package:mathcanvas/features/recognition/presentation/providers/recognition_state_provider.dart';
import 'package:mathcanvas/features/recognition/domain/models/recognized_expression.dart';
import 'math_state.dart';
import '../../domain/repositories/math_repository.dart';
import '../../domain/models/math_result.dart';
import '../../domain/models/variable.dart';
import '../../data/datasources/math_api_client.dart';
import '../../data/datasources/math_local_datasource.dart';
import '../../data/repositories/math_repository_impl.dart';

/// Provider for the Math API Client.
final mathApiClientProvider = Provider<MathApiClient>((ref) {
  return MathApiClient();
});

/// Provider for the Math Local Datasource.
final mathLocalDatasourceProvider = Provider<MathLocalDatasource>((ref) {
  final dbFuture = ref.watch(databaseProvider);
  return MathLocalDatasourceImpl(dbFuture);
});

/// Provider for the Math Repository.
final mathRepositoryProvider = Provider<MathRepository>((ref) {
  final api = ref.watch(mathApiClientProvider);
  final local = ref.watch(mathLocalDatasourceProvider);
  return MathRepositoryImpl(api, local);
});

/// Riverpod provider managing the Math Engine state.
final mathStateProvider = NotifierProvider<MathStateNotifier, MathState>(
  MathStateNotifier.new,
);

/// Notifier that manages expression evaluation, symbol tables, and recursive dependency propagation.
class MathStateNotifier extends Notifier<MathState> {
  String? _lastNotebookId;

  @override
  MathState build() {
    final recognitionState = ref.watch(recognitionStateProvider);
    final expressions = recognitionState.expressions;

    // Retrieve active notebook ID from the expressions (all share the same notebookId)
    final notebookId = expressions.isNotEmpty ? expressions.first.notebookId : null;

    if (notebookId != null) {
      if (_lastNotebookId != notebookId) {
        _lastNotebookId = notebookId;
        Future.microtask(() => _loadNotebookState(notebookId));
      } else {
        // Expressions list changed: process the delta
        Future.microtask(() => _processExpressionsDelta(notebookId, expressions));
      }
    } else {
      _lastNotebookId = null;
    }

    return const MathState();
  }

  /// Loads results and variables from local cache on notebook switch.
  Future<void> _loadNotebookState(String notebookId) async {
    state = state.copyWith(isPending: true);
    try {
      final repository = ref.read(mathRepositoryProvider);
      final cachedResults = await repository.getCachedResults(notebookId);
      final cachedVariables = await repository.getCachedVariables(notebookId);

      // Rebuild the maps from cached database rows
      final resultsMap = <String, MathResult>{};
      for (final r in cachedResults) {
        resultsMap[r.expressionId] = r;
      }

      final symbolTable = <String, String>{};
      final definedVariables = <String, String>{};
      for (final v in cachedVariables) {
        symbolTable[v.name] = v.value;
        if (v.expressionId != null) {
          definedVariables[v.expressionId!] = v.name;
        }
      }

      // Rebuild dependencies by parsing expressions
      final dependencies = <String, Set<String>>{};
      final expressions = ref.read(recognitionStateProvider).expressions;
      for (final expr in expressions) {
        try {
          final parseData = await repository.parse(expr.rawLatex);
          if (parseData['success'] == true) {
            final depsList = parseData['result']['dependencies'] as List<dynamic>;
            dependencies[expr.id] = depsList.map((d) => d.toString()).toSet();
          }
        } catch (_) {
          dependencies[expr.id] = <String>{};
        }
      }

      state = state.copyWith(
        results: resultsMap,
        symbolTable: symbolTable,
        definedVariables: definedVariables,
        dependencies: dependencies,
        isPending: false,
        error: null,
      );

      await _processExpressionsDelta(notebookId, expressions);
    } catch (e) {
      state = state.copyWith(
        isPending: false,
        error: e.toString(),
      );
    }
  }

  /// Processes added/modified/deleted expressions reactively.
  Future<void> _processExpressionsDelta(
    String notebookId,
    List<RecognizedExpression> currentExpressions,
  ) async {
    final oldExprIds = state.results.keys.toSet();
    final currentExprIds = currentExpressions.map((e) => e.id).toSet();

    // 1. Identify deleted expressions
    final deletedExprIds = oldExprIds.difference(currentExprIds);
    var updatedSymbolTable = Map<String, String>.from(state.symbolTable);
    var updatedDefinedVars = Map<String, String>.from(state.definedVariables);
    var updatedDependencies = Map<String, Set<String>>.from(state.dependencies);
    var updatedResults = Map<String, MathResult>.from(state.results);

    final propagatedVariables = <String>[];

    for (final exprId in deletedExprIds) {
      final varName = updatedDefinedVars[exprId];
      if (varName != null) {
        updatedSymbolTable.remove(varName);
        updatedDefinedVars.remove(exprId);
        propagatedVariables.add(varName);
      }
      updatedDependencies.remove(exprId);
      updatedResults.remove(exprId);
    }

    state = state.copyWith(
      symbolTable: updatedSymbolTable,
      definedVariables: updatedDefinedVars,
      dependencies: updatedDependencies,
      results: updatedResults,
    );

    // 2. Identify new or modified expressions
    final List<RecognizedExpression> toEvaluate = [];
    for (final expr in currentExpressions) {
      final oldResult = state.results[expr.id];
      // Re-evaluate if new or LaTeX string changed
      if (oldResult == null || _expressionChanged(expr, oldResult)) {
        toEvaluate.add(expr);
      }
    }

    // Evaluate each added/modified expression
    for (final expr in toEvaluate) {
      await _evaluateSingleExpression(notebookId, expr);
    }

    // 3. Propagate changes from deleted variables
    for (final varName in propagatedVariables) {
      await _propagateVariableChange(varName, notebookId);
    }

    // 4. Persist updated state to database
    await _persistStateToDb(notebookId);
  }

  bool _expressionChanged(RecognizedExpression expr, MathResult oldResult) {
    // If we have an existing success result or error, we re-evaluate if the latex doesn't match
    // Or if it depends on variables whose values changed (handled in propagation).
    return false; // Delta checks only trigger on raw structural change here
  }

  /// Evaluates a single expression, updates symbol tables, and triggers propagation if needed.
  Future<void> _evaluateSingleExpression(
    String notebookId,
    RecognizedExpression expression,
  ) async {
    print('[_evaluateSingleExpression] Evaluating: "${expression.rawLatex}"');
    print('[_evaluateSingleExpression] Current symbolTable: ${state.symbolTable}');
    final repository = ref.read(mathRepositoryProvider);

    try {
      // 1. Call parse to analyze expression structure
      final parseEnvelope = await repository.parse(expression.rawLatex);
      if (parseEnvelope['success'] != true) {
        final errMessage = parseEnvelope['error']?['message'] ?? 'Parsing failed';
        _setErrorResult(expression.id, errMessage);
        return;
      }

      final parseResult = parseEnvelope['result'] as Map<String, dynamic>;
      final sympyStr = parseResult['sympy_str'] as String;
      final exprType = parseResult['type'] as String;
      final deps = (parseResult['dependencies'] as List<dynamic>).map((d) => d.toString()).toSet();
      final definedVar = parseResult['defined_variable'] as String?;

      // 2. Perform cycle detection if this expression defines a variable
      if (definedVar != null) {
        final cycleDetected = _detectCycle(expression.id, definedVar, deps);
        if (cycleDetected) {
          _setErrorResult(
            expression.id,
            'Circular dependency detected: $definedVar depends on itself.',
          );
          return;
        }
      }

      // Update dependencies mapping
      final updatedDeps = Map<String, Set<String>>.from(state.dependencies);
      updatedDeps[expression.id] = deps;
      state = state.copyWith(dependencies: updatedDeps);

      // 3. Evaluate based on type
      MathResult result;
      
      // Build symbol table excluding the variable being defined itself to prevent self-referential errors
      final evalSymbolTable = Map<String, String>.from(state.symbolTable);
      if (definedVar != null) {
        evalSymbolTable.remove(definedVar);
      }

      if (exprType == 'arithmetic') {
        result = await repository.evaluate(expression.id, sympyStr, symbolTable: evalSymbolTable);
      } else if (exprType == 'equation') {
        // Find variables to solve for (symbols in the equation that are not in symbol table)
        final solveVars = (parseResult['variables'] as List<dynamic>)
            .map((v) => v.toString())
            .where((v) => !evalSymbolTable.containsKey(v))
            .toList();

        if (solveVars.isEmpty) {
          // If all variables are defined in the symbol table, treat it as arithmetic check (e.g. 5 = 5)
          result = await repository.evaluate(expression.id, sympyStr, symbolTable: evalSymbolTable);
        } else {
          result = await repository.solve(expression.id, sympyStr, solveVars, symbolTable: evalSymbolTable);
        }
      } else if (exprType == 'assignment') {
        // Split Eq(a, 5) -> RHS is '5'. Evaluate RHS
        final rhs = sympyStr.replaceFirst(RegExp('^Eq\\(${RegExp.escape(definedVar!)},\\s*'), '').replaceFirst(RegExp('\\)\$'), '');
        result = await repository.evaluate(expression.id, rhs, symbolTable: evalSymbolTable);
      } else {
        // General symbol simplification
        result = await repository.simplify(expression.id, sympyStr, symbolTable: evalSymbolTable);
      }

      // 4. Update state with result
      final updatedResults = Map<String, MathResult>.from(state.results);
      updatedResults[expression.id] = result;
      state = state.copyWith(results: updatedResults);

      // 5. Update symbol table and defined variables mappings if assignment
      if (exprType == 'assignment' && definedVar != null && !result.isError) {
        final oldVal = state.symbolTable[definedVar];
        final newVal = result.value;

        final updatedSymbolTable = Map<String, String>.from(state.symbolTable);
        final updatedDefinedVars = Map<String, String>.from(state.definedVariables);

        updatedSymbolTable[definedVar] = newVal;
        updatedDefinedVars[expression.id] = definedVar;

        state = state.copyWith(
          symbolTable: updatedSymbolTable,
          definedVariables: updatedDefinedVars,
        );

        // If the variable value actually changed, propagate the update
        if (oldVal != newVal) {
          await _propagateVariableChange(definedVar, notebookId);
        }
      }
    } catch (e) {
      _setErrorResult(expression.id, e.toString());
    }
  }

  void _setErrorResult(String expressionId, String message) {
    final updatedResults = Map<String, MathResult>.from(state.results);
    updatedResults[expressionId] = MathResult(
      id: UuidGenerator.generateV4(),
      expressionId: expressionId,
      resultType: 'error',
      value: message,
      latex: '\\text{Error: }$message',
      computedAt: DateTime.now(),
    );
    state = state.copyWith(results: updatedResults);
  }

  /// Propagates changes recursively (DFS-style) to expressions depending on the updated variable.
  Future<void> _propagateVariableChange(String varName, String notebookId) async {
    final dependentExprIds = state.dependencies.entries
        .where((entry) => entry.value.contains(varName))
        .map((entry) => entry.key)
        .toList();

    for (final exprId in dependentExprIds) {
      final expr = _findExpression(exprId);
      if (expr != null) {
        await _evaluateSingleExpression(notebookId, expr);
      }
    }
  }

  RecognizedExpression? _findExpression(String id) {
    final expressions = ref.read(recognitionStateProvider).expressions;
    return expressions.firstWhereOrNull((e) => e.id == id);
  }

  /// Checks for cyclic dependencies using DFS cycle detection.
  bool _detectCycle(String expressionId, String definedVar, Set<String> deps) {
    // Reconstruct the variable graph: variableName -> Set of variables it depends on
    final varGraph = <String, Set<String>>{};

    // Add existing variables
    for (final entry in state.definedVariables.entries) {
      final oldExprId = entry.key;
      final oldVar = entry.value;

      if (oldExprId != expressionId) {
        varGraph[oldVar] = state.dependencies[oldExprId] ?? <String>{};
      }
    }

    // Add the proposed variable and its dependencies
    varGraph[definedVar] = deps;

    // Run DFS cycle check starting at the proposed variable
    final visited = <String>{};
    final recStack = <String>{};

    bool dfs(String node) {
      if (recStack.contains(node)) return true;
      if (visited.contains(node)) return false;

      visited.add(node);
      recStack.add(node);

      final neighbors = varGraph[node];
      if (neighbors != null) {
        for (final neighbor in neighbors) {
          if (dfs(neighbor)) return true;
        }
      }

      recStack.remove(node);
      return false;
    }

    return dfs(definedVar);
  }

  /// Persists current symbol table and results state to SQLite database.
  Future<void> _persistStateToDb(String notebookId) async {
    try {
      final repository = ref.read(mathRepositoryProvider);

      final results = state.results.values.toList();
      final variables = <Variable>[];

      for (final entry in state.definedVariables.entries) {
        final exprId = entry.key;
        final varName = entry.value;
        final val = state.symbolTable[varName];

        if (val != null) {
          variables.add(Variable(
            id: UuidGenerator.generateV4(),
            notebookId: notebookId,
            name: varName,
            value: val,
            expressionId: exprId,
            updatedAt: DateTime.now(),
          ));
        }
      }

      await repository.replaceResultsAndVariables(
        notebookId: notebookId,
        results: results,
        variables: variables,
      );
    } catch (_) {
      // Fail silently to keep user session interactive
    }
  }
}
