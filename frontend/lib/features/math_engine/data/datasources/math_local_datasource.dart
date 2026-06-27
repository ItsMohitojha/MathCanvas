import 'package:sqflite/sqflite.dart';
import '../models/result_entity.dart';
import '../models/variable_entity.dart';

/// Local data source interface for storing and retrieving variables and computation results.
abstract class MathLocalDatasource {
  /// Fetches all computed results for expressions belonging to a notebook.
  Future<List<ResultEntity>> getResults(String notebookId);

  /// Fetches all variables declared in a notebook.
  Future<List<VariableEntity>> getVariables(String notebookId);

  /// Saves or updates a computed result.
  Future<void> saveResult(ResultEntity result);

  /// Saves or updates a variable.
  Future<void> saveVariable(VariableEntity variable);

  /// Deletes a result by its expression reference.
  Future<void> deleteResult(String expressionId);

  /// Deletes a variable by name in a notebook.
  Future<void> deleteVariable(String name, String notebookId);

  /// Programmatically replaces all results and variables transactionally.
  Future<void> replaceResultsAndVariables({
    required String notebookId,
    required List<ResultEntity> results,
    required List<VariableEntity> variables,
  });
}

/// SQLite implementation of the MathLocalDatasource.
class MathLocalDatasourceImpl implements MathLocalDatasource {
  final Future<Database> _dbFuture;

  /// Creates a [MathLocalDatasourceImpl].
  MathLocalDatasourceImpl(this._dbFuture);

  @override
  Future<List<ResultEntity>> getResults(String notebookId) async {
    final db = await _dbFuture;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT r.* FROM results r
      INNER JOIN expressions e ON r.expression_id = e.id
      WHERE e.notebook_id = ?
      ''',
      [notebookId],
    );
    return maps.map((m) => ResultEntity.fromMap(m)).toList();
  }

  @override
  Future<List<VariableEntity>> getVariables(String notebookId) async {
    final db = await _dbFuture;
    final List<Map<String, dynamic>> maps = await db.query(
      'variables',
      where: 'notebook_id = ?',
      whereArgs: [notebookId],
    );
    return maps.map((m) => VariableEntity.fromMap(m)).toList();
  }

  @override
  Future<void> saveResult(ResultEntity result) async {
    final db = await _dbFuture;
    await db.insert(
      'results',
      result.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> saveVariable(VariableEntity variable) async {
    final db = await _dbFuture;
    await db.insert(
      'variables',
      variable.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteResult(String expressionId) async {
    final db = await _dbFuture;
    await db.delete(
      'results',
      where: 'expression_id = ?',
      whereArgs: [expressionId],
    );
  }

  @override
  Future<void> deleteVariable(String name, String notebookId) async {
    final db = await _dbFuture;
    await db.delete(
      'variables',
      where: 'name = ? AND notebook_id = ?',
      whereArgs: [name, notebookId],
    );
  }

  @override
  Future<void> replaceResultsAndVariables({
    required String notebookId,
    required List<ResultEntity> results,
    required List<VariableEntity> variables,
  }) async {
    final db = await _dbFuture;
    await db.transaction((txn) async {
      // 1. Delete all results for this notebook
      await txn.rawDelete(
        '''
        DELETE FROM results WHERE expression_id IN (
          SELECT id FROM expressions WHERE notebook_id = ?
        )
        ''',
        [notebookId],
      );

      // 2. Delete all variables for this notebook
      await txn.delete(
        'variables',
        where: 'notebook_id = ?',
        whereArgs: [notebookId],
      );

      // 3. Insert new results
      for (final r in results) {
        await txn.insert(
          'results',
          r.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // 4. Insert new variables
      for (final v in variables) {
        await txn.insert(
          'variables',
          v.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }
}
