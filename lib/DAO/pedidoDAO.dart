import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:tcc/DAO/genericDAO.dart';
import 'package:tcc/DAO/loteDAO.dart';
import 'package:tcc/models/lote.dart';
import 'package:tcc/servicos/connection.dart';

import '../models/pedido.dart';

class PedidoDAO implements GenericDAO<Pedido> {
  @override
  Future<int> insert(Pedido pedido) async {
    final conn = await MySqlConnectionService().getConnection();
    int totalAffectedRows = 0;

    try {
      final result = await conn.query(
        '''
        INSERT INTO pedidos (
          fk_codCliente, qtd_produto, valor_produtos, pagamento, 
          recebimentoStatus, classificacaoStatus, lavagemStatus, 
          centrifugacaoStatus, secagemStatus, passadoriaStatus, 
          finalizacaoStatus, retornoStatus, dataColeta, dataLimite, 
          dataEntrega, pesoTotal, totalLotes, pesoTotalLotes
        ) VALUES (
          ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        )
      ''',
        [
          pedido.codCliente,
          pedido.qtdProduto,
          pedido.valorProdutos,
          pedido.pagamento,
          pedido.recebimentoStatus,
          pedido.classificacaoStatus,
          pedido.lavagemStatus,
          pedido.centrifugacaoStatus,
          pedido.secagemStatus,
          pedido.passadoriaStatus,
          pedido.finalizacaoStatus,
          pedido.retornoStatus,
          pedido.dataColeta,
          pedido.dataLimite,
          pedido.dataEntrega,
          pedido.pesoTotal,
          pedido.totalLotes,
          pedido.pesoTotalLotes,
        ],
      );
      totalAffectedRows += result.affectedRows!;

      // Inserir os lotes relacionados ao pedido
      LoteDAO loteDAO = LoteDAO();
      for (final lote in pedido.lotes) {
        final loteResult = await loteDAO.insert(lote);
        totalAffectedRows += loteResult;
      }
    } finally {
      await conn.close();
    }

    return totalAffectedRows;
  }

