import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc/models/lote.dart';
import 'package:tcc/models/pedido.dart';
import 'package:tcc/providers/user_provider.dart';
import 'package:tcc/repository/clientes_repository.dart';
import 'package:tcc/repository/processos_repository.dart';
import 'package:tcc/servicos/connection.dart';
import 'package:tcc/repository/equipamentos_repository.dart';

class Lavagem extends StatefulWidget {
  final Pedido pedido; // Adiciona o pedido como parâmetro
  final Lote lote; // Adiciona o lote como parâmetro
  final VoidCallback onSave; // Adiciona um callback

  const Lavagem(
      {super.key,
      required this.pedido,
      required this.lote,
      required this.onSave});

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
  TextEditingController pesoController = TextEditingController();
  TextEditingController equipamentoController = TextEditingController();
  ClienteRepository clienteRepository =
      ClienteRepository(MySqlConnectionService());
  List<Map<String, dynamic>> equipamentos = [];
  String? equipamentoSelecionado;
  EquipamentosRepository equipamentosRepository =
      EquipamentosRepository(MySqlConnectionService());
  List<Map<String, String>> processos = [];
  ProcessosRepository processosRepository =
      ProcessosRepository(MySqlConnectionService());

  @override
  void initState() {
    super.initState();
    _loadClienteName();
    _loadEquipamentos();
    _loadProcessos(); // Load processes dynamically
    clienteController =
        TextEditingController(text: widget.pedido.codCliente.toString());
    pedidoController =
        TextEditingController(text: widget.pedido.numPedido.toString());
    dataLimiteController =
        TextEditingController(text: widget.pedido.dataLimite.toString());

    final lote = widget.lote;

    dataInicioController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
    loteController = TextEditingController(text: lote.loteNum.toString());
    equipamentoSelecionado = lote.lavagemEquipamento.toString();
    horaInicioController =
        TextEditingController(text: DateFormat('HH:mm').format(DateTime.now()));
    processoController =
        TextEditingController(text: lote.lavagemProcesso.toString());
    observacoesController =
        TextEditingController(text: lote.lavagemObs.toString());
    pesoController = TextEditingController(text: lote.peso.toString());
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

  Future<void> _loadProcessos() async {
    try {
      final listaProcessos = await processosRepository.getProcessos();
      setState(() {
        processos = listaProcessos;
      });
    } catch (e) {
      print('Erro ao buscar os processos: $e');
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

  void _validateAndSave() {
    if (equipamentoSelecionado == null || equipamentoSelecionado!.isEmpty) {
      _showMessage('O campo "Equipamento" é obrigatório.');
      return;
    }
    if (processoController.text.isEmpty) {
      _showMessage('O campo "Processo" é obrigatório.');
      return;
    }
    if (pesoController.text.isEmpty) {
      _showMessage('O campo "Peso" é obrigatório.');
      return;
    }
    if (dataInicioController.text.isEmpty) {
      _showMessage('O campo "Data de Início" é obrigatório.');
      return;
    }
    if (horaInicioController.text.isEmpty) {
      _showMessage('O campo "Hora de Início" é obrigatório.');
      return;
    }

    setState(() {
      widget.lote.lavagemEquipamento = equipamentoSelecionado ?? '';
      widget.lote.lavagemProcesso = processoController.text;
      widget.lote.lavagemDataInicio = dataInicioController.text;
      widget.lote.lavagemHoraInicio = horaInicioController.text;

      widget.lote.lavagemDataFinal = dataInicioController.text;
      widget.lote.lavagemHoraFinal = horaInicioController.text;

      widget.lote.lavagemObs = observacoesController.text;
      widget.lote.lavagemResponsavel =
          Provider.of<UserProvider>(context, listen: false).loggedInUser;
      widget.lote.loteLavagemStatus = 2; // Atualiza o status do lote
      widget.lote.loteStatus = 1; // Atualiza o status do lote
      widget.lote.loteResponsavel = widget.lote.loteResponsavel;

      //aqui calcula se o total dos lotes com a lavagem concluida é igual ao total do peso do lote, se for marca o statua da lavagem no pedido como 2, senao marca como 1
      if (widget.pedido.lotes
              .where((lote) => lote.loteLavagemStatus == 2)
              .fold<double>(0, (sum, lote) => sum + lote.peso) ==
          widget.pedido.pesoTotal) {
        widget.pedido.lavagemStatus =
            2; // Atualiza o status do pedido para concluído
      } else {
        widget.pedido.lavagemStatus =
            1; // Atualiza o status do pedido para pendente
      }
    });
    print('lote saido do formulario: ' + widget.lote.toString());
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

  Future<void> _calculateHoraFinal() async {
    try {
      // Consulta o processo pelo nome para obter o tempoProcesso
      final processo = await processosRepository
          .findProcessoByName(widget.lote.lavagemProcesso);

      if (processo != null && processo['tempoProcesso'] != null) {
        // Obtém o tempoProcesso em minutos (ou ajuste conforme o formato do banco)
        final tempoProcesso = int.parse(processo['tempoProcesso']!);

        // Converte a hora inicial para DateTime
        final horaInicio = DateFormat('HH:mm').parse(horaInicioController.text);

        // Soma o tempoProcesso à hora inicial
        final horaFinal = horaInicio.add(Duration(minutes: tempoProcesso));

        // Atualiza o valor de lavagemHoraFinal no lote
        setState(() {
          widget.lote.lavagemHoraFinal = DateFormat('HH:mm').format(horaFinal);
        });

        print('Hora Final Calculada: ${widget.lote.lavagemHoraFinal}');
      } else {
        _showMessage('Tempo do processo não encontrado.');
      }
    } catch (e) {
      print('Erro ao calcular a hora final: $e');
      _showMessage('Erro ao calcular a hora final.');
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
                          readOnly: true, // Make read-only
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
                      readOnly: true, // Make read-only
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

              // Linha com Pedido, Lote e Processo
              Row(
                children: [
                  Expanded(
                    flex: 17,
                    child: TextField(
                      controller: pedidoController,
                      readOnly: true, // Make read-only
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
                    flex: 17,
                    child: TextField(
                      controller: loteController,
                      readOnly: true, // Make read-only
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
                    flex: 66,
                    child: DropdownButtonFormField<String>(
                      value: widget.lote.lavagemProcesso.isNotEmpty
                          ? widget.lote.lavagemProcesso
                          : null, // Set initial value from lote.lavagemProcesso
                      hint: const Text(
                          'Selecione o Processo'), // Placeholder text
                      items: processos.map((processo) {
                        return DropdownMenuItem<String>(
                          value: processo['nomeProcesso'],
                          child: Text(processo['nomeProcesso'] ?? ''),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          processoController.text = newValue ?? '';
                        });
                      },
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
                ],
              ),
              const SizedBox(
                  height: 10), // Mantendo o mesmo espaçamento entre linhas

              // Linha com Equipamento, Peso, Data de Início e Hora de Início
              Row(
                children: [
                  Expanded(
                    flex: 25,
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
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 20,
                    child: TextField(
                      controller: pesoController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Peso',
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
                    flex: 35,
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
                    flex: 20,
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
