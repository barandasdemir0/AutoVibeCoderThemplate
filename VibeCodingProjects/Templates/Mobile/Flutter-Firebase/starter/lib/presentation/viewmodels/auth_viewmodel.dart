// ============================================
// Dosya: auth_viewmodel.dart
// Amaç: Auth state yönetimi — login, register, logout, loading, error
// Bağımlılıklar: auth_service.dart, user_model.dart
// ============================================

import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';
import '../../core/utils/logger.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // State
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  AuthViewModel() {
    _checkAuthState();
  }

  /// Auth durumunu kontrol et
  void _checkAuthState() {
    _authService.authStateChanges.listen((firebaseUser) {
      if (firebaseUser != null) {
        _isAuthenticated = true;
        AppLogger.info('Auth state: logged in (${firebaseUser.email})', tag: 'AuthVM');
      } else {
        _isAuthenticated = false;
        _user = null;
        AppLogger.info('Auth state: logged out', tag: 'AuthVM');
      }
      notifyListeners();
    });
  }

  /// Giriş yap
  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    try {
      _user = await _authService.login(email: email, password: password);
      _isAuthenticated = true;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Kayıt ol
  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      _user = await _authService.register(
        email: email,
        password: password,
        name: name,
      );
      _isAuthenticated = true;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  /// Çıkış yap
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  /// Şifre sıfırla
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.sendPasswordReset(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Private helpers
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
