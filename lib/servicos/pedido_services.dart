import 'package:tcc/servicos/connection.dart';

import '../pedido.dart';

class PedidoService {
  final MySqlConnectionService connectionService = MySqlConnectionService();

  Future<void> inserirPedido(Pedido pedido) async {
    final conn = await connectionService.getConnection();
    await conn.query(
      '''
      INSERT INTO pedidos (codCliente, recebimentoStatus, classificacaoStatus, lavagemStatus, centrifugacaoStatus, secagemStatus, passadoriaStatus, finalizacaoStatus, retornoStatus, dataColeta, dataRecebimento, horaRecebimento, dataLimite, dataEntrega, pesoTotal, recebimentoObs, totalLotes, classificacaoObs)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        pedido.codCliente,
        pedido.recebimentoStatus,
        pedido.classificacaoStatus,
        pedido.lavagemStatus,
        pedido.centrifugacaoStatus,
        pedido.secagemStatus,
        pedido.passadoriaStatus,
        pedido.finalizacaoStatus,
        pedido.retornoStatus,
        pedido.dataColeta,
        pedido.dataRecebimento,
        pedido.horaRecebimento,
        pedido.dataLimite,
        pedido.dataEntrega,
        pedido.pesoTotal,
        pedido.recebimentoObs,
        pedido.totalLotes,
        pedido.classificacaoObs,
      ],
    );
    await conn.close();
  }

  // Funções de busca e atualização podem ser implementadas de forma semelhante
}
