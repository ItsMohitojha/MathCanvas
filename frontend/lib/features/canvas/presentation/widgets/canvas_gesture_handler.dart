import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/features/canvas/domain/models/canvas_state.dart';
import 'package:mathcanvas/features/canvas/domain/models/canvas_transform.dart';
import 'package:mathcanvas/features/canvas/presentation/providers/canvas_state_provider.dart';

/// Handles canvas gesture detection for pan, zoom, and drawing.
///
/// Uses raw pointer events via [Listener] to track the number of
/// active pointers and route gestures to the appropriate handler:
/// - 1 finger: drawing strokes (only when canvas mode is draw)
/// - 2 fingers: pan and pinch-to-zoom
class CanvasGestureHandler extends ConsumerStatefulWidget {
  /// Creates a gesture handler that wraps [child].
  const CanvasGestureHandler({
    super.key,
    required this.child,
  });

  /// The child widget (canvas content) to wrap with gestures.
  final Widget child;

  @override
  ConsumerState<CanvasGestureHandler> createState() =>
      _CanvasGestureHandlerState();
}

class _CanvasGestureHandlerState
    extends ConsumerState<CanvasGestureHandler> {
  /// Tracks active pointer positions by pointer ID.
  final Map<int, Offset> _pointers = {};

  /// Previous center point of two-finger gesture for delta calc.
  Offset? _previousCenter;

  /// Previous distance between two fingers for scale calc.
  double? _previousDistance;

  /// Track if stylus input is active for palm rejection.
  bool _stylusActive = false;

  /// The timestamp when the last stylus event occurred.
  DateTime? _lastStylusTime;

  /// Filter out touch pointers when stylus was used recently (palm rejection).
  bool _shouldIgnorePointer(PointerEvent event) {
    if (event.kind == PointerDeviceKind.stylus) {
      _stylusActive = true;
      _lastStylusTime = DateTime.now();
      return false;
    }

    if (event.kind == PointerDeviceKind.touch && _stylusActive) {
      final lastStylus = _lastStylusTime;
      if (lastStylus != null &&
          DateTime.now().difference(lastStylus).inSeconds < 2) {
        // Ignore finger touch if stylus was active within last 2 seconds
        return true;
      } else {
        // Reset stylus active flag after 2 seconds of inactivity
        _stylusActive = false;
      }
    }
    return false;
  }

  Offset _screenToWorld(Offset screenPoint) {
    final state = ref.read(canvasStateProvider);
    final transform = CanvasTransform(
      offset: state.viewportOffset,
      zoom: state.zoomLevel,
    );
    return transform.screenToWorld(screenPoint);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: widget.child,
    );
  }

  void _onPointerDown(PointerDownEvent event) {
    if (_shouldIgnorePointer(event)) return;

    _pointers[event.pointer] = event.localPosition;

    final state = ref.read(canvasStateProvider);

    if (_pointers.length == 1 && state.mode == CanvasMode.draw) {
      // Start single-finger drawing stroke
      final worldPoint = _screenToWorld(event.localPosition);
      ref.read(canvasStateProvider.notifier).startStroke(
            worldPoint,
            event.timeStamp.inMilliseconds,
            event.pressure,
          );
    } else if (_pointers.length == 2) {
      // Transitioning to 2-finger pan/zoom: cancel active drawing stroke
      ref.read(canvasStateProvider.notifier).cancelStroke();

      // Initialize two-finger gesture tracking
      final positions = _pointers.values.toList();
      _previousCenter = _centerOf(positions[0], positions[1]);
      _previousDistance = _distanceBetween(
        positions[0],
        positions[1],
      );
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_shouldIgnorePointer(event)) return;

    _pointers[event.pointer] = event.localPosition;

    final state = ref.read(canvasStateProvider);

    if (_pointers.length == 1 && state.mode == CanvasMode.draw) {
      // Update single-finger drawing stroke
      final worldPoint = _screenToWorld(event.localPosition);
      ref.read(canvasStateProvider.notifier).updateStroke(
            worldPoint,
            event.timeStamp.inMilliseconds,
            event.pressure,
          );
    } else if (_pointers.length == 2) {
      _handleTwoFingerGesture();
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_shouldIgnorePointer(event)) {
      _pointers.remove(event.pointer);
      return;
    }

    final state = ref.read(canvasStateProvider);

    if (_pointers.length == 1 && state.mode == CanvasMode.draw) {
      // Complete single-finger drawing stroke
      final worldPoint = _screenToWorld(event.localPosition);
      ref.read(canvasStateProvider.notifier).endStroke(
            worldPoint,
            event.timeStamp.inMilliseconds,
            event.pressure,
          );
    }

    _pointers.remove(event.pointer);
    _resetTwoFingerState();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    ref.read(canvasStateProvider.notifier).cancelStroke();
    _pointers.remove(event.pointer);
    _resetTwoFingerState();
  }

  void _handleTwoFingerGesture() {
    final positions = _pointers.values.toList();
    if (positions.length != 2) return;

    final currentCenter = _centerOf(positions[0], positions[1]);
    final currentDistance = _distanceBetween(
      positions[0],
      positions[1],
    );
    final notifier = ref.read(canvasStateProvider.notifier);

    // Handle pan (translation).
    if (_previousCenter != null) {
      final delta = currentCenter - _previousCenter!;
      notifier.pan(delta);
    }

    // Handle zoom (scale).
    if (_previousDistance != null && _previousDistance! > 0) {
      final scaleFactor = currentDistance / _previousDistance!;
      if ((scaleFactor - 1.0).abs() > 0.001) {
        notifier.zoom(scaleFactor, currentCenter);
      }
    }

    _previousCenter = currentCenter;
    _previousDistance = currentDistance;
  }

  void _resetTwoFingerState() {
    if (_pointers.length < 2) {
      _previousCenter = null;
      _previousDistance = null;
    }
  }

  /// Returns the midpoint between two positions.
  Offset _centerOf(Offset a, Offset b) {
    return Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
  }

  /// Returns the Euclidean distance between two positions.
  double _distanceBetween(Offset a, Offset b) {
    return (a - b).distance;
  }
}

