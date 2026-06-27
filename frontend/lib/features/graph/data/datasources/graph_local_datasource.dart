import 'package:sqflite/sqflite.dart';
import '../models/graph_entity.dart';

/// Local data source interface for storing and retrieving graph data.
abstract class GraphLocalDatasource {
  /// Fetches all graphs for expressions belonging to a notebook.
  Future<List<GraphEntity>> getGraphs(String notebookId);

  /// Fetches a graph by its expression ID.
  Future<GraphEntity?> getGraphByExpressionId(String expressionId);

  /// Saves or updates a graph record.
  Future<void> saveGraph(GraphEntity graph);

  /// Deletes a graph by its expression reference.
  Future<void> deleteGraph(String expressionId);

  /// Deletes all graphs for expressions belonging to a notebook.
  Future<void> deleteAllGraphs(String notebookId);
}

/// SQLite implementation of the GraphLocalDatasource.
class GraphLocalDatasourceImpl implements GraphLocalDatasource {
  final Future<Database> _dbFuture;

  /// Creates a [GraphLocalDatasourceImpl].
  GraphLocalDatasourceImpl(this._dbFuture);

  @override
  Future<List<GraphEntity>> getGraphs(String notebookId) async {
    final db = await _dbFuture;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT g.* FROM graphs g
      INNER JOIN expressions e ON g.expression_id = e.id
      WHERE e.notebook_id = ?
      ''',
      [notebookId],
    );
    return maps.map((m) => GraphEntity.fromMap(m)).toList();
  }

  @override
  Future<GraphEntity?> getGraphByExpressionId(String expressionId) async {
    final db = await _dbFuture;
    final List<Map<String, dynamic>> maps = await db.query(
      'graphs',
      where: 'expression_id = ?',
      whereArgs: [expressionId],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return GraphEntity.fromMap(maps.first);
  }

  @override
  Future<void> saveGraph(GraphEntity graph) async {
    final db = await _dbFuture;
    await db.insert(
      'graphs',
      graph.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteGraph(String expressionId) async {
    final db = await _dbFuture;
    await db.delete(
      'graphs',
      where: 'expression_id = ?',
      whereArgs: [expressionId],
    );
  }

  @override
  Future<void> deleteAllGraphs(String notebookId) async {
    final db = await _dbFuture;
    await db.rawDelete(
      '''
      DELETE FROM graphs WHERE expression_id IN (
        SELECT id FROM expressions WHERE notebook_id = ?
      )
      ''',
      [notebookId],
    );
  }
}
