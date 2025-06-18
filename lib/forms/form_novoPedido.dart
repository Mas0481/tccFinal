import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcc/DAO/pedidoDAO.dart';
import 'package:tcc/models/pedido.dart';
import 'package:tcc/providers/user_provider.dart';
import 'package:tcc/repository/clientes_repository.dart';
import 'package:tcc/servicos/connection.dart';
import 'package:provider/provider.dart';

class NovoPedido extends StatefulWidget {
  final VoidCallback onSave;

  NovoPedido({required this.onSave});

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
  final TextEditingController enderecoEntregaController =
      TextEditingController();

  List<Map<String, dynamic>> clientes = []; // Armazena código e nome
  String? clienteSelecionado;
  int? codigoClienteSelecionado;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dataColetaController.text =
        DateFormat('dd/MM/yyyy').format(DateTime.now()); // Data do dia
    // Preenche o responsável pela coleta com o usuário logado assim que possível
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final username =
          Provider.of<UserProvider>(context, listen: false).username;
      responsavelColetaController.text = username;
    });
    _loadClientes();
  }

  void _loadClientes() async {
    try {
      final connectionService = MySqlConnectionService();
      final clienteRepository = ClienteRepository(connectionService);
      final resultado = await clienteRepository.getClientes();

      setState(() {
        clientes = resultado
            .map((row) => {
                  'codigo': row['codCliente'],
                  'nome': row['nome'],
                  'endereco':
                      row['endereco'] ?? "", // Adicione o campo endereco
                })
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar clientes: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
    final username = Provider.of<UserProvider>(context).username;
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
          child: Form(
            key: _formKey,
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
                        return Icon(Icons.error, size: 80);
                      },
                    ),
                    Expanded(
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
                SizedBox(height: 10),

                // Linha 2: Cliente
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: clienteSelecionado,
                        items: clientes.map((cliente) {
                          return DropdownMenuItem<String>(
                            value: cliente['nome'],
                            child: Text('${cliente['nome']}'),
                          );
                        }).toList(),
                        onChanged: (value) async {
                          setState(() {
                            clienteSelecionado = value;
                            final clienteMap = clientes.firstWhere(
                                (cliente) => cliente['nome'] == value);
                            codigoClienteSelecionado =
                                int.tryParse(clienteMap['codigo']!);
                          });

                          // Busca o endereço completo do cliente selecionado
                          if (codigoClienteSelecionado != null) {
                            final connectionService = MySqlConnectionService();
                            final clienteRepository =
                                ClienteRepository(connectionService);
                            final enderecoCompleto = await clienteRepository
                                .getEnderecoCompletoCliente(
                                    codigoClienteSelecionado!);
                            setState(() {
                              enderecoEntregaController.text =
                                  enderecoCompleto ?? "";
                            });
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Selecione um Cliente',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Linha 3: Data de Coleta, Peso Total, Data de Entrega
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _selectDate(context, dataColetaController);
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: dataColetaController,
                            decoration: InputDecoration(
                              labelText: 'Data de Coleta',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: pesoTotalController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Peso Total (kg)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Informe um número válido';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          DateTime hoje = DateTime.now();
                          DateTime minEntrega =
                              DateTime(hoje.year, hoje.month, hoje.day)
                                  .add(Duration(days: 1));
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: minEntrega,
                            firstDate: minEntrega,
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              dataEntregaController.text =
                                  DateFormat('dd/MM/yyyy').format(picked);
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: dataEntregaController,
                            decoration: InputDecoration(
                              labelText: 'Data de Entrega',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Campo obrigatório';
                              }
                              // Validação: data de entrega deve ser pelo menos um dia após hoje
                              try {
                                DateTime hoje = DateTime.now();
                                DateTime minEntrega =
                                    DateTime(hoje.year, hoje.month, hoje.day)
                                        .add(Duration(days: 1));
                                DateTime dataEntrega =
                                    DateFormat('dd/MM/yyyy').parseStrict(value);
                                if (dataEntrega.isBefore(minEntrega)) {
                                  // Exibe mensagem imediatamente
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'A data de entrega deve ser pelo menos um dia após a data de hoje!'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  });
                                  return 'Data inválida';
                                }
                              } catch (e) {
                                return 'Data inválida';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Linha 4: Responsável pela Coleta e Entrega
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: responsavelColetaController,
                        decoration: InputDecoration(
                          labelText: 'Responsável pela Coleta',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: responsavelEntregaController,
                        decoration: InputDecoration(
                          labelText: 'Responsável pela Entrega',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Linha: Endereço de Entrega (agora acima das observações)
                TextFormField(
                  controller: enderecoEntregaController,
                  decoration: InputDecoration(
                    labelText: 'Endereço de Entrega',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

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
                SizedBox(height: 15),

                // Linha 6: Botões
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Lógica para adicionar foto
                        },
                        icon: Icon(Icons.camera_alt, color: Colors.black),
                        label: Text(
                          'Adicionar Foto',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          backgroundColor: Colors.grey.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          // Captura os dados dos controladores

                          double pesoTotal =
                              double.tryParse(pesoTotalController.text) ?? 0.0;
                          String dataColeta = dataColetaController.text;
                          String dataEntrega = dataEntregaController.text;

                          // Criar um novo objeto Pedido
                          if (codigoClienteSelecionado == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Erro no código do cliente selecionado')),
                            );
                            return;
                          }

                          Pedido novoPedido = Pedido(
                            codCliente:
                                codigoClienteSelecionado!, // Código do cliente, pode ser obtido com base no nome
                            qtdProduto: 1, // Defina conforme necessário
                            pedidoResponsavel: username,
                            pedidoObs: observacoesController.text,
                            pedidoStatus: 0,
                            valorProdutos: 0.0,
                            recebimentoStatus: 0.0,
                            classificacaoStatus: 0.0,
                            lavagemStatus: 0.0,
                            centrifugacaoStatus: 0.0,
                            secagemStatus: 0.0,
                            passadoriaStatus: 0.0,
                            finalizacaoStatus: 0.0,
                            retornoStatus: 0.0,
                            dataColeta: dataColeta,
                            pagamento: 0,
                            dataLimite: dataEntrega,
                            dataEntrega: dataEntrega,
                            pesoTotal: pesoTotal,
                            totalLotes: 0,
                            pesoTotalLotes: 0.0,
                            respContratadaNaColeta:
                                username, // Nome do usuário logado
                            respContratanteNaColeta:
                                responsavelEntregaController.text,
                            enderecoEntrega: enderecoEntregaController.text,

                            lotes: [],
                          );

                          try {
                            // Criar instância do PedidoDAO
                            final pedidoDAO = PedidoDAO();

                            // Inserir pedido no banco de dados
                            await pedidoDAO.insert(novoPedido);

                            // Chama o onSave para atualizar a interface
                            widget.onSave();

                            // Exibe uma mensagem de sucesso
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Aguarde, pedido sendo processado!')),
                            );
                          } catch (e) {
                            // Em caso de erro, exibe uma mensagem de erro
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Erro ao inserir pedido: $e')),
                            );
                          }

                          widget.onSave();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Pedido salvo com sucesso!'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                          Navigator.pop(context); // Fecha o formulário
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          backgroundColor: Colors.green.withOpacity(0.7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Salvar',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          backgroundColor: Colors.red.withOpacity(0.7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
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
      ),
    );
  }
}
