/// Canvas background painter that renders a dot grid.
///
/// Draws a grid of small circular dots at regular intervals in
/// world coordinates. The grid transforms with the canvas viewport
/// and fades out at low zoom levels for visual clarity.
library;

import 'package:flutter/material.dart';

/// Dot grid spacing in world-coordinate units.
const double _gridSpacing = 20.0;

/// Dot radius in screen pixels.
const double _dotRadius = 1.2;

/// Zoom level below which the grid starts fading out.
const double _fadeStartZoom = 0.5;

/// Zoom level below which the grid is fully invisible.
const double _fadeEndZoom = 0.1;

/// Paints a dot grid background that transforms with the viewport.
///
/// The grid is rendered in world coordinates and clips to the
/// visible viewport for performance. Dots fade out at very low
/// zoom levels to avoid visual clutter.
class CanvasBackgroundPainter extends CustomPainter {
  /// Creates a background painter with the given viewport state.
  CanvasBackgroundPainter({
    required this.viewportOffset,
    required this.zoomLevel,
    required this.gridColor,
    required this.backgroundColor,
  });

  /// Current pan offset in world coordinates.
  final Offset viewportOffset;

  /// Current zoom multiplier.
  final double zoomLevel;

  /// Color for the grid dots, from the theme's canvas grid token.
  final Color gridColor;

  /// Canvas background fill color, from the theme token.
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    // Fill background.
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = backgroundColor,
    );

    // Fade out grid at very low zoom levels.
    final opacity = _calculateGridOpacity();
    if (opacity <= 0) return;

    final dotPaint = Paint()
      ..color = gridColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    // Calculate visible world rect.
    final worldLeft = -viewportOffset.dx;
    final worldTop = -viewportOffset.dy;
    final worldRight = worldLeft + size.width / zoomLevel;
    final worldBottom = worldTop + size.height / zoomLevel;

    // Snap to grid boundaries.
    final startX =
        (worldLeft / _gridSpacing).floor() * _gridSpacing;
    final startY =
        (worldTop / _gridSpacing).floor() * _gridSpacing;
    final endX =
        (worldRight / _gridSpacing).ceil() * _gridSpacing;
    final endY =
        (worldBottom / _gridSpacing).ceil() * _gridSpacing;

    // Draw dots at grid intersections.
    for (var x = startX; x <= endX; x += _gridSpacing) {
      for (var y = startY; y <= endY; y += _gridSpacing) {
        final screenX = (x + viewportOffset.dx) * zoomLevel;
        final screenY = (y + viewportOffset.dy) * zoomLevel;
        canvas.drawCircle(
          Offset(screenX, screenY),
          _dotRadius,
          dotPaint,
        );
      }
    }
  }

  double _calculateGridOpacity() {
    if (zoomLevel >= _fadeStartZoom) return 1.0;
    if (zoomLevel <= _fadeEndZoom) return 0.0;
    return (zoomLevel - _fadeEndZoom) / (_fadeStartZoom - _fadeEndZoom);
  }

  @override
  bool shouldRepaint(covariant CanvasBackgroundPainter oldDelegate) {
    return oldDelegate.viewportOffset != viewportOffset ||
        oldDelegate.zoomLevel != zoomLevel ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
