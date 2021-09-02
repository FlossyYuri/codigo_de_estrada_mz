import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/models/historico.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

final String tabHistorico = "historico";
final String idColumn = "id";
final String dadosColumn = "dados";

class HistoricoHelper {
  static final HistoricoHelper _instance = HistoricoHelper.internal();
  factory HistoricoHelper() => _instance;
  HistoricoHelper.internal();

  apagarTabela() async {
    Database dbCDE = await db;
    dbCDE.execute("DROP TABLE IF EXISTS $tabHistorico");
  }

  // addColumn()async{
  //   Database dbCDE = await db;
  //   dbCDE.execute("ALTER TABLE $tabHistorico ADD COLUMN IF NOT EXISTS $premiumColumn INTEGER DEFAULT 0");
  // }

  deleteDataB() async {
    await deleteDB();
  }

  criarTabela() async {
    Database dbCDE = await db;
    await dbCDE.execute(
        "CREATE TABLE  IF NOT EXISTS $tabHistorico ($idColumn INTEGER PRIMARY KEY, $dadosColumn TEXT)");
  }

  Future<ResultadoHistorico> salvarHistorico(ResultadoHistorico hist) async {
    Database dbCDE = await db;
    await criarTabela();
    await dbCDE.insert(tabHistorico, hist.toMapDB());
    return hist;
  }

  Future<int> deleteHistorico(String id) async {
    Database dbCDE = await db;
    return await dbCDE
        .delete(tabHistorico, where: "$idColumn =?", whereArgs: [id]);
  }

  Future<int> deleteAllHistorico() async {
    Database dbCDE = await db;
    return await dbCDE.delete(tabHistorico);
  }

  Future<List<ResultadoHistorico>> getTodosdados() async {
    Database dbCDE = await db;
    criarTabela();
    List listaMapa = await dbCDE.rawQuery("SELECT * FROM $tabHistorico");
    List<ResultadoHistorico> listadados = [];
    for (Map m in listaMapa) {
      listadados.add(ResultadoHistorico.fromMapDB(m));
    }
    return listadados;
  }

  Future<int> getNumber() async {
    Database dbCDE = await db;
    return Sqflite.firstIntValue(
        await dbCDE.rawQuery("SELECT COUNT(*) FROM $tabHistorico"));
  }

  Future fechar() async {
    Database dbCDE = await db;
    dbCDE.close();
  }
}
