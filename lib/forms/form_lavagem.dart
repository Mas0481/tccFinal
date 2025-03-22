import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc/models/pedido.dart';
import 'package:tcc/repository/clientes_repository.dart';
import 'package:tcc/servicos/connection.dart';
import 'package:tcc/repository/equipamentos_repository.dart';

class Lavagem extends StatefulWidget {
  final Pedido pedido; // Adiciona o pedido como parâmetro
  final VoidCallback onSave; // Adiciona um callback

  const Lavagem({super.key, required this.pedido, required this.onSave});

  @override
  _LavagemState createState() => _LavagemState();
}

class _LavagemState extends State<Lavagem> {
  TextEditingController clienteController = TextEditingController();
  TextEditingController pedidoController = TextEditingController();
  TextEditingController dataLimiteController = TextEditingController();
  TextEditingController dataInicioController = TextEditingController();
  TextEditingController loteController = TextEditingController();
  TextEditingController horaInicioController = TextEditingController();
  TextEditingController processoController = TextEditingController();
  TextEditingController observacoesController = TextEditingController();
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
    clienteController =
        TextEditingController(text: widget.pedido.codCliente.toString());
    pedidoController =
        TextEditingController(text: widget.pedido.numPedido.toString());
    dataLimiteController =
        TextEditingController(text: widget.pedido.dataLimite.toString());

    if (widget.pedido.lotes.isNotEmpty) {
      final lote = widget.pedido.lotes.first;

      dataInicioController = TextEditingController(
          text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
      loteController = TextEditingController(text: lote.loteNum.toString());
      equipamentoSelecionado = lote.lavagemEquipamento?.toString() ?? '';
      horaInicioController = TextEditingController(
          text: DateFormat('HH:mm').format(DateTime.now()));
      processoController =
          TextEditingController(text: lote.processo.toString());
      observacoesController =
          TextEditingController(text: lote.lavagemObs.toString());
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
                        'Lavagem',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Campo Data Limite alinhado à direita, em destaque, com fonte vermelha e bold
                  SizedBox(
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
              const SizedBox(height: 10), // Espaçamento entre as linhas

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
                    child: DropdownButtonFormField<String>(
                      value: equipamentoSelecionado != null &&
                              equipamentoSelecionado!.isNotEmpty
                          ? equipamentoSelecionado
                          : null,
                      hint: const Text(
                          'Selecione'), // Adiciona a máscara de texto "Selecione"
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
                ],
              ),
              const SizedBox(
                  height: 10), // Mantendo o mesmo espaçamento entre linhas

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
              const SizedBox(
                  height: 10), // Mantendo o mesmo espaçamento entre linhas

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
                  const SizedBox(
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
                  const SizedBox(width: 10), // Espaçamento entre os botões
                  SizedBox(
                    width: 90, // Largura fixa para o botão Cancelar
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(
                            context); // Fechando o popup ao clicar no botão Cancelar
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
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
              const SizedBox(height: 20), // Espaçamento adicional no final
            ],
          ),
        ),
      ),
    );
  }
}
