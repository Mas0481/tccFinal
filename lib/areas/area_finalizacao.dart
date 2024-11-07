import 'package:flutter/material.dart';
import 'package:tcc/forms/form_finalizacao.dart';
import 'package:tcc/forms/form_passadoria.dart';
import 'package:tcc/forms/form_retorno.dart'; // Novo import
import 'dart:async';
import 'package:tcc/util/custom_appbar.dart';

class AreaFinalizacao extends StatelessWidget {
  // final PageController _pageController =
  //   PageController(initialPage: 0, viewportFraction: 0.1);

  @override
  Widget build(BuildContext context) {
    List<Pedido> pedidos = [
      Pedido(
        cliente: 'Cliente A',
        pedido: 'Pedido 001',
        dataEntrega: '10/10/2024',
        pesoTotal: 150.0,
        passadoria: 0,
        finalizacao: 0,
        retorno: 0,
        lotes: [
          Lote(nome: 'Lote 1', status: 1), // concluido
          Lote(nome: 'Lote 2', status: 1), // concluido
          Lote(nome: 'Lote 3', status: 0), // não iniciado
        ],
      ),
      Pedido(
        cliente: 'Cliente A',
        pedido: 'Pedido 001',
        dataEntrega: '10/10/2024',
        pesoTotal: 150.0,
        passadoria: 0,
        finalizacao: 0,
        retorno: 0,
        lotes: [
          Lote(nome: 'Lote 1', status: 0), // 100%
          Lote(nome: 'Lote 2', status: 0), // 100%
          Lote(nome: 'Lote 3', status: 00), // 66%
        ],
      ),

      Pedido(
        cliente: 'Cliente A',
        pedido: 'Pedido 001',
        dataEntrega: '10/10/2024',
        pesoTotal: 150.0,
        passadoria: 0,
        finalizacao: 0,
        retorno: 0,
        lotes: [
          Lote(nome: 'Lote 1', status: 0), // 100%
          Lote(nome: 'Lote 2', status: 0), // 100%
          Lote(nome: 'Lote 3', status: 1), // 66%
        ],
      ),

      // Adicione mais pedidos conforme necessário
    ];

    return MaterialApp(
      home: AreaFinalizacaoPage(pedidos: pedidos),
    );
  }
}

class Pedido {
  final String cliente;
  final String pedido;
  final String dataEntrega;
  final double pesoTotal;

  // 0 representa não iniciado, 1 representa iniciado, 2 representa concluído
  int passadoria;
  int finalizacao;
  int retorno;

  final List<Lote> lotes;

  Pedido({
    required this.cliente,
    required this.pedido,
    required this.dataEntrega,
    required this.pesoTotal,
    required this.passadoria,
    required this.finalizacao,
    required this.retorno,
    required this.lotes,
  });
}

class Lote {
  final String nome;
  int status; // 0 representa iniciado, 1 representa concluído

  Lote({required this.nome, required this.status});
}

class AreaFinalizacaoPage extends StatefulWidget {
  final List<Pedido> pedidos;

