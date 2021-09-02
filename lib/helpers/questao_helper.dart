import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/models/questao.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

final String tabQuestao = "Questao";
final String idColumn = "id_questao";
final String idTemaColumn = "id_tema";
final String dificuldadeColumn = "dificuldade";
final String categoriaColumn = "categoria";
final String fotoColumn = "foto";
final String portuguesColumn = "portugues";

class QuestaoHelper {
  static final QuestaoHelper _instance = QuestaoHelper.internal();
  factory QuestaoHelper() => _instance;
  QuestaoHelper.internal();

  apagarTabela() async {
    Database dbCDE = await db;
    dbCDE.execute("DROP TABLE IF EXISTS $tabQuestao");
  }

  criarTabela() async {
    Database dbCDE = await db;
    await dbCDE.execute(
      "CREATE TABLE IF NOT EXISTS $tabQuestao ($idColumn INTEGER PRIMARY KEY, $idTemaColumn INTEGER,"
      "$dificuldadeColumn INTEGER, $categoriaColumn TEXT, $fotoColumn TEXT,"
      " $portuguesColumn TEXT)",
    );
  }

  Future<Questao> salvarQuestao(Questao questao) async {
    Database dbCDE = await db;
    List<Map> map = await dbCDE.query(tabQuestao,
        columns: [idColumn], where: "$idColumn = ?", whereArgs: [questao.id]);

    if (map.length > 0) {
      updateQuestao(questao);
    } else {
      await dbCDE.insert(tabQuestao, questao.toMap(forDB: true));
    }
    return questao;
  }

  Future<Questao> getQuestao(String id) async {
    Database dbCDE = await db;
    List<Map> map = await dbCDE.query(tabQuestao,
        columns: [
          idColumn,
          idTemaColumn,
          dificuldadeColumn,
          categoriaColumn,
          fotoColumn,
          portuguesColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (map.length > 0)
      return Questao.fromMap(map.first, fromDB: true);
    else
      return null;
  }

  Future<int> deleteQuestao(String id) async {
    Database dbCDE = await db;
    return await dbCDE
        .delete(tabQuestao, where: "$idColumn =?", whereArgs: [id]);
  }

  Future<int> updateQuestao(Questao questao) async {
    Database dbCDE = await db;
    return await dbCDE.update(tabQuestao, questao.toMap(forDB: true),
        where: "$idColumn = ?", whereArgs: [questao.id]);
  }

  Future<List<Questao>> getTodosQuestaos() async {
    Database dbCDE = await db;
    List listaMapa = await dbCDE.rawQuery("SELECT * FROM $tabQuestao");
    List<Questao> listaQuestao = [];
    for (Map m in listaMapa) {
      listaQuestao.add(Questao.fromMap(m, fromDB: true));
    }
    return listaQuestao;
  }

  Future<int> getNumber() async {
    Database dbCDE = await db;
    return Sqflite.firstIntValue(
        await dbCDE.rawQuery("SELECT COUNT(*) FROM $tabQuestao"));
  }

  Future fechar() async {
    Database dbCDE = await db;
    dbCDE.close();
  }
}
