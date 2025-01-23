import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  User? _user;
  String? _token;

  bool get isLoggedIn => _isLoggedIn;
  User? get user => _user;
  String? get token => _token;

  Future<void> login(String token, User user) async {
    _isLoggedIn = true;
    _token = token;
    _user = user;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _token = null;
    _user = null;
    notifyListeners();
  }
}

class User {
  final String name;
  final String email;
  final String profilePictureUrl;

  User({required this.name, required this.email, required this.profilePictureUrl});
}