  AreaFinalizacaoPage({required this.pedidos});

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
    timer = Timer.periodic(Duration(seconds: 01), (timer) {
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
      width: MediaQuery.of(context).size.width * 0.25,
      margin: EdgeInsets.all(10),
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
              Text('Cliente: ${pedido.cliente}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('Pedido: ${pedido.pedido}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 5),
              Text('Data Entrega: ${pedido.dataEntrega}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('Peso Total: ${pedido.pesoTotal}kg',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 6),
              buildProgressBar('Passadoria', pedido.passadoria.toDouble()),
              SizedBox(height: 10),
              buildLoteRow(pedido, 'Passadoria'),
              SizedBox(height: 10),
              buildProgressBar('Finalização', pedido.finalizacao.toDouble()),
              SizedBox(height: 10),
              buildLoteRow(pedido, 'Finalização'),
              SizedBox(height: 10),
              buildProgressBar('Retorno', pedido.retorno.toDouble()),
              SizedBox(height: 10),
              buildLoteRow(pedido, 'Retorno'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProgressBar(String label, double progress) {
    return InkWell(
      onTap: () {
        print('Barra de progresso $label pressionada');
      },
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        children: [
          LinearProgressIndicator(
            value: progress / 2, // Para uma visualização adequada
            backgroundColor: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 67,
          ),
          Positioned.fill(
            child: Center(
              child: Text(
                label,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoteRow(Pedido pedido, String processo) {
    return Container(
      height: 67,
      child: Row(
        children: [
          Expanded(child: buildLoteButtonIniciar(pedido, processo)),
          SizedBox(width: 10),
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
        if ((processo == 'Passadoria' && pedido.passadoria == 1) ||
            (processo == 'Finalização' && pedido.finalizacao == 1) ||
            (processo == 'Retorno' && pedido.retorno == 1)) {
          loteColor = Colors.red;
          buttonText = 'Processando';
        } else if ((processo == 'Passadoria' && pedido.passadoria == 2) ||
            (processo == 'Finalização' && pedido.finalizacao == 2) ||
            (processo == 'Retorno' && pedido.retorno == 2)) {
          loteColor = Colors.blue;
          buttonText = 'Processado';
        }

        return GestureDetector(
          onTap: () {
            if (processo == 'Passadoria' && pedido.passadoria == 0) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => Passadoria(
                        onSave: () {
                          setState(() {
                            loteColor = Colors.red;
                            pedido.passadoria = 1;
                            buttonText = 'Processando';
                          });
                        },
                      ));
            } else if (processo == 'Finalização' && pedido.finalizacao == 0) {
              // Verifica se a Passadoria foi iniciada
              if (pedido.passadoria == 0) {
                showProcessoNaoIniciado(context, 'Passadoria');
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => Finalizacao(
                          onSave: () {
                            setState(() {
                              loteColor = Colors.red;
                              pedido.finalizacao = 1;
                              buttonText = 'Processando';
                            });
                          },
                        ));
              }
            } else if (processo == 'Retorno' && pedido.retorno == 0) {
              // Verifica se a Finalização foi iniciada
              if (pedido.finalizacao == 0) {
                showProcessoNaoIniciado(context, 'Finalização');
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => Retorno(
                          onSave: () {
                            setState(() {
                              loteColor = Colors.red;
                              pedido.retorno = 1;
                              buttonText = 'Processando';
                            });
                          },
                        ));
              }
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Atenção'),
                    content:
                        Text('Para concluir o processo use o botão Finalizar.'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'))
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
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
                child: Text(buttonText, style: TextStyle(color: Colors.black))),
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
        if ((processo == 'Passadoria' && pedido.passadoria == 2) ||
            (processo == 'Finalização' && pedido.finalizacao == 2) ||
            (processo == 'Retorno' && pedido.retorno == 2)) {
          loteColor = Colors.blue;
          buttonText = 'Concluído';
        }

        return GestureDetector(
          onTap: () {
            // Verificação de processos anteriores para finalização
            if (processo == 'Finalização' && pedido.passadoria == 0) {
              showAlertDialog(context, 'Passadoria ainda não foi iniciado.');
              return;
            } else if (processo == 'Retorno' && pedido.finalizacao == 0) {
              showAlertDialog(context, 'Finalização ainda não foi iniciado.');
              return;
            }

            if ((processo == 'Passadoria' && pedido.passadoria == 1) ||
                (processo == 'Finalização' && pedido.finalizacao == 1) ||
                (processo == 'Retorno' && pedido.retorno == 1)) {
              // Exibir popup de confirmação
              showConfirmationDialog(context, () {
                setState(() {
                  loteColor = Colors.blue;
                  if (processo == 'Passadoria') {
                    pedido.passadoria = 2;
                  } else if (processo == 'Finalização') {
                    pedido.finalizacao = 2;
                  } else if (processo == 'Retorno') {
                    pedido.retorno = 2;
                  }
                  buttonText = 'Concluído';
                });
              });
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Atenção'),
                    content: Text(
                        'O processo precisa ser iniciado antes de ser finalizado.'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'))
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
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
                child: Text(buttonText, style: TextStyle(color: Colors.black))),
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
          title: Text('Confirmação'),
          content: Text('Tem certeza que deseja finalizar este processo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm(); // Executa a função de confirmação
              },
              child: Text('Confirmar'),
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
          title: Text('Atenção'),
          content: Text(message),
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

  void showProcessoNaoIniciado(BuildContext context, String processoAnterior) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Atenção'),
          content: Text(
              'O processo anterior ($processoAnterior) ainda não foi iniciado.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
