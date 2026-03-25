import 'dart:math';

Duration? netRetry(int retryCount, Object error) {
  if (retryCount >= 5) {
    return null;
  }

  final exponent = min(retryCount, 5);
  final delayMs = 300 * (1 << exponent);
  return Duration(milliseconds: delayMs);
}
