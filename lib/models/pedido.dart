import 'package:tcc/models/lote.dart';
import 'package:tcc/providers/user_provider.dart';

class Pedido {
  int? numPedido;
  final int codCliente;
  final double qtdProduto;
  double valorProdutos;
  int pagamento;
  double pesoTotalLotes = 0.0;
  String? dataPagamento;
  String? pedidoResponsavel;

  //o status do processo tem três níveis 0 - não iniciado, 1 - processando, 2 - concluído
  double recebimentoStatus;
  String? recebimentoResponsavel;
  double classificacaoStatus;
  String? classificacaoResponsavel;
  double lavagemStatus;
  String? lavagemResponsavel;
  double centrifugacaoStatus;
  String? centrifugacaoResponsavel;
  double secagemStatus;
  String? secagemResponsavel;
  double passadoriaStatus;
  String? passadoriaResponsavel;
  double finalizacaoStatus;
  String? finalizacaoResponsavel;
  double retornoStatus;
  String retornoResponsavel = '';

  final String dataColeta;
  String? dataRecebimento;
  String? horaRecebimento;
  final String dataLimite;
  final String dataEntrega;
  double pesoTotal;
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
    required pesoTotalLotes,
    this.recebimentoResponsavel = '',
    this.classificacaoResponsavel = '',
    this.lavagemResponsavel = '',
    this.centrifugacaoResponsavel = '',
    this.secagemResponsavel = '',
    this.passadoriaResponsavel = '',
    this.pedidoResponsavel = '',
    this.finalizacaoResponsavel = '',
    this.retornoResponsavel = '',
  });

  @override
  String toString() {
    return '''
Pedido {
  numPedido: $numPedido,
  codCliente: $codCliente,
  pedidoResponsavel: $pedidoResponsavel,
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
  totalPesoLotes: $pesoTotalLotes,
  recebimentoObs: $recebimentoObs,
  classificacaoObs: $classificacaoObs,
  recebimentoResponsavel: $recebimentoResponsavel,
  classificacaoResponsavel: $classificacaoResponsavel,
  lavagemResponsavel: $lavagemResponsavel,
  finalizacaoObs: $finalizacaoObs,
  finalizacaoReparo: $finalizacaoReparo,
  finalizacaoEtiquetamento: $finalizacaoEtiquetamento,
  finalizacaoTipoEmbalagem: $finalizacaoTipoEmbalagem,
  finalizacaoVolumes: $finalizacaoVolumes,
  finalizacaoControleQualidade: $finalizacaoControleQualidade,
  finalizacaoDataInicio: $finalizacaoDataInicio,
  finalizacaoHoraInicio: $finalizacaoHoraInicio,
  finalizacaoDataFinal: $finalizacaoDataFinal,
  finalizacaoHoraFinal: $finalizacaoHoraFinal,
  finalizacaoObs: $finalizacaoObs,
  retornoData: $retornoData,
  retornoHoraCarregamento: $retornoHoraCarregamento,
  retornoVolumes: $retornoVolumes,
  retornoNomeMotorista: $retornoNomeMotorista,
  retornoVeiculo: $retornoVeiculo,
  retornoPlaca: $retornoPlaca,
  retornoObs: $retornoObs,
  nomCliente: $nomCliente,
  dataRecebimento: $dataRecebimento,
  horaRecebimento: $horaRecebimento,
  dataPagamento: $dataPagamento,
  dataLimite: $dataLimite,
  dataEntrega: $dataEntrega,
  pesoTotal: $pesoTotal,
  recebimentoObs: $recebimentoObs,
  totalLotes: $totalLotes,
  classificacaoObs: $classificacaoObs,
  classificacaoDataInicio: $classificacaoDataInicio,
  classificacaoHoraInicio: $classificacaoHoraInicio,
  classificacaoDataFinal: $classificacaoDataFinal,
  classificacaoHoraFinal: $classificacaoHoraFinal,
  passadoriaEquipamento: $passadoriaEquipamento,
  passadoriaTemperatura: $passadoriaTemperatura,
  passadoriaDataInicio: $passadoriaDataInicio,
  passadoriaHoraInicio: $passadoriaHoraInicio,
  passadoriaDataFinal: $passadoriaDataFinal,
  passadoriaHoraFinal: $passadoriaHoraFinal,
  passadoriaObs: $passadoriaObs,
  
     lotes: $lotes,
}''';
  }
}
