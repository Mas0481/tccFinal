import 'package:flutter/material.dart';
import 'package:tcc/forms/form_centrifugacao';
import 'package:tcc/forms/form_lavagem.dart';
import 'package:tcc/forms/form_secagem.dart';
import 'dart:async';
import 'package:tcc/util/custom_appbar.dart';

class AreaPreparacao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Pedido> pedidos = [
      Pedido(
        cliente: 'Cliente A',
        pedido: 'Pedido 001',
        dataEntrega: '10/10/2024',
        pesoTotal: 150.0,
        recebimento: 0,
        classificacao: 0,
        lavagem: 0,
        lotes: [
          Lote(nome: 'Lote 1', status: 1.0),
          Lote(nome: 'Lote 2', status: 1.0),
          Lote(nome: 'Lote 3', status: 0.0),
          Lote(nome: 'Lote 4', status: 1.0),
          Lote(nome: 'Lote 5', status: 1.0),
          Lote(nome: 'Lote 6', status: 0.0),
        ],
      ),
      // Outros pedidos...
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
  double recebimento;
  double classificacao;
  double lavagem;

  Pedido({
    required this.cliente,
    required this.pedido,
    required this.dataEntrega,
    required this.pesoTotal,
    required this.lotes,
    this.recebimento = 0,
    this.classificacao = 0,
    this.lavagem = 0,
  });
}

class Lote {
  final String nome;
  double status;

  Lote({
    required this.nome,
    required this.status,
  });
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
    double progressoLavagem = calcularProgressoLavagem(pedido.lotes);
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
                  buildProgressBar1('Centrifugação', progressoLavagem, pedido),
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
              buildProgressBar1('Secagem', progressoLavagem, pedido),
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

  Widget buildProgressBar1(String label, double progress, Pedido pedido) {
    // Verifica se todos os lotes estão concluídos e ajusta o label
    String displayLabel =
        todosLotesConcluidos(pedido) ? "$label Concluído" : label;

    return InkWell(
      onTap: () {
        if (pedido.recebimento != 1.0 || pedido.classificacao != 1.0) {
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

  Widget buildLoteButton(Lote lote, Pedido pedido, String processo) {
    // Define o status necessário e o texto padrão com base no processo
    double statusNecessario;
    String textoProcessoConcluido;
    String textoIniciarProcesso;

    if (processo == "Lavagem") {
      statusNecessario = 1.0;
      textoProcessoConcluido = "Lavagem Concluída";
      textoIniciarProcesso = "Iniciar Lavagem";
    } else if (processo == "Centrifugação") {
      statusNecessario = 2.0;
      textoProcessoConcluido = "Centrifugação Concluída";
      textoIniciarProcesso = "Iniciar Centr";
    } else if (processo == "Secagem") {
      statusNecessario = 3.0;
      textoProcessoConcluido = "Secagem Concluída";
      textoIniciarProcesso = "Iniciar Secagem";
    } else {
      return Container(); // Retorna um widget vazio se o processo não for reconhecido
    }

    Color buttonColor =
        lote.status == statusNecessario ? Colors.blue : Colors.grey[300]!;
    String buttonText = lote.status == statusNecessario
        ? textoProcessoConcluido
        : textoIniciarProcesso;

    return GestureDetector(
      onTap: () {
        if (lote.status == statusNecessario) {
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
          if (pedido.recebimento == 1.0 && pedido.classificacao == 1.0) {
            // Define o que ocorre ao iniciar cada processo específico
            if (processo == "Lavagem") {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Lavagem(onSave: () {
                    setState(() {
                      lote.status =
                          1.0; // Atualiza o status para indicar conclusão de Lavagem
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
                      lote.status =
                          2.0; // Atualiza o status para indicar conclusão de Centrifugação
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
                      lote.status =
                          3.0; // Atualiza o status para indicar conclusão de Secagem
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
                      'Para iniciar o processo de $processo, verifique os status dos processos anteriores. É necessário que Recebimento e Classificação estejam concluídos.'),
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

  double calcularProgressoLavagem(List<Lote> lotes) {
    int totalLotes = lotes.length;
    int lotesConcluidos = lotes.where((lote) => lote.status == 1.0).length;

    return totalLotes == 0 ? 0.0 : lotesConcluidos / totalLotes;
  }

  // Verifica se todos os lotes estão concluídos
  bool todosLotesConcluidos(Pedido pedido) {
    for (var lote in pedido.lotes) {
      if (lote.status != 1.0) {
        // 1.0 indica que o lote ainda não está concluído
        return false;
      }
    }

    // Se todos os lotes estão concluídos, atualize pedido.lavagem
    pedido.lavagem = 1.0;
    return true;
  }
}
