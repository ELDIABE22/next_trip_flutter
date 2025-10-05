import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:next_trip/features/auth/data/models/user_model.dart';
import 'package:next_trip/features/auth/data/services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;
  UserModel? _userData;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  UserModel? get userData => _userData;
  bool get isAuthenticated => _user != null;

  AuthController() {
    // Escuchar los cambios de estado de autenticación
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      if (user == null) {
        _userData = null; // Limpiar datos del usuario al cerrar sesión
      }
      notifyListeners();
    });
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Iniciar sesión
  Future<bool> signIn({required String email, required String password}) async {
    try {
      _setLoading(true);
      _setError(null);

      await _authService.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (_authService.currentUser != null) {
        _userData = await _authService.getCurrentUserData();
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Cerrar sesión
  Future<bool> signOut() async {
    try {
      _setLoading(true);
      _setError(null);

      await _authService.signOut();

      _userData = null;
      _user = null;

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Registrar un nuevo usuario
  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String cc,
    required String gender,
    required DateTime birthDate,
  }) async {
    try {
      _setLoading(true);
      _setError(null);

      await _authService.registerWithEmailAndPassword(
        email: email.trim(),
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        cc: cc,
        gender: gender,
        birthDate: birthDate,
      );

      if (_authService.currentUser != null) {
        _userData = await _authService.getCurrentUserData();
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Actualizar usuario
  Future<bool> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? cc,
    String? gender,
    DateTime? birthDate,
  }) async {
    try {
      if (_user == null) return false;

      _setLoading(true);
      _setError(null);

      await _authService.updateUserProfile(
        userId: _user!.uid,
        fullName: fullName,
        phoneNumber: phoneNumber,
        cc: cc,
        gender: gender,
        birthDate: birthDate,
      );

      _userData = await _authService.getCurrentUserData();

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Obtener datos del usuario actual
  Future<void> fetchUserData() async {
    if (_user != null) {
      _userData = await _authService.getCurrentUserData();
      notifyListeners();
    }
  }

  // Restablecer contraseña
  Future<bool> resetPassword({required String email}) async {
    try {
      _setLoading(true);
      _setError(null);

      await _authService.resetPassword(email: email);

      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }
}
