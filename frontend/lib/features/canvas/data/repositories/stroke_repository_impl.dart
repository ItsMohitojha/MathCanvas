/// Stroke repository implementation.
///
/// Implements [StrokeRepository] by coordinating save and load operations
/// using [StrokeLocalDatasource] and converting models to/from entities.
library;

import 'dart:ui';

import 'package:mathcanvas/features/canvas/data/datasources/stroke_local_datasource.dart';
import 'package:mathcanvas/features/canvas/data/models/stroke_entity.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke.dart';
import 'package:mathcanvas/features/canvas/domain/repositories/stroke_repository.dart';

/// Repository implementation for strokes.
class StrokeRepositoryImpl implements StrokeRepository {
  /// Creates a [StrokeRepositoryImpl] with the given datasource.
  const StrokeRepositoryImpl(this._localDatasource);

  final StrokeLocalDatasource _localDatasource;

  @override
  Future<void> saveStroke(Stroke stroke) async {
    await _localDatasource.insertStroke(StrokeEntity.fromDomain(stroke));
  }

  @override
  Future<void> saveStrokes(List<Stroke> strokes) async {
    final entities = strokes.map(StrokeEntity.fromDomain).toList();
    await _localDatasource.insertStrokeBatch(entities);
  }

  @override
  Future<void> deleteStroke(String id) async {
    await _localDatasource.deleteStroke(id);
  }

  @override
  Future<List<Stroke>> getStrokes(String notebookId) async {
    final entities = await _localDatasource.getStrokesByNotebookId(notebookId);
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<Stroke>> getStrokesInViewport(
    String notebookId,
    Rect viewport,
  ) async {
    final entities =
        await _localDatasource.getStrokesInViewport(notebookId, viewport);
    return entities.map((e) => e.toDomain()).toList();
  }
}