  @override
  Future<int> update(Pedido pedido) async {
    final conn = await MySqlConnectionService().getConnection();
    final loteDAO = LoteDAO();
    int totalAffectedRows = 0;

    try {
      // Atualizar dados do pedido
      final pedidoResult = await conn.query('''
      UPDATE pedidos SET
        fk_codCliente = ?, 
        qtd_produto = ?, 
        valor_produtos = ?, 
        pagamento = ?, 
        data_Pagamento = ?, 
        recebimentoStatus = ?, 
        classificacaoStatus = ?, 
        lavagemStatus = ?, 
        centrifugacaoStatus = ?, 
        secagemStatus = ?, 
        passadoriaStatus = ?, 
        finalizacaoStatus = ?, 
        retornoStatus = ?, 
        dataColeta = ?, 
        dataRecebimento = ?, 
        horaRecebimento = ?, 
        dataLimite = ?, 
        dataEntrega = ?, 
        pesoTotal = ?, 
        recebimentoObs = ?, 
        totalLotes = ?, 
        classificacaoObs = ?, 
        classificacaoDataInicio = ?, 
        classificacaoHoraInicio = ?, 
        classificacaoDataFinal = ?, 
        classificacaoHoraFinal = ?, 
        passadoriaEquipamento = ?, 
        passadoriaTemperatura = ?, 
        passadoriaDataInicio = ?, 
        passadoriaHoraInicio = ?, 
        passadoriaDataFinal = ?, 
        passadoriaHoraFinal = ?, 
        passadoriaObs = ?, 
        finalizacaoReparo = ?, 
        finalizacaoEtiquetamento = ?, 
        finalizacaoTipoEmbalagem = ?, 
        finalizacaoVolumes = ?, 
        finalizacaoControleQualidade = ?, 
        finalizacaoDataInicio = ?, 
        finalizacaoHoraInicio = ?, 
        finalizacaoDataFinal = ?, 
        finalizacaoHoraFinal = ?, 
        finalizacaoObs = ?, 
        retornoData = ?, 
        retornoHoraCarregamento = ?, 
        retornoVolumes = ?, 
        retornoNomeMotorista = ?, 
        retornoVeiculo = ?, 
        retornoPlaca = ?, 
        retornoObs = ?,
        pesoTotalLotes = ?
      WHERE codPedido = ?
    ''', [
        pedido.codCliente,
        pedido.qtdProduto,
        pedido.valorProdutos,
        pedido.pagamento,
        pedido.dataPagamento,
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
        pedido.classificacaoDataInicio,
        pedido.classificacaoHoraInicio,
        pedido.classificacaoDataFinal,
        pedido.classificacaoHoraFinal,
        pedido.passadoriaEquipamento,
        pedido.passadoriaTemperatura,
        pedido.passadoriaDataInicio,
        pedido.passadoriaHoraInicio,
        pedido.passadoriaDataFinal,
        pedido.passadoriaHoraFinal,
        pedido.passadoriaObs,
        pedido.finalizacaoReparo,
        pedido.finalizacaoEtiquetamento,
        pedido.finalizacaoTipoEmbalagem,
        pedido.finalizacaoVolumes,
        pedido.finalizacaoControleQualidade,
        pedido.finalizacaoDataInicio,
        pedido.finalizacaoHoraInicio,
        pedido.finalizacaoDataFinal,
        pedido.finalizacaoHoraFinal,
        pedido.finalizacaoObs,
        pedido.retornoData,
        pedido.retornoHoraCarregamento,
        pedido.retornoVolumes,
        pedido.retornoNomeMotorista,
        pedido.retornoVeiculo,
        pedido.retornoPlaca,
        pedido.retornoObs,
        pedido.pesoTotalLotes,
        pedido.numPedido,
      ]);
      totalAffectedRows += pedidoResult.affectedRows!;

      // Atualizar ou inserir lotes
      for (final lote in pedido.lotes) {
        print(
            'Verificando pedidoNum: ${pedido.numPedido}, loteNum: ${lote.loteNum}');
        final result = await conn.query(
          'SELECT COUNT(*) FROM lotes WHERE pedidoNum = ? AND loteNum = ?',
          [pedido.numPedido, lote.loteNum],
        );

        final exists = (result.first[0] as int) > 0;

        if (exists) {
          // Se o lote já existe, atualiza usando o LoteDAO
          print('entrou no update de lote');
          totalAffectedRows += await loteDAO.update(lote);
        } else {
          // Se o lote não existe, insere usando o LoteDAO
          print('entrou no insert');
          totalAffectedRows += await loteDAO.insert(lote);
        }
      }
    } finally {
      await conn.close();
    }

    return totalAffectedRows;
  }

