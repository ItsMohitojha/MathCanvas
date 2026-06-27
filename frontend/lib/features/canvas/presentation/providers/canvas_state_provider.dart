import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/core/constants/app_constants.dart';
import 'package:mathcanvas/core/utils/uuid_generator.dart';
import 'package:mathcanvas/features/canvas/data/datasources/stroke_local_datasource.dart';
import 'package:mathcanvas/features/canvas/data/repositories/stroke_repository_impl.dart';
import 'package:mathcanvas/features/canvas/domain/models/canvas_state.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke_point.dart';
import 'package:mathcanvas/features/canvas/domain/repositories/stroke_repository.dart';
import 'package:mathcanvas/shared/database/database_provider.dart';

import 'package:mathcanvas/features/notebook/presentation/providers/notebook_state_provider.dart';

/// Provider for the stroke local data source.
final strokeLocalDatasourceProvider = Provider<StrokeLocalDatasource>((ref) {
  final dbFuture = ref.watch(databaseProvider);
  return StrokeLocalDatasourceImpl(dbFuture);
});

/// Provider for the stroke repository.
final strokeRepositoryProvider = Provider<StrokeRepository>((ref) {
  final localDatasource = ref.watch(strokeLocalDatasourceProvider);
  return StrokeRepositoryImpl(localDatasource);
});

/// Provider for the canvas viewport state.
///
/// Exposes [CanvasStateNotifier] which handles all viewport
/// mutations (pan, zoom, reset). Widgets watch this provider
/// to rebuild when the viewport changes.
final canvasStateProvider =
    NotifierProvider<CanvasStateNotifier, CanvasState>(
  CanvasStateNotifier.new,
);

/// Manages canvas viewport state: pan offset, zoom level, and mode.
///
/// All viewport mutations flow through this notifier to ensure
/// state changes are centralized and predictable.
class CanvasStateNotifier extends Notifier<CanvasState> {
  @override
  CanvasState build() => const CanvasState();

  /// Loads strokes and viewport from SQLite database for the given [notebookId].
  Future<void> loadNotebook(String notebookId) async {
    final repository = ref.read(strokeRepositoryProvider);
    final strokes = await repository.getStrokes(notebookId);
    
    final notebookRepo = ref.read(notebookRepositoryProvider);
    final notebook = await notebookRepo.getNotebookById(notebookId);

    state = state.copyWith(
      currentNotebookId: notebookId,
      strokes: strokes,
      currentStroke: null,
      showHint: strokes.isEmpty,
      viewportOffset: notebook != null
          ? Offset(notebook.viewportX, notebook.viewportY)
          : Offset.zero,
      zoomLevel: notebook != null ? notebook.zoomLevel : 1.0,
    );
  }

  /// Starts a new stroke at the given [point] (in world coordinates).
  void startStroke(Offset point, int timestamp, double pressure) {
    final notebookId = state.currentNotebookId;
    if (notebookId == null) return;

    final newPoint = StrokePoint(
      x: point.dx,
      y: point.dy,
      timestamp: timestamp,
      pressure: pressure,
    );

    final newStroke = Stroke(
      id: UuidGenerator.generateV4(),
      notebookId: notebookId,
      points: [newPoint],
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      currentStroke: newStroke,
      showHint: false,
    );
  }

  /// Adds a new [point] (in world coordinates) to the active stroke.
  void updateStroke(Offset point, int timestamp, double pressure) {
    final current = state.currentStroke;
    if (current == null) return;

    final newPoint = StrokePoint(
      x: point.dx,
      y: point.dy,
      timestamp: timestamp,
      pressure: pressure,
    );

    final updatedPoints = List<StrokePoint>.from(current.points)..add(newPoint);
    state = state.copyWith(
      currentStroke: current.copyWith(points: updatedPoints),
    );
  }

  /// Completes the active stroke and persists it to the SQLite database.
  ///
  /// The stroke is discarded if it contains fewer than 2 points to comply
  /// with database constraints and filter out accidental taps.
  Future<void> endStroke(Offset point, int timestamp, double pressure) async {
    final current = state.currentStroke;
    if (current == null) return;

    final newPoint = StrokePoint(
      x: point.dx,
      y: point.dy,
      timestamp: timestamp,
      pressure: pressure,
    );

    final updatedPoints = List<StrokePoint>.from(current.points)..add(newPoint);

    if (updatedPoints.length < 2) {
      // Discard invalid stroke with less than 2 points
      state = state.copyWith(currentStroke: null);
      return;
    }

    final completedStroke = current.copyWith(points: updatedPoints);

    // Persist to local database
    final repository = ref.read(strokeRepositoryProvider);
    await repository.saveStroke(completedStroke);

    state = state.copyWith(
      strokes: List<Stroke>.from(state.strokes)..add(completedStroke),
      currentStroke: null,
    );
  }

  /// Cancels and discards the active stroke currently being drawn.
  void cancelStroke() {
    state = state.copyWith(currentStroke: null);
  }

  /// Pans the viewport by [delta] in screen-space pixels.
  ///
  /// The delta is converted from screen-space to world-space by
  /// dividing by the current zoom level, then added to the offset.
  void pan(Offset delta) {
    final worldDelta = delta / state.zoomLevel;
    state = state.copyWith(
      viewportOffset: state.viewportOffset + worldDelta,
      showHint: false,
    );
  }

  /// Zooms the viewport by [scaleFactor] centered on [focalPoint].
  ///
  /// The focal point (in screen-space) stays fixed during the zoom.
  /// Zoom is clamped between [AppConstants.minZoom] and
  /// [AppConstants.maxZoom] to prevent extreme scales.
  void zoom(double scaleFactor, Offset focalPoint) {
    final oldZoom = state.zoomLevel;
    final newZoom = (oldZoom * scaleFactor).clamp(
      AppConstants.minZoom,
      AppConstants.maxZoom,
    );

    if (newZoom == oldZoom) return;

    // Keep the focal point fixed: adjust offset so the world point
    // under the focal stays at the same screen position.
    final focalWorld = Offset(
      focalPoint.dx / oldZoom - state.viewportOffset.dx,
      focalPoint.dy / oldZoom - state.viewportOffset.dy,
    );
    final newOffset = Offset(
      focalPoint.dx / newZoom - focalWorld.dx,
      focalPoint.dy / newZoom - focalWorld.dy,
    );

    state = state.copyWith(
      viewportOffset: newOffset,
      zoomLevel: newZoom,
      showHint: false,
    );
  }

  /// Resets the viewport to the default position and zoom.
  void resetView() {
    state = state.copyWith(
      viewportOffset: Offset.zero,
      zoomLevel: AppConstants.defaultZoom,
    );
  }

  /// Hides the ghost hint text on the canvas.
  void dismissHint() {
    state = state.copyWith(showHint: false);
  }

  /// Sets the canvas interaction mode.
  void setMode(CanvasMode mode) {
    state = state.copyWith(mode: mode);
  }
}

