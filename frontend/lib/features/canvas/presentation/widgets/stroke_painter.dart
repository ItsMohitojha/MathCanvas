/// Stroke painter widget.
///
/// A CustomPainter that renders both completed and active hand-drawn strokes
/// using Catmull-Rom spline interpolation and pressure-sensitive width.
/// Automatically applies viewport culling based on stroke bounding boxes.
library;

import 'package:flutter/material.dart';
import 'package:mathcanvas/features/canvas/domain/models/canvas_transform.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke_point.dart';

/// Paints strokes on the infinite canvas.
class StrokePainter extends CustomPainter {
  /// Creates a [StrokePainter].
  StrokePainter({
    required this.strokes,
    required this.currentStroke,
    required this.viewportOffset,
    required this.zoomLevel,
    required this.strokeColor,
  });

  /// Completed strokes to render.
  final List<Stroke> strokes;

  /// The active stroke currently being drawn.
  final Stroke? currentStroke;

  /// Current viewport pan offset in world coordinates.
  final Offset viewportOffset;

  /// Current viewport zoom level.
  final double zoomLevel;

  /// Default paint color for the strokes.
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (strokes.isEmpty && currentStroke == null) return;

    final transform = CanvasTransform(
      offset: viewportOffset,
      zoom: zoomLevel,
    );

    // Calculate expanded visible world bounds (plus 100px margin in world units)
    final margin = 100.0 / zoomLevel;
    final visibleWorldRect = transform.visibleWorldRect(size, margin: margin);

    canvas.save();
    // Apply viewport transform so we can draw in world coordinates directly
    canvas.transform(transform.transformMatrix.storage);

    final paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    // Renders a stroke.
    void drawStroke(Stroke stroke) {
      final points = stroke.points;
      if (points.length < 2) return;

      final baseWidth = stroke.strokeWidth;

      for (var i = 0; i < points.length - 1; i++) {
        final q0 = i > 0 ? points[i - 1] : points[i];
        final q1 = points[i];
        final q2 = points[i + 1];
        final q3 = i < points.length - 2 ? points[i + 2] : points[i + 1];

        const subdivisions = 4;
        var prevOffset = Offset(q1.x, q1.y);

        for (var j = 1; j <= subdivisions; j++) {
          final t = j / subdivisions;
          final currentOffset = _catmullRom(
            Offset(q0.x, q0.y),
            Offset(q1.x, q1.y),
            Offset(q2.x, q2.y),
            Offset(q3.x, q3.y),
            t,
          );

          final pressure = q1.pressure * (1.0 - t) + q2.pressure * t;
          // Apply pressure formula: Width = baseWidth * (0.5 + pressure * 0.5)
          paint.strokeWidth = baseWidth * (0.5 + pressure * 0.5);

          canvas.drawLine(prevOffset, currentOffset, paint);
          prevOffset = currentOffset;
        }
      }
    }

    // 1. Draw completed strokes, applying viewport culling
    for (final stroke in strokes) {
      final bbox = stroke.boundingBox;
      if (bbox.overlaps(visibleWorldRect)) {
        drawStroke(stroke);
      }
    }

    // 2. Draw active stroke (no culling since it is actively being drawn)
    final activeStroke = currentStroke;
    if (activeStroke != null) {
      drawStroke(activeStroke);
    }

    canvas.restore();
  }

  /// Calculates a point along a Catmull-Rom spline.
  Offset _catmullRom(Offset p0, Offset p1, Offset p2, Offset p3, double t) {
    final t2 = t * t;
    final t3 = t2 * t;

    final x = 0.5 *
        ((2 * p1.dx) +
            (-p0.dx + p2.dx) * t +
            (2 * p0.dx - 5 * p1.dx + 4 * p2.dx - p3.dx) * t2 +
            (-p0.dx + 3 * p1.dx - 3 * p2.dx + p3.dx) * t3);

    final y = 0.5 *
        ((2 * p1.dy) +
            (-p0.dy + p2.dy) * t +
            (2 * p0.dy - 5 * p1.dy + 4 * p2.dy - p3.dy) * t2 +
            (-p0.dy + 3 * p1.dy - 3 * p2.dy + p3.dy) * t3);

    return Offset(x, y);
  }

  @override
  bool shouldRepaint(covariant StrokePainter oldDelegate) {
    return oldDelegate.strokes != strokes ||
        oldDelegate.currentStroke != currentStroke ||
        oldDelegate.viewportOffset != viewportOffset ||
        oldDelegate.zoomLevel != zoomLevel ||
        oldDelegate.strokeColor != strokeColor;
  }
}
