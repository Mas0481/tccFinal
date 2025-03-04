import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NovoPedido extends StatefulWidget {
  final VoidCallback onSave;

  const NovoPedido({super.key, required this.onSave});

  @override
  _NovoPedidoState createState() => _NovoPedidoState();
}

class _NovoPedidoState extends State<NovoPedido> {
  final TextEditingController clienteController = TextEditingController();
  final TextEditingController dataColetaController = TextEditingController();
  final TextEditingController dataEntregaController = TextEditingController();
  final TextEditingController pesoTotalController = TextEditingController();
  final TextEditingController responsavelColetaController =
      TextEditingController();
  final TextEditingController responsavelEntregaController =
      TextEditingController();
  final TextEditingController observacoesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dataColetaController.text =
        DateFormat('dd/MM/yyyy').format(DateTime.now()); // Data do dia
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
      backgroundColor:
          Colors.white.withOpacity(1), // Leve transparência no fundo
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
              // Linha 1: Logo e título
              Row(
                children: [
                  Image.asset(
                    'lib/images/logo.png',
                    width: 150,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 80);
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Novo Pedido',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Linha 2: Cliente
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      items: ['Cliente 1', 'Cliente 2', 'Cliente 3']
                          .map((String cliente) {
                        return DropdownMenuItem<String>(
                          value: cliente,
                          child: Text(cliente),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          clienteController.text = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Cliente',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Linha 3: Data de Coleta, Peso Total, Data de Entrega
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _selectDate(context, dataColetaController);
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: dataColetaController,
                          decoration: InputDecoration(
                            labelText: 'Data de Coleta',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: pesoTotalController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Peso Total (kg)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _selectDate(context, dataEntregaController);
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: dataEntregaController,
                          decoration: InputDecoration(
                            labelText: 'Data de Entrega',
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

              // Linha 4: Responsável pela Coleta e Entrega
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: responsavelColetaController,
                      decoration: InputDecoration(
                        labelText: 'Responsável pela Coleta',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: responsavelEntregaController,
                      decoration: InputDecoration(
                        labelText: 'Responsável pela Entrega',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Linha 5: Observações
              TextField(
                controller: observacoesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Observações',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Linha 6: Botões em largura total com estilo ajustado
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Lógica para adicionar foto
                      },
                      icon: const Icon(Icons.camera_alt, color: Colors.black),
                      label: const Text(
                        'Adicionar Foto',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        backgroundColor: Colors.grey.shade200, // Botão foto
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Salva o pedido
                        widget.onSave();
                        // Exibe a mensagem de sucesso
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pedido salvo com sucesso!'),
                            backgroundColor:
                                Colors.green, // Cor de fundo da mensagem
                            duration:
                                Duration(seconds: 2), // Duração da mensagem
                          ),
                        );

                        // Redireciona para a tela de opções
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        backgroundColor: Colors.green
                            .withOpacity(0.7), // Cor do botão salvar
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.green, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Salvar Pedido',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        backgroundColor:
                            Colors.red.withOpacity(0.7), // Botão cancelar
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
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
