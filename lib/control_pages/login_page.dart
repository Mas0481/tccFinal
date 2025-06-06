import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/control_pages/routes.dart';
import 'package:tcc/providers/user_provider.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberPassword = false;
  DateTime? lastBackPressTime;

  void _performLogin(BuildContext context) async {
    if (_userController.text.isEmpty) {
      _showMessage('O campo "Usuário" é obrigatório.');
      return;
    }
    if (_passwordController.text.isEmpty) {
      _showMessage('O campo "Senha" é obrigatório.');
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUsername(_userController.text);
    userProvider.setPassword(_passwordController.text);

    // Exibe um indicador de carregamento enquanto autentica
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    // Realiza login
    String message = await userProvider.login();
    Navigator.pop(context); // Fecha o indicador de carregamento

    if (userProvider.isAuthenticated) {
      // Login bem-sucedido
      Navigator.pushNamed(context, AppRoutes.options);
    } else {
      // Exibe mensagem de erro
      _showMessage(message);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromARGB(
            255, 12, 68, 114), // Set background color to blue
      ),
    );
  }

  void _exitApp() {
    // Fecha completamente o aplicativo
    SystemNavigator.pop();
  }

  Future<bool> _onWillPop() async {
    final currentTime = DateTime.now();
    if (lastBackPressTime == null ||
        currentTime.difference(lastBackPressTime!) > Duration(seconds: 2)) {
      lastBackPressTime = currentTime;

      // Exibe uma mensagem ao usuário
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pressione novamente para sair'),
          duration: Duration(seconds: 2),
          backgroundColor: const Color.fromARGB(
              255, 12, 68, 114), // Set background color to blue
        ),
      );

      return false; // Previne a ação de voltar
    }

    // Sai do aplicativo no segundo toque
    _exitApp();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/images/logo.png',
                    width: 400,
                    height: 250,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextField(
                      controller: _userController,
                      decoration: InputDecoration(
                        labelText: 'Usuário',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: rememberPassword,
                        onChanged: (bool? value) {
                          setState(() {
                            rememberPassword = value ?? false;
                          });
                        },
                      ),
                      Text('Lembrar senha'),
                      TextButton(
                        onPressed: () {},
                        child: Text('Esqueceu a senha?'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _performLogin(context),
                      child: Text('Entrar'),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _exitApp,
                      child: Text('Sair'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
