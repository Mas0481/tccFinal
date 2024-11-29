import 'package:tcc/DAO/pedidoDAO.dart';
import 'package:tcc/models/pedido.dart';

class PedidoRepository {
  final PedidoDAO _pedidoDAO = PedidoDAO();

  // Lista de pedidos
  List<Pedido> _pedidos = [];

  // Getter para acessar a lista
  List<Pedido> get pedidos => List.unmodifiable(_pedidos);

  // Carregar pedidos do banco e organizar por dataEntrega
  Future<void> carregarPedidos() async {
    print("entrou no repository");
    final pedidosCarregados = await _pedidoDAO.getAll();

    _pedidos = pedidosCarregados
      ..sort((a, b) => a.dataEntrega.compareTo(b.dataEntrega));
  }

  // Adicionar ou atualizar um pedido na lista
  Future<void> salvarPedido(Pedido pedido) async {
    if (_pedidos.any((p) => p.numPedido == pedido.numPedido)) {
      await _pedidoDAO.update(pedido);
    } else {
      await _pedidoDAO.insert(pedido);
    }
    await carregarPedidos(); // Atualizar a lista
  }

  // Remover um pedido
  Future<void> removerPedido(int id) async {
    await _pedidoDAO.delete(id);
    await carregarPedidos(); // Atualizar a lista
  }
}
