import 'dart:convert';

import 'package:codigo_de_estrada_mz/helpers/questao_helper.dart';
import 'package:codigo_de_estrada_mz/models/portugues.dart';

class Questao {
  int id;
  int idTema;
  int dificuldade;
  String categoria;
  String foto;
  Portugues portugues;
  Questao({
    required this.id,
    required this.idTema,
    required this.dificuldade,
    required this.categoria,
    required this.foto,
    required this.portugues,
  });

  factory Questao.fromJson(Map<String, dynamic> json) {
    return Questao(
      id: json['id_questao'],
      idTema: json['id_tema'],
      dificuldade: json['dificuldade'],
      categoria: json['categoria'],
      foto: json['foto'],
      portugues: Portugues.fromJson(json['portugues']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id_questao": id,
      "id_tema": idTema,
      "dificuldade": dificuldade,
      "categoria": categoria,
      "foto": foto,
      "portugues": portugues.toJson(),
    };
  }

  Map toMap({required bool forDB}) {
    var map = new Map<String, dynamic>();
    map["id_questao"] = id;
    map["id_tema"] = idTema;
    map["dificuldade"] = dificuldade;
    map["categoria"] = categoria;
    map["foto"] = foto;
    if (forDB)
      map["portugues"] =
          jsonEncode(portugues.toMap(forDB: true) as Map<String, dynamic>);
    else
      map["portugues"] = portugues.toMap(forDB: false);
    return map;
  }

  factory Questao.fromMap(Map<String, dynamic> map, {required bool fromDB}) {
    final portuguesData = fromDB
        ? jsonDecode(map[portuguesColumn] as String) as Map<String, dynamic>
        : map[portuguesColumn] as Map<String, dynamic>;

    return Questao(
      id: map[idColumn] as int,
      dificuldade: map[dificuldadeColumn] as int,
      idTema: map[idTemaColumn] as int,
      categoria: map[categoriaColumn] as String,
      foto: map[fotoColumn] as String,
      portugues: Portugues.fromMap(portuguesData, fromDB: fromDB),
    );
  }
}
