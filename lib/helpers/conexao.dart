import 'dart:io';

import 'package:codigo_de_estrada_mz/helpers/usuario_helper.dart' as u_helper;
import 'package:codigo_de_estrada_mz/helpers/questao_helper.dart' as q_helper;
import 'package:codigo_de_estrada_mz/helpers/tema_helper.dart' as m_helper;
import 'package:codigo_de_estrada_mz/helpers/teste_helper.dart' as t_helper;
import 'package:codigo_de_estrada_mz/helpers/historico_helper.dart' as h_helper;
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

Database _db;
Future<Database> get db async {
  if (_db != null) {
    return _db;
  } else {
    _db = await initDB();
    return _db;
  }
}

Future<Database> initDB() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, "cde.db");
  return await openDatabase(path, version: 1,
      onCreate: (Database db, int versaoNova) async {
    await db.execute(
      "CREATE TABLE  IF NOT EXISTS ${u_helper.tabUsuario} (${u_helper.idColumn} TEXT PRIMARY KEY, ${u_helper.usernameColumn} TEXT,"
      "${u_helper.emailColumn} TEXT, ${u_helper.cellColumn} TEXT, ${u_helper.imgUrlColumn} TEXT, ${u_helper.csColumn} INTEGER,"
      "${u_helper.testesColumn} INTEGER, ${u_helper.premiumColumn} INTEGER)",
    );
    await db.execute(
      "CREATE TABLE IF NOT EXISTS ${q_helper.tabQuestao} (${q_helper.idColumn} INTEGER PRIMARY KEY, ${q_helper.idTemaColumn} INTEGER,"
      "${q_helper.dificuldadeColumn} INTEGER, ${q_helper.categoriaColumn} TEXT, ${q_helper.fotoColumn} TEXT,"
      " ${q_helper.portuguesColumn} TEXT)",
    );
    await db.execute(
      "CREATE TABLE IF NOT EXISTS ${t_helper.tabTeste} (${t_helper.idColumn} INTEGER PRIMARY KEY, ${t_helper.nomeColumn} TEXT,"
      "${t_helper.maxErrosColumn} INTEGER, ${t_helper.categoriaColumn} TEXT, ${t_helper.idTemaColumn} INTEGER,"
      " ${t_helper.duracaoColumn} INTEGER,${t_helper.questoesColumn} TEXT)",
    );
    await db.execute(
        "CREATE TABLE  IF NOT EXISTS ${m_helper.tabTema} (${m_helper.idColumn} TEXT PRIMARY KEY, ${m_helper.temaColumn} TEXT,"
        "${m_helper.iconColumn} TEXT)");
    await db.execute(
        "CREATE TABLE  IF NOT EXISTS ${h_helper.tabHistorico} (${h_helper.idColumn} INTEGER PRIMARY KEY, ${h_helper.dadosColumn} TEXT)");
  });
}

Future<Null> deleteDB() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, "cde.db");
  await deleteDatabase(path);
}

Future<bool> checkConnection() async {
  bool hasConnection;
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      hasConnection = true;
    } else {
      hasConnection = false;
    }
  } on SocketException catch (_) {
    hasConnection = false;
  }
  return hasConnection;
}
