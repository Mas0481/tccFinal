import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc/models/pedido.dart';
import 'package:tcc/providers/user_provider.dart';
import 'package:tcc/repository/clientes_repository.dart';
import 'package:tcc/repository/util_repository.dart';
import 'package:tcc/servicos/connection.dart';

class Retorno extends StatefulWidget {
  final Pedido pedido; // Recebe o pedido
  final VoidCallback onSave;

  const Retorno({super.key, required this.pedido, required this.onSave});

  @override
  _RetornoState createState() => _RetornoState();
}

class _RetornoState extends State<Retorno> {
  late TextEditingController clienteController;
  late TextEditingController pedidoController;
  late TextEditingController volumesController;
  late TextEditingController dataLimiteController;
  late TextEditingController horaCarregamentoController;
  late TextEditingController enderecoEntregaController;
  late TextEditingController motoristaController;
  late TextEditingController veiculoController;
  late TextEditingController placaController;
  late TextEditingController observacoesController;
  late String dataRetorno = DateFormat('dd/MM/yyyy').format(DateTime.now());

  ClienteRepository clienteRepository =
      ClienteRepository(MySqlConnectionService());
  UtilRepository utilRepository = UtilRepository(MySqlConnectionService());
  List<Map<String, String>> veiculos = [];
  String? veiculoSelecionado;
  List<Map<String, String>> motoristas = [];
  String? motoristaSelecionado;

  @override
  void initState() {
    super.initState();
    clienteController = TextEditingController();
    pedidoController =
        TextEditingController(text: widget.pedido.numPedido?.toString() ?? '');
    volumesController = TextEditingController(
        text: widget.pedido.finalizacaoVolumes?.toString() ?? '');
    dataLimiteController =
        TextEditingController(text: widget.pedido.dataLimite);
    horaCarregamentoController =
        TextEditingController(text: DateFormat('HH:mm').format(DateTime.now()));
    enderecoEntregaController = TextEditingController();
    motoristaController =
        TextEditingController(text: widget.pedido.retornoNomeMotorista ?? '');
    veiculoController =
        TextEditingController(text: widget.pedido.retornoVeiculo ?? '');
    placaController =
        TextEditingController(text: widget.pedido.retornoPlaca ?? '');
    observacoesController =
        TextEditingController(text: widget.pedido.retornoObs ?? '');

    _loadClienteName();
    _loadEnderecoEntrega();
    _carregarVeiculos();
    _carregarMotoristas();
  }

  Future<void> _loadClienteName() async {
    final cliente = await clienteRepository.findById(widget.pedido.codCliente);
    if (cliente != null) {
      setState(() {
        clienteController.text = cliente['nome']!;
      });
    }
  }

  Future<void> _loadEnderecoEntrega() async {
    final endereco = await clienteRepository
        .getEnderecoCompletoCliente(widget.pedido.codCliente);
    if (endereco != null) {
      setState(() {
        enderecoEntregaController.text = endereco;
      });
    }
  }

  Future<void> _carregarVeiculos() async {
    final listaVeiculos = await utilRepository.getVeiculos();
    String? veiculoInicial;
    final veiculoEncontrado = listaVeiculos.firstWhere(
      (v) => v['placa'] == widget.pedido.retornoPlaca,
      orElse: () => {},
    );
    if (veiculoEncontrado.isNotEmpty) {
      veiculoInicial = veiculoEncontrado['modelo'];
    }
    setState(() {
      veiculos = listaVeiculos;
      veiculoSelecionado = veiculoInicial;
      if (veiculoSelecionado != null) {
        final veiculo = veiculos.firstWhere(
          (v) => v['modelo'] == veiculoSelecionado,
          orElse: () => {},
        );
        veiculoController.text = veiculo['modelo'] ?? '';
        placaController.text = veiculo['placa'] ?? '';
      }
    });
  }

  Future<void> _carregarMotoristas() async {
    final listaMotoristas = await utilRepository.getMotoristas();
    String? motoristaInicial;
    final motoristaEncontrado = listaMotoristas.firstWhere(
      (m) => m['nome'] == widget.pedido.retornoNomeMotorista,
      orElse: () => {},
    );
    if (motoristaEncontrado.isNotEmpty) {
      motoristaInicial = motoristaEncontrado['codMotorista'];
    }
    setState(() {
      motoristas = listaMotoristas;
      motoristaSelecionado = motoristaInicial;
      if (motoristaSelecionado != null) {
        final motorista = motoristas.firstWhere(
          (m) => m['codMotorista'] == motoristaSelecionado,
          orElse: () => {},
        );
        motoristaController.text = motorista['nome'] ?? '';
      }
    });
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
    if (volumesController.text.isEmpty) {
      _showMessage('O campo "Volumes" é obrigatório.');
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

    setState(() {
      // Aqui você pode atualizar os campos do pedido, se necessário
      widget.pedido.numPedido = int.tryParse(pedidoController.text);
      widget.pedido.retornoVolumes =
          volumesController.text; // Corrigido para String
      widget.pedido.dataLimite = dataLimiteController.text;
      widget.pedido.retornoHoraCarregamento = horaCarregamentoController.text;
      widget.pedido.retornoNomeMotorista = motoristaController.text;
      widget.pedido.retornoVeiculo = veiculoController.text;
      widget.pedido.retornoPlaca = placaController.text;
      widget.pedido.retornoObs = observacoesController.text;
      widget.pedido.enderecoEntrega = enderecoEntregaController.text;
      widget.pedido.retornoData = dataRetorno.toString();
      widget.pedido.retornoResponsavel =
          Provider.of<UserProvider>(context, listen: false).loggedInUser;
      // Adicione outros campos se necessário
    });

    widget.onSave();
    Navigator.pop(context, widget.pedido);
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
                readOnly: true, // Cliente não editável
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
                      readOnly: true, // Pedido não editável
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
                      keyboardType: TextInputType.number, // Apenas números
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
                    child: GestureDetector(
                      onTap: () async {
                        TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() {
                            horaCarregamentoController.text =
                                picked.format(context);
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: horaCarregamentoController,
                          keyboardType:
                              TextInputType.number, // Teclado numérico
                          decoration: InputDecoration(
                            labelText: 'Hora do Carregamento',
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

              // Linha Nome do Motorista, Veículo e Placa
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: motoristas.any(
                              (m) => m['codMotorista'] == motoristaSelecionado)
                          ? motoristaSelecionado
                          : null,
                      hint: const Text('Selecionar'),
                      items: motoristas.map((motorista) {
                        return DropdownMenuItem<String>(
                          value: motorista['codMotorista'],
                          child: Text(motorista['nome'] ?? ''),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          motoristaSelecionado = value;
                          final motorista = motoristas.firstWhere(
                            (m) => m['codMotorista'] == value,
                            orElse: () => {},
                          );
                          motoristaController.text = motorista['nome'] ?? '';
                        });
                      },
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
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value:
                          veiculos.any((v) => v['placa'] == veiculoSelecionado)
                              ? veiculoSelecionado
                              : null,
                      hint: const Text('Selecionar'),
                      items: veiculos.map((veiculo) {
                        return DropdownMenuItem<String>(
                          value: veiculo['placa'],
                          child: Text(
                            '${veiculo['modelo'] ?? ''}',
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          veiculoSelecionado = value;
                          final veiculo = veiculos.firstWhere(
                            (v) => v['placa'] == value,
                            orElse: () => {},
                          );
                          veiculoController.text = veiculo['modelo'] ?? '';
                          placaController.text = veiculo['placa'] ?? '';
                        });
                      },
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
                      readOnly: true,
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
