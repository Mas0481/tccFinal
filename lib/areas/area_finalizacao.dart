import 'package:flutter/material.dart';
import 'package:tcc/forms/form_finalizacao.dart';
import 'package:tcc/forms/form_passadoria.dart';
import 'package:tcc/forms/form_retorno.dart'; // Novo import
import 'dart:async';
import 'package:tcc/util/custom_appbar.dart';
import '../models/lote.dart';
import '../models/pedido.dart';

class AreaFinalizacao extends StatelessWidget {
  const AreaFinalizacao({super.key});

  // final PageController _pageController =
  //   PageController(initialPage: 0, viewportFraction: 0.1);

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
        totalLotes: 1, pesoTotalLotes: 0.0,
      ),
    ];

    return MaterialApp(
      home: AreaFinalizacaoPage(pedidos: pedidos),
    );
  }
}

class AreaFinalizacaoPage extends StatefulWidget {
  final List<Pedido> pedidos;

  const AreaFinalizacaoPage({super.key, required this.pedidos});

  @override
  _AreaFinalizacaoPageState createState() => _AreaFinalizacaoPageState();
}

class _AreaFinalizacaoPageState extends State<AreaFinalizacaoPage> {
  late List<Pedido> pedidos;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    pedidos = widget.pedidos;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 01), (timer) {
      setState(() {
        // Aqui você pode implementar a lógica para atualizar os pedidos
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
          titulo: 'WindCare - Área Finalização', usuario: true, logo: true),
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
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text('Cliente: ${pedido.nomeCliente}',
              // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
              const SizedBox(height: 6),
              buildProgressBar(
                  'Passadoria', pedido.passadoriaStatus.toDouble(), pedido),
              const SizedBox(height: 10),
              buildLoteRow(pedido, 'Passadoria'),
              const SizedBox(height: 10),
              buildProgressBar(
                  'Finalização', pedido.finalizacaoStatus.toDouble(), pedido),
              const SizedBox(height: 10),
              buildLoteRow(pedido, 'Finalização'),
              const SizedBox(height: 10),
              buildProgressBar(
                  'Retorno', pedido.retornoStatus.toDouble(), pedido),
              const SizedBox(height: 10),
              buildLoteRow(pedido, 'Retorno'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProgressBar(String label, double progress, Pedido pedido) {
    String displayLabel = label;
    // Verifica se todos os lotes estão concluídos e ajusta o label
    if (label == 'Passadoria') {
      displayLabel = pedido.passadoriaStatus == 2 ? "$label Concluído" : label;
    } else if (label == 'Finalização') {
      displayLabel = pedido.finalizacaoStatus == 2 ? "$label Concluído" : label;
    } else if (label == 'Retorno') {
      displayLabel = pedido.retornoStatus == 2 ? "$label Concluído" : label;
    }
    return InkWell(
      onTap: () {
        if (label == 'Passadoria' && pedido.passadoriaStatus == 2) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Atenção'),
                content: const Text('Processo Concluido!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (label == 'Finalização' && pedido.finalizacaoStatus == 2) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Atenção'),
                content: const Text('Processo Concluido!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (label == 'Retorno' && pedido.retornoStatus == 2) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Atenção'),
                content: const Text('Processo Concluido!'),
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
                    'Para Iniciar o Processo de $label Clique no Botão Registrar Inicio!'),
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
        print('Barra de progresso $label pressionada');
      },
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          LinearProgressIndicator(
            value: progress / 2, // Para uma visualização adequada
            backgroundColor: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 67,
          ),
          Positioned.fill(
            child: Center(
              child: Text(
                displayLabel,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoteRow(Pedido pedido, String processo) {
    return SizedBox(
      height: 67,
      child: Row(
        children: [
          Expanded(child: buildLoteButtonIniciar(pedido, processo)),
          const SizedBox(width: 10),
          Expanded(child: buildLoteButtonFinalizar(pedido, processo)),
        ],
      ),
    );
  }

  Widget buildLoteButtonIniciar(Pedido pedido, String processo) {
    Color? loteColor = Colors.grey[300];
    String buttonText = 'Registrar Início';

    return StatefulBuilder(
      builder: (context, setState) {
        if ((processo == 'Passadoria' && pedido.passadoriaStatus == 1) ||
            (processo == 'Finalização' && pedido.finalizacaoStatus == 1) ||
            (processo == 'Retorno' && pedido.retornoStatus == 1)) {
          loteColor = Colors.red;
          buttonText = 'Processando';
        } else if ((processo == 'Passadoria' && pedido.passadoriaStatus == 2) ||
            (processo == 'Finalização' && pedido.finalizacaoStatus == 2) ||
            (processo == 'Retorno' && pedido.retornoStatus == 2)) {
          loteColor = Colors.blue;
          buttonText = 'Processado';
        }

        return GestureDetector(
          onTap: () {
            if (processo == 'Passadoria' &&
                pedido.passadoriaStatus == 0 &&
                pedido.recebimentoStatus != 0 &&
                pedido.classificacaoStatus != 0 &&
                pedido.lavagemStatus != 00 &&
                pedido.centrifugacaoStatus != 00 &&
                pedido.secagemStatus != 00) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => Passadoria(
                        onSave: () {
                          setState(() {
                            loteColor = Colors.red;
                            pedido.passadoriaStatus = 1;
                            buttonText = 'Processando';
                          });
                        },
                      ));
            } else if (processo == 'Finalização' &&
                pedido.finalizacaoStatus == 0 &&
                pedido.recebimentoStatus != 0 &&
                pedido.classificacaoStatus != 0 &&
                pedido.lavagemStatus != 00 &&
                pedido.centrifugacaoStatus != 00 &&
                pedido.secagemStatus != 00 &&
                pedido.passadoriaStatus != 0) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => Finalizacao(
                        onSave: () {
                          setState(() {
                            loteColor = Colors.red;
                            pedido.finalizacaoStatus = 1;
                            buttonText = 'Processando';
                          });
                        },
                      ));
            } else if (processo == 'Retorno' &&
                pedido.retornoStatus == 0 &&
                pedido.recebimentoStatus == 2 &&
                pedido.classificacaoStatus == 2 &&
                pedido.lavagemStatus == 2 &&
                pedido.centrifugacaoStatus == 2 &&
                pedido.secagemStatus == 2 &&
                pedido.passadoriaStatus == 2 &&
                pedido.finalizacaoStatus == 2) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => Retorno(
                        onSave: () {
                          setState(() {
                            loteColor = Colors.red;
                            pedido.retornoStatus = 1;
                            buttonText = 'Processando';
                          });
                        },
                      ));
            } else {
              if (processo == "Retorno") {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Atenção'),
                      content: const Text(
                          'Para dar início ao Processo de Retorno, todos os Processos anteriores devem estar Finalizados!'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'))
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
                          'Para dar início ao Processo de $processo, todos os Processos anteriores devem estar no mínimo iniciados!'),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'))
                      ],
                    );
                  },
                );
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: loteColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
                child: Text(buttonText,
                    style: const TextStyle(color: Colors.black))),
          ),
        );
      },
    );
  }

  Widget buildLoteButtonFinalizar(Pedido pedido, String processo) {
    Color? loteColor = Colors.grey[300];
    String buttonText = 'Finalizar Processo';

    return StatefulBuilder(
      builder: (context, setState) {
        if ((processo == 'Passadoria' && pedido.passadoriaStatus == 2) ||
            (processo == 'Finalização' && pedido.finalizacaoStatus == 2) ||
            (processo == 'Retorno' && pedido.retornoStatus == 2)) {
          loteColor = Colors.blue;
          buttonText = 'Concluído';
        }

        return GestureDetector(
          onTap: () {
            // Verificação de processos anteriores para finalização
            if (processo == 'Finalização' && pedido.passadoriaStatus == 0) {
              showAlertDialog(context, 'Passadoria ainda não foi iniciado.');
              return;
            } else if (processo == 'Retorno' && pedido.finalizacaoStatus == 0) {
              showAlertDialog(context, 'Finalização ainda não foi iniciado.');
              return;
            }

            if ((processo == 'Passadoria' && pedido.passadoriaStatus == 1) ||
                (processo == 'Finalização' && pedido.finalizacaoStatus == 1) ||
                (processo == 'Retorno' && pedido.retornoStatus == 1)) {
              // Exibir popup de confirmação
              showConfirmationDialog(context, () {
                setState(() {
                  loteColor = Colors.blue;
                  if (processo == 'Passadoria') {
                    pedido.passadoriaStatus = 2;
                  } else if (processo == 'Finalização') {
                    pedido.finalizacaoStatus = 2;
                  } else if (processo == 'Retorno') {
                    pedido.retornoStatus = 2;
                  }
                  buttonText = 'Concluído';
                });
              });
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Atenção'),
                    content: const Text(
                        'O processo precisa ser iniciado antes de ser finalizado.'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'))
                    ],
                  );
                },
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: loteColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
                child: Text(buttonText,
                    style: const TextStyle(color: Colors.black))),
          ),
        );
      },
    );
  }

  void showConfirmationDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content:
              const Text('Tem certeza que deseja finalizar este processo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm(); // Executa a função de confirmação
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenção'),
          content: Text(message),
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

  void showProcessoNaoIniciado(BuildContext context, String processoAnterior) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenção'),
          content: Text(
              'O processo anterior ($processoAnterior) ainda não foi iniciado.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
