// ============================================
// Dosya: app_constants.dart
// Amaç: Uygulama sabitleri — API URL, timeout, boyutlar
// Bağımlılıklar: flutter_dotenv
// ============================================

import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  // API
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000/api';
  static const int apiTimeout = 30; // saniye

  // App
  static String get appName => dotenv.env['APP_NAME'] ?? '{{PROJECT_NAME}}';

  // Padding & Margin
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // Border Radius
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 999.0;

  // Animation Duration
  static const int animFast = 200; // ms
  static const int animNormal = 300;
  static const int animSlow = 500;

  // Pagination
  static const int pageSize = 20;

  // Image
  static const double maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
}
