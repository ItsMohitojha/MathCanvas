import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../domain/models/graph_data.dart';

/// CustomPainter that renders a 2D function graph natively.
///
/// Draws axes, grid lines, tick labels, title, and the data curve.
/// Handles null y-values by breaking the polyline at discontinuities.
class GraphChartPainter extends CustomPainter {
  /// The graph data to render.
  final GraphData graphData;

  /// Background color of the chart area.
  final Color backgroundColor;

  /// Color used for grid lines.
  final Color gridColor;

  /// Color used for axes.
  final Color axisColor;

  /// Color used for labels and title text.
  final Color labelColor;

  /// Whether to show the grid.
  final bool showGrid;

  /// Optional inspected point to highlight.
  final Offset? inspectedPoint;

  /// Creates a [GraphChartPainter].
  GraphChartPainter({
    required this.graphData,
    this.backgroundColor = const Color(0xFF0F172A),
    this.gridColor = const Color(0xFF1E293B),
    this.axisColor = const Color(0xFF64748B),
    this.labelColor = const Color(0xFF94A3B8),
    this.showGrid = true,
    this.inspectedPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!graphData.hasData) return;

    // Chart margins for labels
    const double marginLeft = 48.0;
    const double marginRight = 16.0;
    const double marginTop = 28.0;
    const double marginBottom = 32.0;

    final chartRect = Rect.fromLTRB(
      marginLeft,
      marginTop,
      size.width - marginRight,
      size.height - marginBottom,
    );

    // Compute data bounds
    final xMin = graphData.xRangeMin;
    final xMax = graphData.xRangeMax;
    final yMinData = graphData.yMin ?? -1.0;
    final yMaxData = graphData.yMax ?? 1.0;

    // Add 10% padding to y range
    final yRange = yMaxData - yMinData;
    final yPad = yRange == 0 ? 1.0 : yRange * 0.1;
    final yMin = yMinData - yPad;
    final yMax = yMaxData + yPad;

    // Coordinate mapping helpers
    double mapX(double x) {
      return chartRect.left +
          (x - xMin) / (xMax - xMin) * chartRect.width;
    }

    double mapY(double y) {
      return chartRect.bottom -
          (y - yMin) / (yMax - yMin) * chartRect.height;
    }

    // Draw background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = backgroundColor,
    );

    // Draw grid lines
    if (showGrid) {
      _drawGrid(canvas, chartRect, xMin, xMax, yMin, yMax, mapX, mapY);
    }

    // Draw axes
    _drawAxes(canvas, chartRect, xMin, xMax, yMin, yMax, mapX, mapY);

    // Draw tick labels
    _drawTickLabels(canvas, chartRect, xMin, xMax, yMin, yMax, mapX, mapY);

    // Draw curve
    _drawCurve(canvas, chartRect, mapX, mapY);

    // Draw title
    _drawTitle(canvas, size);

