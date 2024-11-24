import 'package:tcc/DAO/genericDAO.dart';
import 'package:tcc/util/mySQLConnection.dart';
import '../models/pedido.dart';

class PedidoDAO implements GenericDAO<Pedido> {
  @override
  Future<int> insert(Pedido pedido) async {
    final conn = await MySQLConnection.getConnection();
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
          pedido.nomeCliente,
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
    final conn = await MySQLConnection.getConnection();
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
          pedido.nomeCliente,
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
    final conn = await MySQLConnection.getConnection();
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
    final conn = await MySQLConnection.getConnection();
    try {
      final result = await conn.query(
        'SELECT * FROM pedidos WHERE numPedido = ?',
        [id],
      );
      if (result.isEmpty) return null;

      final pedido = Pedido(
        codCliente: result.first['codCliente'],
        nomeCliente: result.first['nomeCliente'],
        numPedido: result.first['numPedido'],
        dataColeta: result.first['dataColeta'],
        dataRecebimento: result.first['dataRecebimento'],
        horaRecebimento: result.first['horaRecebimento'],
        dataLimite: result.first['dataLimite'],
        dataEntrega: result.first['dataEntrega'],
        pesoTotal: result.first['pesoTotal'],
        lotes: [],
      );
      return pedido;
    } finally {
      await conn.close();
    }
  }

  @override
  Future<List<Pedido>> getAll() async {
    final conn = await MySQLConnection.getConnection();
    try {
      final result = await conn.query('SELECT * FROM pedidos');
      return result.map((row) {
        return Pedido(
          codCliente: row['codCliente'],
          nomeCliente: row['nomeCliente'],
          numPedido: row['numPedido'],
          dataColeta: row['dataColeta'],
          dataRecebimento: row['dataRecebimento'],
          horaRecebimento: row['horaRecebimento'],
          dataLimite: row['dataLimite'],
          dataEntrega: row['dataEntrega'],
          pesoTotal: row['pesoTotal'],
          lotes: [],
        );
      }).toList();
    } finally {
      await conn.close();
    }
  }
}
