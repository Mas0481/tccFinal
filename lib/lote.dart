class Lote {
  final int pedidoNum;
  final int loteNum;

  // 0 representa aguardando, 1 representa iniciado, 2 representa processando, 3 representa concluído
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

  // Dados da centrifugação
  int loteCentrifugacaoStatus;
  String centrifugacaoEquipamento;
  String centrifugacaoTempoProcesso;
  String centrifugacaoDataInicio;
  String centrifugacaoHoraInicio;
  String centrifugacaoDataFinal;
  String centrifugacaoHoraFinal;
  String centrifugacaoObs;

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

  Lote({
    required this.pedidoNum,
    required this.loteNum,
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
  });
}
