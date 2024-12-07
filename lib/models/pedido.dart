import 'package:tcc/models/lote.dart';

class Pedido {
  int? numPedido;
  final int codCliente;
  final double qtdProduto;
  double valorProdutos;
  int pagamento;
  String? dataPagamento;
  double recebimentoStatus;
  double classificacaoStatus;
  double lavagemStatus;
  double centrifugacaoStatus;
  double secagemStatus;
  double passadoriaStatus;
  double finalizacaoStatus;
  double retornoStatus;
  final String dataColeta;
  String? dataRecebimento;
  String? horaRecebimento;
  final String dataLimite;
  final String dataEntrega;
  final double pesoTotal;
  String? recebimentoObs;
  int totalLotes;
  String? classificacaoObs;
  String? classificacaoDataInicio;
  String? classificacaoHoraInicio;
  String? classificacaoDataFinal;
  String? classificacaoHoraFinal;
  String? passadoriaEquipamento;
  String? passadoriaTemperatura;
  String? passadoriaDataInicio;
  String? passadoriaHoraInicio;
  String? passadoriaDataFinal;
  String? passadoriaHoraFinal;
  String? passadoriaObs;
  String? finalizacaoReparo;
  String? finalizacaoEtiquetamento;
  String? finalizacaoTipoEmbalagem;
  String? finalizacaoVolumes;
  String? finalizacaoControleQualidade;
  String? finalizacaoDataInicio;
  String? finalizacaoHoraInicio;
  String? finalizacaoDataFinal;
  String? finalizacaoHoraFinal;
  String? finalizacaoObs;
  String? retornoData;
  String? retornoHoraCarregamento;
  String? retornoVolumes;
  String? retornoNomeMotorista;
  String? retornoVeiculo;
  String? retornoPlaca;
  String? retornoObs;
  String? nomCliente;
  List<Lote> lotes;

  Pedido({
    this.numPedido,
    required this.codCliente,
    required this.qtdProduto,
    required this.valorProdutos,
    required this.pagamento,
    this.dataPagamento,
    required this.recebimentoStatus,
    required this.classificacaoStatus,
    required this.lavagemStatus,
    required this.centrifugacaoStatus,
    required this.secagemStatus,
    required this.passadoriaStatus,
    required this.finalizacaoStatus,
    required this.retornoStatus,
    required this.dataColeta,
    this.dataRecebimento,
    this.horaRecebimento,
    required this.dataLimite,
    required this.dataEntrega,
    required this.pesoTotal,
    this.recebimentoObs,
    required this.totalLotes,
    this.classificacaoObs,
    this.classificacaoDataInicio,
    this.classificacaoHoraInicio,
    this.classificacaoDataFinal,
    this.classificacaoHoraFinal,
    this.passadoriaEquipamento,
    this.passadoriaTemperatura,
    this.passadoriaDataInicio,
    this.passadoriaHoraInicio,
    this.passadoriaDataFinal,
    this.passadoriaHoraFinal,
    this.passadoriaObs,
    this.finalizacaoReparo,
    this.finalizacaoEtiquetamento,
    this.finalizacaoTipoEmbalagem,
    this.finalizacaoVolumes,
    this.finalizacaoControleQualidade,
    this.finalizacaoDataInicio,
    this.finalizacaoHoraInicio,
    this.finalizacaoDataFinal,
    this.finalizacaoHoraFinal,
    this.finalizacaoObs,
    this.retornoData,
    this.retornoHoraCarregamento,
    this.retornoVolumes,
    this.retornoNomeMotorista,
    this.retornoVeiculo,
    this.retornoPlaca,
    this.retornoObs,
    this.nomCliente,
    required this.lotes,
  });

  @override
  String toString() {
    return '''
Pedido {
  numPedido: $numPedido,
  codCliente: $codCliente,
  qtdProduto: $qtdProduto,
  valorProdutos: $valorProdutos,
  pagamento: $pagamento,
  recebimentoStatus: $recebimentoStatus,
  classificacaoStatus: $classificacaoStatus,
  lavagemStatus: $lavagemStatus,
  centrifugacaoStatus: $centrifugacaoStatus,
  secagemStatus: $secagemStatus,
  passadoriaStatus: $passadoriaStatus,
  finalizacaoStatus: $finalizacaoStatus,
  retornoStatus: $retornoStatus,
  dataColeta: $dataColeta,
  dataLimite: $dataLimite,
  dataEntrega: $dataEntrega,
  pesoTotal: $pesoTotal,
  totalLotes: $totalLotes,
  lotes: $lotes,
}''';
  }
}
