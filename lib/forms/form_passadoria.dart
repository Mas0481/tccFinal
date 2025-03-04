import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Passadoria extends StatefulWidget {
  final VoidCallback onSave;

  const Passadoria({super.key, required this.onSave});

  @override
  _PassadoriaState createState() => _PassadoriaState();
}

class _PassadoriaState extends State<Passadoria> {
  final TextEditingController clienteController = TextEditingController();
  final TextEditingController pedidoController = TextEditingController();
  final TextEditingController dataLimiteController = TextEditingController();
  final TextEditingController dataInicioController = TextEditingController();
  final TextEditingController equipamentoController = TextEditingController();
  final TextEditingController temperaturaController = TextEditingController();
  final TextEditingController horaInicioController = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();
  bool _pecasPassadasCheckbox =
      false; // Variável para armazenar o estado da checkbox

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
                        'Passadoria',
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

              // Pedido e Data de Início
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
                    child: TextField(
                      controller: equipamentoController,
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
                    child: TextField(
                      controller: temperaturaController,
                      keyboardType: TextInputType.number, // Teclado numérico
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
                        widget.onSave();
                        Navigator.pop(context);
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
