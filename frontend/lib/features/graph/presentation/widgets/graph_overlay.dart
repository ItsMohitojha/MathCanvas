import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/features/canvas/domain/models/canvas_transform.dart';
import 'package:mathcanvas/features/canvas/presentation/providers/canvas_state_provider.dart';
import 'package:mathcanvas/features/recognition/presentation/providers/recognition_state_provider.dart';
import 'package:mathcanvas/features/recognition/domain/models/recognized_expression.dart';
import '../providers/graph_state_provider.dart';
import '../../domain/models/graph_data.dart';
import 'graph_card_widget.dart';

/// Canvas-level overlay that positions [GraphCardWidget]s below their
/// parent function expressions.
///
/// Reads the graph and recognition states to determine which expressions
/// have active graphs, then positions each card in screen-space
/// below the expression's bounding box.
class GraphOverlay extends ConsumerWidget {
  /// Creates a [GraphOverlay].
  const GraphOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canvasState = ref.watch(canvasStateProvider);
    final recognitionState = ref.watch(recognitionStateProvider);
    final graphState = ref.watch(graphStateProvider);

    if (graphState.graphs.isEmpty) {
      return const SizedBox.shrink();
    }

    final transform = CanvasTransform(
      offset: canvasState.viewportOffset,
      zoom: canvasState.zoomLevel,
    );

    // Build positioned graph cards
    final children = <Widget>[];

    for (final entry in graphState.graphs.entries) {
      final expressionId = entry.key;
      final graphData = entry.value;

      // Find the corresponding expression to get its bounding box
      final expression = recognitionState.expressions
          .where((e) => e.id == expressionId)
          .firstOrNull;

      if (expression == null) continue;

      // Calculate screen position: below the expression bbox
      final bboxBottom = transform.worldToScreen(
        Offset(expression.bboxMinX, expression.bboxMaxY),
      );
      final bboxCenter = transform.worldToScreen(
        Offset(
          (expression.bboxMinX + expression.bboxMaxX) / 2,
          expression.bboxMaxY,
        ),
      );

      // Position graph card centered below expression, offset down
      // to avoid overlapping the math result overlay
      final cardLeft = bboxCenter.dx - 160; // Half of 320 card width
      final cardTop = bboxBottom.dy + 48; // Below result overlay

      children.add(
        Positioned(
          left: cardLeft,
          top: cardTop,
          child: GraphCardWidget(
            graphData: graphData,
            onRefreshRequested: (exprId, xMin, xMax) {
              final parsedExpr =
                  expression.parsedExpression ?? expression.rawLatex;
              ref.read(graphStateProvider.notifier).refreshGraph(
                    exprId,
                    parsedExpr,
                    xRangeMin: xMin,
                    xRangeMax: xMax,
                  );
            },
            onRangeChanged: (range) {
              ref.read(graphStateProvider.notifier).updateGraphRange(
                    expressionId,
                    xRangeMin: range.xMin,
                    xRangeMax: range.xMax,
                  );
            },
          ),
        ),
      );
    }

    return Stack(children: children);
  }
}
