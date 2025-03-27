import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc/models/pedido.dart';
import 'package:tcc/models/lote.dart';
import 'package:tcc/DAO/pedidoDAO.dart';
import 'package:tcc/repository/clientes_repository.dart';
import 'package:tcc/servicos/connection.dart';
import 'package:tcc/repository/processos_repository.dart';

class Classificacao extends StatefulWidget {
  final Pedido pedido; // Adiciona o pedido como parâmetro
  final VoidCallback onSave; // Adiciona um callback

  const Classificacao({super.key, required this.pedido, required this.onSave});

  Pedido? get processos => null; // Construtor

  @override
  _ClassificacaoState createState() => _ClassificacaoState();
}

class _ClassificacaoState extends State<Classificacao> {
  late TextEditingController clienteController;
  late TextEditingController pedidoController;
  late TextEditingController pesoTotalController;
  late TextEditingController dataLimiteController;
  late TextEditingController dataColetaController;
  final List<Processo> processos = [];
  ClienteRepository clienteRepository =
      ClienteRepository(MySqlConnectionService());
  List<String> processosDisponiveis = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadClienteName();
    _loadProcessosDisponiveis();
    _initializeProcessos();
  }

  void _initializeControllers() {
    clienteController =
        TextEditingController(text: widget.pedido.codCliente.toString());
    pedidoController =
        TextEditingController(text: widget.pedido.numPedido.toString());
    pesoTotalController =
        TextEditingController(text: widget.pedido.pesoTotal.toString());
    dataLimiteController =
        TextEditingController(text: widget.pedido.dataLimite.toString());
    dataColetaController =
        TextEditingController(text: widget.pedido.dataColeta.toString());
  }

  void _initializeProcessos() {
    if (widget.pedido.lotes.isNotEmpty) {
      for (var lote in widget.pedido.lotes) {
        processos.add(Processo(
          selectedProcesso: lote.processo,
          pesoController: TextEditingController(text: lote.peso.toString()),
        ));
      }
    }
  }

  Future<void> _loadClienteName() async {
    final cliente = await clienteRepository.findById(widget.pedido.codCliente);
    if (cliente != null) {
      setState(() {
        clienteController.text = cliente['nome']!;
      });
    }
  }

  Future<void> _loadProcessosDisponiveis() async {
    ProcessosRepository processosRepository =
        ProcessosRepository(MySqlConnectionService());
    try {
      processosDisponiveis = ['Selecione Processo'] +
          (await processosRepository.getProcessos())
              .map((processo) => processo['nomeProcesso'] ?? 'Desconhecido')
              .toList();
      setState(() {
        for (var processo in processos) {
          if (!processosDisponiveis.contains(processo.selectedProcesso)) {
            processo.selectedProcesso = processosDisponiveis.isNotEmpty
                ? processosDisponiveis.first
                : 'Desconhecido';
          }
        }
      });
    } catch (e) {
      print('Erro ao buscar os processos: $e');
      processosDisponiveis = ['Erro ao carregar processos'];
      setState(() {});
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _addProcesso() {
    double pesoTotalLotes = processos.fold<double>(
        0, (sum, p) => sum + (double.tryParse(p.pesoController.text) ?? 0));
    double pesoTotalPedido = double.tryParse(pesoTotalController.text) ?? 0;

    if (pesoTotalLotes < pesoTotalPedido) {
      setState(() {
        processos.add(Processo(
          selectedProcesso: 'Selecione Processo',
        ));
      });
    } else {
      _showMessage(
          'O peso total dos lotes não pode ultrapassar o peso total do pedido.');
    }
  }

  void _removeProcesso(int index) {
    setState(() {
      if (processos.length > 1) {
        processos.removeAt(index);
      }
    });
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aviso'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onSave() async {
    double pesoTotalLotes = processos.fold<double>(
        0, (sum, p) => sum + (double.tryParse(p.pesoController.text) ?? 0));
    double pesoTotalPedido = double.tryParse(pesoTotalController.text) ?? 0;

    if (processos.isEmpty) {
      widget.pedido.classificacaoStatus = 0;
    } else if (pesoTotalLotes == pesoTotalPedido) {
      widget.pedido.classificacaoStatus = 2;
    } else {
      widget.pedido.classificacaoStatus = 1;
    }

    // Atualizar os lotes no pedido
    widget.pedido.lotes = processos
        .map((p) => Lote(
              processo: p.selectedProcesso!,
              peso: double.tryParse(p.pesoController.text) ?? 0,
              pedidoNum: widget.pedido.numPedido ?? 0,
              loteNum: widget.pedido.lotes.length + 1,
            ))
        .toList();

    // Persistir o pedido atualizado no banco de dados
    PedidoDAO pedidoDAO = PedidoDAO();
    await pedidoDAO.update(widget.pedido);

    widget.onSave();
    setState(() {});

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white.withOpacity(0.95),
      shadowColor: const Color.fromARGB(70, 10, 10, 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            border: Border.all(color: Colors.grey[300]!, width: 1),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Linha com a logo à esquerda e o título centralizado
              Row(
                children: [
                  Image.asset(
                    'lib/images/logo.png',
                    width: 200,
                    height: 130,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, size: 150);
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Classificação',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    child: GestureDetector(
                      onTap: () {
                        _selectDate(context, dataLimiteController);
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: dataLimiteController,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Data Limite',
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.withAlpha(80)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              // Linha com Cliente
              TextField(
                controller: clienteController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Cliente',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withAlpha(80)),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Linha com Pedido e Peso Total
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: pedidoController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Pedido',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withAlpha(80)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: dataColetaController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Data da Coleta',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withAlpha(80)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: pesoTotalController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Peso Total',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withAlpha(80)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 10),

              // Container com os processos
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withAlpha(100)),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    ...processos.asMap().entries.map((entry) {
                      int index = entry.key;
                      Processo processo = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom:
                                10.0), // Espaçamento entre linhas de processo
                        child: Row(
                          children: [
                            // Largura do lote ajustada
                            SizedBox(
                              width: 30, // Largura fixa para o número do lote
                              child: Center(
                                child: Text(
                                  '${index + 1}', // Identificação do lote
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Largura do dropdown processo
                            SizedBox(
                              width: MediaQuery.of(context).size.width *
                                  0.5 *
                                  0.55, // 55% da largura do container
                              child: DropdownButtonFormField<String>(
                                value: processo.selectedProcesso,
                                items: processosDisponiveis
                                    .map((processo) => DropdownMenuItem(
                                          value: processo,
                                          child: Text(processo),
                                        ))
                                    .toList(),
                                decoration: InputDecoration(
                                  labelText: 'Processo',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.withAlpha(80)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    processo.selectedProcesso = value;
                                    processo.lote = '${index + 1} - $value';
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Largura do peso
                            SizedBox(
                              width: MediaQuery.of(context).size.width *
                                  0.5 *
                                  0.2, // 20% da largura do container
                              child: TextField(
                                controller: processo.pesoController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Peso',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey.withAlpha(80)),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    double pesoTotalLotes =
                                        processos.fold<double>(
                                            0,
                                            (sum, p) =>
                                                sum +
                                                (double.tryParse(p
                                                        .pesoController.text) ??
                                                    0));
                                    double pesoTotalPedido = double.tryParse(
                                            pesoTotalController.text) ??
                                        0;
                                    if (pesoTotalLotes > pesoTotalPedido) {
                                      _showMessage(
                                          'O peso total dos lotes não pode ultrapassar o peso total do pedido.');
                                      processo.pesoController.text = '';
                                    }
                                  });
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.blueAccent),
                              onPressed: () => _removeProcesso(index),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addProcesso, // Cor da fonte alterada
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blueAccent, // Cor azul para o botão
                      ),
                      child: Text('+ Adicionar Lote',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 10),
                    // Linha com quantidade de lotes e peso total
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total de Lotes: ${processos.length}'),
                        Text(
                          'Peso Total: ${processos.fold<double>(0, (sum, p) => sum + (double.tryParse(p.pesoController.text) ?? 0))} kg',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Observações e Botão OK
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      maxLines: 3,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Observações',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withAlpha(80)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 90,
                    child: ElevatedButton(
                      onPressed: _onSave,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'OK',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 90,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        backgroundColor: Colors.red, // Cor vermelha
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Processo {
  String? selectedProcesso;
  final TextEditingController pesoController;
  String lote = '';

  Processo({String? selectedProcesso, TextEditingController? pesoController})
      : selectedProcesso = selectedProcesso ?? 'Processo 1', // Valor padrão
        pesoController = pesoController ?? TextEditingController();
}
