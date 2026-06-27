import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/features/canvas/domain/models/canvas_transform.dart';
import 'package:mathcanvas/features/canvas/presentation/providers/canvas_state_provider.dart';
import 'package:mathcanvas/features/recognition/presentation/providers/recognition_state_provider.dart';
import 'package:mathcanvas/features/recognition/domain/models/recognized_expression.dart';
import '../providers/math_state_provider.dart';
import '../../domain/models/math_result.dart';

/// Interactive UI overlay that renders math evaluation and solving results directly on the canvas.
class MathResultOverlay extends ConsumerWidget {
  const MathResultOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canvasState = ref.watch(canvasStateProvider);
    final recognitionState = ref.watch(recognitionStateProvider);
    final mathState = ref.watch(mathStateProvider);

    if (recognitionState.expressions.isEmpty || mathState.results.isEmpty) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      painter: MathResultOverlayPainter(
        expressions: recognitionState.expressions,
        results: mathState.results,
        viewportOffset: canvasState.viewportOffset,
        zoomLevel: canvasState.zoomLevel,
        successColor: const Color(0xFF10B981), // Emerald green
        errorColor: const Color(0xFFEF4444),   // Rose red
      ),
      size: Size.infinite,
    );
  }
}

/// CustomPainter drawing the results/errors beneath expressions on the canvas.
class MathResultOverlayPainter extends CustomPainter {
  final List<RecognizedExpression> expressions;
  final Map<String, MathResult> results;
  final Offset viewportOffset;
  final double zoomLevel;
  final Color successColor;
  final Color errorColor;

  MathResultOverlayPainter({
    required this.expressions,
    required this.results,
    required this.viewportOffset,
    required this.zoomLevel,
    required this.successColor,
    required this.errorColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final transform = CanvasTransform(
      offset: viewportOffset,
      zoom: zoomLevel,
    );

    final bgPaint = Paint()..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (final expr in expressions) {
      final result = results[expr.id];
      if (result == null) continue;

      // 1. Get screen-space coordinates of the expression's bounding box
      final topLeft = transform.worldToScreen(Offset(expr.bboxMinX, expr.bboxMinY));
      final bottomRight = transform.worldToScreen(Offset(expr.bboxMaxX, expr.bboxMaxY));
      
      final screenRect = Rect.fromLTRB(
        topLeft.dx - 8,
        topLeft.dy - 8,
        bottomRight.dx + 8,
        bottomRight.dy + 8,
      );

      // 2. Determine container styling based on status
      final isErr = result.isError;
      final accentColor = isErr ? errorColor : successColor;

      bgPaint.color = const Color(0xFF0F172A).withValues(alpha: 0.95); // Deep slate background
      borderPaint.color = accentColor.withValues(alpha: 0.8);

      // 3. Prepare result text painter
      final resultText = isErr ? 'Error: ${result.value}' : '= ${result.value}';
      final textPainter = TextPainter(
        text: TextSpan(
          text: resultText,
          style: TextStyle(
            color: isErr ? errorColor.withValues(alpha: 0.95) : Colors.white,
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            fontFamily: 'monospace',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: size.width * 0.8);

      final resultWidth = textPainter.width;
      final resultHeight = textPainter.height;

      // 4. Center the result container directly underneath the expression bounding box
      final boxX = screenRect.center.dx - (resultWidth / 2);
      final boxY = screenRect.bottom + 8;

      final containerRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          boxX - 10,
          boxY - 6,
          resultWidth + 20,
          resultHeight + 12,
        ),
        const Radius.circular(8.0),
      );

      // Draw container shadow
      canvas.drawRRect(
        containerRect,
        Paint()
          ..color = Colors.black.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0),
      );

      // Draw container background and border
      canvas.drawRRect(containerRect, bgPaint);
      canvas.drawRRect(containerRect, borderPaint);

      // Draw result text
      textPainter.paint(canvas, Offset(boxX, boxY));
    }
  }

  @override
  bool shouldRepaint(covariant MathResultOverlayPainter oldDelegate) {
    return oldDelegate.expressions != expressions ||
        oldDelegate.results != results ||
        oldDelegate.viewportOffset != viewportOffset ||
        oldDelegate.zoomLevel != zoomLevel ||
        oldDelegate.successColor != successColor ||
        oldDelegate.errorColor != errorColor;
  }
}