  @override
  Future<Pedido?> getById(int pedidoId) async {
    final conn = await MySqlConnectionService().getConnection();

    try {
      // Buscar o pedido pelo ID
      final pedidoQuery = await conn.query('''
                SELECT 
        p.*, 
        pe.nome AS nome_cliente
      FROM 
        pedidos p
      LEFT JOIN 
        clientes c ON c.codCliente = p.fk_codCliente
      LEFT JOIN 
        pessoas pe ON pe.cpf = c.fk_cpf
      WHERE 
        p.codPedido = ?
    ''', [pedidoId]);

      if (pedidoQuery.isEmpty) {
        return null; // Retorna null se o pedido não for encontrado
      }

      final row = pedidoQuery.first;

      // Buscar os lotes relacionados ao pedido
      final lotesQuery = await conn.query('''
      SELECT * FROM lotes WHERE pedidoNum = ?
    ''', [pedidoId]);

      // Criar a lista de lotes para o pedido
      List<Lote> lotes = lotesQuery.map((loteRow) {
        return Lote(
          pedidoNum: loteRow['pedidoNum'],
          loteNum: loteRow['loteNum'],
          loteStatus: loteRow['loteStatus'] ?? 0,
          loteLavagemStatus: loteRow['loteLavagemStatus'] ?? 0,
          lavagemEquipamento: loteRow['lavagemEquipamento'] ?? '',
          lavagemProcesso: loteRow['lavagemProcesso'] ?? '',
          lavagemDataInicio: loteRow['lavagemDataInicio'] ?? '',
          lavagemHoraInicio: loteRow['lavagemHoraInicio'] ?? '',
          lavagemDataFinal: loteRow['lavagemDataFinal'] ?? '',
          lavagemHoraFinal: loteRow['lavagemHoraFinal'] ?? '',
          lavagemObs: loteRow['lavagemObs'] ?? '',
          loteCentrifugacaoStatus: loteRow['loteCentrifugacaoStatus'] ?? 0,
          centrifugacaoEquipamento: loteRow['centrifugacaoEquipamento'] ?? '',
          centrifugacaoTempoProcesso:
              loteRow['centrifugacaoTempoProcesso'] ?? '',
          centrifugacaoDataInicio: loteRow['centrifugacaoDataInicio'] ?? '',
          centrifugacaoHoraInicio: loteRow['centrifugacaoHoraInicio'] ?? '',
          centrifugacaoDataFinal: loteRow['centrifugacaoDataFinal'] ?? '',
          centrifugacaoHoraFinal: loteRow['centrifugacaoHoraFinal'] ?? '',
          centrifugacaoObs: loteRow['centrifugacaoObs'] ?? '',
          loteSecagemStatus: loteRow['loteSecagemStatus'] ?? 0,
          secagemEquipamento: loteRow['secagemEquipamento'] ?? '',
          secagemTempoProcesso: loteRow['secagemTempoProcesso'] ?? '',
          secagemTemperatura: loteRow['secagemTemperatura'] ?? '',
          secagemDataInicio: loteRow['secagemDataInicio'] ?? '',
          secagemHoraInicio: loteRow['secagemHoraInicio'] ?? '',
          secagemDataFinal: loteRow['secagemDataFinal'] ?? '',
          secagemHoraFinal: loteRow['secagemHoraFinal'] ?? '',
          secagemObs: loteRow['secagemObs'] ?? '',
          peso: loteRow['peso'] ?? 0,
          processo: loteRow['processo'] ?? '',
        );
      }).toList();

      // Construir o objeto Pedido
      return Pedido(
        numPedido: row['codPedido'],
        codCliente: row['fk_codCliente'],
        qtdProduto: row['qtd_produto'],
        valorProdutos: row['valor_produtos'],
        pagamento: row['pagamento'],
        dataPagamento: row['dataPagamento'],
        recebimentoStatus: row['recebimentoStatus'],
        classificacaoStatus: row['classificacaoStatus'],
        lavagemStatus: row['lavagemStatus'],
        centrifugacaoStatus: row['centrifugacaoStatus'],
        secagemStatus: row['secagemStatus'],
        passadoriaStatus: row['passadoriaStatus'],
        finalizacaoStatus: row['finalizacaoStatus'],
        retornoStatus: row['retornoStatus'],
        dataColeta: row['dataColeta'],
        dataRecebimento: row['dataRecebimento'],
        horaRecebimento: row['horaRecebimento'],
        dataLimite: row['dataLimite'],
        dataEntrega: row['dataEntrega'],
        pesoTotal: row['pesoTotal'],
        recebimentoObs: row['recebimentoObs'],
        totalLotes: row['totalLotes'],
        classificacaoObs: row['classificacaoObs'],
        classificacaoDataInicio: row['classificacaoDataInicio'],
        classificacaoHoraInicio: row['classificacaoHoraInicio'],
        classificacaoDataFinal: row['classificacaoDataFinal'],
        classificacaoHoraFinal: row['classificacaoHoraFinal'],
        passadoriaEquipamento: row['passadoriaEquipamento'],
        passadoriaTemperatura: row['passadoriaTemperatura'],
        passadoriaDataInicio: row['passadoriaDataInicio'],
        passadoriaHoraInicio: row['passadoriaHoraInicio'],
        passadoriaDataFinal: row['passadoriaDataFinal'],
        passadoriaHoraFinal: row['passadoriaHoraFinal'],
        passadoriaObs: row['passadoriaObs'],
        finalizacaoReparo: row['finalizacaoReparo'],
        finalizacaoEtiquetamento: row['finalizacaoEtiquetamento'],
        finalizacaoTipoEmbalagem: row['finalizacaoTipoEmbalagem'],
        finalizacaoVolumes: row['finalizacaoVolumes'],
        finalizacaoControleQualidade: row['finalizacaoControleQualidade'],
        finalizacaoDataInicio: row['finalizacaoDataInicio'],
        finalizacaoHoraInicio: row['finalizacaoHoraInicio'],
        finalizacaoDataFinal: row['finalizacaoDataFinal'],
        finalizacaoHoraFinal: row['finalizacaoHoraFinal'],
        finalizacaoObs: row['finalizacaoObs'],
        retornoData: row['retornoData'],
        retornoHoraCarregamento: row['retornoHoraCarregamento'],
        retornoVolumes: row['retornoVolumes'],
        retornoNomeMotorista: row['retornoNomeMotorista'],
        retornoVeiculo: row['retornoVeiculo'],
        retornoPlaca: row['retornoPlaca'],
        retornoObs: row['retornoObs'],
        nomCliente: row['nome_cliente'],
        pesoTotalLotes: row['pesoTotalLotes'],
        lotes: lotes,
      );
    } finally {
      await conn.close();
    }
  }

