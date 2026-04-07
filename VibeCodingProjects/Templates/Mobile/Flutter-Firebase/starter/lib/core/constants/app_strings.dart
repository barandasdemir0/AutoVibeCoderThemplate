// ============================================
// Dosya: app_strings.dart
// Amaç: Uygulama metin sabitleri — localization hazırlığı
// Bağımlılıklar: Yok
// ============================================

class AppStrings {
  AppStrings._();

  // Auth
  static const String login = 'Giriş Yap';
  static const String register = 'Kayıt Ol';
  static const String logout = 'Çıkış Yap';
  static const String email = 'E-posta';
  static const String password = 'Şifre';
  static const String confirmPassword = 'Şifre Tekrar';
  static const String forgotPassword = 'Şifremi Unuttum';
  static const String noAccount = 'Hesabınız yok mu?';
  static const String hasAccount = 'Zaten hesabınız var mı?';

  // Validation
  static const String fieldRequired = 'Bu alan zorunludur';
  static const String invalidEmail = 'Geçerli bir e-posta girin';
  static const String passwordTooShort = 'Şifre en az 6 karakter olmalı';
  static const String passwordsNotMatch = 'Şifreler eşleşmiyor';

  // General
  static const String appName = '{{PROJECT_NAME}}';
  static const String save = 'Kaydet';
  static const String cancel = 'İptal';
  static const String delete = 'Sil';
  static const String edit = 'Düzenle';
  static const String search = 'Ara';
  static const String loading = 'Yükleniyor...';
  static const String retry = 'Tekrar Dene';
  static const String noData = 'Henüz veri yok';
  static const String error = 'Bir hata oluştu';
  static const String success = 'İşlem başarılı';
  static const String confirm = 'Onayla';
  static const String settings = 'Ayarlar';
  static const String profile = 'Profil';
  static const String home = 'Ana Sayfa';
}
