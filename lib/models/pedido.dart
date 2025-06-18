import 'package:tcc/models/lote.dart';

class Pedido {
  int? numPedido;
  final int codCliente;
  int? pedidoStatus;
  final double qtdProduto;
  double valorProdutos;
  int pagamento;
  double pesoTotalLotes;
  String? dataPagamento;
  String? pedidoResponsavel;
  String? pedidoObs;
  String? respContratadaNaColeta;
  String? respContratanteNaColeta;
  String? respContratadaNaEntrega;
  String? respContratanteNaEntrega;

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
  String? retornoResponsavel = '';

  final String dataColeta;
  String? dataRecebimento;
  String? horaRecebimento;
  String dataLimite;
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
  String? enderecoEntrega;
  String? retornoVolumes;
  String? retornoNomeMotorista;
  String? retornoVeiculo;
  String? retornoPlaca;
  String? retornoObs;
  String? retornoDataEntrega;
  String? retornoHoraEntrega;
  String? nomCliente;
  List<Lote> lotes;

  Pedido({
    this.numPedido = 0,
    required this.codCliente,
    required this.qtdProduto,
    this.pedidoStatus = 0,
    this.valorProdutos = 0,
    this.pagamento = 0,
    this.dataPagamento = "",
    this.pedidoResponsavel = "",
    this.pedidoObs = "",
    this.recebimentoStatus = 0,
    this.recebimentoResponsavel = "",
    this.classificacaoStatus = 0,
    this.classificacaoResponsavel = "",
    this.lavagemStatus = 0,
    this.lavagemResponsavel = "",
    this.centrifugacaoStatus = 0,
    this.centrifugacaoResponsavel = "",
    this.secagemStatus = 0,
    this.secagemResponsavel = "",
    this.passadoriaStatus = 0,
    this.passadoriaResponsavel = "",
    this.finalizacaoStatus = 0,
    this.finalizacaoResponsavel = "",
    this.retornoStatus = 0,
    this.retornoResponsavel = "",
    required this.dataColeta,
    this.dataRecebimento = "",
    this.horaRecebimento = "",
    required this.dataLimite,
    required this.dataEntrega,
    this.pesoTotal = 0,
    this.recebimentoObs = "",
    this.totalLotes = 0,
    this.classificacaoObs = "",
    this.classificacaoDataInicio = "",
    this.classificacaoHoraInicio = "",
    this.classificacaoDataFinal = "",
    this.classificacaoHoraFinal = "",
    this.passadoriaEquipamento = "",
    this.passadoriaTemperatura = "",
    this.passadoriaDataInicio = "",
    this.passadoriaHoraInicio = "",
    this.passadoriaDataFinal = "",
    this.passadoriaHoraFinal = "",
    this.passadoriaObs = "",
    this.finalizacaoReparo = "",
    this.finalizacaoEtiquetamento = "",
    this.finalizacaoTipoEmbalagem = "",
    this.finalizacaoVolumes = "",
    this.finalizacaoControleQualidade = "",
    this.finalizacaoDataInicio = "",
    this.finalizacaoHoraInicio = "",
    this.finalizacaoDataFinal = "",
    this.finalizacaoHoraFinal = "",
    this.finalizacaoObs = "",
    this.retornoData = "",
    this.retornoHoraCarregamento = "",
    this.enderecoEntrega = "",
    this.retornoVolumes = "",
    this.retornoNomeMotorista = "",
    this.retornoVeiculo = "",
    this.retornoPlaca = "",
    this.retornoObs = "",
    this.retornoDataEntrega = "",
    this.retornoHoraEntrega = "",
    this.nomCliente = "",
    required this.lotes,
    this.pesoTotalLotes = 0,
    this.respContratadaNaColeta = "",
    this.respContratanteNaColeta = "",
    this.respContratadaNaEntrega = "",
    this.respContratanteNaEntrega = "",
  });

