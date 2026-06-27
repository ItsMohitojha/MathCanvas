import 'package:sqflite/sqflite.dart';
import '../models/notebook_entity.dart';

/// Local data source interface for notebook operations in SQLite.
abstract class NotebookLocalDatasource {
  /// Fetches all notebooks sorted by updated_at DESC.
  Future<List<NotebookEntity>> getNotebooks();

  /// Fetches a notebook by its ID.
  Future<NotebookEntity?> getNotebookById(String id);

  /// Inserts a new notebook record.
  Future<void> insertNotebook(NotebookEntity notebook);

  /// Updates an existing notebook name and updated_at timestamp.
  Future<void> renameNotebook(String id, String name, int updatedAt);

  /// Deletes a notebook record and its children (via CASCADE constraint).
  Future<void> deleteNotebook(String id);

  /// Updates the viewport offset coordinates and zoom level.
  Future<void> updateViewport(
    String id,
    double x,
    double y,
    double zoom,
    int updatedAt,
  );
}

/// SQLite implementation of the [NotebookLocalDatasource].
class NotebookLocalDatasourceImpl implements NotebookLocalDatasource {
  final Future<Database> _dbFuture;

  /// Creates a [NotebookLocalDatasourceImpl].
  NotebookLocalDatasourceImpl(this._dbFuture);

  @override
  Future<List<NotebookEntity>> getNotebooks() async {
    final db = await _dbFuture;
    final List<Map<String, dynamic>> maps = await db.query(
      'notebooks',
      orderBy: 'updated_at DESC',
    );
    return maps.map((m) => NotebookEntity.fromMap(m)).toList();
  }

  @override
  Future<NotebookEntity?> getNotebookById(String id) async {
    final db = await _dbFuture;
    final List<Map<String, dynamic>> maps = await db.query(
      'notebooks',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return NotebookEntity.fromMap(maps.first);
  }

  @override
  Future<void> insertNotebook(NotebookEntity notebook) async {
    final db = await _dbFuture;
    await db.insert(
      'notebooks',
      notebook.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> renameNotebook(String id, String name, int updatedAt) async {
    final db = await _dbFuture;
    await db.update(
      'notebooks',
      {
        'name': name,
        'updated_at': updatedAt,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteNotebook(String id) async {
    final db = await _dbFuture;
    await db.delete(
      'notebooks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> updateViewport(
    String id,
    double x,
    double y,
    double zoom,
    int updatedAt,
  ) async {
    final db = await _dbFuture;
    await db.update(
      'notebooks',
      {
        'viewport_x': x,
        'viewport_y': y,
        'zoom_level': zoom,
        'updated_at': updatedAt,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
