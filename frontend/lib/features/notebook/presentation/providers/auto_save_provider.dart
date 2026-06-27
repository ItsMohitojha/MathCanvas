import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/features/canvas/presentation/providers/canvas_state_provider.dart';
import '../widgets/save_indicator.dart';
import 'notebook_state_provider.dart';

/// Provider for the AutoSaveController.
final autoSaveProvider = NotifierProvider<AutoSaveNotifier, void>(AutoSaveNotifier.new);

/// Notifier managing periodic and lifecycle-based auto-save triggers.
class AutoSaveNotifier extends Notifier<void> with WidgetsBindingObserver {
  Timer? _timer;
  String? _currentNotebookId;
  bool _isDisposed = false;

  @override
  void build() {
    WidgetsBinding.instance.addObserver(this);
    
    // Watch canvas state to detect notebook changes
    final canvasState = ref.watch(canvasStateProvider);
    final notebookId = canvasState.currentNotebookId;

    if (notebookId != _currentNotebookId) {
      _currentNotebookId = notebookId;
      _setupTimer();
    }

    ref.onDispose(() {
      _isDisposed = true;
      WidgetsBinding.instance.removeObserver(this);
      _timer?.cancel();
    });
  }

  void _setupTimer() {
    _timer?.cancel();
    if (_currentNotebookId == null) return;

    // Trigger auto-save every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      triggerSave();
    });
  }

  /// Manually triggers a viewport save.
  Future<void> triggerSave() async {
    final notebookId = _currentNotebookId;
    if (notebookId == null) return;
    if (_isDisposed) return;

    final canvasState = ref.read(canvasStateProvider);
    final offset = canvasState.viewportOffset;
    final zoom = canvasState.zoomLevel;

    // Update status to saving
    ref.read(saveStatusProvider.notifier).state = SaveStatus.saving;

    try {
      await ref.read(notebookStateProvider.notifier).saveViewport(
        notebookId,
        offset.dx,
        offset.dy,
        zoom,
      );
      
      if (_isDisposed) return;
      // Update status to saved
      ref.read(saveStatusProvider.notifier).state = SaveStatus.saved;
      
      // Revert to idle after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (_isDisposed) return;
        final currentStatus = ref.read(saveStatusProvider);
        if (currentStatus == SaveStatus.saved) {
          ref.read(saveStatusProvider.notifier).state = SaveStatus.idle;
        }
      });
    } catch (_) {
      if (_isDisposed) return;
      ref.read(saveStatusProvider.notifier).state = SaveStatus.idle;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      // Immediate save when app goes into background
      triggerSave();
    }
  }
}
