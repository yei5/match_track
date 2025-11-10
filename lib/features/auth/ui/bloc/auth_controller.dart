import 'package:flutter/material.dart';

import '../../data/repository/auth_repository.dart';

enum AuthState { idle, loading, success, error }

class AuthController extends ChangeNotifier {
  final AuthRepository repository;

  AuthState _state = AuthState.idle;
  String? _errorMessage;

  AuthController({required this.repository});

  AuthState get state => _state;
  String? get errorMessage => _errorMessage;

  Future<void> sendResetEmail(String email) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await repository.sendPasswordResetEmail(email);
      _state = AuthState.success;
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      final token = await repository.signIn(email, password);
      _state = AuthState.success;
      notifyListeners();
      return token.isNotEmpty;
    } catch (e) {
      _state = AuthState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
