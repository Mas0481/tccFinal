import 'package:flutter/material.dart';
import 'package:tcc/forms/form_centrifugacao';
import 'package:tcc/forms/form_lavagem.dart';
import 'package:tcc/forms/form_secagem.dart';
import 'dart:async';
import 'package:tcc/util/custom_appbar.dart';

import '../models/lote.dart';
import '../models/pedido.dart';

class AreaPreparacao extends StatelessWidget {
  const AreaPreparacao({super.key});

  @override
  Widget build(BuildContext context) {
    List<Pedido> pedidos = [
      Pedido(
        codCliente: 001,
        //nomeCliente: 'Cliente A',
        numPedido: 001,
        dataColeta: '05/10/2024',
        dataRecebimento: '05/10/2024',
        horaRecebimento: '08:00',
        dataLimite: '09/10/2024',
        dataEntrega: '10/10/2025',
        pesoTotal: 150.0,
        recebimentoStatus: 2,
        classificacaoStatus: 2,
        lavagemStatus: 2,
        centrifugacaoStatus: 2,
        secagemStatus: 2,
        passadoriaStatus: 2,
        finalizacaoStatus: 2,
        retornoStatus: 0,
        lotes: [
          Lote(
            pedidoNum: 001,
            loteNum: 001,
            peso: 1,
            processo: 'Hospital Pesado',
            loteCentrifugacaoStatus: 0,
            loteSecagemStatus: 0,
          ),
          Lote(
            pedidoNum: 001,
            loteNum: 002,
            peso: 15,
            processo: 'Hospital Leve',
            loteSecagemStatus: 0,
            loteCentrifugacaoStatus: 0,
          )
        ],
        nomCliente: '', qtdProduto: 1, valorProdutos: 1, pagamento: 1,
        totalLotes: 1,
      ),
    ];

    return MaterialApp(
      home: AreaPreparacaoPage(pedidos: pedidos),
    );
  }
}

class AreaPreparacaoPage extends StatefulWidget {
  final List<Pedido> pedidos;

