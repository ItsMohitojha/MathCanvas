import 'package:mathcanvas/core/utils/uuid_generator.dart';
import '../../domain/models/math_result.dart';
import '../../domain/models/variable.dart';
import '../../domain/repositories/math_repository.dart';
import '../datasources/math_api_client.dart';
import '../datasources/math_local_datasource.dart';
import '../models/result_entity.dart';
import '../models/variable_entity.dart';

/// Concrete implementation of the [MathRepository].
class MathRepositoryImpl implements MathRepository {
  final MathApiClient _apiClient;
  final MathLocalDatasource _localDatasource;

  /// Creates a [MathRepositoryImpl].
  MathRepositoryImpl(this._apiClient, this._localDatasource);

  @override
  Future<Map<String, dynamic>> parse(String expression) {
    return _apiClient.parse(expression);
  }

  @override
  Future<MathResult> evaluate(String expressionId, String expression, {Map<String, String>? symbolTable}) async {
    final response = await _apiClient.evaluate(expression, symbolTable: symbolTable);
    return _parseApiResponse(expressionId, response);
  }

  @override
  Future<MathResult> solve(String expressionId, String expression, List<String> variables, {Map<String, String>? symbolTable}) async {
    final response = await _apiClient.solve(expression, variables, symbolTable: symbolTable);
    return _parseApiResponse(expressionId, response);
  }

  @override
  Future<MathResult> simplify(String expressionId, String expression, {Map<String, String>? symbolTable}) async {
    final response = await _apiClient.simplify(expression, symbolTable: symbolTable);
    return _parseApiResponse(expressionId, response);
  }

  MathResult _parseApiResponse(String expressionId, Map<String, dynamic> response) {
    final success = response['success'] as bool;
    final now = DateTime.now();
    if (success) {
      final res = response['result'] as Map<String, dynamic>;
      final type = res['type'] as String;
      final value = res['value'] as String;
      final latex = res['latex'] as String;
      final numeric = res['numeric'] != null ? (res['numeric'] as num).toDouble() : null;

      return MathResult(
        id: UuidGenerator.generateV4(),
        expressionId: expressionId,
        resultType: type,
        value: value,
        latex: latex,
        numericValue: numeric,
        computedAt: now,
      );
    } else {
      final err = response['error'] as Map<String, dynamic>;
      final message = err['message'] as String;

      return MathResult(
        id: UuidGenerator.generateV4(),
        expressionId: expressionId,
        resultType: 'error',
        value: message,
        latex: '\\text{Error: }$message',
        numericValue: null,
        computedAt: now,
      );
    }
  }

  @override
  Future<List<MathResult>> getCachedResults(String notebookId) async {
    final list = await _localDatasource.getResults(notebookId);
    return list.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<Variable>> getCachedVariables(String notebookId) async {
    final list = await _localDatasource.getVariables(notebookId);
    return list.map((e) => e.toDomain()).toList();
  }

  @override
  Future<void> saveResult(MathResult result) async {
    await _localDatasource.saveResult(ResultEntity.fromDomain(result));
  }

  @override
  Future<void> saveVariable(Variable variable) async {
    await _localDatasource.saveVariable(VariableEntity.fromDomain(variable));
  }

  @override
  Future<void> deleteResult(String expressionId) async {
    await _localDatasource.deleteResult(expressionId);
  }

  @override
  Future<void> deleteVariable(String name, String notebookId) async {
    await _localDatasource.deleteVariable(name, notebookId);
  }

  @override
  Future<void> replaceResultsAndVariables({
    required String notebookId,
    required List<MathResult> results,
    required List<Variable> variables,
  }) async {
    final resultEntities = results.map((r) => ResultEntity.fromDomain(r)).toList();
    final variableEntities = variables.map((v) => VariableEntity.fromDomain(v)).toList();
    await _localDatasource.replaceResultsAndVariables(
      notebookId: notebookId,
      results: resultEntities,
      variables: variableEntities,
    );
  }
}
