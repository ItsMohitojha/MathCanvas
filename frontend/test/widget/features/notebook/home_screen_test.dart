import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/app/theme/app_theme.dart';
import 'package:mathcanvas/features/notebook/domain/models/notebook.dart';
import 'package:mathcanvas/features/notebook/presentation/screens/home_screen.dart';
import 'package:mathcanvas/features/notebook/presentation/providers/notebook_state_provider.dart';
import 'package:mathcanvas/features/notebook/presentation/providers/notebook_state.dart';

class FakeNotebookStateNotifierForWidget extends NotebookStateNotifier {
  final List<Notebook> initialNotebooks;
  FakeNotebookStateNotifierForWidget({required this.initialNotebooks});

  @override
  NotebookState build() {
    return NotebookState(notebooks: initialNotebooks);
  }
}

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('renders empty state when no notebooks exist', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notebookStateProvider.overrideWith(
              () => FakeNotebookStateNotifierForWidget(initialNotebooks: []),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          ),
        ),
      );

      // Verify empty state illustration and texts are rendered
      expect(find.text('No Notebooks Yet'), findsOneWidget);
      expect(find.text('New Notebook'), findsOneWidget);
      expect(find.byIcon(Icons.draw_outlined), findsOneWidget);
    });

    testWidgets('renders notebooks in a grid when notebooks exist', (tester) async {
      final now = DateTime.now();
      final notebooks = [
        Notebook(id: '1', name: 'Math Homework', createdAt: now, updatedAt: now),
        Notebook(id: '2', name: 'Physics Notes', createdAt: now, updatedAt: now),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notebookStateProvider.overrideWith(
              () => FakeNotebookStateNotifierForWidget(initialNotebooks: notebooks),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          ),
        ),
      );

      // Verify notebooks are shown
      expect(find.text('Math Homework'), findsOneWidget);
      expect(find.text('Physics Notes'), findsOneWidget);
      expect(find.text('No Notebooks Yet'), findsNothing);
    });

    testWidgets('tap "New Notebook" floating action button opens creation dialog', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            notebookStateProvider.overrideWith(
              () => FakeNotebookStateNotifierForWidget(initialNotebooks: []),
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          ),
        ),
      );

      // Tap the FAB
      await tester.tap(find.text('New Notebook'));
      await tester.pumpAndSettle();

      // Verify create notebook dialog appears
      expect(find.text('New Notebook'), findsNWidgets(2)); // Title and FAB label
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Create'), findsOneWidget);
    });
  });
}
