/// Canvas viewport state model.
///
/// Represents the current viewport state of the infinite canvas, including
/// pan offset, zoom level, and interaction mode. Uses freezed for
/// immutability and copyWith support.
library;

import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'stroke.dart';

part 'canvas_state.freezed.dart';

/// The current interaction mode of the canvas.
enum CanvasMode {
  /// Drawing mode — single-finger gestures create strokes.
  draw,

  /// Pan mode — used during two-finger drag gestures.
  pan,
}

/// Immutable state representing the canvas viewport.
///
/// [viewportOffset] is the pan offset in world coordinates.
/// [zoomLevel] is the current zoom multiplier (clamped 0.1–10.0).
/// [mode] indicates the current gesture interaction mode.
/// [showHint] controls visibility of the "start writing" ghost hint.
/// [strokes] is the list of completed strokes in the notebook.
/// [currentStroke] is the active stroke currently being drawn.
/// [currentNotebookId] is the ID of the currently loaded notebook.
@freezed
class CanvasState with _$CanvasState {
  /// Creates a [CanvasState] with default viewport values.
  const factory CanvasState({
    @Default(Offset.zero) Offset viewportOffset,
    @Default(1.0) double zoomLevel,
    @Default(CanvasMode.draw) CanvasMode mode,
    @Default(true) bool showHint,
    @Default(<Stroke>[]) List<Stroke> strokes,
    Stroke? currentStroke,
    String? currentNotebookId,
  }) = _CanvasState;
}

