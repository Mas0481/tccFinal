import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/providers/user_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;
  final bool usuario;
  final bool logo;

  CustomAppBar({
    required this.titulo,
    required this.usuario,
    required this.logo,
  });

  @override
  Widget build(BuildContext context) {
    // Obter o nome do usuário a partir do Provider
    final username = Provider.of<UserProvider>(context).username;

    return Stack(
      children: [
        // AppBar com borda
        Container(
          child: AppBar(
            toolbarHeight: 80, // Definindo altura do AppBar

            title: Text(
              titulo,
              style: TextStyle(
                fontWeight: FontWeight.bold, // Define o título em negrito
              ),
            ),
            centerTitle: true,
            actions: [
              if (usuario) // Exibe o botão do usuário apenas se o argumento for verdadeiro
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon:
                            Icon(Icons.account_circle, size: 40), // Ícone maior
                        onPressed: () {
                          _onUserPressed(context);
                        },
                      ),
                      Text(
                        username,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ), // Nome do usuário
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        // Logo sobreposta, apenas se o argumento logo for verdadeiro
        if (logo)
          Positioned(
            left: 50, // Margem de 16 à esquerda
            top: 30, // Margem de 16 no topo
            child: Container(
              width: 220, // Ajuste a largura conforme necessário
              height: 65, // A altura da logo deve ser igual à altura da AppBar
              child: ClipRect(
                // Garante que a imagem se ajuste ao container
                child: Image.asset(
                  'lib/images/logo.png',
                  fit: BoxFit.cover, // Faz a logo cobrir o espaço disponível
                ),
              ),
            ),
          ),
      ],
    );
  }

  // Função para trocar de usuário
  void _onUserPressed(BuildContext context) {
    // Pergunta se deseja trocar de usuário
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Trocar de Usuário'),
          content: Text('Você deseja trocar de usuário?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('Não'),
            ),
            TextButton(
              onPressed: () {
                // Chama a rota home do routes.dart
                Navigator.of(context).pushNamed('/home');
              },
              child: Text('Sim'),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80.0);
}
