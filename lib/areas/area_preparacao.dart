import 'package:flutter/material.dart';
import 'package:tcc/forms/form_centrifugacao';
import 'package:tcc/forms/form_lavagem.dart';
import 'dart:async';
import 'package:tcc/util/custom_appbar.dart';

class AreaPreparacao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mapa de exemplo com 4 pedidos
    List<Pedido> pedidos = [
      Pedido(
        cliente: 'Cliente A',
        pedido: 'Pedido 001',
        dataEntrega: '10/10/2024',
        pesoTotal: 150.0,
        lotes: [
          Lote(nome: 'Lote 1', status: 1.0), // 100%
          Lote(nome: 'Lote 2', status: 1.0), // 100%
          Lote(nome: 'Lote 3', status: 0.66), // 66%
          Lote(nome: 'Lote 1', status: 1.0), // 100%
          Lote(nome: 'Lote 2', status: 1.0), // 100%
          Lote(nome: 'Lote 3', status: 0.66), // 66%
          Lote(nome: 'Lote 1', status: 1.0), // 100%
          Lote(nome: 'Lote 2', status: 1.0), // 100%
          Lote(nome: 'Lote 3', status: 0.66), // 66%
          Lote(nome: 'Lote 1', status: 1.0), // 100%
          Lote(nome: 'Lote 2', status: 1.0), // 100%
          Lote(nome: 'Lote 3', status: 0.66), // 66%
        ],
      ),
      Pedido(
        cliente: 'Cliente B',
        pedido: 'Pedido 002',
        dataEntrega: '12/10/2024',
        pesoTotal: 200.0,
        lotes: [
          Lote(nome: 'Lote 1', status: 0.8), // 80%
          Lote(nome: 'Lote 2', status: 0.6), // 60%
        ],
      ),
      Pedido(
        cliente: 'Cliente C',
        pedido: 'Pedido 003',
        dataEntrega: '15/10/2024',
        pesoTotal: 100.0,
        lotes: [
          Lote(nome: 'Lote 1', status: 0.4), // 40%
        ],
      ),
      Pedido(
        cliente: 'Cliente D',
        pedido: 'Pedido 004',
        dataEntrega: '20/10/2024',
        pesoTotal: 250.0,
        lotes: [
          Lote(nome: 'Lote 1', status: 1.0), // 100%
          Lote(nome: 'Lote 2', status: 0.7), // 70%
          Lote(nome: 'Lote 3', status: 0.9), // 90%
        ],
      ),
    ];

    return MaterialApp(
      home: AreaPreparacaoPage(pedidos: pedidos),
    );
  }
}

class Pedido {
  final String cliente;
  final String pedido;
  final String dataEntrega;
  final double pesoTotal;
  final List<Lote> lotes;

  Pedido({
    required this.cliente,
    required this.pedido,
    required this.dataEntrega,
    required this.pesoTotal,
    required this.lotes,
  });
}

class Lote {
  final String nome;
  final double status;

  Lote({required this.nome, required this.status});
}

class AreaPreparacaoPage extends StatefulWidget {
  final List<Pedido> pedidos;

  AreaPreparacaoPage({required this.pedidos});

  @override
  _AreaPreparacaoPageState createState() => _AreaPreparacaoPageState();
}

