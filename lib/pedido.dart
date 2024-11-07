class Pedido {
  final String cliente;
  final String pedido;
  final String dataEntrega;
  final double pesoTotal;

  // 0 representa não iniciado, 1 representa iniciado, 2 representa concluído

  int recebimento;
  int classificacao;
  int passadoria;
  int finalizacao;
  int retorno;

  final List<Lote> lotes;

  Pedido({
    required this.cliente,
    required this.pedido,
    required this.dataEntrega,
    required this.pesoTotal,
    required this.passadoria,
    required this.finalizacao,
    required this.retorno,
    required this.lotes,
    this.recebimento = 0,
    this.classificacao = 0,
  });
}

class Lote {
  final String nome;
  int status; // 0 representa iniciado, 1 representa concluído

  Lote({required this.nome, required this.status});
}
