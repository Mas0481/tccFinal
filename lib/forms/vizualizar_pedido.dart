import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatação de data
import 'package:tcc/models/pedido.dart'; // Modelo Pedido

class VisualizarPedido extends StatelessWidget {
  final Pedido pedido;

  // Construtor que recebe o objeto Pedido
  VisualizarPedido({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white.withOpacity(0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Primeira linha: Título e Data de Entrega
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Visualização do Pedido',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  // Data de Entrega no canto, agora menor, em negrito e vermelho
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.2, // 20% da largura
                    child: _buildTextField(
                        'Data de Entrega', _formatDate(pedido.dataEntrega),
                        isRed: true, isBold: true),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Primeira Linha: Dados do Cliente e Dados do Pedido
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dados do Cliente
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGroupTitle('Dados do Cliente'),
                        _buildTextField(
                            'Código do Cliente', pedido.codCliente.toString()),
                        _buildTextField(
                            'Nome do Cliente', pedido.nomCliente ?? 'N/A'),
                        _buildTextField('Data de Recebimento',
                            pedido.dataRecebimento ?? 'N/A'),
                        _buildTextField('Hora de Recebimento',
                            pedido.horaRecebimento ?? 'N/A'),
                      ],
                    ),
                  ),

                  SizedBox(width: 20), // Espaço entre as colunas

                  // Dados do Pedido
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGroupTitle('Dados do Pedido'),
                        _buildTextField('Número do Pedido',
                            pedido.numPedido?.toString() ?? 'N/A'),
                        _buildTextField('Quantidade de Produto',
                            pedido.qtdProduto.toString()),
                        _buildTextField('Valor dos Produtos',
                            pedido.valorProdutos.toString()),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Segunda Linha: Informações de Entrega e Informações de Pagamento
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informações de Entrega
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGroupTitle('Informações de Entrega'),
                        _buildTextField('Data de Coleta', pedido.dataColeta),
                        _buildTextField('Data Limite', pedido.dataLimite),
                        _buildTextField('Data de Entrega', pedido.dataEntrega,
                            isRed: true),
                      ],
                    ),
                  ),

                  SizedBox(width: 20), // Espaço entre as colunas

                  // Informações de Pagamento
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGroupTitle('Informações de Pagamento'),
                        _buildTextField(
                            'Pagamento', pedido.pagamento.toString()),
                        _buildTextField(
                            'Data de Pagamento', pedido.dataPagamento ?? 'N/A'),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Terceira Linha: Status dos Processos e Observações Adicionais
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status dos Processos
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGroupTitle('Status das Etapas'),
                        _buildTextField('Status Classificação',
                            pedido.classificacaoStatus.toString()),
                        _buildTextField(
                            'Status Lavagem', pedido.lavagemStatus.toString()),
                        _buildTextField('Status Centrifugação',
                            pedido.centrifugacaoStatus.toString()),
                        _buildTextField(
                            'Status Secagem', pedido.secagemStatus.toString()),
                        _buildTextField('Status Passadoria',
                            pedido.passadoriaStatus.toString()),
                        _buildTextField('Status Finalização',
                            pedido.finalizacaoStatus.toString()),
                        _buildTextField(
                            'Status Retorno', pedido.retornoStatus.toString()),
                      ],
                    ),
                  ),

                  SizedBox(width: 20), // Espaço entre as colunas

                  // Observações Adicionais
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGroupTitle('Observações e Dados Adicionais'),
                        _buildTextField('Observações de Recebimento',
                            pedido.recebimentoObs ?? 'N/A'),
                        _buildTextField('Observações de Classificação',
                            pedido.classificacaoObs ?? 'N/A'),
                        _buildTextField('Observações de Passadoria',
                            pedido.passadoriaObs ?? 'N/A'),
                        _buildTextField('Observações de Finalização',
                            pedido.finalizacaoObs ?? 'N/A'),
                        _buildTextField('Observações de Retorno',
                            pedido.retornoObs ?? 'N/A'),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Quarta Linha: Finalização e Dados do Retorno
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Finalização
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGroupTitle('Finalização e Retorno'),
                        _buildTextField('Reparo Finalização',
                            pedido.finalizacaoReparo ?? 'N/A'),
                        _buildTextField('Etiquetamento Finalização',
                            pedido.finalizacaoEtiquetamento ?? 'N/A'),
                        _buildTextField('Tipo de Embalagem Finalização',
                            pedido.finalizacaoTipoEmbalagem ?? 'N/A'),
                        _buildTextField('Volumes Finalização',
                            pedido.finalizacaoVolumes ?? 'N/A'),
                        _buildTextField('Controle de Qualidade Finalização',
                            pedido.finalizacaoControleQualidade ?? 'N/A'),
                      ],
                    ),
                  ),

                  SizedBox(width: 20), // Espaço entre as colunas

                  // Dados do Retorno
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildGroupTitle('Retorno'),
                        _buildTextField(
                            'Volumes Retorno', pedido.retornoVolumes ?? 'N/A'),
                        _buildTextField('Nome Motorista Retorno',
                            pedido.retornoNomeMotorista ?? 'N/A'),
                        _buildTextField(
                            'Veículo Retorno', pedido.retornoVeiculo ?? 'N/A'),
                        _buildTextField(
                            'Placa Retorno', pedido.retornoPlaca ?? 'N/A'),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Botão Fechar
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.blue, // Botão Fechar azul
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Fechar',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para criar o título do grupo, agora com alinhamento
  Widget _buildGroupTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }

  // Função para criar os campos de texto (não editáveis), agora com texto preto
  Widget _buildTextField(String label, String value,
      {bool isRed = false, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        initialValue: value,
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
            color: Colors.black,
          ),
          hintText: value,
          hintStyle: TextStyle(
            color: isRed ? Colors.red : Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        style: TextStyle(
          fontSize: 16,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: isRed ? Colors.red : Colors.black,
        ),
      ),
    );
  }

  // Função para formatar a data
  String _formatDate(String? date) {
    if (date == null) return 'N/A';
    try {
      var parsedDate = DateTime.parse(date);
      var formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(parsedDate);
    } catch (e) {
      return date; // Se a data estiver em formato inválido
    }
  }
}
