import 'package:flutter/material.dart';
import 'package:tcc/DAO/pedidoDAO.dart';
import 'package:tcc/forms/vizualizar_pedido.dart';
import 'package:tcc/models/pedido.dart'; // Modelo Pedido

class Pedidos extends StatefulWidget {
  @override
  _PedidosState createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  List<Pedido> pedidos = []; // Lista de pedidos que será exibida

  @override
  void initState() {
    super.initState();
    _loadPedidos(); // Carregar os pedidos ao inicializar
  }

  // Método para carregar os pedidos do banco de dados
  Future<void> _loadPedidos() async {
    final pedidoDAO = PedidoDAO(); // Criando uma instância do PedidoDAO
    List<Pedido> fetchedPedidos =
        await pedidoDAO.getAll(); // Buscando os pedidos
    setState(() {
      pedidos = fetchedPedidos; // Atualizando o estado com os pedidos
    });
  }

  // Função para visualizar o pedido
  void _visualizarPedido(String numero) {
    // Lógica para visualizar o pedido
    print('Visualizar pedido $numero');
  }

  // Função para apagar o pedido
  Future<void> _apagarPedido(int index) async {
    final pedido = pedidos[index];
    // Exibir o dialog de confirmação
    bool? confirmacao = await _showDeleteConfirmationDialog();

    if (confirmacao == true) {
      // Excluir do banco de dados
      final pedidoDAO = PedidoDAO();
      await pedidoDAO
          .delete(pedido.numPedido!); // Chama o método de exclusão do DAO

      // Remover da lista e exibir a Snackbar
      setState(() {
        pedidos.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pedido ${pedido.numPedido} excluído com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Método para exibir o dialog de confirmação de exclusão
  Future<bool?> _showDeleteConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Você tem certeza que deseja excluir este pedido?'),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(false), // Cancela a exclusão
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(true), // Confirma a exclusão
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
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
          width: MediaQuery.of(context).size.width * 0.7,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Image.asset(
                    'lib/images/logo.png',
                    width: 200,
                    height: 130,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, size: 150);
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Pedidos',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Cor preta para o título
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Verificar se há pedidos
              pedidos.isEmpty
                  ? Center(
                      child: Text(
                        'Sem Pedidos Registrados',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.red,
                        ),
                      ),
                    ) // Exibe a mensagem se não houver pedidos
                  : Container(
                      height: MediaQuery.of(context).size.height *
                          0.5, // Definir altura para permitir rolagem
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: pedidos.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            elevation:
                                5, // Sombra para um visual mais agradável
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10), // Bordas arredondadas
                            ),
                            color:
                                Colors.grey[200], // Fundo cinza para as linhas
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12), // Espaçamento interno
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Primeira linha: Pedido
                                  Row(
                                    children: [
                                      Text(
                                        'Pedido: ${pedidos[index].numPedido}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors
                                              .black87, // Cor preta para o número do pedido
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),

                                  // Segunda linha: Cliente
                                  Row(
                                    children: [
                                      Text(
                                        'Cliente: ${pedidos[index].nomCliente}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors
                                              .black87, // Cor preta para o nome do cliente
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),

                                  // Terceira linha: Data de Entrega (em destaque)
                                  Row(
                                    children: [
                                      Text(
                                        'Data de Entrega: ${pedidos[index].dataEntrega}',
                                        style: TextStyle(
                                          fontSize:
                                              18, // Maior que as outras datas
                                          fontWeight:
                                              FontWeight.bold, // Em negrito
                                          color: Colors
                                              .red, // Cor vermelha para destacar
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Ícone de visualização (aumentado)
                                  IconButton(
                                    icon: Icon(Icons.visibility,
                                        size: 30, color: Colors.blue),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return VisualizarPedido(
                                              pedido: pedidos[
                                                  index]); // Passa o pedido selecionado
                                        },
                                      );
                                    },
                                  ),
                                  // Ícone de exclusão (aumentado)
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        size: 30, color: Colors.red),
                                    onPressed: () => _apagarPedido(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

              SizedBox(height: 20),

              // Botão de Fechar com fundo azul
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.blue, // Botão Fechar azul
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Fechar',
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
