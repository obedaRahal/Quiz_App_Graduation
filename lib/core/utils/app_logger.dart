import 'package:flutter/foundation.dart';

abstract final class AppLogger {
  static bool _isConfigured = false;

  static final RegExp _sensitiveValuePattern = RegExp(
    r'''(\b(?:access[ _-]?token|refresh[ _-]?token|fcm[ _-]?token|token|password(?:[ _-]?confirmation)?|otp(?:[ _-]?code)?|email|authorization)\b(?:\s+(?:available|value))?\s*["']?\s*(?:=>|:|=)\s*)(?:"[^"]*"|'[^']*'|[^,\s}\]]+)''',
    caseSensitive: false,
  );

  static final RegExp _bearerTokenPattern = RegExp(
    r'(Bearer\s+)[A-Za-z0-9._~+/=-]+',
    caseSensitive: false,
  );

  static void configure() {
    if (_isConfigured) {
      return;
    }

    _isConfigured = true;
    final originalDebugPrint = debugPrint;

    debugPrint = (String? message, {int? wrapWidth}) {
      if (!kDebugMode || message == null) {
        return;
      }

      originalDebugPrint(_redact(message), wrapWidth: wrapWidth);
    };
  }

  static String _redact(String message) {
    final withoutBearerTokens = message.replaceAllMapped(
      _bearerTokenPattern,
      (match) => '${match.group(1)}[REDACTED]',
    );

    return withoutBearerTokens.replaceAllMapped(
      _sensitiveValuePattern,
      (match) => '${match.group(1)}[REDACTED]',
    );
  }

  @visibleForTesting
  static String redactForTesting(String message) => _redact(message);
}
