import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthNotifier extends ChangeNotifier {
  User? user;
  bool isLoading = false;
  String? error;

  Future<bool> login(String username, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      user = await ApiService.login(username.trim(), password.trim());
    } catch (e) {
      error = errorMessage(e);
    }

    isLoading = false;
    notifyListeners();
    return user != null;
  }

  void logout() {
    ApiService.logout();
    user = null;
    error = null;
    notifyListeners();
  }
}
