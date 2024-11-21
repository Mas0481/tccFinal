import 'package:flutter/material.dart';
import 'package:tcc/forms/form_novoPedido.dart';
import 'package:tcc/util/custom_appbar.dart';
import 'routes.dart';

class OptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              width: 400,
              height: 250,
            ),
            buildOptionButton(context, 'Área Suja', AppRoutes.areaSuja),
            SizedBox(height: 20),
            buildOptionButton(context, 'Área Preparação', AppRoutes.preparacao),
            SizedBox(height: 20),
            buildOptionButton(
                context, 'Área Finalização', AppRoutes.finalizacao),
          ],
        ),
      ),
      floatingActionButton: Container(
          margin: const EdgeInsets.only(
              bottom: 40, right: 40), // Eleva o botão para cima
          child: ElevatedButton(
            onPressed: () {
              // Exibe o formulário de novo pedido na frente da tela de opções
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return NovoPedido(
                    onSave: () {
                      // Lógica para salvar o pedido
                      // Exemplo: Chamar algum método para salvar o pedido no banco ou realizar a ação desejada
                    },
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 24),
              backgroundColor:
                  const Color.fromARGB(255, 238, 233, 237), // Cor do botão
              foregroundColor: const Color.fromARGB(255, 119, 90, 113),
              side: BorderSide(color: Color.fromARGB(255, 238, 233, 237)),
              shape: CircleBorder(),
            ),
            child: Text(
              '+',
              style: TextStyle(
                  color: Color.fromARGB(255, 119, 90, 113), fontSize: 30),
            ),
          )),
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
