import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/data/usuario_api.dart';
import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/models/cuppon.dart';
import 'package:codigo_de_estrada_mz/ui/home/widgets/promo-dialogue.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransacoesBloc extends BlocBase {
  var sub;
  bool timerSet = false;
  StreamController _streamController = StreamController<Duration>.broadcast();
  get outTimer => _streamController.stream;
  void setTimer() {
    if (!timerSet) {
      timerSet = true;
      sub.cancel();

      sub.onData((Duration d) {
        _streamController.sink.add(d);
      });
      // when it finish the onDone cb is called
      sub.onDone(() {
        timerSet = false;
        sub.cancel();
      });
    }
  }

  usarCupom(BuildContext context, String codigo) async {
    if (await checkConnection()) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("cupons")
          .doc(codigo.toUpperCase())
          .get();
      if (snapshot.exists) {
        Cupom cupom = Cupom.fromJson(snapshot.data());
        if (!cupom.usado) {
          var bloc = BlocProvider.getBloc<UsuarioBloc>();
          bloc.userData.cs += cupom.cs;
          await FirebaseFirestore.instance
              .collection("cupons")
              .doc(cupom.codigo)
              .update({"usado": true, "username": bloc.userData.username});
          await bloc.fullUpdateUser();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Cupom de ${cupom.cs} cs usado com sucesso",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w300, color: branco),
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Este cupom ja foi usado.",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w300, color: branco),
              ),
              backgroundColor: lightred,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Codigo invalido! porfavor, digite um codigo valido",
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w300, color: branco),
            ),
            backgroundColor: lightred,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Falha ao verificar o cupom por falta de conexao a internet!",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w300, color: branco),
          ),
          backgroundColor: lightred,
        ),
      );
    }
  }

  void gerarTestesIlimitados() {
    DateTime dataInicioTestesInfinitos = DateTime.now();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(
        "dITestesInfinitos",
        dataInicioTestesInfinitos.toString(),
      );
      prefs.setString(
        "dFTestesInfinitos",
        dataInicioTestesInfinitos.add(Duration(hours: 12)).toString(),
      );
    });
  }

  void cancelarTestesIlimitados() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove("dITestesInfinitos");
      prefs.remove("dFTestesInfinitos");
    });
  }

  Future<bool> verificarTestesIlimitados() async {
    DateTime agora = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("dITestesInfinitos")) {
      DateTime init = DateTime.parse(prefs.getString("dITestesInfinitos"));
      DateTime fim = DateTime.parse(prefs.getString("dFTestesInfinitos"));
      if (agora.isAfter(init) && agora.isBefore(fim))
        return true;
      else
        return false;
    } else {
      return false;
    }
  }

  comprarTestes(int testes, int cs, BuildContext context) async {
    var bloc = BlocProvider.getBloc<UsuarioBloc>();
    if (bloc.userData.cs >= cs) {
      bloc.userData.cs -= cs;
      switch (testes) {
        case -1:
          gerarTestesIlimitados();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Comprou testes infinitos por 12h com sucesso.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
              duration: Duration(seconds: 1),
              backgroundColor: lightgreen,
            ),
          );
          break;
        default:
          bloc.userData.nrTestes += testes;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Comprou $testes testes com sucesso.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
              duration: Duration(seconds: 1),
              backgroundColor: lightgreen,
            ),
          );
      }
      bloc.fullUpdateUser();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Nao tem cs suficientes",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: lightred,
          action: SnackBarAction(
            label: "Comprar cs",
            textColor: preto,
            onPressed: () {
              DefaultTabController.of(context).index = 0;
            },
          ),
        ),
      );
    }
  }

  comprarCS(int cs, BuildContext context) async {
    var bloc = BlocProvider.getBloc<UsuarioBloc>();
    bloc.userData.cs += cs;
    bloc.fullUpdateUser();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Comprou $cs cs com sucesso.",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
