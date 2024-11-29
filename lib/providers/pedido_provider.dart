import 'package:flutter/material.dart';
import 'package:tcc/models/pedido.dart';
import 'package:tcc/repository/pedido_repository.dart';

class PedidoProvider extends ChangeNotifier {
  final PedidoRepository _repository = PedidoRepository();

  // Getter para acessar os pedidos
  List<Pedido> get pedidos => _repository.pedidos;

  // Carregar pedidos e notificar listeners
  Future<void> carregarPedidos() async {
    await _repository.carregarPedidos();
    notifyListeners();
  }

  // Salvar um pedido e atualizar o estado
  Future<void> salvarPedido(Pedido pedido) async {
    await _repository.salvarPedido(pedido);
    notifyListeners();
  }

  // Remover um pedido e atualizar o estado
  Future<void> removerPedido(int id) async {
    await _repository.removerPedido(id);
    notifyListeners();
  }
}
