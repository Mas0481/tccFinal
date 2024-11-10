class Lote {
  final int pedidoNum;
  late int loteNum;

  // 0 representa aguardando, 1 representa iniciado, 2 representa processando, 3 representa concluído
  int loteStatus = 0;

  //dados da lavagem
  late String lavagemEquipamento;
  late String lavagemProcesso;
  late String lavagemDataInicio;
  late String lavagemHoraInicio;
  late String lavagemDataFinal;
  late String lavagemHoraFinal;
  late String lavagemObs;

  //dados da centrifugação
  late String centrifugacaoEquipamento;
  late String centrifugacaoTempoProcesso;
  late String centrifugacaoDataInicio;
  late String centrifugacaoHoraInicio;
  late String centrifugacaoDataFinal;
  late String centrifugacaoHoraFinal;
  late String centrifugacaoObs;

  //dados da secagem
  late String secagemEquipamento;
  late String secagemTempoProcesso;
  late String secagemTemperatura;
  late String secagemDataInicio;
  late String secagemHoraInicio;
  late String secagemDataFinal;
  late String secagemHoraFinal;
  late String secagemObs;

  Lote({required this.pedidoNum});
}
