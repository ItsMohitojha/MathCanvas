import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/app/theme/app_theme.dart';
import 'package:mathcanvas/features/canvas/presentation/providers/canvas_state_provider.dart';
import 'package:mathcanvas/features/canvas/presentation/widgets/canvas_toolbar.dart';
import 'package:mathcanvas/features/canvas/presentation/widgets/canvas_widget.dart';

/// The primary canvas screen for mathematical drawing.
///
/// Provides a full-screen canvas with an app bar showing the
/// notebook name, a floating toolbar for zoom controls, and
/// a ghost hint for empty canvases. Loads strokes on open.
class CanvasScreen extends ConsumerStatefulWidget {
  /// Creates a canvas screen for the given [notebookId].
  const CanvasScreen({super.key, required this.notebookId});

  /// The ID of the notebook being displayed.
  final String notebookId;

  @override
  ConsumerState<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends ConsumerState<CanvasScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(canvasStateProvider.notifier).loadNotebook(widget.notebookId);
    });
  }

  @override
  void didUpdateWidget(CanvasScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.notebookId != widget.notebookId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(canvasStateProvider.notifier).loadNotebook(widget.notebookId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final showHint = ref.watch(
      canvasStateProvider.select((s) => s.showHint),
    );
    final colors = context.appColorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notebook',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: Semantics(
          label: 'Go back to notebook list',
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // Full-screen canvas.
          const Positioned.fill(
            child: CanvasWidget(),
          ),

          // Ghost hint text for empty canvas.
          if (showHint)
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Text(
                    'Start writing math here...',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(
                          color: colors.onSurfaceVariant
                              .withValues(alpha: 0.4),
                        ),
                  ),
                ),
              ),
            ),

          // Floating toolbar.
          const CanvasToolbar(),
        ],
      ),
    );
  }
}

