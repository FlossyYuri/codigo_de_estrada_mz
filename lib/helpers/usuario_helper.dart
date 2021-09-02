import 'package:codigo_de_estrada_mz/helpers/conexao.dart';
import 'package:codigo_de_estrada_mz/models/usuario.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

final String tabUsuario = "usuario";
final String idColumn = "id";
final String usernameColumn = "username";
final String emailColumn = "email";
final String cellColumn = "cell";
final String imgUrlColumn = "imgUrl";
final String csColumn = "cs";
final String testesColumn = "nrTestes";
final String premiumColumn = "premium";

class UsuarioHelper {
  static final UsuarioHelper _instance = UsuarioHelper.internal();
  factory UsuarioHelper() => _instance;
  UsuarioHelper.internal();

  apagarTabela() async {
    Database dbCDE = await db;
    dbCDE.execute("DROP TABLE IF EXISTS $tabUsuario");
  }

  addColumn() async {
    Database dbCDE = await db;
    dbCDE.execute(
        "ALTER TABLE $tabUsuario ADD COLUMN IF NOT EXISTS $premiumColumn INTEGER DEFAULT 0");
  }

  deleteDataB() async {
    await deleteDB();
  }

  criarTabela() async {
    Database dbCDE = await db;
    await dbCDE.execute(
        "CREATE TABLE $tabUsuario ($idColumn TEXT PRIMARY KEY, $usernameColumn TEXT,"
        "$emailColumn TEXT, $cellColumn TEXT, $imgUrlColumn TEXT,$testesColumn INTEGER,"
        " $csColumn INTEGER, $premiumColumn INTEGER)");
  }

  Future<Usuario> salvarUsuario(Usuario user) async {
    Database dbCDE = await db;
    List<Map> map = await dbCDE.query(tabUsuario,
        columns: [idColumn], where: "$idColumn = ?", whereArgs: [user.id]);

    if (map.length > 0) {
      return user;
    } else {
      await dbCDE.insert(tabUsuario, user.toMap(forDB: true));
      return user;
    }
  }

  Future<Usuario> getUsuario(String id) async {
    Database dbCDE = await db;
    List<Map> map = await dbCDE.query(tabUsuario,
        columns: [
          idColumn,
          usernameColumn,
          emailColumn,
          cellColumn,
          imgUrlColumn,
          csColumn,
          testesColumn,
          premiumColumn,
        ],
        where: "$idColumn = ?",
        whereArgs: [id]);
    if (map.length > 0)
      return Usuario.fromMap(map.first, fromDB: true);
    else
      return null;
  }

  Future<int> deleteUsuario(String id) async {
    Database dbCDE = await db;
    return await dbCDE
        .delete(tabUsuario, where: "$idColumn =?", whereArgs: [id]);
  }

  Future<int> updateUsuario(Usuario usuario) async {
    Database dbCDE = await db;
    return await dbCDE.update(tabUsuario, usuario.toMap(forDB: true),
        where: "$idColumn = ?", whereArgs: [usuario.id]);
  }

  Future<List<Usuario>> getTodosusuarios() async {
    Database dbCDE = await db;
    List listaMapa = await dbCDE.rawQuery("SELECT * FROM $tabUsuario");
    List<Usuario> listausuario = [];
    for (Map m in listaMapa) {
      listausuario.add(Usuario.fromMap(m, fromDB: true));
    }
    return listausuario;
  }

  Future<int> getNumber() async {
    Database dbCDE = await db;
    return Sqflite.firstIntValue(
        await dbCDE.rawQuery("SELECT COUNT(*) FROM $tabUsuario"));
  }

  Future fechar() async {
    Database dbCDE = await db;
    dbCDE.close();
  }
}
