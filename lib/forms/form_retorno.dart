import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Retorno extends StatefulWidget {
  final VoidCallback onSave;

  const Retorno({super.key, required this.onSave});

  @override
  _RetornoState createState() => _RetornoState();
}

class _RetornoState extends State<Retorno> {
  final TextEditingController clienteController = TextEditingController();
  final TextEditingController pedidoController = TextEditingController();
  final TextEditingController volumesController = TextEditingController();
  final TextEditingController dataLimiteController = TextEditingController();
  final TextEditingController horaCarregamentoController =
      TextEditingController();
  final TextEditingController enderecoEntregaController =
      TextEditingController();
  final TextEditingController motoristaController = TextEditingController();
  final TextEditingController veiculoController = TextEditingController();
  final TextEditingController placaController = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Data Limite predefinida em vermelho
    dataLimiteController.text = DateFormat('dd/MM/yyyy').format(DateTime.now()
        .add(const Duration(days: 5))); // Exemplo de data limite fixa
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
    if (enderecoEntregaController.text.isEmpty) {
      _showMessage('O campo "Endereço de Entrega" é obrigatório.');
      return;
    }
    if (pedidoController.text.isEmpty) {
      _showMessage('O campo "Pedido" é obrigatório.');
      return;
    }
    if (volumesController.text.isEmpty ||
        int.tryParse(volumesController.text) == null) {
      _showMessage('O campo "Volumes" é obrigatório e deve ser numérico.');
      return;
    }
    if (horaCarregamentoController.text.isEmpty) {
      _showMessage('O campo "Hora do Carregamento" é obrigatório.');
      return;
    }
    if (motoristaController.text.isEmpty) {
      _showMessage('O campo "Nome do Motorista" é obrigatório.');
      return;
    }
    if (veiculoController.text.isEmpty) {
      _showMessage('O campo "Veículo" é obrigatório.');
      return;
    }
    if (placaController.text.isEmpty) {
      _showMessage('O campo "Placa" é obrigatório.');
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
              // Linha do Logo
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
                        'Retorno',
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

              // Linha Cliente
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

              // Linha Endereço de Entrega
              TextField(
                controller: enderecoEntregaController,
                decoration: InputDecoration(
                  labelText: 'Endereço de Entrega',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Linha Pedido, Volumes e Hora do Carregamento
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: pedidoController,
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
                      controller: volumesController,
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
                      controller: horaCarregamentoController,
                      keyboardType: TextInputType.number, // Teclado numérico
                      decoration: InputDecoration(
                        labelText: 'Hora do Carregamento',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Linha Nome do Motorista, Veículo e Placa
              Row(
                children: [
                  Expanded(
                    flex: 2, // Motorista com o dobro do tamanho
                    child: TextField(
                      controller: motoristaController,
                      decoration: InputDecoration(
                        labelText: 'Nome do Motorista',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: veiculoController,
                      decoration: InputDecoration(
                        labelText: 'Veículo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: placaController,
                      decoration: InputDecoration(
                        labelText: 'Placa',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Observações e botões OK e Cancelar
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