    // Draw inspected point
    if (inspectedPoint != null) {
      _drawInspectedPoint(canvas, chartRect, mapX, mapY, xMin, xMax, yMin, yMax);
    }
  }

  void _drawGrid(
    Canvas canvas,
    Rect chartRect,
    double xMin,
    double xMax,
    double yMin,
    double yMax,
    double Function(double) mapX,
    double Function(double) mapY,
  ) {
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.5;

    // Vertical grid lines
    final xTicks = _computeTicks(xMin, xMax);
    for (final tick in xTicks) {
      final x = mapX(tick);
      canvas.drawLine(
        Offset(x, chartRect.top),
        Offset(x, chartRect.bottom),
        gridPaint,
      );
    }

    // Horizontal grid lines
    final yTicks = _computeTicks(yMin, yMax);
    for (final tick in yTicks) {
      final y = mapY(tick);
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
    }
  }

  void _drawAxes(
    Canvas canvas,
    Rect chartRect,
    double xMin,
    double xMax,
    double yMin,
    double yMax,
    double Function(double) mapX,
    double Function(double) mapY,
  ) {
    final axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = 1.2;

    // X axis (y=0 line, if visible)
    if (yMin <= 0 && yMax >= 0) {
      final y0 = mapY(0);
      canvas.drawLine(
        Offset(chartRect.left, y0),
        Offset(chartRect.right, y0),
        axisPaint,
      );
    }

    // Y axis (x=0 line, if visible)
    if (xMin <= 0 && xMax >= 0) {
      final x0 = mapX(0);
      canvas.drawLine(
        Offset(x0, chartRect.top),
        Offset(x0, chartRect.bottom),
        axisPaint,
      );
    }

    // Chart border
    final borderPaint = Paint()
      ..color = axisColor.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawRect(chartRect, borderPaint);
  }

  void _drawTickLabels(
    Canvas canvas,
    Rect chartRect,
    double xMin,
    double xMax,
    double yMin,
    double yMax,
    double Function(double) mapX,
    double Function(double) mapY,
  ) {
    final xTicks = _computeTicks(xMin, xMax);
    for (final tick in xTicks) {
      final label = _formatTickLabel(tick);
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(color: labelColor, fontSize: 9),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final x = mapX(tick);
      tp.paint(canvas, Offset(x - tp.width / 2, chartRect.bottom + 4));
    }

    final yTicks = _computeTicks(yMin, yMax);
    for (final tick in yTicks) {
      final label = _formatTickLabel(tick);
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(color: labelColor, fontSize: 9),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final y = mapY(tick);
      tp.paint(canvas, Offset(chartRect.left - tp.width - 4, y - tp.height / 2));
    }
  }

  void _drawCurve(
    Canvas canvas,
    Rect chartRect,
    double Function(double) mapX,
    double Function(double) mapY,
  ) {
    final curveColor = _parseColor(graphData.color);
    final curvePaint = Paint()
      ..color = curveColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Clip to chart area
    canvas.save();
    canvas.clipRect(chartRect);

    Path? currentPath;
    for (var i = 0; i < graphData.xValues.length; i++) {
      final y = graphData.yValues[i];
      if (y == null) {
        // Break the line at discontinuities
        if (currentPath != null) {
          canvas.drawPath(currentPath, curvePaint);
          currentPath = null;
        }
        continue;
      }

      final px = mapX(graphData.xValues[i]);
      final py = mapY(y);

      if (currentPath == null) {
        currentPath = Path()..moveTo(px, py);
      } else {
        currentPath.lineTo(px, py);
      }
    }

    if (currentPath != null) {
      canvas.drawPath(currentPath, curvePaint);
    }

    // Draw a subtle glow beneath the curve
    final glowPaint = Paint()
      ..color = curveColor.withValues(alpha: 0.15)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    Path? glowPath;
    for (var i = 0; i < graphData.xValues.length; i++) {
      final y = graphData.yValues[i];
      if (y == null) {
        if (glowPath != null) {
          canvas.drawPath(glowPath, glowPaint);
          glowPath = null;
        }
        continue;
      }
      final px = mapX(graphData.xValues[i]);
      final py = mapY(y);
      if (glowPath == null) {
        glowPath = Path()..moveTo(px, py);
      } else {
        glowPath.lineTo(px, py);
      }
    }
    if (glowPath != null) {
      canvas.drawPath(glowPath, glowPaint);
    }

    canvas.restore();
  }

  void _drawTitle(Canvas canvas, Size size) {
    final tp = TextPainter(
      text: TextSpan(
        text: graphData.title,
        style: TextStyle(
          color: labelColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width - 32);
    tp.paint(canvas, Offset((size.width - tp.width) / 2, 6));
  }

  void _drawInspectedPoint(
    Canvas canvas,
    Rect chartRect,
    double Function(double) mapX,
    double Function(double) mapY,
    double xMin,
    double xMax,
    double yMin,
    double yMax,
  ) {
    if (inspectedPoint == null) return;

    // Find nearest data point to the inspected position
    final tapX = inspectedPoint!.dx;
    final tapY = inspectedPoint!.dy;

    // Convert screen tap to data coordinates
    final dataX = xMin + (tapX - chartRect.left) / chartRect.width * (xMax - xMin);

    // Find closest x index
    int closestIdx = 0;
    double closestDist = double.infinity;
    for (var i = 0; i < graphData.xValues.length; i++) {
      final dist = (graphData.xValues[i] - dataX).abs();
      if (dist < closestDist) {
        closestDist = dist;
        closestIdx = i;
      }
    }

    final pointY = graphData.yValues[closestIdx];
    if (pointY == null) return;

    final px = mapX(graphData.xValues[closestIdx]);
    final py = mapY(pointY);

    // Draw crosshair
    final crosshairPaint = Paint()
      ..color = _parseColor(graphData.color).withValues(alpha: 0.4)
      ..strokeWidth = 0.8;
    canvas.drawLine(Offset(px, chartRect.top), Offset(px, chartRect.bottom), crosshairPaint);
    canvas.drawLine(Offset(chartRect.left, py), Offset(chartRect.right, py), crosshairPaint);

    // Draw dot
    canvas.drawCircle(
      Offset(px, py),
      5.0,
      Paint()..color = _parseColor(graphData.color),
    );
    canvas.drawCircle(
      Offset(px, py),
      3.0,
      Paint()..color = const Color(0xFF0F172A),
    );

    // Draw tooltip
    final xVal = graphData.xValues[closestIdx];
    final tooltipText = '(${_formatTickLabel(xVal)}, ${_formatTickLabel(pointY)})';
    final tp = TextPainter(
      text: TextSpan(
        text: tooltipText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          fontFamily: 'monospace',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    // Position tooltip above the point
    var tooltipX = px - tp.width / 2;
    var tooltipY = py - tp.height - 14;

    // Clamp within chart bounds
    tooltipX = tooltipX.clamp(chartRect.left, chartRect.right - tp.width - 8);
    tooltipY = tooltipY.clamp(chartRect.top, chartRect.bottom - tp.height);

    final tooltipRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tooltipX - 4, tooltipY - 2, tp.width + 8, tp.height + 4),
      const Radius.circular(4),
    );
    canvas.drawRRect(tooltipRect, Paint()..color = const Color(0xFF1E293B));
    canvas.drawRRect(
      tooltipRect,
      Paint()
        ..color = _parseColor(graphData.color).withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
    tp.paint(canvas, Offset(tooltipX, tooltipY));
  }

  /// Computes sensible tick positions for a given range.
  List<double> _computeTicks(double min, double max, {int targetCount = 5}) {
    final range = max - min;
    if (range <= 0) return [];

    // Calculate a "nice" step size
    final rawStep = range / targetCount;
    final magnitude = math.pow(10, (math.log(rawStep) / math.ln10).floor()).toDouble();
    final normalizedStep = rawStep / magnitude;

    double niceStep;
    if (normalizedStep <= 1.5) {
      niceStep = magnitude;
    } else if (normalizedStep <= 3.5) {
      niceStep = 2 * magnitude;
    } else if (normalizedStep <= 7.5) {
      niceStep = 5 * magnitude;
    } else {
      niceStep = 10 * magnitude;
    }

    final ticks = <double>[];
    var tick = (min / niceStep).ceil() * niceStep;
    while (tick <= max) {
      ticks.add(tick);
      tick += niceStep;
    }
    return ticks;
  }

  /// Formats a numeric value for tick labels.
  String _formatTickLabel(double value) {
    if (value == value.roundToDouble() && value.abs() < 1e6) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  /// Parses a hex color string into a [Color].
  Color _parseColor(String hex) {
    try {
      final buffer = StringBuffer();
      if (hex.startsWith('#')) {
        buffer.write('FF');
        buffer.write(hex.substring(1));
      } else {
        buffer.write('FF');
        buffer.write(hex);
      }
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return const Color(0xFF6366F1); // Fallback indigo
    }
  }

  @override
  bool shouldRepaint(covariant GraphChartPainter oldDelegate) {
    return oldDelegate.graphData != graphData ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.inspectedPoint != inspectedPoint ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
