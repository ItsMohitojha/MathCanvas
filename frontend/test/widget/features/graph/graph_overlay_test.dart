import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/features/canvas/domain/models/canvas_state.dart';
import 'package:mathcanvas/features/canvas/presentation/providers/canvas_state_provider.dart';
import 'package:mathcanvas/features/recognition/domain/models/recognized_expression.dart';
import 'package:mathcanvas/features/recognition/presentation/providers/recognition_state_provider.dart';
import 'package:mathcanvas/features/graph/domain/models/graph_data.dart';
import 'package:mathcanvas/features/graph/presentation/providers/graph_state.dart';
import 'package:mathcanvas/features/graph/presentation/providers/graph_state_provider.dart';
import 'package:mathcanvas/features/graph/presentation/widgets/graph_overlay.dart';
import 'package:mathcanvas/features/graph/presentation/widgets/graph_card_widget.dart';

class FakeCanvasStateNotifier extends CanvasStateNotifier {
  final CanvasState mockState;
  FakeCanvasStateNotifier(this.mockState);

  @override
  CanvasState build() => mockState;
}

class FakeRecognitionStateNotifier extends RecognitionStateNotifier {
  final List<RecognizedExpression> mockExpressions;
  FakeRecognitionStateNotifier(this.mockExpressions);

  @override
  RecognitionState build() => RecognitionState(expressions: mockExpressions);
}

class FakeGraphStateNotifier extends GraphStateNotifier {
  final GraphState mockState;
  FakeGraphStateNotifier(this.mockState);

  @override
  GraphState build() => mockState;
}

void main() {
  group('GraphOverlay Widget Tests', () {
    testWidgets('renders GraphCardWidget when graphs exist', (WidgetTester tester) async {
      final mockExpr = RecognizedExpression(
        id: 'expr_1',
        notebookId: 'nb_1',
        rawLatex: 'y = x^2',
        parsedExpression: 'y - x^2',
        expressionType: 'function',
        confidence: 0.95,
        bboxMinX: 10.0,
        bboxMinY: 10.0,
        bboxMaxX: 110.0,
        bboxMaxY: 40.0,
        strokeIds: const ['s_1'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final mockGraph = GraphData(
        id: 'graph_1',
        expressionId: 'expr_1',
        xValues: const [1.0, 2.0],
        yValues: const [1.0, 4.0],
        title: 'y = x^2',
        generatedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            canvasStateProvider.overrideWith(() => FakeCanvasStateNotifier(const CanvasState(
                  zoomLevel: 1.0,
                  viewportOffset: Offset.zero,
                ))),
            recognitionStateProvider.overrideWith(() => FakeRecognitionStateNotifier([mockExpr])),
            graphStateProvider.overrideWith(() => FakeGraphStateNotifier(GraphState(
                  graphs: {'expr_1': mockGraph},
                ))),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  GraphOverlay(),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(GraphCardWidget), findsOneWidget);
    });

    testWidgets('renders empty space when no graphs', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            canvasStateProvider.overrideWith(() => FakeCanvasStateNotifier(const CanvasState())),
            recognitionStateProvider.overrideWith(() => FakeRecognitionStateNotifier(const [])),
            graphStateProvider.overrideWith(() => FakeGraphStateNotifier(const GraphState())),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: GraphOverlay(),
            ),
          ),
        ),
      );

      expect(find.byType(GraphCardWidget), findsNothing);
    });
  });
}
