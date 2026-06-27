/// Floating canvas toolbar widget.
///
/// A glassmorphism-style floating toolbar positioned at the
/// bottom-center of the canvas. Shows a zoom level indicator and
/// a reset-view button. Phase 2 will add stroke color/width controls.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mathcanvas/app/theme/app_borders.dart';
import 'package:mathcanvas/app/theme/app_shadows.dart';
import 'package:mathcanvas/app/theme/app_spacing.dart';
import 'package:mathcanvas/app/theme/app_theme.dart';
import 'package:mathcanvas/features/canvas/presentation/providers/canvas_state_provider.dart';
import 'package:mathcanvas/features/notebook/presentation/widgets/save_indicator.dart';
import 'package:mathcanvas/features/settings/presentation/widgets/settings_bottom_sheet.dart';

/// Floating toolbar that displays zoom level, reset, save indicator, and settings.
///
/// Positioned at the bottom-center of the canvas with a
/// semi-transparent glassmorphism surface. Becomes fully opaque
/// when interacted with.
class CanvasToolbar extends ConsumerWidget {
  /// Creates the canvas toolbar.
  const CanvasToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zoomLevel = ref.watch(
      canvasStateProvider.select((s) => s.zoomLevel),
    );
    final colors = context.appColorScheme;
    final zoomPercent = (zoomLevel * 100).round();

    return Positioned(
      bottom: AppSpacing.space24,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space16,
          ),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: 0.95),
            borderRadius: AppBorders.toolbarBorderRadius,
            border: Border.all(color: colors.divider),
            boxShadow: AppShadows.toolbar,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Save indicator.
              const SaveIndicator(),
              const SizedBox(width: AppSpacing.space12),
              // Divider.
              Container(
                width: 1,
                height: 24,
                color: colors.divider,
              ),
              const SizedBox(width: AppSpacing.space12),

              // Zoom level indicator.
              Text(
                '$zoomPercent%',
                style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: colors.onSurfaceVariant),
              ),
              const SizedBox(width: AppSpacing.space12),
              // Divider.
              Container(
                width: 1,
                height: 24,
                color: colors.divider,
              ),
              const SizedBox(width: AppSpacing.space8),

              // Reset view button.
              Semantics(
                label: 'Reset canvas view',
                child: IconButton(
                  icon: Icon(
                    Icons.center_focus_strong_outlined,
                    color: colors.onSurfaceVariant,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                  ),
                  onPressed: () {
                    ref
                        .read(canvasStateProvider.notifier)
                        .resetView();
                  },
                  tooltip: 'Reset view',
                ),
              ),
              const SizedBox(width: AppSpacing.space4),
              // Divider.
              Container(
                width: 1,
                height: 24,
                color: colors.divider,
              ),
              const SizedBox(width: AppSpacing.space8),

              // Settings button.
              Semantics(
                label: 'Open settings',
                child: IconButton(
                  icon: Icon(
                    Icons.settings_outlined,
                    color: colors.onSurfaceVariant,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 44,
                    minHeight: 44,
                  ),
                  onPressed: () => SettingsBottomSheet.show(context),
                  tooltip: 'Settings',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
