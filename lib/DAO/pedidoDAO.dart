import 'package:intl/intl.dart';
import 'package:tcc/DAO/genericDAO.dart';
import 'package:tcc/servicos/connection.dart';

import '../models/pedido.dart';

class PedidoDAO implements GenericDAO<Pedido> {
  @override
  Future<int> insert(Pedido pedido) async {
    final conn = await MySqlConnectionService().getConnection();
    try {
      final result = await conn.query(
        '''
        INSERT INTO pedidos (
          codCliente, nomeCliente, numPedido, dataColeta, dataRecebimento,
          horaRecebimento, dataLimite, dataEntrega, pesoTotal
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''',
        [
          pedido.codCliente,
          //pedido.nomeCliente,
          pedido.numPedido,
          pedido.dataColeta,
          pedido.dataRecebimento,
          pedido.horaRecebimento,
          pedido.dataLimite,
          pedido.dataEntrega,
          pedido.pesoTotal,
        ],
      );
      return result.insertId!;
    } finally {
      await conn.close();
    }
  }

  @override
  Future<int> update(Pedido pedido) async {
    final conn = await MySqlConnectionService().getConnection();
    try {
      final result = await conn.query(
        '''
        UPDATE pedidos SET
          codCliente = ?, nomeCliente = ?, numPedido = ?, dataColeta = ?,
          dataRecebimento = ?, horaRecebimento = ?, dataLimite = ?, dataEntrega = ?, pesoTotal = ?
        WHERE numPedido = ?
        ''',
        [
          pedido.codCliente,
          // pedido.nomeCliente,
          pedido.numPedido,
          pedido.dataColeta,
          pedido.dataRecebimento,
          pedido.horaRecebimento,
          pedido.dataLimite,
          pedido.dataEntrega,
          pedido.pesoTotal,
          pedido.numPedido,
        ],
      );
      return result.affectedRows!;
    } finally {
      await conn.close();
    }
  }

  @override
  Future<int> delete(int id) async {
    final conn = await MySqlConnectionService().getConnection();
    try {
      final result = await conn.query(
        'DELETE FROM pedidos WHERE numPedido = ?',
        [id],
      );
      return result.affectedRows!;
    } finally {
      await conn.close();
    }
  }

  @override
  Future<Pedido?> getById(int id) async {
    final conn = await MySqlConnectionService().getConnection();
    try {
      final result = await conn.query(
        'SELECT * FROM pedidos WHERE codPedido = ?',
        [id],
      );
      if (result.isEmpty) return null;

      final pedido = Pedido(
        numPedido: result.first['codPedido'],
        codCliente: result.first['fk_codCliente'],
        qtdProduto: result.first['qtd_produto'],
        valorProdutos: result.first['valor_produtos'],
        pagamento: result.first['pagamento'],
        recebimentoStatus: result.first['recebimentoStatus'],
        classificacaoStatus: result.first['classificacaoStatus'],
        lavagemStatus: result.first['lavagemStatus'],
        centrifugacaoStatus: result.first['centrifugacaoStatus'],
        secagemStatus: result.first['secagemStatus'],
        passadoriaStatus: result.first['passadoriaStatus'],
        finalizacaoStatus: result.first['finalizacaoStatus'],
        retornoStatus: result.first['retornoStatus'],
        dataColeta: result.first['dataColeta'],
        dataLimite: result.first['dataLimite'],
        dataEntrega: result.first['dataEntrega'],
        pesoTotal: result.first['pesoTotal'],
        totalLotes: result.first['totalLotes'],
        lotes: [], // Lista vazia como padrão
      );
      return pedido;
    } finally {
      await conn.close();
    }
  }

  @override
  Future<List<Pedido>> getAll() async {
    final conn = await MySqlConnectionService().getConnection();
    try {
      final result = await conn.query('SELECT * FROM pedidos');
      return result.map((row) {
        return Pedido(
          numPedido: row['codPedido'],
          codCliente: row['fk_codCliente'],
          qtdProduto: row['qtd_produto'],
          valorProdutos: row['valor_produtos'],
          pagamento: row['pagamento'],
          recebimentoStatus: row['recebimentoStatus'],
          classificacaoStatus: row['classificacaoStatus'],
          lavagemStatus: row['lavagemStatus'],
          centrifugacaoStatus: row['centrifugacaoStatus'],
          secagemStatus: row['secagemStatus'],
          passadoriaStatus: row['passadoriaStatus'],
          finalizacaoStatus: row['finalizacaoStatus'],
          retornoStatus: row['retornoStatus'],
          dataColeta: row['dataColeta'],
          dataLimite: row['dataLimite'],
          dataEntrega: row['dataEntrega'],
          pesoTotal: row['pesoTotal'],
          totalLotes: row['totalLotes'],
          lotes: [], // Lista vazia como padrão
        );
      }).toList();
    } finally {
      await conn.close();
    }
  }

  /// Função auxiliar para formatar campos TIME para String no formato 'HH:mm:ss'
  String? formatHora(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) {
      return DateFormat('HH:mm:ss').format(value);
    }
    try {
      return DateFormat('HH:mm:ss').format(DateTime.parse(value.toString()));
    } catch (e) {
      throw FormatException("Erro ao formatar hora: $e");
    }
  }
}
