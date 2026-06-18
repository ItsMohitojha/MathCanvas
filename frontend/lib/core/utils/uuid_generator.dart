/// UUID generator utility.
///
/// Provides a simple, secure, and self-contained RFC 4122 v4 UUID generator
/// using Dart's secure random number generator.
library;

import 'dart:math';

/// Secure UUID generator.
class UuidGenerator {
  static final Random _random = Random.secure();

  /// Generates a random RFC 4122 version 4 UUID.
  static String generateV4() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));

    // Set version to 4 (bits 12-15 of time_hi_and_version to 0100)
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    // Set variant to RFC 4122 (bits 6-7 of clock_seq_hi_and_reserved to 10)
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    final buffer = StringBuffer();
    for (var i = 0; i < 16; i++) {
      if (i == 4 || i == 6 || i == 8 || i == 10) {
        buffer.write('-');
      }
      buffer.write(bytes[i].toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}
