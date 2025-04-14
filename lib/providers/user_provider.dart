import 'package:flutter/material.dart';
import 'package:tcc/repository/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository;
  String _username = '';
  String _password = '';
  bool _isAuthenticated = false;

  UserProvider(this._userRepository);

  String get username => _username;
  String get password => _password;
  bool get isAuthenticated => _isAuthenticated;
  String get loggedInUser => _username;

  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  // Novo método para limpar os dados de login
  void clearCredentials() {
    _username = '';
    _password = '';
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<String> login() async {
    try {
      if (_username.isEmpty || _password.isEmpty) {
        return "Usuário e senha não podem estar vazios.";
      }

      _isAuthenticated =
          await _userRepository.authenticate(_username, _password);
      notifyListeners();

      return _isAuthenticated
          ? "Login bem-sucedido"
          : "Usuário ou senha inválidos.";
    } catch (e) {
      print("Erro durante o login: $e");
      return "Erro inesperado. Tente novamente mais tarde.";
    }
  }
}
