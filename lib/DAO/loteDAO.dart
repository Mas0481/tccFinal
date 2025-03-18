import 'package:tcc/models/lote.dart';
import 'package:tcc/servicos/connection.dart';
import 'genericDAO.dart';

class LoteDAO implements GenericDAO<Lote> {
  @override
  Future<int> insert(Lote lote) async {
    final conn = await MySqlConnectionService().getConnection();
    try {
      final result = await conn.query(
        '''
        INSERT INTO lotes (
          pedidoNum, loteNum, loteStatus
        ) VALUES (?, ?, ?)
        ''',
        [
          lote.pedidoNum,
          lote.loteNum,
          lote.loteStatus,
        ],
      );
      return result.insertId!;
    } finally {
      await conn.close();
    }
  }

  @override
  Future<int> update(Lote lote) async {
    final conn = await MySqlConnectionService().getConnection();
    try {
      final result = await conn.query(
        '''
        UPDATE lotes SET
          loteStatus = ?
        WHERE pedidoNum = ? AND loteNum = ?
        ''',
        [
          lote.loteStatus,
          lote.pedidoNum,
          lote.loteNum,
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
        'DELETE FROM lotes WHERE loteNum = ?',
        [id],
      );
      return result.affectedRows!;
    } finally {
      await conn.close();
    }
  }

  @override
  Future<Lote?> getById(int id) async {
    final conn = await MySqlConnectionService().getConnection();
    try {
      final result = await conn.query(
        'SELECT * FROM lotes WHERE loteNum = ?',
        [id],
      );
      if (result.isEmpty) return null;

      final lote = Lote(
        pedidoNum: result.first['pedidoNum'],
        loteNum: result.first['loteNum'],
        loteStatus: result.first['loteStatus'],
        peso: result.first['peso'],
        processo: result.first['processo'],
        status: result.first['status'],
      );
      return lote;
    } finally {
      await conn.close();
    }
  }

  @override
  Future<List<Lote>> getAll() async {
    final conn = await MySqlConnectionService().getConnection();
    try {
      final result = await conn.query('SELECT * FROM pedidos');
      return result.map((row) {
        return Lote(
          pedidoNum: row['pedidoNum'],
          loteNum: row['loteNum'],
          loteStatus: row['loteStatus'],
          peso: row['peso'],
          processo: row['processo'],
          status: row['status'],
        );
      }).toList();
    } finally {
      await conn.close();
    }
  }
}
