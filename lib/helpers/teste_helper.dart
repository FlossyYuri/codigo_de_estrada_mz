import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/models/teste.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

final String tabTeste = "Teste";
final String idColumn = "id_teste";
final String nomeColumn = "nome";
final String maxErrosColumn = "max_erros";
final String categoriaColumn = "categoria";
final String idTemaColumn = "id_tema";
final String duracaoColumn = "duracao";
final String questoesColumn = "questoes";

class TesteHelper {
  static final TesteHelper _instance = TesteHelper.internal();
  factory TesteHelper() => _instance;
  TesteHelper.internal();

  apagarTabela() async {
    Database dbCDE = await db;
    dbCDE.execute("DROP TABLE IF EXISTS $tabTeste");
  }

  criarTabela() async {
    Database dbCDE = await db;
    await dbCDE.execute(
        "CREATE TABLE IF NOT EXISTS $tabTeste ($idColumn INTEGER PRIMARY KEY, $nomeColumn TEXT,"
        "$maxErrosColumn INTEGER, $categoriaColumn TEXT, $idTemaColumn INTEGER,"
        " $duracaoColumn INTEGER,$questoesColumn TEXT)");
  }

  Future<Teste> salvarTeste(Teste categoria) async {
    Database dbCDE = await db;
    await criarTabela();
    List<Map> map = await dbCDE.query(tabTeste,
        columns: [idColumn], where: "$idColumn = ?", whereArgs: [categoria.id]);

    if (map.length > 0) {
      updateTeste(categoria);
    } else {
      await dbCDE.insert(tabTeste, categoria.toMap(forDB: true));
    }
    return categoria;
  }

  Future<Teste> getTeste(String id) async {
    Database dbCDE = await db;
    List<Map> map = await dbCDE.query(tabTeste,
        columns: [
          idColumn,
          nomeColumn,
          maxErrosColumn,
          categoriaColumn,
          idTemaColumn,
          duracaoColumn,
          questoesColumn
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (map.length > 0)
      return Teste.fromMap(map.first, fromDB: true);
    else
      return null;
  }

  Future<int> deleteTeste(String id) async {
    Database dbCDE = await db;
    return await dbCDE.delete(tabTeste, where: "$idColumn =?", whereArgs: [id]);
  }

  Future<int> updateTeste(Teste categoria) async {
    Database dbCDE = await db;
    return await dbCDE.update(tabTeste, categoria.toMap(forDB: true),
        where: "$idColumn = ?", whereArgs: [categoria.id]);
  }

  Future<List<Teste>> getTodosTestes() async {
    Database dbCDE = await db;
    criarTabela();
    List listaMapa = await dbCDE.rawQuery("SELECT * FROM $tabTeste");
    List<Teste> listaTeste = [];
    for (Map m in listaMapa) {
      listaTeste.add(Teste.fromMap(m, fromDB: true));
    }
    return listaTeste;
  }

  Future<int> getNumber() async {
    Database dbCDE = await db;
    return Sqflite.firstIntValue(
        await dbCDE.rawQuery("SELECT COUNT(*) FROM $tabTeste"));
  }

  Future fechar() async {
    Database dbCDE = await db;
    dbCDE.close();
  }
}
