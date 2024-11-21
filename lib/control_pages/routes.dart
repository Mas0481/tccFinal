// routes.dart
import 'package:flutter/material.dart';
import 'package:tcc/areas/area_finalizacao.dart';
import 'package:tcc/areas/area_preparacao.dart';
import 'package:tcc/areas/area_suja.dart';
import 'package:tcc/forms/form_lavagem.dart';
import 'package:tcc/forms/form_novoPedido.dart';

import 'package:tcc/forms/form_recebimento.dart';
import 'package:tcc/forms/form_classificacao.dart';
import 'package:tcc/control_pages/login_page.dart';
import 'package:tcc/control_pages/options_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String options = '/options';
  static const String areaSuja = '/areaSuja';
  static const String preparacao = '/preparacao';
  static const String recebimento = '/recebimento';
  static const String lavagem = '/lavagem';
  static const String classificacao = '/classificacao';
  static const String finalizacao = '/finalizacao';
  static const String novoPedido = '/novoPedido';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => LoginPage(),
      options: (context) => OptionsPage(),
      areaSuja: (context) => AreaSuja(),
      preparacao: (context) => AreaPreparacao(),
      finalizacao: (context) => AreaFinalizacao(),
      recebimento: (context) {
        // Exibir o popup quando a rota 'recebimento' é chamada
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => Recebimento(
              onSave: () {},
            ),
          );
        });
        return Container(); // Retorne um container vazio pois estamos exibindo um dialog
      },
      lavagem: (context) {
        // Exibir o popup quando a rota 'recebimento' é chamada
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => Lavagem(
              onSave: () {},
            ),
          );
        });
        return Container(); // Retorne um container vazio pois estamos exibindo um dialog
      },
      classificacao: (context) {
        // Exibir o popup quando a rota 'recebimento' é chamada
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => Classificacao(
              onSave: () {},
            ),
          );
        });
        return Container(); // Retorne um container vazio pois estamos exibindo um dialog
      },
      novoPedido: (context) {
        // Exibir o popup quando a rota 'recebimento' é chamada
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (context) => NovoPedido(
              onSave: () {},
            ),
          );
        });
        return Container(); // Retorne um container vazio pois estamos exibindo um dialog
      },
    };
  }
}
