import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/features/recognition/presentation/providers/recognition_state_provider.dart';
import 'package:mathcanvas/features/recognition/domain/models/recognized_expression.dart';
import 'package:mathcanvas/features/math_engine/domain/repositories/math_repository.dart';
import 'package:mathcanvas/features/math_engine/presentation/providers/math_state_provider.dart';
import 'package:mathcanvas/features/math_engine/domain/models/math_result.dart';
import 'package:mathcanvas/features/math_engine/domain/models/variable.dart';

// Fake Math Repository for unit testing
class FakeMathRepository implements MathRepository {
  final Map<String, Map<String, dynamic>> parseResults = {};
  final Map<String, MathResult> evalResults = {};

  @override
  Future<Map<String, dynamic>> parse(String expression) async {
    return parseResults[expression] ?? {
      'success': true,
      'result': {
        'sympy_str': expression,
        'type': 'expression',
        'variables': <String>[],
        'defined_variable': null,
        'dependencies': <String>[]
      }
    };
  }

  @override
  Future<MathResult> evaluate(String expressionId, String expression, {Map<String, String>? symbolTable}) async {
    var substituted = expression;
    if (symbolTable != null) {
      for (final entry in symbolTable.entries) {
        substituted = substituted.replaceAll(RegExp('\\b${entry.key}\\b'), entry.value);
      }
    }
    return evalResults[substituted] ?? MathResult(
      id: 'r_eval',
      expressionId: expressionId,
      resultType: 'numeric',
      value: substituted,
      latex: substituted,
      computedAt: DateTime.now(),
    );
  }

  @override
  Future<MathResult> solve(String expressionId, String expression, List<String> variables, {Map<String, String>? symbolTable}) async {
    var substituted = expression;
    if (symbolTable != null) {
      for (final entry in symbolTable.entries) {
        if (!variables.contains(entry.key)) {
          substituted = substituted.replaceAll(RegExp('\\b${entry.key}\\b'), entry.value);
        }
      }
    }
    return MathResult(
      id: 'r_solve',
      expressionId: expressionId,
      resultType: 'solution',
      value: '${variables.first}=2',
      latex: '${variables.first} = 2',
      computedAt: DateTime.now(),
    );
  }

  @override
  Future<MathResult> simplify(String expressionId, String expression, {Map<String, String>? symbolTable}) async {
    var substituted = expression;
    if (symbolTable != null) {
      for (final entry in symbolTable.entries) {
        substituted = substituted.replaceAll(RegExp('\\b${entry.key}\\b'), entry.value);
      }
    }
    return MathResult(
      id: 'r_simp',
      expressionId: expressionId,
      resultType: 'simplified',
      value: substituted,
      latex: substituted,
      computedAt: DateTime.now(),
    );
  }

  @override
  Future<List<MathResult>> getCachedResults(String notebookId) async => [];

  @override
  Future<List<Variable>> getCachedVariables(String notebookId) async => [];

  @override
  Future<void> saveResult(MathResult result) async {}

  @override
  Future<void> saveVariable(Variable variable) async {}

  @override
  Future<void> deleteResult(String expressionId) async {}

  @override
  Future<void> deleteVariable(String name, String notebookId) async {}

  @override
  Future<void> replaceResultsAndVariables({
    required String notebookId,
    required List<MathResult> results,
    required List<Variable> variables,
  }) async {}
}

