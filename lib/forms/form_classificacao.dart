import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc/models/pedido.dart';
import 'package:tcc/models/lote.dart';
import 'package:tcc/DAO/pedidoDAO.dart';
import 'package:tcc/providers/user_provider.dart';
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
  late TextEditingController pesoController;
  late TextEditingController pedidoController;
  late TextEditingController pesoTotalController;
  late TextEditingController dataLimiteController;
  late TextEditingController dataColetaController;
  late List<TextEditingController> pesoControllers;
  late TextEditingController observacoesController;
  ClienteRepository clienteRepository =
      ClienteRepository(MySqlConnectionService());
  List<String> processosDisponiveis = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializePesoControllers();
    _loadClienteName();
    _loadProcessosDisponiveis();
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
    pesoController =
        TextEditingController(text: widget.pedido.pesoTotal.toString());
    observacoesController = TextEditingController(
      text: widget.pedido.classificacaoObs ?? '', // Default to existing value
    );
  }

  void _initializePesoControllers() {
    pesoControllers = widget.pedido.lotes
        .map((lote) => TextEditingController(text: lote.peso.toString()))
        .toList();
  }

  @override
  void dispose() {
    for (var controller in pesoControllers) {
      controller.dispose();
    }
    observacoesController.dispose();
    super.dispose();
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
              .map((lavagemProcesso) =>
                  lavagemProcesso['nomeProcesso'] ?? 'Desconhecido')
              .toList();
      setState(() {
        for (var lote in widget.pedido.lotes) {
          if (!processosDisponiveis.contains(lote.lavagemProcesso)) {
            lote.lavagemProcesso = processosDisponiveis.isNotEmpty
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
    double pesoTotalLotes =
        widget.pedido.lotes.fold<double>(0, (sum, lote) => sum + lote.peso);
    double pesoTotalPedido = double.tryParse(pesoTotalController.text) ?? 0;

    if (pesoTotalLotes < pesoTotalPedido) {
      setState(() {
        int nextLoteNum = widget.pedido.lotes.isNotEmpty
            ? widget.pedido.lotes
                    .map((lote) => lote.loteNum)
                    .reduce((a, b) => a > b ? a : b) +
                1
            : 1;

        widget.pedido.lotes.add(Lote(
          processo: 'Selecione Processo',
          loteResponsavel:
              Provider.of<UserProvider>(context, listen: false).loggedInUser,
          peso: 0, // No default value
          pedidoNum: widget.pedido.numPedido ?? 0, // Provide a default value
          loteNum: nextLoteNum,
        ));
        pesoControllers.add(TextEditingController()); // No default value

        // Update pesoTotalLotes in the pedido
        //widget.pedido.pesoTotalLotes =
        //    widget.pedido.lotes.fold<double>(0, (sum, lote) => sum + lote.peso);
      });
    } else {
      _showMessage(
          'O peso total dos lotes não pode ultrapassar o peso total do pedido.');
    }
  }

  void _removeProcesso(int index) {
    setState(() {
      if (widget.pedido.lotes.length > 1) {
        widget.pedido.lotes.removeAt(index);
        pesoControllers.removeAt(index);
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

  void _updatePeso(int index, String value) {
    setState(() {
      double peso = double.tryParse(value) ?? 0;
      double pesoTotalLotes = widget.pedido.lotes.fold<double>(
          0,
          (sum, lote) =>
              sum + (lote == widget.pedido.lotes[index] ? peso : lote.peso));
      double pesoTotalPedido = double.tryParse(pesoTotalController.text) ?? 0;

      if (pesoTotalLotes <= pesoTotalPedido) {
        widget.pedido.lotes[index].peso = peso;
        widget.pedido.pesoTotalLotes = pesoTotalLotes;
      } else {
        _showMessage(
            'A soma dos pesos dos lotes não pode ultrapassar o peso total do pedido.');
        pesoControllers[index].text =
            widget.pedido.lotes[index].peso.toString();
      }
    });
  }

  void _validateAndSave() {
    if (clienteController.text.isEmpty) {
      _showMessage('O campo "Cliente" é obrigatório.');
      return;
    }
    if (pedidoController.text.isEmpty) {
      _showMessage('O campo "Pedido" é obrigatório.');
      return;
    }
    if (pesoTotalController.text.isEmpty) {
      _showMessage('O campo "Peso Total" é obrigatório.');
      return;
    }
    if (dataLimiteController.text.isEmpty) {
      _showMessage('O campo "Data Limite" é obrigatório.');
      return;
    }
    if (dataColetaController.text.isEmpty) {
      _showMessage('O campo "Data da Coleta" é obrigatório.');
      return;
    }
    for (int i = 0; i < widget.pedido.lotes.length; i++) {
      if (widget.pedido.lotes[i].lavagemProcesso.isEmpty ||
          widget.pedido.lotes[i].lavagemProcesso == 'Selecione Processo') {
        _showMessage('O campo "Processo" do lote ${i + 1} é obrigatório.');
        return;
      }
      if (pesoControllers[i].text.isEmpty ||
          double.tryParse(pesoControllers[i].text) == null) {
        _showMessage('O campo "Peso" do lote ${i + 1} é obrigatório.');
        return;
      }
    }

    _onSave();
  }

  void _onSave() async {
    double pesoTotalLotes =
        widget.pedido.lotes.fold<double>(0, (sum, lote) => sum + lote.peso);
    double pesoTotalPedido = double.tryParse(pesoTotalController.text) ?? 0;
    widget.pedido.classificacaoResponsavel =
        Provider.of<UserProvider>(context, listen: false).loggedInUser;

    if (widget.pedido.classificacaoDataInicio == null) {
      widget.pedido.classificacaoDataInicio =
          DateFormat('dd/MM/yyyy').format(DateTime.now());
      widget.pedido.classificacaoHoraInicio =
          DateFormat('HH:mm').format(DateTime.now());
      widget.pedido.pesoTotalLotes = pesoTotalLotes;
      widget.pedido.classificacaoStatus = 1;
    } else if (pesoTotalLotes == pesoTotalPedido) {
      widget.pedido.pesoTotalLotes = pesoTotalLotes;
      widget.pedido.classificacaoStatus = 2;
      widget.pedido.classificacaoDataFinal =
          DateFormat('dd/MM/yyyy').format(DateTime.now());
      widget.pedido.classificacaoHoraFinal =
          DateFormat('HH:mm').format(DateTime.now());
    } else {
      widget.pedido.pesoTotalLotes = pesoTotalLotes;
      widget.pedido.classificacaoStatus = 1;
    }

    // Update pesoTotalLotes in the pedido
    widget.pedido.totalLotes = widget.pedido.lotes.length;

    widget.pedido.classificacaoObs =
        observacoesController.text; // Save "Observações"

    PedidoDAO pedidoDAO = PedidoDAO();
    await pedidoDAO
        .update(widget.pedido); // Save updated pedido to the database

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
                readOnly: true, // Make read-only
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
                      readOnly: true, // Make read-only
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
                      readOnly: true, // Make read-only
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
                      readOnly: true, // Make read-only
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
                    ...widget.pedido.lotes.asMap().entries.map((entry) {
                      int index = entry.key;
                      Lote lote = entry.value;
                      bool isEditable = lote.loteLavagemStatus == 0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isEditable)
                              Text(
                                'Lote ${index + 1} já está em processo de lavagem.',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 30,
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.5 *
                                      0.55,
                                  child: DropdownButtonFormField<String>(
                                    value: lote.lavagemProcesso.isNotEmpty
                                        ? lote.lavagemProcesso
                                        : 'Selecione Processo',
                                    items: processosDisponiveis
                                        .map((lavagemProcesso) =>
                                            DropdownMenuItem(
                                              value: lavagemProcesso,
                                              child: Text(lavagemProcesso),
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
                                    onChanged: isEditable
                                        ? (value) {
                                            setState(() {
                                              lote.lavagemProcesso =
                                                  value ?? 'Selecione Processo';
                                            });
                                          }
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.5 *
                                      0.2,
                                  child: TextField(
                                    controller: pesoControllers[index],
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
                                    onChanged: isEditable
                                        ? (value) => _updatePeso(index, value)
                                        : null,
                                    enabled: isEditable,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle,
                                      color: Colors.blueAccent),
                                  onPressed: isEditable
                                      ? () {
                                          setState(() {
                                            widget.pedido.lotes.removeAt(index);
                                            pesoControllers.removeAt(index);
                                          });
                                        }
                                      : null,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addProcesso,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: Text('+ Adicionar Lote',
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total de Lotes: ${widget.pedido.lotes.length}'),
                        Text(
                          'Peso Total: ${widget.pedido.lotes.fold<double>(0, (sum, lote) => sum + lote.peso)} kg',
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
                      controller: observacoesController,
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
                      onPressed: _validateAndSave, // Use the validation method
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
