import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _token;
  String _userName = 'User Name';
  String _userEmail = 'user.name@email.com';

  String get userName => _userName;
  String get userEmail => _userEmail;
  String? get token => _token;
  bool get isLoggedIn => _token != null;

  void setUser(String name, String email, String token) {
    _userName = name;
    _userEmail = email;
    _token = token;
    notifyListeners(); // This tells the app that the user data has changed
  }

  void logout() {
    _userName = 'User Name';
    _userEmail = 'user.name@email.com';
    _token = null;
    notifyListeners();
  }
}