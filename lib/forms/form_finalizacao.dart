import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc/models/pedido.dart';
import 'package:tcc/providers/user_provider.dart';
import 'package:tcc/repository/clientes_repository.dart';
import 'package:tcc/servicos/connection.dart';

class Finalizacao extends StatefulWidget {
  final Pedido pedido; // Adicione este parâmetro
  final VoidCallback onSave;

  const Finalizacao({
    super.key,
    required this.pedido,
    required this.onSave,
  });

  @override
  _FinalizacaoState createState() => _FinalizacaoState();
}

class _FinalizacaoState extends State<Finalizacao> {
  late TextEditingController clienteController;
  late TextEditingController pedidoController;
  late TextEditingController dataLimiteController;
  late TextEditingController dataInicioController;
  late TextEditingController embalagemController;
  late TextEditingController volumesController;
  late TextEditingController horaInicioController;
  late TextEditingController observacoesController;
  String? reparoSelecionado;
  String? etiquetamentoSelecionado;
  String? qualidadeSelecionada;
  ClienteRepository clienteRepository =
      ClienteRepository(MySqlConnectionService());

  @override
  void initState() {
    super.initState();
    _loadClienteName();
    clienteController = TextEditingController(
        text:
            widget.pedido.codCliente.toString()); // ajuste conforme seu modelo
    pedidoController =
        TextEditingController(text: widget.pedido.numPedido.toString());
    dataLimiteController =
        TextEditingController(text: widget.pedido.dataLimite.toString());
    embalagemController = TextEditingController();
    volumesController = TextEditingController();
    observacoesController = TextEditingController();
    dataInicioController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
    );
    horaInicioController = TextEditingController(
      text: DateFormat('HH:mm').format(DateTime.now()),
    );
    reparoSelecionado = null;
    etiquetamentoSelecionado = null;
    qualidadeSelecionada = null;
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

  void _validateAndSave() {
    if (clienteController.text.isEmpty) {
      _showMessage('O campo "Cliente" é obrigatório.');
      return;
    }
    if (pedidoController.text.isEmpty) {
      _showMessage('O campo "Pedido" é obrigatório.');
      return;
    }
    if (reparoSelecionado == null || reparoSelecionado == 'Selecione') {
      _showMessage('O campo "Reparo" é obrigatório.');
      return;
    }
    if (etiquetamentoSelecionado == null ||
        etiquetamentoSelecionado == 'Selecione') {
      _showMessage('O campo "Etiquetamento" é obrigatório.');
      return;
    }
    if (dataInicioController.text.isEmpty) {
      _showMessage('O campo "Data de Início" é obrigatório.');
      return;
    }
    if (embalagemController.text.isEmpty) {
      _showMessage('O campo "Tipo de Embalagem" é obrigatório.');
      return;
    }
    if (volumesController.text.isEmpty ||
        int.tryParse(volumesController.text) == null) {
      _showMessage('O campo "Volumes" é obrigatório e deve ser numérico.');
      return;
    }
    if (qualidadeSelecionada == null || qualidadeSelecionada == 'Selecione') {
      _showMessage('O campo "Controle de Qualidade" é obrigatório.');
      return;
    }
    if (horaInicioController.text.isEmpty) {
      _showMessage('O campo "Hora de Início" é obrigatório.');
      return;
    }
    setState(() {
      widget.pedido.finalizacaoReparo = reparoSelecionado;
      widget.pedido.finalizacaoEtiquetamento = etiquetamentoSelecionado;
      widget.pedido.finalizacaoTipoEmbalagem = embalagemController.text;
      widget.pedido.finalizacaoVolumes = volumesController.text;
      widget.pedido.finalizacaoControleQualidade = qualidadeSelecionada;
      widget.pedido.finalizacaoDataInicio = dataInicioController.text;
      widget.pedido.finalizacaoHoraInicio = horaInicioController.text;
      widget.pedido.finalizacaoObs = observacoesController.text;
      widget.pedido.finalizacaoResponsavel =
          Provider.of<UserProvider>(context, listen: false).username;
    });
    widget.onSave();
    Navigator.pop(context);
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
                    width: 200,
                    height: 130,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 150);
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Finalização',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: TextField(
                      controller: dataLimiteController,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      readOnly: true, // Data Limite não editável
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
                decoration: InputDecoration(
                  labelText: 'Cliente',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Pedido, Reparo, Etiquetamento e Data de Início
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: pedidoController,
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
                    child: DropdownButtonFormField<String>(
                      value: reparoSelecionado != null &&
                              reparoSelecionado!.isNotEmpty
                          ? reparoSelecionado
                          : null,
                      hint: const Text('Selecione'),
                      items: const [
                        DropdownMenuItem(value: 'Sim', child: Text('Sim')),
                        DropdownMenuItem(value: 'Não', child: Text('Não')),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          reparoSelecionado = newValue ?? '';
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Reparo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: etiquetamentoSelecionado != null &&
                              etiquetamentoSelecionado!.isNotEmpty
                          ? etiquetamentoSelecionado
                          : null,
                      hint: const Text('Selecione'),
                      items: const [
                        DropdownMenuItem(value: 'Sim', child: Text('Sim')),
                        DropdownMenuItem(value: 'Não', child: Text('Não')),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          etiquetamentoSelecionado = newValue ?? '';
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Etiquetamento',
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

              // Tipo de Embalagem, Volumes, Controle de Qualidade e Hora de Início
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: embalagemController.text.isNotEmpty
                          ? embalagemController.text
                          : null,
                      hint: const Text('Selecione'),
                      items: const [
                        DropdownMenuItem(
                            value: 'Saco Plástico',
                            child: Text('Saco Plástico')),
                        DropdownMenuItem(
                            value: 'Sacola Plástica',
                            child: Text('Sacola Plástica')),
                        DropdownMenuItem(
                            value: 'Retornável', child: Text('Retornável')),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          embalagemController.text = newValue ?? '';
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Tipo de Embalagem',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 100, // sacola/volumes um pouco menor
                    child: TextField(
                      controller: volumesController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Volumes',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 150, // CQ um pouco maior
                    child: DropdownButtonFormField<String>(
                      value: qualidadeSelecionada != null &&
                              qualidadeSelecionada!.isNotEmpty
                          ? qualidadeSelecionada
                          : null,
                      hint: const Text('Selecione'),
                      items: const [
                        DropdownMenuItem(value: 'Sim', child: Text('Sim')),
                        DropdownMenuItem(value: 'Não', child: Text('Não')),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          qualidadeSelecionada = newValue ?? '';
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Controle Qualidade',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: horaInicioController,
                      keyboardType: TextInputType.number, // Teclado numérico
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
              // Texto informativo abaixo da linha do tipo de embalagem
              const Padding(
                padding: EdgeInsets.only(top: 4, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Todas as particularidades da Finalização devem ser registradas nas observações.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),

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
