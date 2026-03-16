import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

enum LogLevel { debug, info, warning, error }

class AppLogger {
  static LogLevel _minLevel = kDebugMode ? LogLevel.debug : LogLevel.warning;

  static void setMinLevel(LogLevel level) => _minLevel = level;

  static void d(String tag, String message) =>
      _log(LogLevel.debug, tag, message);

  static void i(String tag, String message) =>
      _log(LogLevel.info, tag, message);

  static void w(String tag, String message) =>
      _log(LogLevel.warning, tag, message);

  static void e(
    String tag,
    String message, [
    Object? error,
    StackTrace? stack,
  ]) {
    _log(LogLevel.error, tag, message);
    if (kDebugMode && error != null) {
      developer.log(
        '  Error: $error',
        name: tag,
        error: error,
        stackTrace: stack,
      );
    }
  }

  static void _log(LogLevel level, String tag, String message) {
    if (level.index < _minLevel.index) return;
    if (!kDebugMode) return; // Never log in production

    final prefix = switch (level) {
      LogLevel.debug => '🔍',
      LogLevel.info => 'ℹ️',
      LogLevel.warning => '⚠️',
      LogLevel.error => '❌',
    };

    // Use developer.log for better console output with full data
    developer.log(
      '$prefix $message',
      name: tag,
      level: switch (level) {
        LogLevel.debug => 500, // DEBUG level
        LogLevel.info => 800, // INFO level
        LogLevel.warning => 900, // WARNING level
        LogLevel.error => 1000, // ERROR level
      },
    );
  }

  /// Log API request (debug only, never log body in production)
  static void apiRequest(
    String method,
    String url,
    Map<String, String> header,
  ) {
    d('API', '$method $url header - $header');
  }

  /// Log API response (status only, never log body)
  static void apiResponse(
    String method,
    String url,
    int statusCode, [
    String? body,
  ]) {
    if (statusCode >= 400) {
      e('API', '$method $url -> $statusCode, $body');
    } else {
      d('API', '$method $url -> $statusCode, $body');
    }
  }

  /// Log large data objects (JSON, maps, lists) with full output
  static void data(String tag, String description, dynamic data) {
    if (!kDebugMode) return;

    try {
      final formattedData = data is String ? data : data.toString();
      developer.log(
        '📊 $description\n$formattedData',
        name: tag,
        level: 700, // DATA level between INFO and WARNING
      );
    } catch (error, stackTrace) {
      AppLogger.e(tag, 'Failed to log data: $description', error, stackTrace);
    }
  }

  /// Log with stack trace for debugging
  static void trace(String tag, String message, [StackTrace? stack]) {
    if (!kDebugMode) return;

    developer.log(
      '🔍 $message',
      name: tag,
      level: 600, // TRACE level
      stackTrace: stack ?? StackTrace.current,
    );
  }
}
