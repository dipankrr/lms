// controllers/auth_controller.dart
import 'package:flutter/foundation.dart';

class AuthController with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void login(String username, String password) {
    if (username == "admin" && password == "admin123") {
      _isLoggedIn = true;
      notifyListeners();
    } else {
      throw Exception("Invalid credentials");
    }
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}