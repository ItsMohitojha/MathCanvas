import 'package:sqflite/sqflite.dart';
import '../models/expression_entity.dart';

/// Local data source interface for storing and retrieving expressions.
abstract class ExpressionLocalDatasource {
  /// Fetches all expressions in the notebook.
  Future<List<ExpressionEntity>> getExpressions(String notebookId);

  /// Fetches all stroke IDs associated with an expression.
  Future<List<String>> getStrokeIdsForExpression(String expressionId);

  /// Saves/updates an expression and its stroke mapping.
  Future<void> saveExpression(ExpressionEntity expression, List<String> strokeIds);

  /// Deletes an expression.
  Future<void> deleteExpression(String id);

  /// Replaces the active set of expressions in a transaction.
  Future<void> replaceExpressions(
    String notebookId,
    List<ExpressionEntity> expressions,
    List<List<String>> strokeIdsList,
  );
}

/// SQLite implementation of the local data source.
class ExpressionLocalDatasourceImpl implements ExpressionLocalDatasource {
  final Future<Database> _dbFuture;

  /// Creates an [ExpressionLocalDatasourceImpl].
  ExpressionLocalDatasourceImpl(this._dbFuture);

  @override
  Future<List<ExpressionEntity>> getExpressions(String notebookId) async {
    final db = await _dbFuture;
    final List<Map<String, dynamic>> maps = await db.query(
      'expressions',
      where: 'notebook_id = ?',
      whereArgs: [notebookId],
    );
    return maps.map((map) => ExpressionEntity.fromMap(map)).toList();
  }

  @override
  Future<List<String>> getStrokeIdsForExpression(String expressionId) async {
    final db = await _dbFuture;
    final List<Map<String, dynamic>> maps = await db.query(
      'expression_strokes',
      columns: ['stroke_id'],
      where: 'expression_id = ?',
      whereArgs: [expressionId],
    );
    return maps.map((map) => map['stroke_id'] as String).toList();
  }

  @override
  Future<void> saveExpression(ExpressionEntity expression, List<String> strokeIds) async {
    final db = await _dbFuture;
    await db.transaction((txn) async {
      await txn.insert(
        'expressions',
        expression.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      await txn.delete(
        'expression_strokes',
        where: 'expression_id = ?',
        whereArgs: [expression.id],
      );

      for (final strokeId in strokeIds) {
        await txn.insert('expression_strokes', {
          'expression_id': expression.id,
          'stroke_id': strokeId,
        });
      }
    });
  }

  @override
  Future<void> deleteExpression(String id) async {
    final db = await _dbFuture;
    await db.delete(
      'expressions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> replaceExpressions(
    String notebookId,
    List<ExpressionEntity> expressions,
    List<List<String>> strokeIdsList,
  ) async {
    final db = await _dbFuture;
    await db.transaction((txn) async {
      await txn.delete(
        'expressions',
        where: 'notebook_id = ?',
        whereArgs: [notebookId],
      );

      for (int i = 0; i < expressions.length; i++) {
        final expr = expressions[i];
        final strokeIds = strokeIdsList[i];

        await txn.insert(
          'expressions',
          expr.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        for (final strokeId in strokeIds) {
          await txn.insert('expression_strokes', {
            'expression_id': expr.id,
            'stroke_id': strokeId,
          });
        }
      }
    });
  }
}
