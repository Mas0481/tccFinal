import 'package:flutter/material.dart';
import '../models/lote.dart';
import '../models/pedido.dart';

class LoteButton extends StatelessWidget {
  final Lote lote;
  final Pedido pedido;
  final String processo;
  final VoidCallback onTap;

  const LoteButton({
    Key? key,
    required this.lote,
    required this.pedido,
    required this.processo,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color buttonColor = Colors.grey[300]!;
    String buttonText = 'Iniciar Lote';

    if (processo == "Centrifugação" && lote.loteCentrifugacaoStatus == 2) {
      buttonColor = Colors.blue;
      buttonText = "Lote Concluído";
    } else if (processo == "Secagem" && lote.loteSecagemStatus == 2) {
      buttonColor = Colors.blue;
      buttonText = "Lote Concluído";
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
