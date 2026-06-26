import 'package:mathcanvas/features/recognition/domain/models/recognized_expression.dart';
import 'package:mathcanvas/features/recognition/domain/repositories/expression_repository.dart';
import '../datasources/expression_local_datasource.dart';
import '../models/expression_entity.dart';

/// Concrete implementation of the expression repository contract.
class ExpressionRepositoryImpl implements ExpressionRepository {
  final ExpressionLocalDatasource _localDatasource;

  /// Creates an [ExpressionRepositoryImpl].
  ExpressionRepositoryImpl(this._localDatasource);

  @override
  Future<List<RecognizedExpression>> getExpressions(String notebookId) async {
    final entities = await _localDatasource.getExpressions(notebookId);
    final List<RecognizedExpression> domainList = [];
    for (final entity in entities) {
      final strokeIds = await _localDatasource.getStrokeIdsForExpression(entity.id);
      domainList.add(entity.toDomain(strokeIds));
    }
    return domainList;
  }

  @override
  Future<void> saveExpression(RecognizedExpression expression) async {
    final entity = ExpressionEntity.fromDomain(expression);
    await _localDatasource.saveExpression(entity, expression.strokeIds);
  }

  @override
  Future<void> deleteExpression(String id) async {
    await _localDatasource.deleteExpression(id);
  }

  @override
  Future<void> replaceExpressions(String notebookId, List<RecognizedExpression> expressions) async {
    final entities = expressions.map((e) => ExpressionEntity.fromDomain(e)).toList();
    final strokeIdsList = expressions.map((e) => e.strokeIds).toList();
    await _localDatasource.replaceExpressions(notebookId, entities, strokeIdsList);
  }
}
