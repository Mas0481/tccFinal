class Lote {
  final int pedidoNum;
  int loteNum;
  double peso;
  String processo;
  String loteResponsavel;

  // 0 representa aguardando, 1 representa iniciado, 2 representa concluído
  int loteStatus;

  // Dados da lavagem
  int loteLavagemStatus;
  String lavagemEquipamento;
  String lavagemProcesso;
  String lavagemDataInicio;
  String lavagemHoraInicio;
  String lavagemDataFinal;
  String lavagemHoraFinal;
  String lavagemObs;
  String lavagemResponsavel;

  // Dados da centrifugação
  int loteCentrifugacaoStatus;
  String centrifugacaoEquipamento;
  String centrifugacaoTempoProcesso;
  String centrifugacaoDataInicio;
  String centrifugacaoHoraInicio;
  String centrifugacaoDataFinal;
  String centrifugacaoHoraFinal;
  String centrifugacaoObs;
  String centrifugacaoResponsavel;

  // Dados da secagem
  int loteSecagemStatus;
  String secagemEquipamento;
  String secagemTempoProcesso;
  String secagemTemperatura;
  String secagemDataInicio;
  String secagemHoraInicio;
  String secagemDataFinal;
  String secagemHoraFinal;
  String secagemObs;
  String secagemResponsavel;

  Lote({
    required this.pedidoNum,
    required this.loteNum,
    required this.peso,
    required this.processo,
    this.loteStatus = 0,
    this.loteLavagemStatus = 0,
    this.lavagemEquipamento = '',
    this.lavagemProcesso = '',
    this.lavagemDataInicio = '',
    this.lavagemHoraInicio = '',
    this.lavagemDataFinal = '',
    this.lavagemHoraFinal = '',
    this.lavagemObs = '',
    this.loteCentrifugacaoStatus = 0,
    this.centrifugacaoEquipamento = '',
    this.centrifugacaoTempoProcesso = '',
    this.centrifugacaoDataInicio = '',
    this.centrifugacaoHoraInicio = '',
    this.centrifugacaoDataFinal = '',
    this.centrifugacaoHoraFinal = '',
    this.centrifugacaoObs = '',
    this.loteSecagemStatus = 0,
    this.secagemEquipamento = '',
    this.secagemTempoProcesso = '',
    this.secagemTemperatura = '',
    this.secagemDataInicio = '',
    this.secagemHoraInicio = '',
    this.secagemDataFinal = '',
    this.secagemHoraFinal = '',
    this.secagemObs = '',
    this.lavagemResponsavel = '',
    this.centrifugacaoResponsavel = '',
    this.secagemResponsavel = '',
    this.loteResponsavel = '',
  });

  @override
  String toString() {
    return 'Lote(pedidoNum: $pedidoNum, loteNum: $loteNum, peso: $peso, processo: $processo, loteStatus: $loteStatus, '
        'loteLavagemStatus: $loteLavagemStatus, lavagemEquipamento: $lavagemEquipamento, '
        'lavagemProcesso: $lavagemProcesso, lavagemDataInicio: $lavagemDataInicio, '
        'lavagemHoraInicio: $lavagemHoraInicio, lavagemDataFinal: $lavagemDataFinal, '
        'lavagemHoraFinal: $lavagemHoraFinal, lavagemObs: $lavagemObs, '
        'loteCentrifugacaoStatus: $loteCentrifugacaoStatus, centrifugacaoEquipamento: $centrifugacaoEquipamento, '
        'centrifugacaoTempoProcesso: $centrifugacaoTempoProcesso, centrifugacaoDataInicio: $centrifugacaoDataInicio, '
        'centrifugacaoHoraInicio: $centrifugacaoHoraInicio, centrifugacaoDataFinal: $centrifugacaoDataFinal, '
        'centrifugacaoHoraFinal: $centrifugacaoHoraFinal, centrifugacaoObs: $centrifugacaoObs, '
        'loteSecagemStatus: $loteSecagemStatus, secagemEquipamento: $secagemEquipamento, '
        'secagemTempoProcesso: $secagemTempoProcesso, secagemTemperatura: $secagemTemperatura, '
        'secagemDataInicio: $secagemDataInicio, secagemHoraInicio: $secagemHoraInicio, '
        'secagemDataFinal: $secagemDataFinal, secagemHoraFinal: $secagemHoraFinal, '
        'secagemObs: $secagemObs, lavagemResponsavel: $lavagemResponsavel, '
        'centrifugacaoResponsavel: $centrifugacaoResponsavel, secagemResponsavel: $secagemResponsavel, '
        'loteResponsavel: $loteResponsavel)';
  }
}
