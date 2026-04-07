// ============================================
// Dosya: logger.dart
// Amaç: Custom logger wrapper — debug/info/warning/error seviyeleri
// Bağımlılıklar: Yok
// ============================================

import 'package:flutter/foundation.dart';

class AppLogger {
  AppLogger._();

  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      print('🔍 [DEBUG] ${tag != null ? '[$tag] ' : ''}$message');
    }
  }

  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      print('ℹ️ [INFO] ${tag != null ? '[$tag] ' : ''}$message');
    }
  }

  static void warning(String message, {String? tag}) {
    print('⚠️ [WARN] ${tag != null ? '[$tag] ' : ''}$message');
  }

  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    print('❌ [ERROR] ${tag != null ? '[$tag] ' : ''}$message');
    if (error != null) print('   Error: $error');
    if (stackTrace != null && kDebugMode) print('   Stack: $stackTrace');
  }

  static void api(String method, String url, {int? statusCode, String? body}) {
    if (kDebugMode) {
      final status = statusCode != null ? ' → $statusCode' : '';
      print('🌐 [API] $method $url$status');
      if (body != null) print('   Body: $body');
    }
  }
}
