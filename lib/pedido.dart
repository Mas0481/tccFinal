import 'package:tcc/lote.dart';

class Pedido {
  // Informação dos status dos processos
  // 0 aguardando, 1 processando, 2 concluído
  int recebimentoStatus;
  int classificacaoStatus;
  int lavagemStatus;
  int centrifugacaoStatus;
  int secagemStatus;
  int passadoriaStatus;
  int finalizacaoStatus;
  int retornoStatus;

  // Dados do recebimento
  final int codCliente;
  final String nomeCliente;
  String numPedido;
  final String dataColeta;
  final String dataRecebimento;
  final String horaRecebimento;
  final String dataLimite;
  final String dataEntrega;
  final double pesoTotal;
  String recebimentoObs;

  // Dados da classificação
  int totalLotes;
  String classificacaoObs;
  String classificacaoDataInicio;
  String classificacaoHoraInicio;
  String classificacaoDataFinal;
  String classificacaoHoraFinal;

  // Dados da passadoria
  String passadoriaEquipamento;
  String passadoriaTemperatura;
  String passadoriaDataInicio;
  String passadoriaHoraInicio;
  String passadoriaDataFinal;
  String passadoriaHoraFinal;
  String passadoriaObs;

  // Dados da finalização
  String finalizacaoReparo;
  String finalizacaoEtiquetamento;
  String finalizacaoTipoEmbalagem;
  String finalizacaoVolumes;
  String finalizacaoControleQualidade;
  String finalizacaoDataInicio;
  String finalizacaoHoraInicio;
  String finalizacaoDataFinal;
  String finalizacaoHoraFinal;
  String finalizacaoObs;

  // Dados do retorno
  String retornoData;
  String retornoHoraCarregamento;
  String retornoVolumes;
  String retornoNomeMotorista;
  String retornoVeiculo;
  String retornoPlaca;
  String retornoObs;

  // Lista de lotes
  List<Lote> lotes;

  Pedido({
    required this.codCliente,
    required this.nomeCliente,
    required this.numPedido,
    required this.dataColeta,
    required this.dataRecebimento,
    required this.horaRecebimento,
    required this.dataLimite,
    required this.dataEntrega,
    required this.pesoTotal,
    required this.lotes,
    this.recebimentoStatus = 0,
    this.classificacaoStatus = 0,
    this.lavagemStatus = 0,
    this.centrifugacaoStatus = 0,
    this.secagemStatus = 0,
    this.passadoriaStatus = 0,
    this.finalizacaoStatus = 0,
    this.retornoStatus = 0,
    this.recebimentoObs = '',
    this.totalLotes = 0,
    this.classificacaoObs = '',
    this.classificacaoDataInicio = '',
    this.classificacaoHoraInicio = '',
    this.classificacaoDataFinal = '',
    this.classificacaoHoraFinal = '',
    this.passadoriaEquipamento = '',
    this.passadoriaTemperatura = '',
    this.passadoriaDataInicio = '',
    this.passadoriaHoraInicio = '',
    this.passadoriaDataFinal = '',
    this.passadoriaHoraFinal = '',
    this.passadoriaObs = '',
    this.finalizacaoReparo = '',
    this.finalizacaoEtiquetamento = '',
    this.finalizacaoTipoEmbalagem = '',
    this.finalizacaoVolumes = '',
    this.finalizacaoControleQualidade = '',
    this.finalizacaoDataInicio = '',
    this.finalizacaoHoraInicio = '',
    this.finalizacaoDataFinal = '',
    this.finalizacaoHoraFinal = '',
    this.finalizacaoObs = '',
    this.retornoData = '',
    this.retornoHoraCarregamento = '',
    this.retornoVolumes = '',
    this.retornoNomeMotorista = '',
    this.retornoVeiculo = '',
    this.retornoPlaca = '',
    this.retornoObs = '',
  });
}
