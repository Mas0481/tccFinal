import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Secagem extends StatefulWidget {
  final VoidCallback onSave; // Adiciona um callback

  const Secagem({super.key, required this.onSave}); // Construtor

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

  @override
  void initState() {
    super.initState();
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
                    child: TextField(
                      controller: equipamentoController,
                      style: const TextStyle(color: Colors.black),
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
                      onPressed: () {
                        // Lógica do botão OK
                        Navigator.pop(context);
                        widget
                            .onSave(); // Chama o callback para atualizar o status do lote
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