class _AreaPreparacaoPageState extends State<AreaPreparacaoPage> {
  late List<Pedido> pedidos;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    pedidos = widget.pedidos;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 30), (timer) {
      // Aqui você pode implementar a lógica para atualizar os pedidos
      setState(() {
        // Atualize os pedidos conforme necessário
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titulo: 'WindCare - Área Preparação',
        usuario: true,
        logo: true,
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(left: 25),
              height: MediaQuery.of(context).size.height * 0.807,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pedidos.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.24,
                    child: buildPedidoCard(pedidos[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPedidoCard(Pedido pedido) {
    return Container(
      width: MediaQuery.of(context).size.width *
          0.25, // Cada elemento ocupa 25% da largura
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: SingleChildScrollView(
        // Permite a rolagem interna
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cliente: ${pedido.cliente}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text('Pedido: ${pedido.pedido}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 5),
                  Text('Data Entrega: ${pedido.dataEntrega}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text('Peso Total: ${pedido.pesoTotal}kg',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
              SizedBox(height: 06),

              // Barras de Progresso
              Column(
                children: [
                  buildProgressBar('Centrifugação', 0.5),
                  SizedBox(height: 10),
                ],
              ),

              // Lotes - dois por linha usando GridView
              SizedBox(
                height: 145, // Aumentando a altura do GridView
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Define duas colunas
                    childAspectRatio: 2, // Proporção de aspecto dos botões
                    crossAxisSpacing: 10, // Espaçamento horizontal
                    mainAxisSpacing: 10, // Espaçamento vertical
                  ),
                  shrinkWrap:
                      true, // Para permitir que o GridView se ajuste ao tamanho do conteúdo
                  // physics:
                  // NeverScrollableScrollPhysics(), // Desativa a rolagem do GridView
                  itemCount: pedido.lotes.length,
                  itemBuilder: (context, index) {
                    return buildLoteButton(pedido.lotes[index]);
                  },
                ),
              ),
              SizedBox(height: 10),
              buildProgressBar1('Secagem', 0.5),
              SizedBox(height: 10),

              // Lotes - dois por linha usando GridView
              SizedBox(
                height: 320, // Aumentando a altura do GridView
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Define duas colunas
                    childAspectRatio: 2, // Proporção de aspecto dos botões
                    crossAxisSpacing: 10, // Espaçamento horizontal
                    mainAxisSpacing: 10, // Espaçamento vertical
                  ),
                  shrinkWrap:
                      true, // Para permitir que o GridView se ajuste ao tamanho do conteúdo
                  // physics:
                  // NeverScrollableScrollPhysics(), // Desativa a rolagem do GridView
                  itemCount: pedido.lotes.length,
                  itemBuilder: (context, index) {
                    return buildLoteButton(pedido.lotes[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Barra de progresso animada que atua como um botão
  Widget buildProgressBar(String label, double progress) {
    return InkWell(
        onTap: () {
          print('Barra de progresso $label pressionada');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Centrifugacao(
                onSave: () {},
              );
            },
          );
          print('$label clicado!'); // Exemplo de ação: imprimir no console
        },
        borderRadius:
            BorderRadius.circular(8), // Adiciona um raio de borda ao botão
        child: Stack(
          children: [
            // ProgressBar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 67, // Aumenta a altura da barra para acomodar o rótulo
            ),
            // Texto sobreposto
            Positioned.fill(
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.black, // Cor do texto
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildProgressBar1(String label, double progress) {
    return InkWell(
        onTap: () {
          print('Barra de progresso $label pressionada');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Atenção'),
                content: Text(
                    'Para inserir os dados das Secagens use os botões de Lote.'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'))
                ],
              );
            },
          );
          print('$label clicado!'); // Exemplo de ação: imprimir no console
        },
        borderRadius:
            BorderRadius.circular(8), // Adiciona um raio de borda ao botão
        child: Stack(
          children: [
            // ProgressBar
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              minHeight: 67, // Aumenta a altura da barra para acomodar o rótulo
            ),
            // Texto sobreposto
            Positioned.fill(
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.black, // Cor do texto
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildLoteButton(Lote lote) {
    Color loteColor = lote.status == 1.0
        ? Colors.blue
        : Colors.grey[300]!; // Cor igual à progress bar quando 100%

    return GestureDetector(
      onTap: () {
        // Adicione a lógica que você deseja quando o botão do lote for clicado
        print('Lote: ${lote.nome} foi clicado');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Lavagem(
              onSave: () {},
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: loteColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Center(
          child: Text(
            lote.nome,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
