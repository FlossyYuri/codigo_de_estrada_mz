import 'package:codigo_de_estrada_mz/models/teste.dart';
import 'package:flutter/material.dart';

class Resultados {
  List<Map<int, String>> opcoesEscolhidas;
  Teste teste;
  bool testPaid = false;
  int acertos;
  int erros;
  String classificacao;
  double valorClassif;
  int tipoDeTeste;
  DateTime data;
  Resultados({
    @required this.opcoesEscolhidas,
    @required this.teste,
    @required this.acertos,
    @required this.erros,
    @required this.classificacao,
    @required this.valorClassif,
    @required this.tipoDeTeste,
    @required this.data,
  });

  String getTipoDeTeste() {
    switch (tipoDeTeste) {
      case 1:
        return "Personalizado";
      case 2:
        return "Exercicio";
      default:
        return "outro";
    }
  }
}
