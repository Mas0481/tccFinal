import 'package:flutter/material.dart';
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
