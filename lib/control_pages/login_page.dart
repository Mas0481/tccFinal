import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/control_pages/routes.dart';
import 'package:tcc/providers/user_provider.dart'; // Certifique-se de que o caminho esteja correto

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberPassword = false;

  void _performLogin(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.setUsername(_userController.text);
    userProvider.setPassword(_passwordController.text);

    // Exibe um carregando enquanto autentica
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

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
                  'lib/images/logo.png',
                  width: 400,
                  height: 250,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextField(
                    controller: _userController,
                    decoration: const InputDecoration(
                      labelText: 'Usuário',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
<<<<<<< HEAD
                const SizedBox(height: 20), // Espaçamento entre os campos
=======
                SizedBox(height: 20),
>>>>>>> b7391761758770e119e982b5324c048478d92f9b
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
<<<<<<< HEAD
                const SizedBox(
                    height: 20), // Espaçamento entre o campo de senha e a ajuda
=======
                SizedBox(height: 20),
>>>>>>> b7391761758770e119e982b5324c048478d92f9b
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
                    const Text('Lembrar senha'),
                    TextButton(
<<<<<<< HEAD
                      onPressed: () {
                        // Ação para "Esqueceu a senha?"
                      },
                      child: const Text('Esqueceu a senha?'),
=======
                      onPressed: () {},
                      child: Text('Esqueceu a senha?'),
>>>>>>> b7391761758770e119e982b5324c048478d92f9b
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 50,
                  child: ElevatedButton(
<<<<<<< HEAD
                    onPressed: () {
                      Provider.of<UserProvider>(context, listen: false)
                          .setUsername(_userController.text);
                      Provider.of<UserProvider>(context, listen: false)
                          .setPassword(_passwordController.text);
                      Navigator.pushNamed(context, AppRoutes.options);
                    },
                    child: const Text('Entrar'),
=======
                    onPressed: () => _performLogin(context),
                    child: Text('Entrar'),
>>>>>>> b7391761758770e119e982b5324c048478d92f9b
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
