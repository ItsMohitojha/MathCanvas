/// Stroke repository interface.
///
/// Defines the contract for persistence operations on [Stroke] models,
/// allowing saving, deleting, and loading strokes in standard or viewport-culled configurations.
library;

import 'dart:ui';

import '../models/stroke.dart';

/// Repository interface for stroke storage.
abstract class StrokeRepository {
  /// Saves a single [stroke] to persistent storage.
  Future<void> saveStroke(Stroke stroke);

  /// Saves a list of [strokes] to persistent storage in a single batch transaction.
  Future<void> saveStrokes(List<Stroke> strokes);

  /// Deletes a stroke by its [id].
  Future<void> deleteStroke(String id);

  /// Retrieves all strokes for a given [notebookId], ordered by creation time.
  Future<List<Stroke>> getStrokes(String notebookId);

  /// Retrieves strokes within the visible [viewport] rectangle for a given [notebookId].
  Future<List<Stroke>> getStrokesInViewport(String notebookId, Rect viewport);
}
