import 'dart:async';
import 'dart:math';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/models/historico.dart';
import 'package:codigo_de_estrada_mz/models/questao.dart';
import 'package:codigo_de_estrada_mz/blocs/questao_bloc.dart';
import 'package:codigo_de_estrada_mz/models/resultados.dart';
import 'package:codigo_de_estrada_mz/models/teste.dart';
import 'package:codigo_de_estrada_mz/helpers/historico_helper.dart';
import 'package:flutter/material.dart';

class InGameBloc extends BlocBase {
  Teste teste;
  bool jogando = false;
  bool salvarHistorico = false;
  String questionMode = "normal";
  int tipoDeTeste = 1;
  List<Map<int, String>> opcoesEscolhidas;
  Resultados resultados;
  final StreamController _questoesRespController =
      StreamController<int>.broadcast();
  Stream get outQtdQuestoesResp => _questoesRespController.stream;

  List<int> criarQuestoes({
    @required BuildContext context,
    @required int idTema,
  }) {
    int qtdQuestoes = 25;
    int dificuldade = 0;
    //carregar todas questoes
    List<Questao> questoes = BlocProvider.getBloc<QuestaoBloc>().questoes;
    List<Questao> questoesTemaDificuldade = [];
    //selecionar todas questoes relacionadas com o idTema e a difuculdade
    for (Questao q in questoes) {
      switch (dificuldade) {
        case 0:
          switch (idTema) {
            case 0:
              questoesTemaDificuldade = questoes; //levar todas questoes
              break;
            default:
              if (q.idTema == idTema) // so filtrar por idTema
                questoesTemaDificuldade.add(q);
          }
          break;
        default:
          switch (idTema) {
            case 0:
              if (dificuldade == q.dificuldade) // filtrar por dificuldaed
                questoesTemaDificuldade.add(q);
              break;
            default:
              if (q.idTema == idTema &&
                  q.dificuldade ==
                      dificuldade) //filtrar por idTema e a dificuldade
                questoesTemaDificuldade.add(q);
          }
      }
    }
    Random r = Random();
    List<int> listaQuestoes = [];
    int index, tamanho = questoesTemaDificuldade.length;
    if (tamanho < 25)
      qtdQuestoes = tamanho; //caso nao tenha questoes suficientes
    while (listaQuestoes.length < qtdQuestoes) {
      //enquanto nao tiver questoes suficientes
      index = r.nextInt(tamanho);
      if (!listaQuestoes.contains(questoesTemaDificuldade[index].id))
        listaQuestoes.add(questoesTemaDificuldade[index].id);
    }

    return listaQuestoes;
  }

  carregarTeste({@required BuildContext context, @required Teste teste}) {
    teste.questoes2 =
        BlocProvider.getBloc<QuestaoBloc>().questoesPorIDs(teste.questoes);
    this.teste = teste;
    opcoesEscolhidas = [];
    for (int quests in teste.questoes) {
      opcoesEscolhidas.add({quests: ""});
    }
    _questoesRespController.sink.add(0);
  }

  escolherOpcao(int id, String texto) {
    opcoesEscolhidas.forEach((Map<int, String> map) {
      if (map.keys.contains(id)) {
        map[id] = texto;
        return;
      }
    });
    _questoesRespController.sink.add(contarNaoRespondidas());
  }

  int contarNaoRespondidas() {
    int cont = 0;
    opcoesEscolhidas.forEach((Map<int, String> map) {
      if (!map.containsValue("")) {
        cont++;
      }
    });
    _questoesRespController.sink.add(cont);
    return cont;
  }

  void calcularResultados() {
    int acertos = 0, erros = 0;
    double valorClassif = 0;
    String classificacao = "";

    for (int i = 0; i < teste.questoes.length; i++) {
      if (teste.questoes2[i].portugues.resposta ==
          opcoesEscolhidas[i][teste.questoes2[i].id])
        acertos++;
      else
        erros++;
    }
    if (teste.questoes.length < 25) {
      valorClassif = acertos / teste.questoes.length;
      if (acertos == teste.questoes.length) {
        classificacao = "Excelente!";
      } else {
        if (acertos >= teste.questoes.length * 3 / 4) {
          classificacao = "Muito bom!";
        } else {
          if (acertos >= teste.questoes.length / 2) {
            classificacao = "Bom!";
          } else {
            if (acertos >= teste.questoes.length / 4) {
              classificacao = "Mau!";
            } else {
              classificacao = "Muito mau!";
            }
          }
        }
      }
    } else {
      if (acertos == 25) {
        classificacao = "Excelente!";
        valorClassif = 1;
      } else if (acertos >= 22 && acertos < 25) {
        classificacao = "Muito bom!";
        valorClassif = 0.8;
        switch (acertos) {
          case 23:
            valorClassif = 0.85;
            break;
          case 24:
            valorClassif = 0.85;
            break;
        }
      } else if (acertos >= 17 && acertos < 22) {
        classificacao = "Bom!";
        valorClassif = 0.5;
        switch (acertos) {
          case 18:
            valorClassif = 0.56;
            break;
          case 19:
            valorClassif = 0.62;
            break;
          case 20:
            valorClassif = 0.70;
            break;
          case 21:
            valorClassif = 0.76;
            break;
        }
      } else if (acertos >= 10 && acertos < 17) {
        classificacao = "Mau!";
      } else if (acertos >= 0 && acertos < 10) {
        classificacao = "Muito mau!";
      }
      valorClassif = acertos * 0.5 / 17;
    }
    resultados = Resultados(
        opcoesEscolhidas: opcoesEscolhidas,
        teste: teste,
        acertos: acertos,
        erros: erros,
        classificacao: classificacao,
        valorClassif: valorClassif,
        data: DateTime.now(),
        tipoDeTeste: tipoDeTeste);
    HistoricoHelper histoHelper = HistoricoHelper();
    ResultadoHistorico historico = ResultadoHistorico(
      data: DateTime.now(),
      nrErros: erros,
      tipoDeTeste: tipoDeTeste,
      teste: teste,
    );
    histoHelper.salvarHistorico(historico);
    salvarHistorico = false;
  }

  jogarNovamente() {
    opcoesEscolhidas = [];
    for (int quests in teste.questoes) {
      opcoesEscolhidas.add({quests: ""});
    }
    salvarHistorico = true;
    _questoesRespController.sink.add(0);
  }

  @override
  void dispose() {
    _questoesRespController.close();
  }
}
