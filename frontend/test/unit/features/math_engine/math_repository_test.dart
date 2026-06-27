import 'package:flutter_test/flutter_test.dart';
import 'package:mathcanvas/features/math_engine/data/datasources/math_api_client.dart';
import 'package:mathcanvas/features/math_engine/data/datasources/math_local_datasource.dart';
import 'package:mathcanvas/features/math_engine/data/models/result_entity.dart';
import 'package:mathcanvas/features/math_engine/data/models/variable_entity.dart';
import 'package:mathcanvas/features/math_engine/data/repositories/math_repository_impl.dart';
import 'package:mathcanvas/features/math_engine/domain/models/math_result.dart';
import 'package:mathcanvas/features/math_engine/domain/models/variable.dart';

class FakeMathApiClient implements MathApiClient {
  Map<String, dynamic>? mockParseResponse;
  Map<String, dynamic>? mockEvaluateResponse;
  Map<String, dynamic>? mockSolveResponse;
  Map<String, dynamic>? mockSimplifyResponse;

  @override
  Future<Map<String, dynamic>> parse(String expression) async {
    return mockParseResponse ?? {'success': true, 'type': 'expression'};
  }

  @override
  Future<Map<String, dynamic>> evaluate(String expression, {Map<String, String>? symbolTable}) async {
    return mockEvaluateResponse ?? {
      'success': true,
      'result': {
        'type': 'numeric',
        'value': '5',
        'latex': '5',
        'numeric': 5.0,
      }
    };
  }

  @override
  Future<Map<String, dynamic>> solve(String expression, List<String> variables, {Map<String, String>? symbolTable}) async {
    return mockSolveResponse ?? {
      'success': true,
      'result': {
        'type': 'symbolic',
        'value': 'x = 2',
        'latex': 'x = 2',
        'numeric': null,
      }
    };
  }

  @override
  Future<Map<String, dynamic>> simplify(String expression, {Map<String, String>? symbolTable}) async {
    return mockSimplifyResponse ?? {
      'success': true,
      'result': {
        'type': 'expression',
        'value': '2*x',
        'latex': '2x',
        'numeric': null,
      }
    };
  }
}

class FakeMathLocalDatasource implements MathLocalDatasource {
  final Map<String, ResultEntity> results = {};
  final Map<String, String> resultNotebooks = {}; // Maps expressionId to notebookId
  final Map<String, List<VariableEntity>> variables = {};

  @override
  Future<List<ResultEntity>> getResults(String notebookId) async {
    final list = <ResultEntity>[];
    results.forEach((exprId, result) {
      if (resultNotebooks[exprId] == notebookId) {
        list.add(result);
      }
    });
    return list;
  }

  @override
  Future<List<VariableEntity>> getVariables(String notebookId) async {
    return variables[notebookId] ?? [];
  }

  @override
  Future<void> saveResult(ResultEntity result) async {
    results[result.expressionId] = result;
    // Map it to nb_1 by default if not set
    resultNotebooks[result.expressionId] ??= 'nb_1';
  }

  @override
  Future<void> saveVariable(VariableEntity variable) async {
    final list = variables[variable.notebookId] ?? [];
    list.removeWhere((v) => v.name == variable.name);
    list.add(variable);
    variables[variable.notebookId] = list;
  }

  @override
  Future<void> deleteResult(String expressionId) async {
    results.remove(expressionId);
    resultNotebooks.remove(expressionId);
  }

  @override
  Future<void> deleteVariable(String name, String notebookId) async {
    final list = variables[notebookId] ?? [];
    list.removeWhere((v) => v.name == name);
    variables[notebookId] = list;
  }

  @override
  Future<void> replaceResultsAndVariables({
    required String notebookId,
    required List<ResultEntity> results,
    required List<VariableEntity> variables,
  }) async {
    resultNotebooks.removeWhere((exprId, nbId) => nbId == notebookId);
    this.results.removeWhere((exprId, r) => !resultNotebooks.containsKey(exprId));
    
    for (final r in results) {
      this.results[r.expressionId] = r;
      resultNotebooks[r.expressionId] = notebookId;
    }
    this.variables[notebookId] = List.from(variables);
  }
}

