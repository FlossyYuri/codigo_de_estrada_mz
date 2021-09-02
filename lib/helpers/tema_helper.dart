import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/models/tema.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

final String tabTema = "tema";
final String idColumn = "id_tema";
final String temaColumn = "tema";
final String iconColumn = "icon";

class TemaHelper {
  static final TemaHelper _instance = TemaHelper.internal();
  factory TemaHelper() => _instance;
  TemaHelper.internal();

  apagarTabela() async {
    Database dbCDE = await db;
    dbCDE.execute("DROP TABLE IF EXISTS $tabTema");
  }

  // addColumn()async{
  //   Database dbCDE = await db;
  //   dbCDE.execute("ALTER TABLE $tabTema ADD COLUMN IF NOT EXISTS $premiumColumn INTEGER DEFAULT 0");
  // }

  deleteDataB() async {
    await deleteDB();
  }

  criarTabela() async {
    Database dbCDE = await db;
    await dbCDE.execute(
        "CREATE TABLE  IF NOT EXISTS $tabTema ($idColumn TEXT PRIMARY KEY, $temaColumn TEXT,"
        "$iconColumn TEXT)");
  }

  Future<Tema> salvarTema(Tema user) async {
    Database dbCDE = await db;
    await criarTabela();
    List<Map> map = await dbCDE.query(tabTema,
        columns: [idColumn], where: "$idColumn = ?", whereArgs: [user.id]);

    if (map.length > 0) {
      return user;
    } else {
      await dbCDE.insert(tabTema, user.toMap());
      return user;
    }
  }

  Future<Tema> getTema(String id) async {
    Database dbCDE = await db;
    List<Map> map = await dbCDE.query(tabTema,
        columns: [
          idColumn,
          temaColumn,
          iconColumn,
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (map.length > 0)
      return Tema.fromMap(map.first);
    else
      return null;
  }

  Future<int> deleteTema(String id) async {
    Database dbCDE = await db;
    return await dbCDE.delete(tabTema, where: "$idColumn =?", whereArgs: [id]);
  }

  Future<int> updateTema(Tema tema) async {
    Database dbCDE = await db;
    return await dbCDE.update(tabTema, tema.toMap(),
        where: "$idColumn = ?", whereArgs: [tema.id]);
  }

  Future<List<Tema>> getTodostemas() async {
    Database dbCDE = await db;
    criarTabela();
    List listaMapa = await dbCDE.rawQuery("SELECT * FROM $tabTema");
    List<Tema> listatema = [];
    for (Map m in listaMapa) {
      listatema.add(Tema.fromMap(m));
    }
    return listatema;
  }

  Future<int> getNumber() async {
    Database dbCDE = await db;
    return Sqflite.firstIntValue(
        await dbCDE.rawQuery("SELECT COUNT(*) FROM $tabTema"));
  }

  Future fechar() async {
    Database dbCDE = await db;
    dbCDE.close();
  }
}
