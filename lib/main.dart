import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/control_pages/routes.dart';
import 'package:tcc/providers/pedido_provider.dart';
import 'package:tcc/providers/user_provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => PedidoProvider())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wind Care',
      initialRoute: AppRoutes.home,
      routes: AppRoutes.getRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }
}
