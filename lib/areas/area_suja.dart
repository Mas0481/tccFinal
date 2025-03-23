import 'package:flutter/material.dart';
import 'package:tcc/DAO/pedidoDAO.dart';
import 'package:tcc/forms/form_classificacao.dart';
import 'package:tcc/forms/form_lavagem.dart';
import 'package:tcc/forms/form_recebimento.dart';
import 'package:tcc/models/lote.dart';
import 'package:tcc/models/pedido.dart';
import 'package:tcc/util/custom_appbar.dart';
import 'dart:async';

class AreaSuja extends StatelessWidget {
  const AreaSuja({super.key});

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
              return const Center(
                  child: CircularProgressIndicator()); // Exibe carregamento
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Erro ao carregar pedidos: ${snapshot.error}"),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("Nenhum pedido aguardando."));
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

  const AreaSujaPage({super.key, required this.pedidos});

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
    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
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
    double progressoLavagem = calcularProgressoLavagem(pedido.lotes);
    //print(pedido);
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
              // Dados do pedido
              Text('Cliente: ${pedido.nomCliente}',
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
              const SizedBox(height: 6),

              // Barras de progresso
              Column(
                children: [
                  buildProgressBar('Recebimento', pedido),
                  const SizedBox(height: 10),
                  buildProgressBar('Classificação', pedido),
                  const SizedBox(height: 10),
                  buildProgressBar1('Lavagem', progressoLavagem, pedido),
                  const SizedBox(height: 10),
                ],
              ),
              // Lotes
              SizedBox(
                height: 320,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  shrinkWrap: true,
                  itemCount: pedido.lotes.length,
                  itemBuilder: (context, index) {
                    print(pedido.lotes[index]);
                    print('enviou o lote para o botão');
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
      progress = pedido.recebimentoStatus.toDouble();
      barColor = (progress == 2.0) ? Colors.blue : Colors.grey[300]!;
      buttonText = (progress == 2.0) ? "$label Concluído" : label;
    } else if (label == 'Classificação') {
      double pesoTotalLotes =
          pedido.lotes.fold<double>(0, (sum, lote) => sum + lote.peso);
      double pesoTotalPedido = pedido.pesoTotal.toDouble();
      progress = pesoTotalLotes / pesoTotalPedido;
      barColor =
          (pedido.classificacaoStatus == 2.0) ? Colors.blue : Colors.grey[300]!;
      buttonText =
          (pedido.classificacaoStatus == 2.0) ? "$label Concluído" : label;
    } else if (label == 'Lavagem') {
      progress = pedido.lavagemStatus.toDouble();
      buttonText = (progress == 2.0) ? "$label Concluído" : label;
    }

    return GestureDetector(
      onTap: () {
        if (pedido.recebimentoStatus == 2.0 && label == 'Recebimento' ||
            pedido.classificacaoStatus == 2.0 && label == 'Classificação') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Atenção'),
                content: Text('O processo de $label já foi concluído.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (progress == 2.0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Atenção'),
                content: Text('O processo de $label já foi concluído.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else if (label == 'Recebimento' && pedido.recebimentoStatus != 2.0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Recebimento(
                  pedido: pedido,
                  onSave: () async {
                    setState(() {
                      pedido.recebimentoStatus = 2;
                    });

                    // Verifique se o pedidoDAO está acessível aqui

                    int retorno = await pedidoDAO.update(pedido);
                    print("Atualizado com sucesso! Retorno: $retorno");
                  });
            },
          );
        } else if (label == 'Classificação' &&
            pedido.recebimentoStatus == 2.0 &&
            pedido.classificacaoStatus != 2.0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Classificacao(
                pedido: pedido, // Passa o pedido
                onSave: () async {
                  //PedidoDAO pedidoDAO = PedidoDAO();
                  //int retorno = await pedidoDAO.update(pedido);
                  // print("Atualizado com sucesso! Retorno: $retorno");
                  // setState(() {
                  //pedido.classificacaoStatus = 2;
                  //});
                  Navigator.pop(context, pedido);
                },
              );
            },
          ).then((updatedPedido) async {
            print("entrou no then");
            if (updatedPedido != null) {
              double pesoTotalLotes = updatedPedido.lotes
                  .fold<double>(0, (sum, lote) => sum + lote.peso);
              double pesoTotalPedido = updatedPedido.pesoTotal;

              if (pesoTotalLotes == pesoTotalPedido) {
                updatedPedido.classificacaoStatus = 2;
              } else {
                updatedPedido.classificacaoStatus = 1;
              }

              //PedidoDAO pedidoDAO = PedidoDAO();
              //int retorno = await pedidoDAO.update(pedido);
              // print("Atualizado com sucesso! Retorno: $retorno");

              setState(() {
                pedidos[pedidos.indexWhere(
                        (p) => p.numPedido == updatedPedido.numPedido)] =
                    updatedPedido;
              });
            }
          });
        } else if (label == 'Lavagem' &&
            pedido.recebimentoStatus == 2.0 &&
            pedido.classificacaoStatus == 2.0) {
          if (todosLotesConcluidos(pedido)) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Sucesso'),
                  content:
                      const Text('Todos os lotes de lavagem foram concluídos!'),
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
                  content: const Text(
                      'Para dar início nos processos de lavagem, utilize os botões de lote.'),
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
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Atenção'),
                content: Text(
                    'O processo de $label não pode ser iniciado. Verifique os status dos processos anteriores.'),
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
          color: barColor,
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

  // Método atualizado para a barra de lavagem
  Widget buildProgressBar1(String label, double progress, Pedido pedido) {
    // Verifica se todos os lotes estão concluídos e ajusta o label
    String displayLabel =
        todosLotesConcluidos(pedido) ? "$label Concluído" : label;

    return InkWell(
      onTap: () {
        if (pedido.recebimentoStatus != 2.0 ||
            pedido.classificacaoStatus != 2.0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Atenção'),
                content: const Text(
                    'Para iniciar o processo de lavagem, verifique se o recebimento esta completo e a classificação com no mínimo 1 lote concluido.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
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
                title: const Text('Atenção'),
                content:
                    const Text('Todos os lotes de lavagem foram concluídos!'),
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
                content: const Text(
                    'Para iniciar o processo de lavagem, use o botão do Lote desejado.'),
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

  Widget buildLoteButton(Lote lote, Pedido pedido) {
    PedidoDAO pedidoDAO = PedidoDAO();
    Color loteColor = lote.loteStatus == 2.0 ? Colors.blue : Colors.grey[300]!;
    String buttonText =
        lote.loteStatus == 2.0 ? "Lote Concluído" : "Iniciar Lavagem";

    return GestureDetector(
      onTap: () {
        if (lote.loteStatus == 2.0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Atenção'),
                content: const Text(
                    'O processo de Lavagem do lote já foi concluído.'),
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
          if (pedido.recebimentoStatus == 2.0 &&
              pedido.classificacaoStatus != 0.0) {
            // Aqui, você pode adicionar a lógica de iniciar a lavagem do lote
            // Para fins de exemplo, estamos apenas exibindo um AlertDialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Lavagem(
                    pedido: pedido,
                    lote: lote, // Passa o lote específico
                    onSave: () async {
                      setState(() {
                        lote.loteStatus = 2; // Atualiza o status do lote
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
                  title: const Text('Atenção'),
                  content: const Text(
                      'Para iniciar o processo de lavagem, verifique os status dos Processos anteriores, é necessário que Recebimento e Classificação estejam Concluídos.'),
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
          child: Text(buttonText, style: const TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  double calcularProgressoLavagem(List<Lote> lotes) {
    int totalLotes = lotes.length;
    int lotesConcluidos = lotes.where((lote) => lote.loteStatus == 2).length;

    return totalLotes == 0 ? 0.0 : lotesConcluidos / totalLotes;
  }

  // Verifica se todos os lotes estão concluídos
  bool todosLotesConcluidos(Pedido pedido) {
    for (var lote in pedido.lotes) {
      if (lote.loteStatus != 2) {
        // 1.0 indica que o lote ainda não está concluído
        return false;
      }
    }

    // Se todos os lotes estão concluídos, atualize pedido.lavagem
    pedido.lavagemStatus = 2.0;
    return true;
  }
}
