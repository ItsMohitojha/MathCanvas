import 'package:flutter/material.dart';
import 'package:mathcanvas/app/theme/app_theme.dart';
import 'package:mathcanvas/app/theme/app_borders.dart';

class AppSnackbar {
  static void showSuccess(BuildContext context, String message) {
    final colors = context.appColorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline_rounded, color: colors.success),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.onSurface,
                    ),
              ),
            ),
          ],
        ),
        backgroundColor: colors.successSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorders.mediumBorderRadius,
          side: BorderSide(color: colors.success.withOpacity(0.3)),
        ),
      ),
    );
  }

  static void showError(BuildContext context, String message) {
    final colors = context.appColorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: colors.error),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.error,
                    ),
              ),
            ),
          ],
        ),
        backgroundColor: colors.errorSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorders.mediumBorderRadius,
          side: BorderSide(color: colors.error.withOpacity(0.3)),
        ),
      ),
    );
  }
}
