import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/helpers/historico_helper.dart';
import 'package:codigo_de_estrada_mz/helpers/questao_helper.dart';
import 'package:codigo_de_estrada_mz/helpers/tema_helper.dart';
import 'package:codigo_de_estrada_mz/helpers/teste_helper.dart';
import 'package:codigo_de_estrada_mz/models/app_info.dart';
import 'package:codigo_de_estrada_mz/models/historico.dart';
import 'package:codigo_de_estrada_mz/models/questao.dart';
import 'package:codigo_de_estrada_mz/models/tema.dart';
import 'package:codigo_de_estrada_mz/models/teste.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestaoBloc extends BlocBase {
  List<Questao> questoes;
  List<Teste> testes;
  List<Tema> temas;
  List<ResultadoHistorico> listaHistorico;
  load() async {
    if (questoes == null || testes == null || temas == null) {
      if (await checkConnection()) {
        questoes = [];
        testes = [];
        temas = [];
        QuestaoHelper questaoHelper = QuestaoHelper();
        TesteHelper testeHelper = TesteHelper();
        TemaHelper temaHelper = TemaHelper();

        latestVersionCheck();

        await downloadQuestoes();
        await downloadTestes();
        await downloadTemas();
        for (Questao q in questoes) {
          questaoHelper.salvarQuestao(q);
        }
        for (Teste t in testes) {
          testeHelper.salvarTeste(t);
        }
        for (Tema m in temas) {
          temaHelper.salvarTema(m);
        }
      } else {
        await buscarQuestoesDB();
        await buscarTemasDB();
        await buscarTestesDB();
      }
      lerHistorico();
    }
    return true;
  }

  Questao questaoPorID(int id) {
    for (Questao q in questoes) {
      if (q.id == id) return q;
    }
    return null;
  }

  List<Questao> questoesPorIDs(List<int> ids) {
    List<Questao> l = [];
    for (int i in ids) {
      l.add(questaoPorID(i));
    }
    return l;
  }

  latestVersionCheck() async {
    final prefs = await SharedPreferences.getInstance();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    int buildNumber = int.parse(packageInfo.buildNumber);

    AppInfo app = AppInfo(
      platform: "android",
      bundle: buildNumber,
      state: true,
      version: version,
    );
    bool update = false;
    bool obrigatorio = false;

    //buscar todas apps cadastradas
    List<AppInfo> apps = [];
    // await Firestore.instance
    //     .collection("app-info")
    //     .getDocuments()
    //     .then((QuerySnapshot snapshot) {
    //   apps = snapshot.documents.map((doc) {
    //     return AppInfo.fromMap(doc.data);
    //   }).toList();
    // });
    // percorer todas apps e verificar se
    apps.forEach((AppInfo a) {
      if (a.bundle > app.bundle)
        update = true; //já existe disponivel uma nova versao
      if (a.bundle == app.bundle) if (!a.state)
        obrigatorio = true; // a versão atual ainda é permitida
    });
    prefs.setBool("update", update);
    prefs.setBool("obrigatorio", obrigatorio);
  }

  deleteDATA() async {
    QuestaoHelper questaoHelper = QuestaoHelper();
    for (Questao q in questoes) {
      questaoHelper.salvarQuestao(q);
    }
  }

  Future<Null> downloadQuestoes() async {
    if (questoes.length == 0) {
      // await Firestore.instance
      //     .collection("questao")
      //     .getDocuments()
      //     .then((QuerySnapshot snapshot) {
      //   questoes = snapshot.documents.map((doc) {
      //     return Questao.fromMap(doc.data, fromDB: false);
      //   }).toList();
      // });
    }
  }

  Future<Null> downloadTestes() async {
    if (testes.length == 0) {
      // await Firestore.instance
      //     .collection("teste")
      //     .getDocuments()
      //     .then((QuerySnapshot snapshot) {
      //   testes = snapshot.documents.map((doc) {
      //     return Teste.fromMap(doc.data, fromDB: false);
      //   }).toList();
      // });
    }
  }

  Future<Null> downloadTemas() async {
    if (temas.length == 0) {
      // await Firestore.instance
      //     .collection("tema")
      //     .getDocuments()
      //     .then((QuerySnapshot snapshot) {
      //   temas = snapshot.documents.map((doc) {
      //     return Tema.fromMap(doc.data);
      //   }).toList();
      // });
    }
  }

  buscarQuestoesDB() async {
    questoes = [];
    QuestaoHelper questaoHelper = QuestaoHelper();
    questoes = await questaoHelper.getTodosQuestaos();
  }

  buscarTestesDB() async {
    testes = [];
    TesteHelper testeHelper = TesteHelper();
    testes = await testeHelper.getTodosTestes();
  }

  buscarTemasDB() async {
    temas = [];
    TemaHelper temaHelper = TemaHelper();
    temas = await temaHelper.getTodostemas();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/historico.txt');
  }

  Future<File> writeHistorico(String text) async {
    final file = await _localFile;

    // Write the file.
    String contents = await file.readAsString();
    return file.writeAsString(contents + text + "\n");
  }

  Future<String> readHistorico() async {
    try {
      final file = await _localFile;

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return "";
    }
  }

  String temaPorID(int id) {
    String tema = "Este";
    for (Tema t in temas) {
      if (t.id == id) {
        tema = t.tema;
        break;
      }
    }
    return tema;
  }

  Future<void> guardarHistorico() async {
    // HistoricoHelper histoHelper = HistoricoHelper();
    // histoHelper.deleteHistorico("0");
  }

  Future<bool> lerHistorico() async {
    HistoricoHelper histoHelper = HistoricoHelper();
    listaHistorico = await histoHelper.getTodosdados();
    listaHistorico.reversed;
    return true;
  }

  Future<void> deleteHistorico() async {
    HistoricoHelper histoHelper = HistoricoHelper();
    await histoHelper.deleteAllHistorico();
  }
}