  @override
  String toString() {
    return '''
Pedido {
  numPedido: ${numPedido ?? 0},
  codCliente: $codCliente,
  pedidoResponsavel: ${pedidoResponsavel ?? ""},
  pedidoStatus: $pedidoStatus,
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
  recebimentoObs: ${recebimentoObs ?? ""},
  classificacaoObs: ${classificacaoObs ?? ""},
  recebimentoResponsavel: ${recebimentoResponsavel ?? ""},
  classificacaoResponsavel: ${classificacaoResponsavel ?? ""},
  lavagemResponsavel: ${lavagemResponsavel ?? ""},
  finalizacaoObs: ${finalizacaoObs ?? ""},
  finalizacaoReparo: ${finalizacaoReparo ?? ""},
  finalizacaoEtiquetamento: ${finalizacaoEtiquetamento ?? ""},
  finalizacaoTipoEmbalagem: ${finalizacaoTipoEmbalagem ?? ""},
  finalizacaoVolumes: ${finalizacaoVolumes ?? ""},
  finalizacaoControleQualidade: ${finalizacaoControleQualidade ?? ""},
  finalizacaoDataInicio: ${finalizacaoDataInicio ?? ""},
  finalizacaoHoraInicio: ${finalizacaoHoraInicio ?? ""},
  finalizacaoDataFinal: ${finalizacaoDataFinal ?? ""},
  finalizacaoHoraFinal: ${finalizacaoHoraFinal ?? ""},
  finalizacaoObs: ${finalizacaoObs ?? ""},
  retornoData: ${retornoData ?? ""},
  retornoHoraCarregamento: ${retornoHoraCarregamento ?? ""},
  retornoVolumes: ${retornoVolumes ?? ""},
  retornoNomeMotorista: ${retornoNomeMotorista ?? ""},
  retornoVeiculo: ${retornoVeiculo ?? ""},
  retornoPlaca: ${retornoPlaca ?? ""},
  retornoObs: ${retornoObs ?? ""},
  nomCliente: ${nomCliente ?? ""},
  dataRecebimento: ${dataRecebimento ?? ""},
  horaRecebimento: ${horaRecebimento ?? ""},
  dataPagamento: ${dataPagamento ?? ""},
  dataLimite: $dataLimite,
  dataEntrega: $dataEntrega,
  pesoTotal: $pesoTotal,
  recebimentoObs: ${recebimentoObs ?? ""},
  totalLotes: $totalLotes,
  classificacaoObs: ${classificacaoObs ?? ""},
  classificacaoDataInicio: ${classificacaoDataInicio ?? ""},
  classificacaoHoraInicio: ${classificacaoHoraInicio ?? ""},
  classificacaoDataFinal: ${classificacaoDataFinal ?? ""},
  classificacaoHoraFinal: ${classificacaoHoraFinal ?? ""},
  passadoriaEquipamento: ${passadoriaEquipamento ?? ""},
  passadoriaTemperatura: ${passadoriaTemperatura ?? ""},
  passadoriaDataInicio: ${passadoriaDataInicio ?? ""},
  passadoriaHoraInicio: ${passadoriaHoraInicio ?? ""},
  passadoriaDataFinal: ${passadoriaDataFinal ?? ""},
  passadoriaHoraFinal: ${passadoriaHoraFinal ?? ""},
  passadoriaObs: ${passadoriaObs ?? ""},
  enderecoEntrega: ${enderecoEntrega ?? ""},
  retornoData: ${retornoData ?? ""},
  retornoHoraCarregamento: ${retornoHoraCarregamento ?? ""},
  retornoVolumes: ${retornoVolumes ?? ""},
  retornoNomeMotorista: ${retornoNomeMotorista ?? ""},
  retornoVeiculo: ${retornoVeiculo ?? ""},
  retornoPlaca: ${retornoPlaca ?? ""},
  retornoObs: ${retornoObs ?? ""},
  retornoDataEntrega: ${retornoDataEntrega ?? ""},
  retornoHoraEntrega: ${retornoHoraEntrega ?? ""},
  retornoResponsavel: ${retornoResponsavel ?? ""},
  pedidoObs: ${pedidoObs ?? ""},
  respContratadaNaColeta: ${respContratadaNaColeta ?? ""},
  respContratanteNaColeta: ${respContratanteNaColeta ?? ""},
  respContratadaNaEntrega: ${respContratadaNaEntrega ?? ""},
  respContratanteNaEntrega: ${respContratanteNaEntrega ?? ""},
  lotes: $lotes,
}''';
  }
}
