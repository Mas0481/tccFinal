import 'package:tcc/models/lote.dart';
import 'package:tcc/servicos/connection.dart';
import 'genericDAO.dart';

class LoteDAO implements GenericDAO<Lote> {
  @override
  Future<int> insert(Lote lote) async {
    final conn = await MySqlConnectionService().getConnection();
    try {
      final result = await conn.query('''
        INSERT INTO lotes (
          pedidoNum, loteNum, loteStatus, loteLavagemStatus, lavagemEquipamento, 
          lavagemProcesso, lavagemDataInicio, lavagemHoraInicio, lavagemDataFinal, 
          lavagemHoraFinal, lavagemObs, loteCentrifugacaoStatus, centrifugacaoEquipamento, 
          centrifugacaoTempoProcesso, centrifugacaoDataInicio, centrifugacaoHoraInicio, 
          centrifugacaoDataFinal, centrifugacaoHoraFinal, centrifugacaoObs, loteSecagemStatus, 
          secagemEquipamento, secagemTempoProcesso, secagemTemperatura, secagemDataInicio, 
          secagemHoraInicio, secagemDataFinal, secagemHoraFinal, secagemObs, peso, processo
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', [
        lote.pedidoNum,
        lote.loteNum,
        lote.loteStatus,
        lote.loteLavagemStatus,
        lote.lavagemEquipamento,
        lote.lavagemProcesso,
        lote.lavagemDataInicio,
        lote.lavagemHoraInicio,
        lote.lavagemDataFinal,
        lote.lavagemHoraFinal,
        lote.lavagemObs,
        lote.loteCentrifugacaoStatus,
        lote.centrifugacaoEquipamento,
        lote.centrifugacaoTempoProcesso,
        lote.centrifugacaoDataInicio,
        lote.centrifugacaoHoraInicio,
        lote.centrifugacaoDataFinal,
        lote.centrifugacaoHoraFinal,
        lote.centrifugacaoObs,
        lote.loteSecagemStatus,
        lote.secagemEquipamento,
        lote.secagemTempoProcesso,
        lote.secagemTemperatura,
        lote.secagemDataInicio,
        lote.secagemHoraInicio,
        lote.secagemDataFinal,
        lote.secagemHoraFinal,
        lote.secagemObs,
        lote.peso,
        lote.processo,
      ]);
      return result.insertId!;
    } finally {
      await conn.close();
    }
  }

  @override
  Future<int> update(Lote lote) async {
    print('entrou no update lote');
    final conn = await MySqlConnectionService().getConnection();
    try {
      final result = await conn.query(
        '''
        UPDATE lotes SET
loteStatus = ?, loteLavagemStatus = ?, lavagemEquipamento = ?, lavagemProcesso = ?, 
          lavagemDataInicio = ?, lavagemHoraInicio = ?, lavagemDataFinal = ?, lavagemHoraFinal = ?, 
          lavagemObs = ?, loteCentrifugacaoStatus = ?, centrifugacaoEquipamento = ?, 
          centrifugacaoTempoProcesso = ?, centrifugacaoDataInicio = ?, centrifugacaoHoraInicio = ?, 
          centrifugacaoDataFinal = ?, centrifugacaoHoraFinal = ?, centrifugacaoObs = ?, 
          loteSecagemStatus = ?, secagemEquipamento = ?, secagemTempoProcesso = ?, 
          secagemTemperatura = ?, secagemDataInicio = ?, secagemHoraInicio = ?, 
          secagemDataFinal = ?, secagemHoraFinal = ?, secagemObs = ?, peso = ?, processo = ?
        WHERE pedidoNum = ? AND loteNum = ?
        ''',
        [
          lote.loteStatus,
          lote.loteLavagemStatus,
          lote.lavagemEquipamento,
          lote.lavagemProcesso,
          lote.lavagemDataInicio,
          lote.lavagemHoraInicio,
          lote.lavagemDataFinal,
          lote.lavagemHoraFinal,
          lote.lavagemObs,
          lote.loteCentrifugacaoStatus,
          lote.centrifugacaoEquipamento,
          lote.centrifugacaoTempoProcesso,
          lote.centrifugacaoDataInicio,
          lote.centrifugacaoHoraInicio,
          lote.centrifugacaoDataFinal,
          lote.centrifugacaoHoraFinal,
          lote.centrifugacaoObs,
          lote.loteSecagemStatus,
          lote.secagemEquipamento,
          lote.secagemTempoProcesso,
          lote.secagemTemperatura,
          lote.secagemDataInicio,
          lote.secagemHoraInicio,
          lote.secagemDataFinal,
          lote.secagemHoraFinal,
          lote.secagemObs,
          lote.peso,
          lote.processo,
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
        );
      }).toList();
    } finally {
      await conn.close();
    }
  }
}
