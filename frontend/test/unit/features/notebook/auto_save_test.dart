import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/features/canvas/domain/models/canvas_state.dart';
import 'package:mathcanvas/features/canvas/presentation/providers/canvas_state_provider.dart';
import 'package:mathcanvas/features/notebook/presentation/providers/auto_save_provider.dart';
import 'package:mathcanvas/features/notebook/presentation/providers/notebook_state_provider.dart';
import 'package:mathcanvas/features/notebook/presentation/providers/notebook_state.dart';
import 'package:mathcanvas/features/notebook/presentation/widgets/save_indicator.dart';

class FakeNotebookStateNotifier extends NotebookStateNotifier {
  bool saveViewportCalled = false;
  double savedX = 0;
  double savedY = 0;
  double savedZoom = 0;

  @override
  NotebookState build() => const NotebookState();

  @override
  Future<void> saveViewport(String id, double x, double y, double zoom) async {
    saveViewportCalled = true;
    savedX = x;
    savedY = y;
    savedZoom = zoom;
  }
}

class FakeCanvasStateNotifier extends CanvasStateNotifier {
  final CanvasState mockState;
  FakeCanvasStateNotifier(this.mockState);

  @override
  CanvasState build() => mockState;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AutoSaveNotifier', () {
    late ProviderContainer container;
    late FakeNotebookStateNotifier fakeNotebookNotifier;

    setUp(() {
      fakeNotebookNotifier = FakeNotebookStateNotifier();
      container = ProviderContainer(
        overrides: [
          notebookStateProvider.overrideWith(() => fakeNotebookNotifier),
          // Set canvas state with an active notebook using FakeCanvasStateNotifier
          canvasStateProvider.overrideWith(
            () => FakeCanvasStateNotifier(
              const CanvasState(
                currentNotebookId: 'test_notebook_123',
                viewportOffset: Offset(50.0, 100.0),
                zoomLevel: 1.5,
              ),
            ),
          ),
        ],
      );
      // Explicitly read the provider to trigger build() execution
      container.read(autoSaveProvider);
    });

    tearDown(() {
      container.dispose();
    });

    test('triggerSave calls saveViewport with current canvas coordinates', () async {
      // Setup SaveIndicator to idle
      container.read(saveStatusProvider.notifier).state = SaveStatus.idle;

      // Trigger save
      final autoSave = container.read(autoSaveProvider.notifier);
      await autoSave.triggerSave();

      // Check results
      expect(fakeNotebookNotifier.saveViewportCalled, isTrue);
      expect(fakeNotebookNotifier.savedX, 50.0);
      expect(fakeNotebookNotifier.savedY, 100.0);
      expect(fakeNotebookNotifier.savedZoom, 1.5);
      
      // Save status should be 'saved' immediately after trigger
      expect(container.read(saveStatusProvider), SaveStatus.saved);
    });

    test('app lifecycle transition to paused triggers save', () async {
      fakeNotebookNotifier.saveViewportCalled = false;

      final autoSave = container.read(autoSaveProvider.notifier);
      
      // Simulate app pausing (going background)
      autoSave.didChangeAppLifecycleState(AppLifecycleState.paused);

      // Verify immediate save was triggered
      expect(fakeNotebookNotifier.saveViewportCalled, isTrue);
      expect(fakeNotebookNotifier.savedX, 50.0);
      expect(fakeNotebookNotifier.savedY, 100.0);
      expect(fakeNotebookNotifier.savedZoom, 1.5);
    });
  });
}