  @override
  Future<List<Pedido>> getAll() async {
    final conn = await MySqlConnectionService().getConnection();

    //metodo para converter os dados TEXT do Bd que estavam ficando como Blob
    String getObs(dynamic obs) {
      if (obs is List<int>) {
        // Verifica se o campo é BLOB (List<int>)
        return utf8.decode(obs); // Converte BLOB para String
      }
      return obs?.toString() ??
          ''; // Retorna a String ou um campo vazio se for null
    }

    // 1. Obter todos os pedidos organizados por dataEntrega
    final pedidosQuery = await conn.query('''
    SELECT 
      p.*,                          
      pe.nome AS nome_cliente       
    FROM 
      pedidos p
    LEFT JOIN 
      clientes c ON c.codCliente = p.fk_codCliente
    LEFT JOIN 
      pessoas pe ON pe.cpf = c.fk_cpf
    ORDER BY 
      p.dataEntrega ASC;  -- Ordena pela coluna dataEntrega em ordem crescente
  ''');

    // Lista de pedidos que será retornada
    List<Pedido> pedidos = [];

    for (final row in pedidosQuery) {
      // 2. Para cada pedido, buscar seus lotes relacionados
      final lotesQuery = await conn.query('''
      SELECT * FROM lotes WHERE pedidoNum = ?
    ''', [row['codPedido']]);

      // Criar a lista de lotes para o pedido atual
      List<Lote> lotes = lotesQuery.map((loteRow) {
        // Função para garantir que o campo 'obs' seja convertido corretamente para String

        return Lote(
          pedidoNum: loteRow['pedidoNum'],
          loteNum: loteRow['loteNum'],
          loteStatus: loteRow['loteStatus'] ?? 0,
          loteLavagemStatus: loteRow['loteLavagemStatus'] ?? 0,
          lavagemEquipamento: loteRow['lavagemEquipamento'] ?? '',
          lavagemProcesso: loteRow['lavagemProcesso'] ?? '',
          lavagemDataInicio: loteRow['lavagemDataInicio'] ?? '',
          lavagemHoraInicio: loteRow['lavagemHoraInicio'] ?? '',
          lavagemDataFinal: loteRow['lavagemDataFinal'] ?? '',
          lavagemHoraFinal: loteRow['lavagemHoraFinal'] ?? '',
          lavagemObs:
              getObs(loteRow['lavagemObs']), // Converte o campo 'lavagemObs'
          loteCentrifugacaoStatus: loteRow['loteCentrifugacaoStatus'] ?? 0,
          centrifugacaoEquipamento: loteRow['centrifugacaoEquipamento'] ?? '',
          centrifugacaoTempoProcesso:
              loteRow['centrifugacaoTempoProcesso'] ?? '',
          centrifugacaoDataInicio: loteRow['centrifugacaoDataInicio'] ?? '',
          centrifugacaoHoraInicio: loteRow['centrifugacaoHoraInicio'] ?? '',
          centrifugacaoDataFinal: loteRow['centrifugacaoDataFinal'] ?? '',
          centrifugacaoHoraFinal: loteRow['centrifugacaoHoraFinal'] ?? '',
          centrifugacaoObs: loteRow['centrifugacaoObs'] ?? '',
          loteSecagemStatus: loteRow['loteSecagemStatus'] ?? 0,
          secagemEquipamento: loteRow['secagemEquipamento'] ?? '',
          secagemTempoProcesso: loteRow['secagemTempoProcesso'] ?? '',
          secagemTemperatura: loteRow['secagemTemperatura'] ?? '',
          secagemDataInicio: loteRow['secagemDataInicio'] ?? '',
          secagemHoraInicio: loteRow['secagemHoraInicio'] ?? '',
          secagemDataFinal: loteRow['secagemDataFinal'] ?? '',
          secagemHoraFinal: loteRow['secagemHoraFinal'] ?? '',
          secagemObs: loteRow['secagemObs'] ?? '',
          peso: loteRow['peso'] ?? 0,
          processo: loteRow['processo'] ?? '',
        );
      }).toList();

      // 3. Construir o objeto Pedido com todos os campos
      pedidos.add(Pedido(
        numPedido: row['codPedido'],
        codCliente: row['fk_codCliente'],
        qtdProduto: row['qtd_produto'],
        valorProdutos: row['valor_produtos'],
        pagamento: row['pagamento'],
        dataPagamento: row['dataPagamento'],
        recebimentoStatus: row['recebimentoStatus'],
        classificacaoStatus: row['classificacaoStatus'],
        lavagemStatus: row['lavagemStatus'],
        centrifugacaoStatus: row['centrifugacaoStatus'],
        secagemStatus: row['secagemStatus'],
        passadoriaStatus: row['passadoriaStatus'],
        finalizacaoStatus: row['finalizacaoStatus'],
        retornoStatus: row['retornoStatus'],
        dataColeta: row['dataColeta'],
        dataRecebimento: row['dataRecebimento'],
        horaRecebimento: row['horaRecebimento'],
        dataLimite: row['dataLimite'],
        dataEntrega: row['dataEntrega'],
        pesoTotal: row['pesoTotal'],
        totalLotes: row['totalLotes'],
        classificacaoDataInicio: row['classificacaoDataInicio'],
        classificacaoHoraInicio: row['classificacaoHoraInicio'],
        classificacaoDataFinal: row['classificacaoDataFinal'],
        classificacaoHoraFinal: row['classificacaoHoraFinal'],
        passadoriaEquipamento: row['passadoriaEquipamento'],
        passadoriaTemperatura: row['passadoriaTemperatura'],
        passadoriaDataInicio: row['passadoriaDataInicio'],
        passadoriaHoraInicio: row['passadoriaHoraInicio'],
        passadoriaDataFinal: row['passadoriaDataFinal'],
        passadoriaHoraFinal: row['passadoriaHoraFinal'],
        finalizacaoReparo: row['finalizacaoReparo'],
        finalizacaoEtiquetamento: row['finalizacaoEtiquetamento'],
        finalizacaoTipoEmbalagem: row['finalizacaoTipoEmbalagem'],
        finalizacaoVolumes: row['finalizacaoVolumes'],
        finalizacaoControleQualidade: row['finalizacaoControleQualidade'],
        finalizacaoDataInicio: row['finalizacaoDataInicio'],
        finalizacaoHoraInicio: row['finalizacaoHoraInicio'],
        finalizacaoDataFinal: row['finalizacaoDataFinal'],
        finalizacaoHoraFinal: row['finalizacaoHoraFinal'],
        retornoData: row['retornoData'],
        retornoHoraCarregamento: row['retornoHoraCarregamento'],
        retornoVolumes: row['retornoVolumes'],
        retornoNomeMotorista: row['retornoNomeMotorista'],
        retornoVeiculo: row['retornoVeiculo'],
        retornoPlaca: row['retornoPlaca'],
        // Convertendo os campos obs
        recebimentoObs: getObs(row['recebimentoObs']),
        classificacaoObs: getObs(row['classificacaoObs']),
        passadoriaObs: getObs(row['passadoriaObs']),
        finalizacaoObs: getObs(row['finalizacaoObs']),
        retornoObs: getObs(row['retornoObs']),
        nomCliente: row['nome_cliente'],
        pesoTotalLotes: row['pesoTotalLotes'],
        lotes: lotes,
      ));
    }

    return pedidos;
  }

  @override
  Future<int> delete(int pedidoId) async {
    final conn = await MySqlConnectionService().getConnection();
    int totalAffectedRows = 0;

    try {
      // Deletar os lotes relacionados ao pedido
      final lotesResult = await conn.query('''
      DELETE FROM lotes WHERE pedidoNum = ?
    ''', [pedidoId]);
      totalAffectedRows += lotesResult.affectedRows!;

      // Deletar o pedido
      final pedidoResult = await conn.query('''
      DELETE FROM pedidos WHERE codPedido = ?
    ''', [pedidoId]);
      totalAffectedRows += pedidoResult.affectedRows!;
    } finally {
      await conn.close();
    }

    return totalAffectedRows;
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
