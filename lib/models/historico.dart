import 'dart:convert';

import 'package:codigo_de_estrada_mz/models/teste.dart';

class ResultadoHistorico {
  int nrErros;
  DateTime data;
  int tipoDeTeste;
  Teste teste;
  ResultadoHistorico({
    required this.nrErros,
    required this.data,
    required this.tipoDeTeste,
    required this.teste,
  });

  factory ResultadoHistorico.fromJson(Map<String, dynamic> json) {
    return ResultadoHistorico(
      nrErros: json['nrErros'],
      data: DateTime.parse(json['data']),
      tipoDeTeste: json['tipoDeTeste'],
      teste: Teste.fromJson(json['teste']),
    );
  }
  factory ResultadoHistorico.fromMap(Map<String, dynamic> map) {
    return ResultadoHistorico(
      nrErros: map["nrErros"] as int,
      data: DateTime.parse(map['data'] as String),
      tipoDeTeste: map['tipoDeTeste'] as int,
      teste: Teste.fromJson(map['teste'] as Map<String, dynamic>),
    );
  }
  factory ResultadoHistorico.fromMapDB(Map<String, dynamic> map) {
    final dados = json.decode(map['dados'] as String) as Map<String, dynamic>;
    return ResultadoHistorico(
      nrErros: dados["nrErros"] as int,
      data: DateTime.parse(dados['data'] as String),
      tipoDeTeste: dados['tipoDeTeste'] as int,
      teste: Teste.fromJsonDB(dados['teste'] as Map<String, dynamic>),
    );
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
    map["teste"] = teste.toMap(forDB: true) as Map<String, dynamic>;
    var map2 = {"dados": jsonEncode(map)};

    return map2;
  }

  String toString() {
    return jsonEncode(toJson());
  }
}
