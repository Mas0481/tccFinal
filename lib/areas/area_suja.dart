import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc/DAO/pedidoDAO.dart';
import 'package:tcc/forms/form_classificacao.dart';
import 'package:tcc/forms/form_lavagem.dart';
import 'package:tcc/forms/form_recebimento.dart';
import 'package:tcc/models/lote.dart';
import 'package:tcc/models/pedido.dart';
import 'package:tcc/providers/pedido_provider.dart';
import 'package:tcc/util/custom_appbar.dart';
import 'dart:async';

class AreaSuja extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PedidoDAO pedidoDAO = PedidoDAO();

    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<List<Pedido>>(
          future:
              pedidoDAO.getAll(), // Chamada assíncrona para buscar os pedidos
          builder: (context, snapshot) {
            // Verifica o estado do Future
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator()); // Exibe carregamento
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Erro ao carregar pedidos: ${snapshot.error}"),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("Nenhum pedido aguardando."));
            } else {
              // Dados carregados com sucesso
              List<Pedido> pedidos = snapshot.data!;
              return AreaSujaPage(
                  pedidos: pedidos); // Passa os pedidos para o widget
            }
          },
        ),
      ),
    );
  }
}

class AreaSujaPage extends StatefulWidget {
  final List<Pedido> pedidos;

  AreaSujaPage({required this.pedidos});

  @override
  _AreaSujaPageState createState() => _AreaSujaPageState();
}

class _AreaSujaPageState extends State<AreaSujaPage> {
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
      setState(() {
        // Atualizações periódicas
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
        titulo: 'WindCare - Área Suja',
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
    double progressoLavagem = calcularProgressoLavagem(pedido.lotes);
    print(pedido);
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
              // Dados do pedido
              Text('Cliente: ${pedido.nomCliente}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('Pedido: ${pedido.numPedido}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 5),
              Text('Data Entrega: ${pedido.dataEntrega}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text('Peso Total: ${pedido.pesoTotal}kg',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 6),

              // Barras de progresso
              Column(
                children: [
                  buildProgressBar('Recebimento', pedido),
                  SizedBox(height: 10),
                  buildProgressBar('Classificação', pedido),
                  SizedBox(height: 10),
                  buildProgressBar1('Lavagem', progressoLavagem, pedido),
                  SizedBox(height: 10),
                ],
              ),
              // Lotes
              SizedBox(
                height: 320,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  shrinkWrap: true,
                  itemCount: pedido.lotes.length,
                  itemBuilder: (context, index) {
                    return buildLoteButton(pedido.lotes[index], pedido);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProgressBar(String label, Pedido pedido) {
    PedidoDAO pedidoDAO = PedidoDAO();
    double progress = 0.0;
    Color barColor = Colors.red[300]!;
    String buttonText = label;

    if (label == 'Recebimento') {
      progress = pedido.recebimentoStatus as double;
      barColor = (progress == 1.0) ? Colors.blue : Colors.grey[300]!;
      buttonText = (progress == 1.0) ? "$label Concluído" : label;
    } else if (label == 'Classificação') {
      progress = pedido.classificacaoStatus as double;
      barColor =
          (pedido.classificacaoStatus == 1.0) ? Colors.blue : Colors.grey[300]!;
      buttonText =
          (pedido.classificacaoStatus == 1.0) ? "$label Concluído" : label;
    } else if (label == 'Lavagem') {
      progress = pedido.lavagemStatus as double;
      //barColor = (progress == 1.0) ? Colors.blue : Colors.red[300]!;
      buttonText = (progress == 1.0) ? "$label Concluído" : label;
    }

    return GestureDetector(
      onTap: () {
        if (pedido.recebimentoStatus == 1.0 && label == 'Recebimento') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Atenção'),
                content: Text('O processo de $label já foi concluído.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (progress == 1.0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Atenção'),
                content: Text('O processo de $label já foi concluído.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (label == 'Recebimento' && pedido.recebimentoStatus == 0.0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Recebimento(onSave: () async {
                setState(() {
                  pedido.recebimentoStatus = 1;
                });

                // Verifique se o pedidoDAO está acessível aqui

                int retorno = await pedidoDAO.update(pedido);
                print("Atualizado com sucesso! Retorno: $retorno");
              });
            },
          );
        } else if (label == 'Classificação' &&
            pedido.recebimentoStatus == 1.0 &&
            pedido.classificacaoStatus == 0.0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Classificacao(onSave: () async {
                setState(() {
                  pedido.classificacaoStatus = 1;
                });
                int retorno = await pedidoDAO.update(pedido);
                print("Atualizado com sucesso! Retorno: $retorno");
              });
            },
          );
        } else if (label == 'Lavagem' &&
            pedido.recebimentoStatus == 1.0 &&
            pedido.classificacaoStatus == 1.0) {
          if (todosLotesConcluidos(pedido)) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Sucesso'),
                  content: Text('Todos os lotes de lavagem foram concluídos!'),
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
                      'Para dar início nos processos de lavagem, utilize os botões de lote.'),
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
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Atenção'),
                content: Text(
                    'O processo de $label não pode ser iniciado. Verifique os status dos processos anteriores.'),
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
      child: Container(
        decoration: BoxDecoration(
          color: barColor,
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

  // Método atualizado para a barra de lavagem
  Widget buildProgressBar1(String label, double progress, Pedido pedido) {
    // Verifica se todos os lotes estão concluídos e ajusta o label
    String displayLabel =
        todosLotesConcluidos(pedido) ? "$label Concluído" : label;

    return InkWell(
      onTap: () {
        if (pedido.recebimentoStatus != 1.0 ||
            pedido.classificacaoStatus != 1.0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Atenção'),
                content: Text(
                    'Para iniciar o processo de lavagem, verifique se o recebimento e a classificação estão completos.'),
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
                content: Text('Todos os lotes de lavagem foram concluídos!'),
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
                    'Para iniciar o processo de lavagem, use o botão do Lote desejado.'),
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

  Widget buildLoteButton(Lote lote, Pedido pedido) {
    PedidoDAO pedidoDAO = PedidoDAO();
    Color loteColor = lote.loteStatus == 1.0 ? Colors.blue : Colors.grey[300]!;
    String buttonText =
        lote.loteStatus == 1.0 ? "Lote Concluído" : "Iniciar Lavagem";

    return GestureDetector(
      onTap: () {
        if (lote.loteStatus == 1.0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Atenção'),
                content:
                    Text('O processo de Lavagem do lote já foi concluído.'),
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
          if (pedido.recebimentoStatus == 1.0 &&
              pedido.classificacaoStatus == 1.0) {
            // Aqui, você pode adicionar a lógica de iniciar a lavagem do lote
            // Para fins de exemplo, estamos apenas exibindo um AlertDialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Lavagem(onSave: () async {
                  setState(() {
                    lote.loteStatus = 1; // Atualiza o status do lote
                  });
                  int retorno = await pedidoDAO.update(pedido);
                  print("Atualizado com sucesso! Retorno: $retorno");
                });
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Atenção'),
                  content: Text(
                      'Para iniciar o processo de lavagem, verifique os status dos Processos anteriores, é necessário que Recebimento e Classificação estejam Concluídos.'),
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
          color: loteColor,
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

  double calcularProgressoLavagem(List<Lote> lotes) {
    int totalLotes = lotes.length;
    int lotesConcluidos = lotes.where((lote) => lote.loteStatus == 1).length;

    return totalLotes == 0 ? 0.0 : lotesConcluidos / totalLotes;
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
    pedido.lavagemStatus = 1.0;
    return true;
  }
}
