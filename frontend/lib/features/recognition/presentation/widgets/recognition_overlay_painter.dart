import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mathcanvas/features/canvas/domain/models/canvas_transform.dart';
import 'package:mathcanvas/features/recognition/domain/models/recognized_expression.dart';

/// Renders bounding boxes and recognized LaTeX labels for math expressions.
///
/// Converts world-space coordinates of expressions into screen-space to draw
/// crisp text and dashed borders that stay perfectly aligned with the drawings.
class RecognitionOverlayPainter extends CustomPainter {
  final List<RecognizedExpression> expressions;
  final Offset viewportOffset;
  final double zoomLevel;
  final Color primaryColor;
  final Color warningColor;
  final Color labelTextColor;

  /// Creates a [RecognitionOverlayPainter].
  RecognitionOverlayPainter({
    required this.expressions,
    required this.viewportOffset,
    required this.zoomLevel,
    required this.primaryColor,
    required this.warningColor,
    required this.labelTextColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (expressions.isEmpty) return;

    final transform = CanvasTransform(
      offset: viewportOffset,
      zoom: zoomLevel,
    );

    final boxPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final labelBgPaint = Paint()
      ..style = PaintingStyle.fill;

    for (final expr in expressions) {
      // 1. Convert world-space bounding box to screen-space
      final topLeft = transform.worldToScreen(Offset(expr.bboxMinX, expr.bboxMinY));
      final bottomRight = transform.worldToScreen(Offset(expr.bboxMaxX, expr.bboxMaxY));
      
      // Add a small 8px padding in screen-space around the expression
      final screenRect = Rect.fromLTRB(
        topLeft.dx - 8,
        topLeft.dy - 8,
        bottomRight.dx + 8,
        bottomRight.dy + 8,
      );

      final isLowConfidence = expr.confidence < 0.6 || expr.rawLatex == '?';
      final color = isLowConfidence ? warningColor : primaryColor;
      boxPaint.color = color.withValues(alpha: 0.8);
      labelBgPaint.color = color.withValues(alpha: 0.9);

      // 2. Draw dashed bounding box in screen-space
      _drawDashedRect(canvas, screenRect, boxPaint, 6.0, 4.0);

      // 3. Draw LaTeX label above the bounding box
      final labelText = isLowConfidence ? 'Unrecognized (?)' : expr.rawLatex;
      
      final textPainter = TextPainter(
        text: TextSpan(
          text: labelText,
          style: TextStyle(
            color: labelTextColor,
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      final labelWidth = textPainter.width;
      final labelHeight = textPainter.height;

      // Position the label centered above the bounding box
      final labelX = screenRect.center.dx - (labelWidth / 2);
      final labelY = screenRect.top - labelHeight - 8;

      // Draw label container background
      final backgroundRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          labelX - 8,
          labelY - 4,
          labelWidth + 16,
          labelHeight + 8,
        ),
        const Radius.circular(6.0),
      );
      canvas.drawRRect(backgroundRect, labelBgPaint);

      // Draw label text
      textPainter.paint(canvas, Offset(labelX, labelY));
    }
  }

  void _drawDashedRect(Canvas canvas, Rect rect, Paint paint, double dashLength, double gapLength) {
    _drawDashedLine(canvas, Offset(rect.left, rect.top), Offset(rect.right, rect.top), paint, dashLength, gapLength);
    _drawDashedLine(canvas, Offset(rect.right, rect.top), Offset(rect.right, rect.bottom), paint, dashLength, gapLength);
    _drawDashedLine(canvas, Offset(rect.right, rect.bottom), Offset(rect.left, rect.bottom), paint, dashLength, gapLength);
    _drawDashedLine(canvas, Offset(rect.left, rect.bottom), Offset(rect.left, rect.top), paint, dashLength, gapLength);
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint, double dashLength, double gapLength) {
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    if (distance == 0) return;
    
    final count = (distance / (dashLength + gapLength)).floor();

    for (int i = 0; i < count; i++) {
      final tStart = i * (dashLength + gapLength) / distance;
      final tEnd = (i * (dashLength + gapLength) + dashLength) / distance;
      canvas.drawLine(
        Offset(p1.dx + dx * tStart, p1.dy + dy * tStart),
        Offset(p1.dx + dx * tEnd, p1.dy + dy * tEnd),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant RecognitionOverlayPainter oldDelegate) {
    return oldDelegate.expressions != expressions ||
        oldDelegate.viewportOffset != viewportOffset ||
        oldDelegate.zoomLevel != zoomLevel ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.warningColor != warningColor ||
        oldDelegate.labelTextColor != labelTextColor;
  }
}
