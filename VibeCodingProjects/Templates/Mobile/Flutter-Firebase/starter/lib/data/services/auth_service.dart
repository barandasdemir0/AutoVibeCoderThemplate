// ============================================
// Dosya: auth_service.dart
// Amaç: Firebase Auth wrapper — login, register, logout, state listener
// Bağımlılıklar: firebase_auth, user_repository.dart, user_model.dart
// ============================================

import 'package:firebase_auth/firebase_auth.dart';
import '../../core/utils/logger.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepo = UserRepository();

  /// Mevcut kullanıcı
  User? get currentUser => _auth.currentUser;

  /// Auth durumunu dinle
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Email/Password ile kayıt
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Firestore'a kullanıcı bilgilerini kaydet
      final user = UserModel(
        id: credential.user!.uid,
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );

      await _userRepo.createWithId(credential.user!.uid, user);
      await credential.user!.updateDisplayName(name);

      AppLogger.info('User registered: $email', tag: 'Auth');
      return user;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Register failed: ${e.code}', tag: 'Auth');
      throw _handleAuthError(e);
    }
  }

  /// Email/Password ile giriş
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = await _userRepo.getById(credential.user!.uid);
      AppLogger.info('User logged in: $email', tag: 'Auth');
      return user;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Login failed: ${e.code}', tag: 'Auth');
      throw _handleAuthError(e);
    }
  }

  /// Çıkış yap
  Future<void> logout() async {
    await _auth.signOut();
    AppLogger.info('User logged out', tag: 'Auth');
  }

  /// Şifre sıfırlama maili gönder
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      AppLogger.info('Password reset sent: $email', tag: 'Auth');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Password reset failed: ${e.code}', tag: 'Auth');
      throw _handleAuthError(e);
    }
  }

  /// Firebase Auth hata mesajlarını Türkçeleştir
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Bu e-posta ile kayıtlı kullanıcı bulunamadı';
      case 'wrong-password':
        return 'Şifre yanlış';
      case 'email-already-in-use':
        return 'Bu e-posta zaten kullanılıyor';
      case 'invalid-email':
        return 'Geçersiz e-posta adresi';
      case 'weak-password':
        return 'Şifre çok zayıf (en az 6 karakter)';
      case 'too-many-requests':
        return 'Çok fazla deneme yaptınız. Lütfen bekleyin.';
      case 'user-disabled':
        return 'Bu hesap devre dışı bırakılmış';
      default:
        return 'Bir hata oluştu: ${e.message}';
    }
  }
}
