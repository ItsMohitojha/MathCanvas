import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The status of a save operation.
enum SaveStatus {
  /// No save in progress.
  idle,

  /// Currently saving data.
  saving,

  /// Recently completed a save operation.
  saved,
}

/// Provider managing the active save indicator status.
final saveStatusProvider = StateProvider<SaveStatus>((ref) => SaveStatus.idle);

/// Widget rendering save status in the Canvas toolbar.
class SaveIndicator extends ConsumerWidget {
  /// Creates a [SaveIndicator].
  const SaveIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(saveStatusProvider);

    if (status == SaveStatus.idle) {
      return const Tooltip(
        message: 'All changes saved locally',
        child: Icon(
          Icons.cloud_done_outlined,
          color: const Color(0xFF10B981),
          size: 18,
        ),
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: status == SaveStatus.saving
          ? const Row(
              key: ValueKey('saving'),
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: Colors.amber,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Saving...',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.amber,
                  ),
                ),
              ],
            )
          : const Row(
              key: ValueKey('saved'),
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: const Color(0xFF10B981),
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  'Saved',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
    );
  }
}