  const AreaPreparacaoPage({super.key, required this.pedidos});

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
    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
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
              margin: const EdgeInsets.only(left: 25),
              height: MediaQuery.of(context).size.height * 0.807,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pedidos.length,
                itemBuilder: (context, index) {
                  return SizedBox(
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
    //double progressoLavagem = calcularProgresso(pedido, "Lavagem");
    double progressoCentrifugacao = calcularProgresso(pedido, "Centrifugação");
    double progressoSecagem = calcularProgresso(pedido, "Secagem");
    //print("Progresso lavagem: $progressoLavagem");
    return Container(
      width: MediaQuery.of(context).size.width *
          0.25, // Cada elemento ocupa 25% da largura
      margin: const EdgeInsets.all(10),
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
                  Text('Cliente: ${pedido.centrifugacaoStatus}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  Text('Pedido: ${pedido.numPedido}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 5),
                  Text('Data Entrega: ${pedido.dataEntrega}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  Text('Peso Total: ${pedido.pesoTotal}kg',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
              const SizedBox(height: 06),

              // Barras de Progresso
              Column(
                children: [
                  buildProgressBar1(
                      'Centrifugação', progressoCentrifugacao, pedido),
                  const SizedBox(height: 10),
                ],
              ),

              // Lotes - dois por linha usando GridView
              SizedBox(
                height: 145, // Aumentando a altura do GridView
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              const SizedBox(height: 10),
              buildProgressBar1('Secagem', progressoSecagem, pedido),
              const SizedBox(height: 10),

              // Lotes - dois por linha usando GridView
              SizedBox(
                height: 320, // Aumentando a altura do GridView
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    String displayLabel = label;
    // Verifica se todos os lotes estão concluídos e ajusta o label
    if (label == 'Centrifugação') {
      displayLabel =
          pedido.centrifugacaoStatus == 2 ? "$label Concluído" : label;
    } else {
      displayLabel = pedido.secagemStatus == 2 ? "$label Concluído" : label;
    }
    return InkWell(
      onTap: () {
        if (pedido.centrifugacaoStatus == 2) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Atenção'),
                content: const Text(
                    'Todos os lotes de Centrifugação foram concluídos!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (pedido.secagemStatus == 2) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Atenção'),
                content:
                    const Text('Todos os lotes de Secagem foram concluídos!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
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
                title: const Text('Atenção'),
                content: Text(
                    'Para iniciar o processo de $label, use o botão do Lote desejado.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
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
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 67,
          ),
          // Texto sobreposto
          Positioned.fill(
            child: Center(
              child: Text(
                displayLabel,
                style: const TextStyle(
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
    print('status do lote secagem: ${lote.loteSecagemStatus}');
    print('status do lote centrifugação: ${lote.loteCentrifugacaoStatus}');
    print('status do processo secagem: ${pedido.secagemStatus}');
    print('status do processo centrifugação: ${pedido.centrifugacaoStatus}');

    if (processo == "Centrifugação" && lote.loteCentrifugacaoStatus == 2) {
      buttonColor = Colors.blue;
      buttonText = "Lote Concluído";
    }

    if (processo == "Secagem" && lote.loteSecagemStatus == 2) {
      buttonColor = Colors.blue;
      buttonText = "Lote Concluído";
    }

    return GestureDetector(
      onTap: () {
        if (processo == "Centrifugação" && lote.loteCentrifugacaoStatus == 2) {
          // Exibe um diálogo informando que o processo já foi concluído
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Atenção'),
                content:
                    Text('O processo de $processo do lote já foi concluído.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (processo == "Secagem" && lote.loteSecagemStatus == 2) {
          // Exibe um diálogo informando que o processo já foi concluído
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Atenção'),
                content:
                    Text('O processo de $processo do lote já foi concluído.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (processo == "Lavagem" && lote.loteSecagemStatus == 0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Lavagem(
                  pedido: pedido,
                  onSave: () {
                    setState(() {
                      print("entrou no setstate da lavagem");
                      pedido.lavagemStatus =
                          1; // Atualiza o status para indicar conclusão de Lavagem
                    });
                  });
            },
          );
        } else if (processo == "Centrifugação" &&
            lote.loteCentrifugacaoStatus == 0.0 &&
            pedido.recebimentoStatus != 0.0 &&
            pedido.classificacaoStatus != 0.0 &&
            pedido.lavagemStatus != 0.0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Centrifugacao(onSave: () {
                setState(() {
                  lote.loteCentrifugacaoStatus =
                      2; // Atualiza o status para indicar conclusão do lote de Centrifugação
                  pedido.centrifugacaoStatus =
                      1; // Atualiza o status para indicar processode Secagem iniciado
                });
              });
            },
          );
        } else if (processo == "Secagem" &&
            lote.loteSecagemStatus == 0 &&
            pedido.recebimentoStatus != 0 &&
            pedido.classificacaoStatus != 0 &&
            pedido.lavagemStatus != 00 &&
            pedido.centrifugacaoStatus != 00) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Secagem(onSave: () {
                setState(() {
                  lote.loteSecagemStatus =
                      2; // Atualiza o status para indicar conclusão do lote de Secagem
                  pedido.secagemStatus =
                      1; // Atualiza o status para indicar processode Secagem iniciado
                });
              });
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Atenção'),
                content: Text(
                    'Para iniciar o processo de $processo, verifique os status dos processos anteriores. É necessário que tenham pelo menos sido iniciado.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(buttonText, style: const TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  double calcularProgresso(Pedido pedido, String processo) {
    int totalLotes = pedido.lotes.length;
    print("Total de lotes no pedido: $totalLotes");

    if (totalLotes == 0) {
      return 0.0; // Evita divisão por zero
    }

    if (processo == "Centrifugação") {
      int lotesCentrifugacaoConcluidos = pedido.lotes
          .where((lote) => lote.loteCentrifugacaoStatus == 2)
          .length;

      double progresso = lotesCentrifugacaoConcluidos / totalLotes;

      if (progresso == 1.0) {
        pedido.centrifugacaoStatus =
            2; // Atualiza o status do pedido para concluído
      }

      return progresso;
    } else if (processo == "Secagem") {
      int lotesSecagemConcluidos =
          pedido.lotes.where((lote) => lote.loteSecagemStatus == 2).length;

      double progresso = lotesSecagemConcluidos / totalLotes;

      if (progresso == 1.0) {
        pedido.secagemStatus = 2; // Atualiza o status do pedido para concluído
      }

      return progresso;
    } else {
      throw ArgumentError("Processo inválido: $processo");
    }
  }

  // Verifica se todos os lotes estão concluído

  /*  bool todosLotesConcluidos(Pedido pedido, String processo) {
    bool centrifugacao = false;
    bool secagem = false;
    bool retorno = false;

    for (var lote in pedido.lotes) {
      if (processo == 'Centrifugacao') {
        if (lote.loteCentrifugacaoStatus != 1) {
          centrifugacao = false;
          break;
        } else {
          pedido.centrifugacaoStatus = 2;
        }
      } else if (processo == 'Secagem') {
        if (lote.loteSecagemStatus != 1) {
          secagem = false;
          break;
        } else {
          pedido.secagemStatus = 2;
        }
      }
    }
    if (centrifugacao && secagem) {
      retorno = true;
    }
    return retorno;
  } */
}
