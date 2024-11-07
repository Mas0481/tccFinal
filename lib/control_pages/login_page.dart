import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/control_pages/routes.dart';
import 'package:tcc/util/user_provider.dart'; // Certifique-se de que o caminho esteja correto

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/images/logo.png', // Caminho para o logo local
                  width: 400,
                  height: 250,
                ),
                SizedBox(
                  width:
                      MediaQuery.of(context).size.width * 0.3, // 30% da largura
                  child: TextField(
                    controller: _userController,
                    decoration: InputDecoration(
                      labelText: 'Usuário',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Espaçamento entre os campos
                SizedBox(
                  width:
                      MediaQuery.of(context).size.width * 0.3, // 30% da largura
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                    height: 20), // Espaçamento entre o campo de senha e a ajuda
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
                      onPressed: () {
                        // Ação para "Esqueceu a senha?"
                      },
                      child: Text('Esqueceu a senha?'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width:
                      MediaQuery.of(context).size.width * 0.3, // 30% da largura
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Provider.of<UserProvider>(context, listen: false)
                          .setUsername(_userController.text);
                      Provider.of<UserProvider>(context, listen: false)
                          .setPassword(_passwordController.text);
                      Navigator.pushNamed(context, AppRoutes.options);
                    },
                    child: Text('Entrar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
