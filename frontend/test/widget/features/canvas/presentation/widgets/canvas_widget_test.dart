import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/app/theme/app_theme.dart';
import 'package:mathcanvas/features/canvas/domain/models/stroke.dart';
import 'package:mathcanvas/features/canvas/domain/repositories/stroke_repository.dart';
import 'package:mathcanvas/features/canvas/presentation/providers/canvas_state_provider.dart';
import 'package:mathcanvas/features/canvas/presentation/screens/canvas_screen.dart';
import 'package:mathcanvas/features/canvas/presentation/widgets/canvas_widget.dart';

class FakeStrokeRepository implements StrokeRepository {
  final List<Stroke> strokes = [];

  @override
  Future<void> saveStroke(Stroke stroke) async {
    strokes.removeWhere((s) => s.id == stroke.id);
    strokes.add(stroke);
  }

  @override
  Future<void> saveStrokes(List<Stroke> strokes) async {
    for (final s in strokes) {
      await saveStroke(s);
    }
  }

  @override
  Future<void> deleteStroke(String id) async {
    strokes.removeWhere((s) => s.id == id);
  }

  @override
  Future<List<Stroke>> getStrokes(String notebookId) async {
    return strokes.where((s) => s.notebookId == notebookId).toList();
  }

  @override
  Future<List<Stroke>> getStrokesInViewport(
    String notebookId,
    Rect viewport,
  ) async {
    return strokes
        .where((s) => s.notebookId == notebookId && s.boundingBox.overlaps(viewport))
        .toList();
  }
}

void main() {
  group('CanvasWidget & CanvasGestureHandler Widget Tests', () {
    Widget buildTestWidget({FakeStrokeRepository? fakeRepository}) {
      final repo = fakeRepository ?? FakeStrokeRepository();
      return ProviderScope(
        overrides: [
          strokeRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const CanvasScreen(notebookId: 'test_notebook'),
        ),
      );
    }

    testWidgets('Initial state displays correct UI', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Verify that the title is present
      expect(find.text('Notebook'), findsOneWidget);

      // Verify CanvasWidget is present
      expect(find.byType(CanvasWidget), findsOneWidget);

      // Verify ghost hint is visible initially
      expect(find.text('Start writing math here...'), findsOneWidget);

      // Verify initial zoom is 100%
      expect(find.text('100%'), findsOneWidget);

      // Verify reset button is present
      expect(find.byTooltip('Reset view'), findsOneWidget);
    });

    testWidgets('Single finger drawing dismisses ghost hint', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Start drawing with single pointer
      final gesture = await tester.startGesture(const Offset(400, 300), pointer: 1);
      await gesture.moveTo(const Offset(500, 400));
      await tester.pump();

      // Verify ghost hint is now dismissed (removed from widget tree)
      expect(find.text('Start writing math here...'), findsNothing);

      await gesture.up();
      await tester.pump();
    });

    testWidgets('Two-finger pan dismisses ghost hint', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Verify hint is initially visible
      expect(find.text('Start writing math here...'), findsOneWidget);

      // Start gesture with 2 pointers
      final gesture1 = await tester.startGesture(const Offset(400, 300), pointer: 1);
      final gesture2 = await tester.startGesture(const Offset(450, 300), pointer: 2);

      // Move both to pan
      await gesture1.moveTo(const Offset(500, 300));
      await gesture2.moveTo(const Offset(550, 300));
      await tester.pump();

      // Verify ghost hint is now dismissed (removed from widget tree)
      expect(find.text('Start writing math here...'), findsNothing);

      // Clean up gestures
      await gesture1.up();
      await gesture2.up();
      await tester.pump();
    });

    testWidgets('Two-finger pinch-zoom updates zoom level and reset view works', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget());

      // Verify initial zoom
      expect(find.text('100%'), findsOneWidget);

      // Start pinch gesture with 2 pointers
      final gesture1 = await tester.startGesture(const Offset(400, 300), pointer: 1);
      final gesture2 = await tester.startGesture(const Offset(450, 300), pointer: 2);

      // Move them apart to zoom in (focal point is (425, 300), distance increases)
      await gesture1.moveTo(const Offset(350, 300));
      await gesture2.moveTo(const Offset(500, 300));
      await tester.pump();

      // Zoom percent should have increased
      expect(find.text('100%'), findsNothing);
      
      // Clean up gestures
      await gesture1.up();
      await gesture2.up();
      await tester.pump();

      // Tap the reset button to return to 100%
      await tester.tap(find.byTooltip('Reset view'));
      await tester.pump();

      // Verify zoom is back to 100%
      expect(find.text('100%'), findsOneWidget);
    });
  });
}
