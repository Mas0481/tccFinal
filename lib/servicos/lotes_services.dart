import 'package:tcc/servicos/connection.dart';

import '../lote.dart';

class LoteService {
  final MySqlConnectionService connectionService = MySqlConnectionService();

  Future<void> inserirLote(Lote lote) async {
    final conn = await connectionService.getConnection();
    await conn.query(
      '''
      INSERT INTO lotes (pedidoNum, loteNum, loteStatus, lavagemEquipamento, lavagemProcesso, lavagemDataInicio, lavagemHoraInicio, lavagemDataFinal, lavagemHoraFinal, lavagemObs, centrifugacaoEquipamento, centrifugacaoTempoProcesso, centrifugacaoDataInicio, centrifugacaoHoraInicio, centrifugacaoDataFinal, centrifugacaoHoraFinal, centrifugacaoObs, secagemEquipamento, secagemTempoProcesso, secagemTemperatura, secagemDataInicio, secagemHoraInicio, secagemDataFinal, secagemHoraFinal, secagemObs)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      [
        lote.pedidoNum,
        lote.loteNum,
        lote.loteStatus,
        lote.lavagemEquipamento,
        lote.lavagemProcesso,
        lote.lavagemDataInicio,
        lote.lavagemHoraInicio,
        lote.lavagemDataFinal,
        lote.lavagemHoraFinal,
        lote.lavagemObs,
        lote.centrifugacaoEquipamento,
        lote.centrifugacaoTempoProcesso,
        lote.centrifugacaoDataInicio,
        lote.centrifugacaoHoraInicio,
        lote.centrifugacaoDataFinal,
        lote.centrifugacaoHoraFinal,
        lote.centrifugacaoObs,
        lote.secagemEquipamento,
        lote.secagemTempoProcesso,
        lote.secagemTemperatura,
        lote.secagemDataInicio,
        lote.secagemHoraInicio,
        lote.secagemDataFinal,
        lote.secagemHoraFinal,
        lote.secagemObs,
      ],
    );
    await conn.close();
  }

  // Funções de busca e atualização podem ser implementadas de forma semelhante
}
