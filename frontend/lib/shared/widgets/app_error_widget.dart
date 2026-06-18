import 'package:flutter/material.dart';
import 'package:mathcanvas/app/theme/app_theme.dart';
import 'package:mathcanvas/app/theme/app_spacing.dart';
import 'package:mathcanvas/app/theme/app_borders.dart';

class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColorScheme;
    return Center(
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.space24),
        padding: const EdgeInsets.all(AppSpacing.space16),
        decoration: BoxDecoration(
          color: colors.errorSurface,
          borderRadius: AppBorders.mediumBorderRadius,
          border: Border.all(
            color: colors.error.withOpacity(0.3),
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: colors.error,
              size: 40,
            ),
            const SizedBox(height: AppSpacing.space12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.error,
                  ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.space16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
