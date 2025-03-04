import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: Colors.blueAccent, // Define a cor primária
  appBarTheme: const AppBarTheme(
    color: Colors.blueAccent, // Cor da AppBar
    toolbarHeight: 80, // Altura da AppBar
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
          Colors.blueAccent), // Cor de fundo do botão
      foregroundColor:
          WidgetStateProperty.all<Color>(Colors.white), // Cor do texto do botão
      textStyle: WidgetStateProperty.all<TextStyle>(const TextStyle(
        fontSize: 16,
      )),
    ),
  ),
);
