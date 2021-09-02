import 'dart:convert';

import 'package:codigo_de_estrada_mz/helpers/teste_helper.dart';
import 'package:codigo_de_estrada_mz/models/questao.dart';
import 'package:flutter/widgets.dart';

class Teste {
  int id;
  String nome;
  String categoria;
  int duracao;
  int maxErros;
  int idTema;
  List<int> questoes;
  List<Questao> questoes2;
  Teste(
      {@required this.nome,
      @required this.categoria,
      @required this.duracao,
      @required this.id,
      @required this.maxErros,
      @required this.questoes,
      @required this.idTema});

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

  Teste.fromMap(Map<String, dynamic> map, {@required bool fromDB}) {
    nome = map["nome"];
    categoria = map["categoria"];
    if (fromDB) {
      id = map["id_teste"];
      idTema = map["id_tema"];
      maxErros = map["max_erros"];
      duracao = map["duracao"];
      questoes = List<int>.from(jsonDecode(map[questoesColumn]));
    } else {
      id = int.parse(map["id_teste"]);
      idTema = int.parse(map["id_tema"]);
      maxErros = int.parse(map["max_erros"]);
      duracao = int.parse(map["duracao"]);
      questoes = List<int>.from(map["questoes"]);
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

  Map toMap({@required bool forDB}) {
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
