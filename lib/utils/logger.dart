import 'package:flutter/foundation.dart';

/// Sistema de logging para la aplicación
/// En modo debug imprime en consola, en producción se puede conectar a un servicio
class AppLogger {
  static void debug(String message, [dynamic data]) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('🔍 DEBUG: $message${data != null ? ' - $data' : ''}');
    }
  }

  static void info(String message, [dynamic data]) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('ℹ️ INFO: $message${data != null ? ' - $data' : ''}');
    }
  }

  static void warning(String message, [dynamic data]) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('⚠️ WARNING: $message${data != null ? ' - $data' : ''}');
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('❌ ERROR: $message${error != null ? ' - $error' : ''}');
      if (stackTrace != null) {
        // ignore: avoid_print
        print('Stack trace: $stackTrace');
      }
    }
  }

  static void nfc(String message, [dynamic data]) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('📱 NFC: $message${data != null ? ' - $data' : ''}');
    }
  }

  static void api(String message, [dynamic data]) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('🌐 API: $message${data != null ? ' - $data' : ''}');
    }
  }
}
