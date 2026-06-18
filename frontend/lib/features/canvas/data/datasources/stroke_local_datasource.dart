/// Stroke local data source.
///
/// Executes raw SQL queries on the SQLite database using sqflite.
/// Handles operations such as inserting, deleting, and fetching strokes.
library;

import 'dart:ui';

import 'package:sqflite/sqflite.dart';
import '../models/stroke_entity.dart';

/// Abstract interface for stroke local data storage.
abstract class StrokeLocalDatasource {
  /// Inserts a stroke entity into the database.
  Future<void> insertStroke(StrokeEntity stroke);

  /// Inserts a list of stroke entities as a batch transaction.
  Future<void> insertStrokeBatch(List<StrokeEntity> strokes);

  /// Deletes a stroke entity by ID.
  Future<void> deleteStroke(String id);

  /// Gets all stroke entities for a notebook ID ordered by creation time.
  Future<List<StrokeEntity>> getStrokesByNotebookId(String notebookId);

  /// Gets all stroke entities within the visible viewport bounds.
  Future<List<StrokeEntity>> getStrokesInViewport(
    String notebookId,
    Rect viewport,
  );
}

/// Local SQLite data source implementation for strokes.
class StrokeLocalDatasourceImpl implements StrokeLocalDatasource {
  /// Creates a [StrokeLocalDatasourceImpl] with a future database reference.
  const StrokeLocalDatasourceImpl(this._dbFuture);

  final Future<Database> _dbFuture;

  @override
  Future<void> insertStroke(StrokeEntity stroke) async {
    final db = await _dbFuture;
    await db.insert(
      'strokes',
      stroke.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> insertStrokeBatch(List<StrokeEntity> strokes) async {
    final db = await _dbFuture;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final stroke in strokes) {
        batch.insert(
          'strokes',
          stroke.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> deleteStroke(String id) async {
    final db = await _dbFuture;
    await db.delete(
      'strokes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<StrokeEntity>> getStrokesByNotebookId(String notebookId) async {
    final db = await _dbFuture;
    final List<Map<String, dynamic>> maps = await db.query(
      'strokes',
      where: 'notebook_id = ?',
      whereArgs: [notebookId],
      orderBy: 'created_at ASC',
    );
    return maps.map((map) => StrokeEntity.fromMap(map)).toList();
  }

  @override
  Future<List<StrokeEntity>> getStrokesInViewport(
    String notebookId,
    Rect viewport,
  ) async {
    final db = await _dbFuture;
    final List<Map<String, dynamic>> maps = await db.query(
      'strokes',
      where: '''
        notebook_id = ?
        AND bbox_max_x >= ?
        AND bbox_min_x <= ?
        AND bbox_max_y >= ?
        AND bbox_min_y <= ?
      ''',
      whereArgs: [
        notebookId,
        viewport.left,
        viewport.right,
        viewport.top,
        viewport.bottom,
      ],
      orderBy: 'created_at ASC',
    );
    return maps.map((map) => StrokeEntity.fromMap(map)).toList();
  }
}
