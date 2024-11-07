import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatar datas

class Lavagem extends StatefulWidget {
  final VoidCallback onSave; // Adiciona um callback

  Lavagem({required this.onSave}); // Construtor

  @override
  _LavagemState createState() => _LavagemState();
}

class _LavagemState extends State<Lavagem> {
  final TextEditingController clienteController = TextEditingController();
  final TextEditingController pedidoController = TextEditingController();
  final TextEditingController dataLimiteController = TextEditingController();
  final TextEditingController dataInicioController = TextEditingController();
  final TextEditingController loteController = TextEditingController();
  final TextEditingController equipamentoController = TextEditingController();
  final TextEditingController horaInicioController = TextEditingController();
  final TextEditingController processoController = TextEditingController();
  final TextEditingController observacoesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Definindo a data de início como a data atual
    dataInicioController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    // Definindo a hora de início como a hora atual
    horaInicioController.text = DateFormat('HH:mm').format(DateTime.now());
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
                      return Icon(Icons.error,
                          size:
                              150); // Ícone de erro caso não carregue a imagem
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Lavagem',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Campo Data Limite alinhado à direita, em destaque, com fonte vermelha e bold
                  Container(
                    width: 150, // Aumenta a largura do campo Data Limite
                    child: GestureDetector(
                      onTap: () {
                        _selectDate(context, dataLimiteController);
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: dataLimiteController,
                          style: const TextStyle(
                            color: Colors.red, // Cor da fonte vermelha
                            fontWeight: FontWeight.bold, // Fonte em destaque
                            fontSize: 18, // Aumenta a fonte para 18 pts
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

              // Linha com Cliente
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
              SizedBox(height: 10), // Espaçamento entre as linhas

              // Linha com Pedido, Lote e Equipamento
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
                  SizedBox(width: 10),
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
                  SizedBox(width: 10),
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
                ],
              ),
              SizedBox(height: 10), // Mantendo o mesmo espaçamento entre linhas

              // Linha com Processo, Data de Início e Hora de Início
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: processoController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Processo',
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.withAlpha(80)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
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
                  SizedBox(width: 10),
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
              SizedBox(height: 10), // Mantendo o mesmo espaçamento entre linhas

              // Observações e Botões
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
                  SizedBox(
                      width: 10), // Espaçamento entre Observações e botão OK
                  SizedBox(
                    width: 90, // Largura fixa para o botão OK
                    child: ElevatedButton(
                      onPressed: () {
                        // Aqui você pode adicionar a lógica para salvar os dados
                        widget
                            .onSave(); // Chama o callback para atualizar o status do lote
                        Navigator.pop(
                            context); // Fechando o popup ao clicar no botão OK
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('OK',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 10), // Espaçamento entre os botões
                  SizedBox(
                    width: 90, // Largura fixa para o botão Cancelar
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                            context); // Fechando o popup ao clicar no botão Cancelar
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                40), // Altura igual à do campo Observações
                        backgroundColor: Colors.red, // Cor vermelha
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
              SizedBox(height: 20), // Espaçamento adicional no final
            ],
          ),
        ),
      ),
    );
  }
}
