import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/blocs/usuario_bloc.dart';
import 'package:codigo_de_estrada_mz/constantes.dart';
import 'package:codigo_de_estrada_mz/data/usuario_api.dart';
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
    // if (await checkConnection()) {
    //   DocumentSnapshot snapshot = await Firestore.instance
    //       .collection("cupons")
    //       .document(codigo.toUpperCase())
    //       .get();
    //   if (snapshot.exists) {
    //     Cupom cupom = Cupom.fromJson(snapshot.data);
    //     if (!cupom.usado) {
    //       var bloc = BlocProvider.getBloc<UsuarioBloc>();
    //       bloc.userData.cs += cupom.cs;
    //       await Firestore.instance
    //           .collection("cupons")
    //           .document(cupom.codigo)
    //           .updateData({"usado": true, "username": bloc.userData.username});
    //       await bloc.fullUpdateUser();
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text(
    //             "Cupom de ${cupom.cs} cs usado com sucesso",
    //             style: TextStyle(
    //                 fontSize: 22, fontWeight: FontWeight.w300, color: branco),
    //           ),
    //           backgroundColor: Colors.green,
    //           duration: Duration(seconds: 2),
    //         ),
    //       );
    //       Future.delayed(Duration(seconds: 3)).then((_) async {
    //         Map<String, dynamic> json = await createPost(body: {});
    //         DateTime data = DateTime.parse(json['data_hora_atual']);
    //         if (data.month == 12 && data.day >= 8 && data.day <= 31) {
    //           switch (cupom.cs) {
    //             case 200:
    //               bloc.userData.nrTestes += 10;
    //               bloc.fullUpdateUser();

    //               showDialog(
    //                 context: context,
    //                 builder: (BuildContext context) => PromoDialogue(
    //                   title: "Parabéns",
    //                   description:
    //                       "Ganhou 10 testes por ter usado o cupom na época festiva. Desejamos-lhe festas felizes.",
    //                   buttonText: "fechar",
    //                 ),
    //               );
    //               break;
    //             case 500:
    //               bloc.userData.cs += 100;
    //               bloc.userData.nrTestes += 15;
    //               bloc.fullUpdateUser();
    //               showDialog(
    //                 context: context,
    //                 builder: (BuildContext context) => PromoDialogue(
    //                   title: "Parabéns",
    //                   description:
    //                       "Ganhou 100cs e 15 testes por ter usado o cupom na época festiva. Desejamos-lhe festas felizes.",
    //                   buttonText: "fechar",
    //                 ),
    //               );
    //               break;
    //           }
    //         }
    //       });
    //     } else {
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text(
    //             "Este cupom ja foi usado.",
    //             style: TextStyle(
    //                 fontSize: 22, fontWeight: FontWeight.w300, color: branco),
    //           ),
    //           backgroundColor: lightred,
    //         ),
    //       );
    //     }
    //   } else {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(
    //           "Codigo invalido! porfavor, digite um codigo valido",
    //           style: TextStyle(
    //               fontSize: 22, fontWeight: FontWeight.w300, color: branco),
    //         ),
    //         backgroundColor: lightred,
    //       ),
    //     );
    //   }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(
    //         "Falha ao verificar o cupom por falta de conexao a internet!",
    //         style: TextStyle(
    //             fontSize: 22, fontWeight: FontWeight.w300, color: branco),
    //       ),
    //       backgroundColor: lightred,
    //     ),
    //   );
    // }
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

  ganharTestes(BuildContext context, int quantidade) async {
    var bloc = BlocProvider.getBloc<UsuarioBloc>();
    bloc.userData.nrTestes += quantidade;
    await bloc.fullUpdateUser();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Parabens, ganhou +1 testes por ter assistido o video",
        style:
            TextStyle(fontSize: 22, fontWeight: FontWeight.w300, color: branco),
      ),
      backgroundColor: Colors.green,
    ));
  }

  usarTeste(BuildContext context) async {
    var bloc = BlocProvider.getBloc<UsuarioBloc>();
    if (await verificarTestesIlimitados())
      print("clear");
    else {
      bloc.userData.nrTestes -= 1;
      await bloc.fullUpdateUser();
    }
  }

  pagarResolucao(BuildContext context) async {
    var bloc = BlocProvider.getBloc<UsuarioBloc>();
    if (!bloc.userData.premium) {
      bloc.userData.cs -= 5;
      await bloc.fullUpdateUser();
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

  Future<void> virarPremium(BuildContext context) async {
    var bloc = BlocProvider.getBloc<UsuarioBloc>();
    bloc.userData.premium = true;
    bloc.fullUpdateUser();
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Parabéns, Versão Premium assinada com sucesso",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: lightgreen,
        ),
      );
    } catch (e) {}
  }

  Future<void> cancelarPremium(BuildContext context) async {
    var bloc = BlocProvider.getBloc<UsuarioBloc>();
    bloc.userData.premium = false;
    bloc.fullUpdateUser();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Oiaaaa, Versão Premium cancela MIRMÃO",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: lightgreen,
      ),
    );
  }

  Future<bool> timerGanharTestes(BuildContext context) async {
    var bloc = BlocProvider.getBloc<UsuarioBloc>();
    if (bloc.userData.nrTestes < 3) {
      // se tiver menos de 3 testes
      final prefs = await SharedPreferences.getInstance();
      int testes = bloc.userData.nrTestes;

      if (!prefs.containsKey("ultima_data"))
        prefs.setString("ultima_data", "-");
      if (!prefs.containsKey("segundos_acumulados"))
        prefs.setInt("segundos_acumulados", -1);
      if (!prefs.containsKey("minutos_acumulados"))
        prefs.setInt("minutos_acumulados", -1);

      if (prefs.getInt("segundos_acumulados") == -1)
        prefs.setInt("segundos_acumulados", 0);
      if (prefs.getInt("minutos_acumulados") == -1)
        prefs.setInt("minutos_acumulados", 0);

      String ultimaData = prefs.getString("ultima_data");
      int minutosAcumulados = prefs.getInt("minutos_acumulados");
      int segundosAcumulados = prefs.getInt("segundos_acumulados");

      var json = await createPost(body: {"data": ultimaData});

      if (minutosAcumulados + json['total_minutes'] < 20) {
        prefs.setInt(
            "minutos_acumulados", minutosAcumulados + json['total_minutes']);
        prefs.setInt(
            "segundos_acumulados", segundosAcumulados + json['total_segundos']);
      } else if (minutosAcumulados + json['total_minutes'] >= 20 &&
          minutosAcumulados + json['total_minutes'] < 40) {
        bloc.userData.nrTestes = testes + 1;

        print("+1");
        prefs.setInt("minutos_acumulados",
            minutosAcumulados + json['total_minutes'] - 20);
        prefs.setInt("segundos_acumulados",
            segundosAcumulados + json['total_segundos'] - (20 * 60));
      } else if (minutosAcumulados + json['total_minutes'] >= 40 &&
          minutosAcumulados + json['total_minutes'] < 60) {
        if (testes <= 1)
          bloc.userData.nrTestes = testes + 2;
        else
          bloc.userData.nrTestes = 3;

        print("+2");
        prefs.setInt("minutos_acumulados",
            minutosAcumulados + json['total_minutes'] - 40);
        prefs.setInt("segundos_acumulados",
            segundosAcumulados + json['total_segundos'] - (40 * 60));
      } else if (minutosAcumulados + json['total_minutes'] >= 60) {
        bloc.userData.nrTestes = 3;

        print("+3");
        prefs.setInt("minutos_acumulados", 0);
        prefs.setInt("segundos_acumulados", 0);
      }

      if (json["total_minutes"] != 0 || prefs.getString("ultima_data") == "-")
        prefs.setString("ultima_data", json["data_hora_atual"]);
      bloc.userSink();
      print("---------------------------------------------");
      print(prefs.getInt("segundos_acumulados"));
      print(prefs.getInt("minutos_acumulados"));
      print(prefs.getString("ultima_data"));
      print(json);
      if (bloc.userData.nrTestes >= 3) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("ultima_data", "-");
        prefs.setInt("segundos_acumulados", 0);
        prefs.setInt("minutos_acumulados", 0);
      }
      return true;
    } else
      return false;
  }

  recompensadiaria(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = await createPost(body: {"data": ""});
    var bloc = BlocProvider.getBloc<UsuarioBloc>();
    if (prefs.containsKey("lastLogin")) {
      //verificar se existe o ultimo login
      DateTime dataAtual = DateTime.parse(json["data_hora_atual"]);
      DateTime lastLogin = DateTime.parse(prefs.getString("lastLogin"));
      int diferenca = dataAtual.difference(lastLogin).inDays;
      if (diferenca == 1) {
        //incrementar dias seguidos
        prefs.setInt("diasSeguidos", prefs.getInt("diasSeguidos") + 1);
        // guardar data de ultimo login
        prefs.setString("lastLogin", json["data_hora_atual"]);
      } else if (diferenca > 1) {
        //resetar dias seguidos
        prefs.setInt("diasSeguidos", 1);
        // guardar data de ultimo login
        prefs.setString("lastLogin", json["data_hora_atual"]);
      }

      //Recompensas
      if (prefs.getInt("diasSeguidos") > 0) {
        switch (prefs.getInt("diasSeguidos")) {
          case 1:
            bloc.userData.nrTestes += 1;
            break;
          case 2:
            bloc.userData.nrTestes += 2;
            break;
          case 3:
            bloc.userData.nrTestes += 4;
            bloc.userData.cs += 5;
            break;
          case 4:
            bloc.userData.nrTestes += 2;
            break;
          case 5:
            bloc.userData.nrTestes += 3;
            break;
          case 6:
            bloc.userData.nrTestes += 4;
            break;
          case 7:
            bloc.userData.nrTestes += 4;
            bloc.userData.cs += 30;
            //resetar dias seguidos
            prefs.setInt("diasSeguidos", 1);
            break;
          default:
        }
        bloc.fullUpdateUser();
      }
    } else {
      prefs.setString("lastLogin", json["data_hora_atual"]);
      prefs.setInt("diasSeguidos", 1);
      bloc.userData.nrTestes += 1;
      bloc.fullUpdateUser();
    }
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