void main() {
  group('Math Engine State Notifier Tests', () {
    late FakeMathRepository fakeMathRepository;

    setUp(() {
      fakeMathRepository = FakeMathRepository();
    });

    test('should evaluate a simple arithmetic expression to a numeric result', () async {
      // 1. Setup mock parse and evaluation results
      fakeMathRepository.parseResults['2 + 3 * 4'] = {
        'success': true,
        'result': {
          'sympy_str': '2 + 3 * 4',
          'type': 'arithmetic',
          'variables': <String>[],
          'defined_variable': null,
          'dependencies': <String>[]
        }
      };

      fakeMathRepository.evalResults['2 + 3 * 4'] = MathResult(
        id: 'res-1',
        expressionId: 'expr-1',
        resultType: 'numeric',
        value: '14',
        latex: '14',
        computedAt: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: [
          mathRepositoryProvider.overrideWithValue(fakeMathRepository),
          // Override recognition state to provide a mock notebook and expression list
          recognitionStateProvider.overrideWith(() => RecognitionStateNotifierFake([
            RecognizedExpression(
              id: 'expr-1',
              notebookId: 'test-notebook',
              rawLatex: '2 + 3 * 4',
              confidence: 0.95,
              bboxMinX: 0,
              bboxMinY: 0,
              bboxMaxX: 100,
              bboxMaxY: 30,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              strokeIds: ['s1'],
            )
          ])),
        ],
      );

      // Trigger the build
      final mathState = container.read(mathStateProvider);

      // Wait for microtask callbacks (evaluation delta process)
      await Future.delayed(const Duration(milliseconds: 10));

      final stateAfterEval = container.read(mathStateProvider);
      expect(stateAfterEval.results.containsKey('expr-1'), isTrue);
      expect(stateAfterEval.results['expr-1']!.value, equals('14'));
      expect(stateAfterEval.results['expr-1']!.resultType, equals('numeric'));
    });

    test('should evaluate variable assignments and propagate updates to dependencies', () async {
      // Expression 1: a = 5
      fakeMathRepository.parseResults['a = 5'] = {
        'success': true,
        'result': {
          'sympy_str': 'Eq(a, 5)',
          'type': 'assignment',
          'variables': ['a'],
          'defined_variable': 'a',
          'dependencies': <String>[]
        }
      };
      fakeMathRepository.evalResults['5'] = MathResult(
        id: 'res-a',
        expressionId: 'expr-a',
        resultType: 'numeric',
        value: '5',
        latex: '5',
        computedAt: DateTime.now(),
      );

      // Expression 2: a + 10
      fakeMathRepository.parseResults['a + 10'] = {
        'success': true,
        'result': {
          'sympy_str': 'a + 10',
          'type': 'arithmetic',
          'variables': ['a'],
          'defined_variable': null,
          'dependencies': ['a']
        }
      };
      // Mock evaluation result for substituting a=5: "5 + 10" -> 15
      fakeMathRepository.evalResults['5 + 10'] = MathResult(
        id: 'res-dep',
        expressionId: 'expr-dep',
        resultType: 'numeric',
        value: '15',
        latex: '15',
        computedAt: DateTime.now(),
      );

      final container = ProviderContainer(
        overrides: [
          mathRepositoryProvider.overrideWithValue(fakeMathRepository),
          recognitionStateProvider.overrideWith(() => RecognitionStateNotifierFake([
            RecognizedExpression(
              id: 'expr-a',
              notebookId: 'test-notebook',
              rawLatex: 'a = 5',
              confidence: 0.95,
              bboxMinX: 0,
              bboxMinY: 0,
              bboxMaxX: 100,
              bboxMaxY: 30,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              strokeIds: ['s1'],
            ),
            RecognizedExpression(
              id: 'expr-dep',
              notebookId: 'test-notebook',
              rawLatex: 'a + 10',
              confidence: 0.95,
              bboxMinX: 0,
              bboxMinY: 50,
              bboxMaxX: 100,
              bboxMaxY: 80,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              strokeIds: ['s2'],
            )
          ])),
        ],
      );

      container.read(mathStateProvider);
      await Future.delayed(const Duration(milliseconds: 10));

      final state = container.read(mathStateProvider);
      // Verify symbol table was populated
      expect(state.symbolTable['a'], equals('5'));
      
      // Verify defined variables mapping
      expect(state.definedVariables['expr-a'], equals('a'));

      // Verify dependency mapping
      expect(state.dependencies['expr-dep'], contains('a'));

      // Verify the dependent evaluation succeeded with the substituted value
      expect(state.results['expr-dep']!.value, equals('15'));
    });

    test('circular dependency check: should reject circular variable definitions', () async {
      // 1. Existing variable: a = b
      fakeMathRepository.parseResults['a = b'] = {
        'success': true,
        'result': {
          'sympy_str': 'Eq(a, b)',
          'type': 'assignment',
          'variables': ['a', 'b'],
          'defined_variable': 'a',
          'dependencies': ['b']
        }
      };

      // 2. New proposed variable: b = a (Creating cycle a -> b -> a)
      fakeMathRepository.parseResults['b = a'] = {
        'success': true,
        'result': {
          'sympy_str': 'Eq(b, a)',
          'type': 'assignment',
          'variables': ['b', 'a'],
          'defined_variable': 'b',
          'dependencies': ['a']
        }
      };

      final container = ProviderContainer(
        overrides: [
          mathRepositoryProvider.overrideWithValue(fakeMathRepository),
          recognitionStateProvider.overrideWith(() => RecognitionStateNotifierFake([
            // Add a = b
            RecognizedExpression(
              id: 'expr-a',
              notebookId: 'test-notebook',
              rawLatex: 'a = b',
              confidence: 0.95,
              bboxMinX: 0,
              bboxMinY: 0,
              bboxMaxX: 100,
              bboxMaxY: 30,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              strokeIds: ['s1'],
            ),
            // Propose b = a
            RecognizedExpression(
              id: 'expr-b',
              notebookId: 'test-notebook',
              rawLatex: 'b = a',
              confidence: 0.95,
              bboxMinX: 0,
              bboxMinY: 50,
              bboxMaxX: 100,
              bboxMaxY: 80,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              strokeIds: ['s2'],
            )
          ])),
        ],
      );

      container.read(mathStateProvider);
      await Future.delayed(const Duration(milliseconds: 10));

      final state = container.read(mathStateProvider);

      // Verify that expr-b ends up with an error result indicating circular dependency
      expect(state.results['expr-b']!.isError, isTrue);
      expect(state.results['expr-b']!.value, contains('Circular dependency'));
    });
  });
}

// Fake Recognition State Notifier to override in tests
class RecognitionStateNotifierFake extends RecognitionStateNotifier {
  final List<RecognizedExpression> initialExpressions;

  RecognitionStateNotifierFake(this.initialExpressions);

  @override
  RecognitionState build() {
    return RecognitionState(expressions: initialExpressions);
  }
}
