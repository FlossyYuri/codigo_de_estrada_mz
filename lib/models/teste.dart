import 'dart:convert';

import 'package:latest_codigo_de_estrada/helpers/teste_helper.dart';
import 'package:latest_codigo_de_estrada/models/questao.dart';

class Teste {
  int id;
  String nome;
  String categoria;
  int duracao;
  int maxErros;
  int idTema;
  List<int> questoes;
  late List<Questao> questoes2;
  Teste(
      {required this.nome,
      required this.categoria,
      required this.duracao,
      required this.id,
      required this.maxErros,
      required this.questoes,
      required this.idTema});

  factory Teste.fromJson(Map<String, dynamic> json) {
    return Teste(
      id: json['id_teste'],
      nome: json['nome'],
      categoria: json['categoria'],
      duracao: json['duracao'],
      idTema: json['id_tema'],
      maxErros: json['max_erros'],
      questoes: json['questoes'],
    );
  }

  factory Teste.fromJsonDB(Map<String, dynamic> json) {
    return Teste(
      id: json['id_teste'],
      nome: json['nome'],
      categoria: json['categoria'],
      duracao: json['duracao'],
      idTema: json['id_tema'],
      maxErros: json['max_erros'],
      questoes: List<int>.from(jsonDecode(json['questoes'])),
    );
  }

  factory Teste.fromMap(Map<String, dynamic> map, {required bool fromDB}) {
    if (fromDB) {
      return Teste(
        nome: map["nome"],
        categoria: map["categoria"],
        duracao: map["duracao"],
        id: map["id_teste"],
        maxErros: map["max_erros"],
        questoes: List<int>.from(jsonDecode(map[questoesColumn])),
        idTema: map["id_tema"],
      );
    } else {
      return Teste(
        nome: map["nome"],
        categoria: map["categoria"],
        duracao: int.parse(map["duracao"]),
        id: int.parse(map["id_teste"]),
        maxErros: int.parse(map["max_erros"]),
        questoes: List<int>.from(map["questoes"]),
        idTema: int.parse(map["id_tema"]),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "id_teste": id,
      "nome": nome,
      "categoria": categoria,
      "id_tema": idTema,
      "max_erros": maxErros,
      "duracao": duracao,
      "questoes": questoes,
    };
  }

  Map toMap({required bool forDB}) {
    var map = new Map<String, dynamic>();
    map["id_teste"] = id;
    map["nome"] = nome;
    map["categoria"] = categoria;
    map["id_tema"] = idTema;
    map["max_erros"] = maxErros;
    map["duracao"] = duracao;
    if (forDB)
      map["questoes"] = jsonEncode(questoes);
    else
      map["questoes"] = questoes;
    return map;
  }
}
