import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _username = '';
  String _password = '';

  String get username => _username;
  String get password => _password;

  void setUsername(String username) {
    _username = username;
    notifyListeners(); // Notifica as partes interessadas quando o usuário muda
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners(); // Notifica as partes interessadas quando a senha muda
  }
}