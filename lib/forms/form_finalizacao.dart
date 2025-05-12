import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Finalizacao extends StatefulWidget {
  final VoidCallback onSave;

  const Finalizacao({super.key, required this.onSave});

  @override
  _FinalizacaoState createState() => _FinalizacaoState();
}

class _FinalizacaoState extends State<Finalizacao> {
  final TextEditingController clienteController = TextEditingController();
  final TextEditingController pedidoController = TextEditingController();
  final TextEditingController reparoController = TextEditingController();
  final TextEditingController etiquetamentoController = TextEditingController();
  final TextEditingController dataLimiteController = TextEditingController();
  final TextEditingController dataInicioController = TextEditingController();
  final TextEditingController embalagemController = TextEditingController();
  final TextEditingController volumesController = TextEditingController();
  final TextEditingController qualidadeController = TextEditingController();
  final TextEditingController horaInicioController = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dataLimiteController.text = DateFormat('dd/MM/yyyy').format(DateTime.now()
        .add(const Duration(days: 5))); // Data limite fixa como exemplo
    dataInicioController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    horaInicioController.text = DateFormat('HH:mm').format(DateTime.now());
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
    if (clienteController.text.isEmpty) {
      _showMessage('O campo "Cliente" é obrigatório.');
      return;
    }
    if (pedidoController.text.isEmpty) {
      _showMessage('O campo "Pedido" é obrigatório.');
      return;
    }
    if (reparoController.text.isEmpty) {
      _showMessage('O campo "Reparo" é obrigatório.');
      return;
    }
    if (etiquetamentoController.text.isEmpty) {
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
    if (qualidadeController.text.isEmpty) {
      _showMessage('O campo "Controle de Qualidade" é obrigatório.');
      return;
    }
    if (horaInicioController.text.isEmpty) {
      _showMessage('O campo "Hora de Início" é obrigatório.');
      return;
    }

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
                    child: TextField(
                      controller: reparoController,
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
                    child: TextField(
                      controller: etiquetamentoController,
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
                    child: TextField(
                      controller: embalagemController,
                      decoration: InputDecoration(
                        labelText: 'Tipo de Embalagem',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: qualidadeController,
                      decoration: InputDecoration(
                        labelText: 'Controle de Qualidade',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
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
