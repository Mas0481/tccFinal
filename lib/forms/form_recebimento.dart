import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcc/DAO/pedidoDAO.dart';
import 'package:tcc/models/pedido.dart'; // Para formatar datas
import 'package:tcc/providers/user_provider.dart';
import 'package:tcc/repository/clientes_repository.dart';
import 'package:tcc/servicos/connection.dart'; // Importar o ClienteRepository

class Recebimento extends StatefulWidget {
  final Pedido pedido; // Adiciona o pedido como parâmetro
  final VoidCallback onSave; // Adiciona um callback

  const Recebimento(
      {super.key, required this.pedido, required this.onSave}); // Construtor

  Pedido? get processos => null; // Construtor

  @override
  _RecebimentoState createState() => _RecebimentoState();
}

class _RecebimentoState extends State<Recebimento> {
  TextEditingController clienteController = TextEditingController();
  TextEditingController pedidoController = TextEditingController();
  TextEditingController dataColetaController = TextEditingController();
  TextEditingController dataEntregaController = TextEditingController();
  TextEditingController pesoTotalController = TextEditingController();
  TextEditingController observacoesController = TextEditingController();
  ClienteRepository clienteRepository =
      ClienteRepository(MySqlConnectionService());

  @override
  void initState() {
    super.initState();
    _loadClienteName();
    clienteController =
        TextEditingController(text: widget.pedido.codCliente.toString());
    pedidoController =
        TextEditingController(text: widget.pedido.numPedido.toString());
    dataColetaController =
        TextEditingController(text: widget.pedido.dataColeta.toString());
    dataEntregaController =
        TextEditingController(text: widget.pedido.dataEntrega.toString());
    pesoTotalController =
        TextEditingController(text: widget.pedido.pesoTotal.toString());
    observacoesController =
        TextEditingController(text: widget.pedido.recebimentoObs.toString());

    // Verifica se pedidoObs não está vazio e exibe mensagem
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final obs = widget.pedido.pedidoObs ?? "";
      if (obs.trim().isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Observação do Pedido'),
            content: Text(obs),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });
  }

  Future<void> _loadClienteName() async {
    final cliente = await clienteRepository.findById(widget.pedido.codCliente);
    if (cliente != null) {
      setState(() {
        clienteController.text = cliente['nome']!;
      });
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
                      readOnly: true, // Campo somente leitura
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
                      readOnly: true, // Campo somente leitura
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
                      controller: dataColetaController,
                      style: const TextStyle(color: Colors.black),
                      readOnly: true, // Campo somente leitura
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
                ],
              ),
              const SizedBox(
                  height: 10), // Mantendo o mesmo espaçamento entre linhas

              // Data Entrega e Peso Total (na mesma linha)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: dataEntregaController,
                      style: const TextStyle(color: Colors.black),
                      readOnly: true, // Campo somente leitura
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
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: pesoTotalController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.black),
                      // Campo editável, sem alterações
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
                      // Campo editável, sem alterações
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
                      onPressed: _validateAndSave, // Use the validation method
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

  void _validateAndSave() {
    if (clienteController.text.isEmpty) {
      _showMessage('O campo "Cliente" é obrigatório.');
      return;
    }
    if (pedidoController.text.isEmpty) {
      _showMessage('O campo "Pedido" é obrigatório.');
      return;
    }
    if (dataColetaController.text.isEmpty) {
      _showMessage('O campo "Data de Coleta" é obrigatório.');
      return;
    }
    if (dataEntregaController.text.isEmpty) {
      _showMessage('O campo "Data de Entrega" é obrigatório.');
      return;
    }
    if (pesoTotalController.text.isEmpty ||
        double.tryParse(pesoTotalController.text) == null) {
      _showMessage('O campo "Peso Total" é obrigatório e deve ser numérico.');
      return;
    }

    _onSave();
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

  void _onSave() async {
    // Atualiza os dados do objeto Pedido
    widget.pedido.recebimentoStatus = 2.0;
    widget.pedido.dataRecebimento =
        DateFormat('dd/MM/yyyy').format(DateTime.now());
    widget.pedido.horaRecebimento =
        DateFormat('HH:mm:ss').format(DateTime.now());
    widget.pedido.dataLimite = DateFormat('dd/MM/yyyy').format(
        DateFormat('dd/MM/yyyy')
            .parse(widget.pedido.dataEntrega)
            .subtract(const Duration(days: 1)));
    widget.pedido.pesoTotal =
        double.tryParse(pesoTotalController.text) ?? widget.pedido.pesoTotal;
    widget.pedido.recebimentoObs = observacoesController.text;
    widget.pedido.recebimentoResponsavel =
        Provider.of<UserProvider>(context, listen: false).loggedInUser;

    // Consistir os dados no banco de dados
    final pedidoDAO = PedidoDAO();
    await pedidoDAO.update(widget.pedido);

    // Chama o callback onSave e fecha o diálogo
    widget.onSave();
    setState(() {});
    Navigator.pop(context);
  }
}
