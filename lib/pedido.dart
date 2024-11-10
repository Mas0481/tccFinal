import 'package:tcc/lote.dart';

class Pedido {
  // informação dos estatus dos processos
  //0 aguardando, 1 representa processando, 2 representa concluído
  late int recebimentoStatus;
  late int classificacaoStatus;
  late int lavagemStatus;
  late int centrifugacaoStatus;
  late int secagemStatus;
  late int passadoriaStatus;
  late int finalizacaoStatus;
  late int retornoStatus;

  //dados recebimento
  final int codCliente;
  late String numPedido;
  final String dataColeta;
  final String dataRecebimento;
  final String horaRecebimento;
  final String dataLimite;
  final String dataEntrega;
  final double pesoTotal;
  late String recebimentoObs;

  //dados classificação
  late int totalLotes;
  late String classificacaoObs;
  late String classificacaoDataInicio;
  late String classificacaoHoraInicio;
  late String classificacaoDataFinal;
  late String classificacaoHoraFinal;

  //dados da passadoria
  late String passadoriaEquipamento;
  late String passadoriaTemperatura;
  late String passadoriaDataInicio;
  late String passadoriaHoraInicio;
  late String passadoriaDataFinal;
  late String passadoriaHoraFinal;
  late String passadoriaObs;

  //dados da finalizacao
  late String finalizacaoReparo;
  late String finalizacaoEtiquetamento;
  late String finalizacaoTipoEmbalagem;
  late String finalizacaoVolumes;
  late String finalizacaoControleQualidade;
  late String finalizacaoDataInicio;
  late String finalizacaoHoraInicio;
  late String finalizacaoDataFinal;
  late String finalizacaoHoraFinal;
  late String finalizacaoObs;

  //dados da retorno
  late String retornoData;
  late String retornoHoraCarregamento;
  late String retornoVolumes;
  late String retornoNomeMotorista;
  late String retornoVeiculo;
  late String retornoPlaca;
  late String retornoObs;

  late List<Lote> lotes;

  Pedido(
      {required this.codCliente,
      required this.dataColeta,
      required this.dataRecebimento,
      required this.horaRecebimento,
      required this.dataLimite,
      required this.dataEntrega,
      required this.pesoTotal});
}