void main() {
  group('MathRepositoryImpl Tests', () {
    late FakeMathApiClient fakeApiClient;
    late FakeMathLocalDatasource fakeLocalDatasource;
    late MathRepositoryImpl repository;

    setUp(() {
      fakeApiClient = FakeMathApiClient();
      fakeLocalDatasource = FakeMathLocalDatasource();
      repository = MathRepositoryImpl(fakeApiClient, fakeLocalDatasource);
    });

    test('parse calls apiClient.parse', () async {
      fakeApiClient.mockParseResponse = {'success': true, 'type': 'assignment'};
      final result = await repository.parse('x = 5');
      expect(result['success'], isTrue);
      expect(result['type'], equals('assignment'));
    });

    test('evaluate handles success and formats MathResult', () async {
      final result = await repository.evaluate('expr_1', '2 + 3');
      expect(result.expressionId, equals('expr_1'));
      expect(result.resultType, equals('numeric'));
      expect(result.value, equals('5'));
      expect(result.latex, equals('5'));
      expect(result.numericValue, equals(5.0));
    });

    test('evaluate handles api error and formats Error result', () async {
      fakeApiClient.mockEvaluateResponse = {
        'success': false,
        'error': {'message': 'Division by zero'}
      };
      final result = await repository.evaluate('expr_2', '1/0');
      expect(result.expressionId, equals('expr_2'));
      expect(result.resultType, equals('error'));
      expect(result.value, equals('Division by zero'));
      expect(result.latex, contains('Error:'));
    });

    test('solve formats symbolic result correctly', () async {
      final result = await repository.solve('expr_3', 'x^2 = 4', ['x']);
      expect(result.expressionId, equals('expr_3'));
      expect(result.resultType, equals('symbolic'));
      expect(result.value, equals('x = 2'));
    });

    test('simplify formats simplified result correctly', () async {
      final result = await repository.simplify('expr_4', 'x + x');
      expect(result.expressionId, equals('expr_4'));
      expect(result.resultType, equals('expression'));
      expect(result.value, equals('2*x'));
    });

    test('cache operations save, delete and retrieve correct entities', () async {
      final mockResult = MathResult(
        id: 'res_1',
        expressionId: 'expr_1',
        resultType: 'numeric',
        value: '10',
        latex: '10',
        numericValue: 10.0,
        computedAt: DateTime.now(),
      );

      final mockVariable = Variable(
        id: 'var_1',
        name: 'a',
        notebookId: 'nb_1',
        value: '10.0',
        updatedAt: DateTime.now(),
      );

      // Save to local cache
      await repository.saveResult(mockResult);
      await repository.saveVariable(mockVariable);

      // Map mockResult expressionId to notebook nb_1 in the fake
      fakeLocalDatasource.resultNotebooks['expr_1'] = 'nb_1';

      // Retrieve from cache
      final results = await repository.getCachedResults('nb_1');
      final variables = await repository.getCachedVariables('nb_1');

      expect(results.length, equals(1));
      expect(results.first.expressionId, equals('expr_1'));
      expect(results.first.value, equals('10'));

      expect(variables.length, equals(1));
      expect(variables.first.name, equals('a'));
      expect(variables.first.value, equals('10.0'));

      // Delete operations
      await repository.deleteResult('expr_1');
      await repository.deleteVariable('a', 'nb_1');

      final resultsAfter = await repository.getCachedResults('nb_1');
      final variablesAfter = await repository.getCachedVariables('nb_1');

      expect(resultsAfter.isEmpty, isTrue);
      expect(variablesAfter.isEmpty, isTrue);
    });

    test('replaceResultsAndVariables handles transaction updates', () async {
      final res = MathResult(
        id: 'res_2',
        expressionId: 'expr_2',
        resultType: 'numeric',
        value: '20',
        latex: '20',
        numericValue: 20.0,
        computedAt: DateTime.now(),
      );

      final v = Variable(
        id: 'var_2',
        name: 'b',
        notebookId: 'nb_1',
        value: '20.0',
        updatedAt: DateTime.now(),
      );

      await repository.replaceResultsAndVariables(
        notebookId: 'nb_1',
        results: [res],
        variables: [v],
      );

      final results = await repository.getCachedResults('nb_1');
      final variables = await repository.getCachedVariables('nb_1');

      expect(results.length, equals(1));
      expect(results.first.expressionId, equals('expr_2'));
      expect(variables.length, equals(1));
      expect(variables.first.name, equals('b'));
    });
  });
}
