import 'dart:convert';

import 'package:codigo_de_estrada_mz/models/teste.dart';
import 'package:flutter/material.dart';

class ResultadoHistorico {
  int nrErros;
  DateTime data;
  int tipoDeTeste;
  Teste teste;
  ResultadoHistorico({
    @required this.nrErros,
    @required this.data,
    @required this.tipoDeTeste,
    @required this.teste,
  });

  factory ResultadoHistorico.fromJson(Map<String, dynamic> json) {
    return ResultadoHistorico(
      nrErros: json['nrErros'],
      data: DateTime.parse(json['data']),
      tipoDeTeste: json['tipoDeTeste'],
      teste: Teste.fromJson(json['teste']),
    );
  }
  ResultadoHistorico.fromMap(Map<String, dynamic> map) {
    nrErros = map["nrErros"];
    data = DateTime.parse(map['data']);
    tipoDeTeste = map['tipoDeTeste'];
    teste = Teste.fromJson(map['teste']);
  }
  ResultadoHistorico.fromMapDB(Map<String, dynamic> map) {
    var dados = json.decode(map['dados']);
    nrErros = dados["nrErros"];
    data = DateTime.parse(dados['data']);
    tipoDeTeste = dados['tipoDeTeste'];
    teste = Teste.fromJsonDB(dados['teste']);
  }

  Map<String, dynamic> toJson() {
    return {
      "nrErros": nrErros,
      "data": data.toString(),
      "tipoDeTeste": tipoDeTeste,
      "teste": teste.toJson(),
    };
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["nrErros"] = nrErros;
    map["data"] = data;
    map["tipoDeTeste"] = tipoDeTeste;
    map["teste"] = teste.toMap(forDB: false);
    return map;
  }

  Map toMapDB() {
    var map = new Map<String, dynamic>();
    map["nrErros"] = nrErros;
    map["data"] = data.toString();
    map["tipoDeTeste"] = tipoDeTeste;
    map["teste"] = teste.toMap(forDB: true);
    var map2 = {"dados": jsonEncode(map)};

    return map2;
  }

  String toString() {
    return jsonEncode(toJson());
  }
}
