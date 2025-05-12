import 'package:flutter/material.dart';
import 'package:tcc/forms/form_novoPedido.dart';
import 'package:tcc/forms/pedidos.dart';
import 'package:tcc/util/custom_appbar.dart';
import 'routes.dart';

class OptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldLogout = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirmar Logout'),
                  content:
                      const Text('Você gostaria de fazer logout do sistema?'),
                  actions: [
                    TextButton(
                      child: const Text('Não'),
                      onPressed: () {
                        Navigator.of(context).pop(false); // Stay on the page
                      },
                    ),
                    TextButton(
                      child: const Text('Sim'),
                      onPressed: () {
                        Navigator.of(context).pop(true); // Proceed with logout
                      },
                    ),
                  ],
                );
              },
            ) ??
            false;

        if (shouldLogout) {
          // Clear login data (e.g., user and password)
          // Add your logic to clear login data here, if necessary

          Navigator.pushNamedAndRemoveUntil(
            context,
            '/', // Navigate to the login screen
            (route) => false, // Remove all routes from the stack
          );
        }
        return false; // Prevent default back button behavior
      },
      child: Scaffold(
        appBar: CustomAppBar(
          titulo: '',
          usuario: true,
          logo: false,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'lib/images/logo.png',
                width: MediaQuery.of(context).size.width *
                    0.8, // 80% da largura da tela
                height: MediaQuery.of(context).size.height *
                    0.3, // 30% da altura da tela
              ),
              buildOptionButton(context, 'Área Suja', AppRoutes.areaSuja),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.02), // 2% da altura
              buildOptionButton(
                  context, 'Área Preparação', AppRoutes.preparacao),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.02), // 2% da altura
              buildOptionButton(
                  context, 'Área Finalização', AppRoutes.finalizacao),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.02), // 2% da altura
              SizedBox(
                width:
                    MediaQuery.of(context).size.width * 0.3, // 30% da largura
                height:
                    MediaQuery.of(context).size.height * 0.06, // 6% da altura
                child: ElevatedButton(
                  onPressed: () async {
                    bool shouldLogout = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirmar Logout'),
                              content: const Text(
                                  'Você gostaria de fazer logout do sistema?'),
                              actions: [
                                TextButton(
                                  child: const Text('Não'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(false); // Stay on the page
                                  },
                                ),
                                TextButton(
                                  child: const Text('Sim'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(true); // Proceed with logout
                                  },
                                ),
                              ],
                            );
                          },
                        ) ??
                        false;

                    if (shouldLogout) {
                      // Clear login data (e.g., user and password)
                      // Add your logic to clear login data here, if necessary

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/', // Navigate to the login screen
                        (route) => false, // Remove all routes from the stack
                      );
                    }
                  },
                  child: Text('Sair'),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: 40,
              right: 40,
              child: ElevatedButton(
                onPressed: () {
                  // Exibe o formulário de novo pedido
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return NovoPedido(
                        onSave: () {
                          // Lógica para salvar o pedido
                        },
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height *
                        0.03, // 3% da altura
                  ),
                  backgroundColor:
                      const Color.fromARGB(255, 238, 233, 237), // Cor do botão
                  foregroundColor: const Color.fromARGB(255, 119, 90, 113),
                  side: BorderSide(color: Color.fromARGB(255, 238, 233, 237)),
                  shape: CircleBorder(),
                ),
                child: Text(
                  '+',
                  style: TextStyle(
                      color: Color.fromARGB(255, 119, 90, 113),
                      fontSize: MediaQuery.of(context).size.height *
                          0.07), // 10% da altura
                ),
              ),
            ),
            Positioned(
              bottom: 130,
              right: 40,
              child: ElevatedButton(
                onPressed: () {
                  // Exibe o formulário de informações
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Pedidos(); // Chama o formulário de informações
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height *
                        0.03, // 3% da altura
                  ),
                  backgroundColor:
                      const Color.fromARGB(255, 238, 233, 237), // Cor do botão
                  foregroundColor: const Color.fromARGB(255, 119, 90, 113),
                  side: BorderSide(color: Color.fromARGB(255, 238, 233, 237)),
                  shape: CircleBorder(),
                ),
                child: Text(
                  'i',
                  style: TextStyle(
                      color: Color.fromARGB(255, 119, 90, 113),
                      fontSize: MediaQuery.of(context).size.height *
                          0.07), // 4% da altura
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOptionButton(BuildContext context, String title, String route) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3, // 30% da largura
      height: 50, // Altura dos botões
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(
              context, route); // Navega para a rota correspondente
        },
        child: Text(title),
      ),
    );
  }
}
