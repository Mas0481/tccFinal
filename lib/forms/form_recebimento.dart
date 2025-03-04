import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatar datas

class Recebimento extends StatefulWidget {
  final VoidCallback onSave; // Adiciona um callback

  const Recebimento({super.key, required this.onSave}); // Construtor

  @override
  _RecebimentoState createState() => _RecebimentoState();
}

class _RecebimentoState extends State<Recebimento> {
  final TextEditingController clienteController = TextEditingController();
  final TextEditingController pedidoController = TextEditingController();
  final TextEditingController dataColetaController = TextEditingController();
  final TextEditingController dataEntregaController = TextEditingController();
  final TextEditingController pesoTotalController = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  // Função para selecionar datas
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
          width: MediaQuery.of(context).size.width *
              0.5, // Ajusta a largura para 50% da tela
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            border: Border.all(color: Colors.grey[300]!, width: 1),
            borderRadius:
                BorderRadius.circular(20), // Arredonda os cantos da borda
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
                    width: 200, // Tamanho do logo
                    height: 130,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error,
                          size:
                              150); // Ícone de erro caso não carregue a imagem
                    },
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Recebimento',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Linha cliente ocupando a largura total
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
              const SizedBox(
                  height: 10), // Mantendo o mesmo espaçamento entre linhas

              // Pedido e Data Coleta (na mesma linha)
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
                    child: GestureDetector(
                      onTap: () {
                        _selectDate(context, dataColetaController);
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: dataColetaController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Data de Coleta',
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
              const SizedBox(
                  height: 10), // Mantendo o mesmo espaçamento entre linhas

              // Data Entrega e Peso Total (na mesma linha)
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _selectDate(context, dataEntregaController);
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: dataEntregaController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'Data de Entrega',
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: pesoTotalController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Peso Total (kg)',
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
              const SizedBox(
                  height: 10), // Mantendo o mesmo espaçamento entre linhas

              // Observações e Botão OK (na mesma linha)
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
                        // Lógica de persistência no banco de dados aqui
                        widget.onSave();
                        Navigator.pop(context);
                      },
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
                          borderRadius: BorderRadius.circular(8),
                        ),
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
