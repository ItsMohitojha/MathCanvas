import 'dart:async';

/// A utility class to debounce function executions.
///
/// Prevents a function from being called too frequently by waiting for a
/// specified idle duration after the last call before executing the function.
class Debouncer {
  /// The delay duration for debouncing.
  final Duration delay;
  Timer? _timer;

  /// Creates a [Debouncer] with the given [delay].
  Debouncer({required this.delay});

  /// Executes the given [callback] after the [delay] duration.
  ///
  /// If [run] is called again before the delay expires, the previous timer is
  /// cancelled and a new one is started.
  void run(void Function() callback) {
    cancel();
    _timer = Timer(delay, callback);
  }

  /// Cancels any active timer.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Checks if the debouncer is currently active.
  bool get isActive => _timer?.isActive ?? false;
}
