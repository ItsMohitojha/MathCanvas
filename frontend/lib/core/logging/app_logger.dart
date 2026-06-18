import 'dart:developer' as developer;

class AppLogger {
  final String tag;

  AppLogger(this.tag);

  void info(String message) {
    developer.log(
      message,
      name: tag,
      level: 800, // Info level
    );
  }

  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: tag,
      level: 900, // Warning level
      error: error,
      stackTrace: stackTrace,
    );
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: tag,
      level: 1000, // Error level
      error: error,
      stackTrace: stackTrace,
    );
  }
}
