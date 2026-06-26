/// Main canvas composition widget.
///
/// Composes the canvas rendering stack: background grid,
/// future stroke layers, and overlay layers. Wrapped by
/// [CanvasGestureHandler] for pan/zoom input.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/app/theme/app_theme.dart';
import 'package:mathcanvas/features/canvas/presentation/providers/canvas_state_provider.dart';
import 'package:mathcanvas/features/canvas/presentation/widgets/canvas_background_painter.dart';
import 'package:mathcanvas/features/canvas/presentation/widgets/canvas_gesture_handler.dart';
import 'package:mathcanvas/features/canvas/presentation/widgets/stroke_painter.dart';
import 'package:mathcanvas/features/recognition/presentation/providers/recognition_state_provider.dart';
import 'package:mathcanvas/features/recognition/presentation/widgets/recognition_overlay_painter.dart';

/// The main infinite canvas widget.
///
/// Renders the background grid, hand-drawn strokes, and recognized
/// mathematical expression overlays. Wrapped with gesture detection.
class CanvasWidget extends ConsumerWidget {
  /// Creates the canvas widget.
  const CanvasWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canvasState = ref.watch(canvasStateProvider);
    final colors = context.appColorScheme;

    return CanvasGestureHandler(
      child: Stack(
        children: [
          // Background Layer: Dot grid that changes only on pan/zoom
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: CanvasBackgroundPainter(
                  viewportOffset: canvasState.viewportOffset,
                  zoomLevel: canvasState.zoomLevel,
                  gridColor: colors.canvasGrid,
                  backgroundColor: colors.canvasBackground,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          // Stroke Layer: Drawing path and finished strokes, repaints on draw
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: StrokePainter(
                  strokes: canvasState.strokes,
                  currentStroke: canvasState.currentStroke,
                  viewportOffset: canvasState.viewportOffset,
                  zoomLevel: canvasState.zoomLevel,
                  strokeColor: colors.strokeDefault,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          // Recognition Layer: Draws bounding boxes and math labels
          Positioned.fill(
            child: IgnorePointer(
              child: Consumer(
                builder: (context, ref, child) {
                  final recState = ref.watch(recognitionStateProvider);
                  return CustomPaint(
                    painter: RecognitionOverlayPainter(
                      expressions: recState.expressions,
                      viewportOffset: canvasState.viewportOffset,
                      zoomLevel: canvasState.zoomLevel,
                      primaryColor: colors.primary,
                      warningColor: colors.warning,
                      labelTextColor: colors.onPrimary,
                    ),
                    child: const SizedBox.expand(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

