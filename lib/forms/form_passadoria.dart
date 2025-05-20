import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc/models/lote.dart';
import 'package:tcc/models/pedido.dart';
import 'package:tcc/repository/clientes_repository.dart';
import 'package:tcc/repository/equipamentos_repository.dart';
import 'package:tcc/repository/processos_repository.dart';
import 'package:tcc/servicos/connection.dart';

class Passadoria extends StatefulWidget {
  final VoidCallback onSave;
  final Pedido pedido; // Adiciona o pedido como parâmetro

  const Passadoria({super.key, required this.onSave, required this.pedido});

  @override
  _PassadoriaState createState() => _PassadoriaState();
}

class _PassadoriaState extends State<Passadoria> {
  TextEditingController clienteController = TextEditingController();
  TextEditingController pedidoController = TextEditingController();
  TextEditingController dataLimiteController = TextEditingController();
  TextEditingController dataInicioController = TextEditingController();
  TextEditingController loteController = TextEditingController();
  TextEditingController horaInicioController = TextEditingController();
  TextEditingController equipamentoController = TextEditingController();
  TextEditingController temperaturaController = TextEditingController();
  TextEditingController observacoesController = TextEditingController();
  bool _pecasPassadasCheckbox =
      false; // Variável para armazenar o estado da checkbox

  final ClienteRepository clienteRepository =
      ClienteRepository(MySqlConnectionService());
  final EquipamentosRepository equipamentosRepository =
      EquipamentosRepository(MySqlConnectionService());
  final ProcessosRepository processosRepository =
      ProcessosRepository(MySqlConnectionService());
  List<Map<String, dynamic>> equipamentos = [];
  String? equipamentoSelecionado;
  List<Map<String, String>> processos = [];

  @override
  void initState() {
    super.initState();
    _loadClienteName();
    _loadEquipamentos();
    _loadProcessos(); // Load processes dynamically
    clienteController =
        TextEditingController(text: widget.pedido.codCliente.toString());
    pedidoController =
        TextEditingController(text: widget.pedido.numPedido.toString());
    dataLimiteController =
        TextEditingController(text: widget.pedido.dataLimite.toString());

    dataInicioController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
  }

  Future<void> _loadClienteName() async {
    // Replace with appropriate logic to fetch client data
    final cliente = await clienteRepository.findById(1); // Example ID
    if (cliente != null) {
      setState(() {
        clienteController.text = cliente['nome']!;
      });
    }
  }

  Future<void> _loadEquipamentos() async {
    try {
      final listaEquipamentos = await equipamentosRepository.getEquipamentos();
      setState(() {
        equipamentos = listaEquipamentos
            .map((e) => {
                  'codigo': e['codigoEquipamento'],
                  'nome': e['nomeEquipamento']
                })
            .toList();
        if (equipamentos.isNotEmpty &&
            (equipamentoSelecionado == null ||
                equipamentoSelecionado!.isEmpty)) {
          equipamentoSelecionado =
              null; // Ensure the hint text "Selecione" is shown
        }
      });
    } catch (e) {
      print('Erro ao buscar os equipamentos: $e');
    }
  }

  Future<void> _loadProcessos() async {
    try {
      final listaProcessos = await processosRepository.getProcessos();
      setState(() {
        processos = listaProcessos;
      });
    } catch (e) {
      print('Erro ao buscar os processos: $e');
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

  void _validateAndSave() {
    if (equipamentoSelecionado == null || equipamentoSelecionado!.isEmpty) {
      _showMessage('O campo "Equipamento" é obrigatório.');
      return;
    }
    if (temperaturaController.text.isEmpty) {
      _showMessage('O campo "Temperatura" é obrigatório.');
      return;
    }
    if (dataInicioController.text.isEmpty) {
      _showMessage('O campo "Data de Início" é obrigatório.');
      return;
    }
    if (horaInicioController.text.isEmpty) {
      _showMessage('O campo "Hora de Início" é obrigatório.');
      return;
    }

    setState(() {
      widget.pedido.passadoriaEquipamento = equipamentoSelecionado ?? '';
      widget.pedido.passadoriaTemperatura = temperaturaController.text;
      widget.pedido.passadoriaDataInicio = dataInicioController.text;
      widget.pedido.passadoriaHoraInicio = horaInicioController.text;
      widget.pedido.passadoriaObs = observacoesController.text;
      widget.pedido.passadoriaStatus = 1; // Atualiza o status do pedido
    });

    widget.onSave();
    Navigator.pop(context, widget.pedido);
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aviso'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white.withOpacity(0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Image.asset(
                    'lib/images/logo.png',
                    width: 200, // Fixed width as in form_lavagem
                    height: 130, // Fixed height as in form_lavagem
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 150);
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Passadoria',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150, // Fixed width as in form_lavagem
                    child: TextField(
                      controller: dataLimiteController,
                      readOnly: true, // Set to read-only
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Data Limite',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Cliente
              TextField(
                controller: clienteController,
                readOnly: true, // Set to read-only
                decoration: InputDecoration(
                  labelText: 'Cliente',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Pedido e Data de Início
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: pedidoController,
                      readOnly: true, // Set to read-only
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Pedido',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, dataInicioController),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: dataInicioController,
                          decoration: InputDecoration(
                            labelText: 'Data de Início',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Equipamento, Temperatura e Hora de Início
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: equipamentoSelecionado != null &&
                              equipamentoSelecionado!.isNotEmpty
                          ? equipamentoSelecionado
                          : null,
                      hint: const Text('Selecione'),
                      items: equipamentos.map((equipamento) {
                        return DropdownMenuItem<String>(
                          value: equipamento['nome'],
                          child: Text(equipamento['nome']),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          equipamentoSelecionado = newValue ?? '';
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Equipamento',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: temperaturaController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Temperatura',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: horaInicioController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Hora de Início',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Checkbox para peças passadas a ferro
              CheckboxListTile(
                title: const Text(
                  "Existem peças passadas a ferro neste pedido (registrar as informações nas observações)",
                  style: TextStyle(fontSize: 16),
                ),
                value: _pecasPassadasCheckbox,
                onChanged: (bool? value) {
                  setState(() {
                    _pecasPassadasCheckbox = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 10),

              // Observações e botões
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: observacoesController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Observações',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 90,
                    child: ElevatedButton(
                      onPressed: () {
                        _validateAndSave();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('OK',
                          style: TextStyle(color: Colors.white)),
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
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Cancelar',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
