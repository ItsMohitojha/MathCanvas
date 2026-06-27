import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/features/canvas/domain/models/canvas_state.dart';
import 'package:mathcanvas/features/canvas/presentation/providers/canvas_state_provider.dart';
import 'package:mathcanvas/features/recognition/domain/models/recognized_expression.dart';
import 'package:mathcanvas/features/recognition/presentation/providers/recognition_state_provider.dart';
import 'package:mathcanvas/features/math_engine/domain/models/math_result.dart';
import 'package:mathcanvas/features/math_engine/presentation/providers/math_state.dart';
import 'package:mathcanvas/features/math_engine/presentation/providers/math_state_provider.dart';
import 'package:mathcanvas/features/math_engine/presentation/widgets/math_result_overlay.dart';

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

class FakeMathStateNotifier extends MathStateNotifier {
  final Map<String, MathResult> mockResults;
  FakeMathStateNotifier(this.mockResults);

  @override
  MathState build() => MathState(results: mockResults);
}

void main() {
  group('MathResultOverlay Widget Tests', () {
    testWidgets('renders CustomPaint when expressions and results are non-empty', (WidgetTester tester) async {
      final mockExpr = RecognizedExpression(
        id: 'expr_1',
        notebookId: 'nb_1',
        rawLatex: '2 + 3',
        parsedExpression: '2 + 3',
        expressionType: 'expression',
        confidence: 0.95,
        bboxMinX: 10.0,
        bboxMinY: 10.0,
        bboxMaxX: 110.0,
        bboxMaxY: 40.0,
        strokeIds: const ['s_1'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final mockResult = MathResult(
        id: 'res_1',
        expressionId: 'expr_1',
        resultType: 'numeric',
        value: '5',
        latex: '5',
        numericValue: 5.0,
        computedAt: DateTime.now(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            canvasStateProvider.overrideWith(() => FakeCanvasStateNotifier(const CanvasState(
                  zoomLevel: 1.0,
                  viewportOffset: Offset.zero,
                ))),
            recognitionStateProvider.overrideWith(() => FakeRecognitionStateNotifier([mockExpr])),
            mathStateProvider.overrideWith(() => FakeMathStateNotifier({'expr_1': mockResult})),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: MathResultOverlay(),
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is CustomPaint && widget.painter is MathResultOverlayPainter,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders empty space when no expressions or results', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            canvasStateProvider.overrideWith(() => FakeCanvasStateNotifier(const CanvasState())),
            recognitionStateProvider.overrideWith(() => FakeRecognitionStateNotifier(const [])),
            mathStateProvider.overrideWith(() => FakeMathStateNotifier(const {})),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: MathResultOverlay(),
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is CustomPaint && widget.painter is MathResultOverlayPainter,
        ),
        findsNothing,
      );
    });
  });
}
