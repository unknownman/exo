import 'package:flutter/foundation.dart';

class AppLogger {
  static void logError(dynamic error, [StackTrace? stackTrace]) {
    debugPrint('🔴 ERROR: $error');
    if (stackTrace != null) {
      debugPrint('Stacktrace:\n$stackTrace');
    }
    // TODO: Send to Sentry/Crashlytics in production
  }

  static void logInfo(String message) {
    debugPrint('ℹ️ INFO: $message');
  }

  static void logWarning(String message) {
    debugPrint('⚠️ WARNING: $message');
  }
}
