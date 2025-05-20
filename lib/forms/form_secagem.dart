import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc/models/lote.dart';
import 'package:tcc/models/pedido.dart';
import 'package:tcc/providers/user_provider.dart';
import 'package:tcc/repository/clientes_repository.dart';
import 'package:tcc/repository/equipamentos_repository.dart';
import 'package:tcc/servicos/connection.dart';

class Secagem extends StatefulWidget {
  final Pedido pedido; // Adiciona o pedido como parâmetro
  final Lote lote; // Adiciona o lote como parâmetro
  final VoidCallback onSave; // Adiciona um callback

  const Secagem({
    super.key,
    required this.pedido,
    required this.lote,
    required this.onSave,
  });

  @override
  _SecagemState createState() => _SecagemState();
}

class _SecagemState extends State<Secagem> {
  final TextEditingController clienteController = TextEditingController();
  final TextEditingController pedidoController = TextEditingController();
  final TextEditingController loteController = TextEditingController();
  final TextEditingController dataLimiteController = TextEditingController();
  final TextEditingController dataInicioController = TextEditingController();
  final TextEditingController equipamentoController = TextEditingController();
  final TextEditingController tempoProcessoController = TextEditingController();
  final TextEditingController temperaturaController = TextEditingController();
  final TextEditingController horaInicioController = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();

  ClienteRepository clienteRepository =
      ClienteRepository(MySqlConnectionService());
  List<Map<String, dynamic>> equipamentos = [];
  String? equipamentoSelecionado;
  EquipamentosRepository equipamentosRepository =
      EquipamentosRepository(MySqlConnectionService());

  @override
  void initState() {
    super.initState();
    _loadClienteName();
    _loadEquipamentos();

    clienteController.text = widget.pedido.codCliente.toString();
    pedidoController.text = widget.pedido.numPedido.toString();
    dataInicioController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    horaInicioController.text = DateFormat('HH:mm').format(DateTime.now());
    loteController.text = widget.lote.loteNum.toString();
    equipamentoSelecionado = widget.lote.secagemEquipamento.toString();
    dataLimiteController.text = widget.pedido.dataLimite.toString();
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

  Future<void> _loadClienteName() async {
    final cliente = await clienteRepository.findById(widget.pedido.codCliente);
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

  void _validateAndSave() {
    if (clienteController.text.isEmpty) {
      _showMessage('O campo "Cliente" é obrigatório.');
      return;
    }
    if (pedidoController.text.isEmpty) {
      _showMessage('O campo "Pedido" é obrigatório.');
      return;
    }
    if (loteController.text.isEmpty) {
      _showMessage('O campo "Lote" é obrigatório.');
      return;
    }
    if (dataLimiteController.text.isEmpty) {
      _showMessage('O campo "Data Limite" é obrigatório.');
      return;
    }
    if (dataInicioController.text.isEmpty) {
      _showMessage('O campo "Data de Início" é obrigatório.');
      return;
    }
    if (equipamentoSelecionado == null || equipamentoSelecionado!.isEmpty) {
      _showMessage('O campo "Equipamento" é obrigatório.');
      return;
    }
    if (tempoProcessoController.text.isEmpty ||
        int.tryParse(tempoProcessoController.text) == null) {
      _showMessage(
          'O campo "Tempo do Processo" é obrigatório e deve ser numérico.');
      return;
    }
    if (temperaturaController.text.isEmpty ||
        double.tryParse(temperaturaController.text) == null) {
      _showMessage('O campo "Temperatura" é obrigatório e deve ser numérico.');
      return;
    }
    if (horaInicioController.text.isEmpty) {
      _showMessage('O campo "Hora de Início" é obrigatório.');
      return;
    }

    setState(() {
      widget.lote.secagemEquipamento = equipamentoSelecionado ?? '';
      widget.lote.secagemDataInicio = dataInicioController.text;
      widget.lote.secagemHoraInicio = horaInicioController.text;
      widget.lote.secagemTempoProcesso = tempoProcessoController.text;
      widget.lote.secagemTemperatura = temperaturaController.text;
      widget.lote.secagemObs = observacoesController.text;
      widget.lote.secagemResponsavel =
          Provider.of<UserProvider>(context, listen: false).loggedInUser;

      // Calculo da secagemHoraFinal e data final
      final horaInicio = DateFormat('HH:mm').parse(horaInicioController.text);
      final dataInicio =
          DateFormat('dd/MM/yyyy').parse(dataInicioController.text);
      final tempoProcesso = int.tryParse(tempoProcessoController.text) ?? 0;
      final horaFinal = horaInicio.add(Duration(minutes: tempoProcesso));
      final dataFinal = horaFinal.day > horaInicio.day
          ? dataInicio.add(Duration(days: 1))
          : dataInicio;

      widget.lote.secagemHoraFinal = DateFormat('HH:mm').format(horaFinal);
      widget.lote.secagemDataFinal = DateFormat('dd/MM/yyyy').format(dataFinal);
      widget.lote.loteSecagemStatus = 2;
      widget.lote.loteStatus = 2;

      if (widget.pedido.lotes
              .where((lote) => lote.loteSecagemStatus == 2)
              .fold<double>(0, (sum, lote) => sum + lote.peso) ==
          widget.pedido.pesoTotal) {
        widget.pedido.secagemStatus = 2;
      } else {
        widget.pedido.secagemStatus = 1;
      }
    });

    widget.onSave();
    Navigator.pop(context, widget.lote);
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
              Row(
                children: [
                  Image.asset(
                    'lib/images/logo.png',
                    width: 200,
                    height: 130,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 150);
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Secagem',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
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
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: clienteController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Cliente',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withAlpha(80)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
                      controller: loteController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Lote',
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
                    child: GestureDetector(
                      onTap: () {
                        _selectDate(context, dataInicioController);
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: dataInicioController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Data de Início',
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
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
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
                      controller: tempoProcessoController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Tempo do Processo',
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
                      controller: temperaturaController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Temperatura',
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
                      controller: horaInicioController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Hora de Início',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withAlpha(80)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Cancelar',
                          style: TextStyle(color: Colors.white)),
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('OK',
                          style: TextStyle(color: Colors.white)),
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
