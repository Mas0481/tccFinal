import 'package:flutter/material.dart';
import 'package:tcc/forms/form_centrifugacao';
import 'package:tcc/forms/form_lavagem.dart';
import 'package:tcc/forms/form_secagem.dart';
import 'dart:async';
import 'package:tcc/util/custom_appbar.dart';

import '../lote.dart';
import '../pedido.dart';

class AreaPreparacao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Pedido> pedidos = [
      Pedido(
        codCliente: 001,
        nomeCliente: 'Cliente A',
        numPedido: 'Pedido 001',
        dataColeta: '05/10/2024',
        dataRecebimento: '05/10/2024',
        horaRecebimento: '08:00',
        dataLimite: '09/10/2024',
        dataEntrega: '10/10/2025',
        pesoTotal: 150.0,
        recebimentoStatus: 1,
        classificacaoStatus: 1,
        lavagemStatus: 1,
        lotes: [
          Lote(
            pedidoNum: 001,
            loteNum: 001,
            loteCentrifugacaoStatus: 0,
            loteSecagemStatus: 0,
          ),
          Lote(
            pedidoNum: 001,
            loteNum: 002,
            loteSecagemStatus: 0,
            loteCentrifugacaoStatus: 0,
          )
        ],
      ),
    ];

    return MaterialApp(
      home: AreaPreparacaoPage(pedidos: pedidos),
    );
  }
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
    double progressoLavagem = calcularProgresso(pedido.lotes, "Lavagem");
    double progressoCentrifugacao =
        calcularProgresso(pedido.lotes, "Centrifugação");
    double progressoSecagem = calcularProgresso(pedido.lotes, "Secagem");
    print("Progresso lavagem: $progressoLavagem");
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
                  Text('Cliente: ${pedido.nomeCliente}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text('Pedido: ${pedido.numPedido}',
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
                  buildProgressBar1(
                      'Centrifugação', progressoCentrifugacao, pedido),
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
                    return buildLoteButton(
                        pedido.lotes[index], pedido, "Centrifugação");
                  },
                ),
              ),
              SizedBox(height: 10),
              buildProgressBar1('Secagem', progressoSecagem, pedido),
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
                    return buildLoteButton(
                        pedido.lotes[index], pedido, "Secagem");
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
  Widget buildProgressBar1(String label, double progress, Pedido pedido) {
    // Verifica se todos os lotes estão concluídos e ajusta o label
    String displayLabel =
        todosLotesConcluidos(pedido) ? "$label Concluído" : label;

    return InkWell(
      onTap: () {
        if (pedido.recebimentoStatus != 1 ||
            pedido.classificacaoStatus != 1 ||
            pedido.lavagemStatus == 0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Atenção'),
                content: Text(
                    'Para iniciar o processo de Centrifugação deste lote, verifique se o recebimento e a classificação estão completos e lavagem no minimo iniciado.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (todosLotesConcluidos(pedido)) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Atenção'),
                content:
                    Text('Todos os lotes de Centrifugação foram concluídos!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Atenção'),
                content: Text(
                    'Para iniciar o processo, use o botão do Lote desejado.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          // Barra de progresso
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 67,
          ),
          // Texto sobreposto
          Positioned.fill(
            child: Center(
              child: Text(
                displayLabel,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoteButton(Lote lote, Pedido pedido, String processo) {
    // Define o status necessário e o texto padrão com base no processo
    late Color buttonColor = Colors.grey[300]!;
    late String buttonText = 'Iniciar Lote';
    print('status secagem: ${lote.loteSecagemStatus}');

    if (processo == "Centrifugação" && lote.loteCentrifugacaoStatus == 1) {
      buttonColor = Colors.blue;
      buttonText = "Lote Concluído";
      print("entrou no if da cor centrifugacao");
    }

    if (processo == "Secagem" && lote.loteSecagemStatus == 1) {
      buttonColor = Colors.blue;
      buttonText = "Lote Concluído";
      print("entrou no if da cor secagem");
    }

    return GestureDetector(
      onTap: () {
        if (processo == "Centrifugação" && lote.loteCentrifugacaoStatus == 1) {
          // Exibe um diálogo informando que o processo já foi concluído
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Atenção'),
                content:
                    Text('O processo de $processo do lote já foi concluído.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (processo == "Secagem" && lote.loteSecagemStatus == 1) {
          // Exibe um diálogo informando que o processo já foi concluído
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Atenção'),
                content:
                    Text('O processo de $processo do lote já foi concluído.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Verifica os status dos processos anteriores
          if (pedido.recebimentoStatus == 1.0 &&
              pedido.classificacaoStatus == 1.0 &&
              pedido.lavagemStatus != 0.0) {
            // Define o que ocorre ao iniciar cada processo específico
            if (processo == "Lavagem") {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Lavagem(onSave: () {
                    setState(() {
                      print("entrou no setstate da lavagem");
                      pedido.lavagemStatus =
                          1; // Atualiza o status para indicar conclusão de Lavagem
                    });
                  });
                },
              );
            } else if (processo == "Centrifugação") {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Centrifugacao(onSave: () {
                    setState(() {
                      lote.loteCentrifugacaoStatus =
                          1; // Atualiza o status para indicar conclusão de Centrifugação                    1; // Atualiza o status para indicar conclusão de Centrifugação
                      print('entrou no setstate da centrifugacao');
                    });
                  });
                },
              );
            } else if (processo == "Secagem") {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Secagem(onSave: () {
                    setState(() {
                      print("entrou no setstate do secagem");
                      lote.loteSecagemStatus =
                          1; // Atualiza o status para indicar conclusão de Secagem
                      print('entrou no setstate do secagem');
                    });
                  });
                },
              );
            }
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Atenção'),
                  content: Text(
                      'Para iniciar o processo de $processo, verifique os status dos processos anteriores. É necessário que Recebimento e Classificação estejam concluídos e Lavagem tenha sido iniciado.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(buttonText, style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  double calcularProgresso(List<Lote> lotes, String processo) {
    int totalLotes = lotes.length;
    print("Total de lotes: $totalLotes");
    if (processo == "Centrifugação") {
      int lotesCentrifugacaoConcluidos =
          lotes.where((lote) => lote.loteCentrifugacaoStatus == 1).length;
      print(totalLotes == 0 ? 0.0 : lotesCentrifugacaoConcluidos / totalLotes);
      return totalLotes == 0 ? 0.0 : lotesCentrifugacaoConcluidos / totalLotes;
    } else {
      int lotesSecagemConcluidos =
          lotes.where((lote) => lote.loteSecagemStatus == 1).length;
      print(totalLotes == 0 ? 0.0 : lotesSecagemConcluidos / totalLotes);
      return totalLotes == 0 ? 0.0 : lotesSecagemConcluidos / totalLotes;
    }
  }

  // Verifica se todos os lotes estão concluídos
  bool todosLotesConcluidos(Pedido pedido) {
    for (var lote in pedido.lotes) {
      if (lote.loteStatus != 1) {
        // 1.0 indica que o lote ainda não está concluído
        return false;
      }
    }

    // Se todos os lotes estão concluídos, atualize pedido.lavagem
    pedido.lavagemStatus = 1;
    return true;
  }
}
