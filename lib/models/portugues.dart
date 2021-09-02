import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Portugues {
  String resposta;
  String questao;
  List<String> alternativas;

  Portugues({
    @required this.resposta,
    @required this.questao,
    @required this.alternativas,
  });

  factory Portugues.fromJson(Map<String, dynamic> json) {
    return Portugues(
      resposta: json['resposta'],
      questao: json['questao'],
      alternativas: json['alternativas'],
    );
  }

  Portugues.fromMap(Map<String, dynamic> map, {@required bool fromDB}) {
    resposta = map["resposta"];
    questao = map["questao"];
    if (fromDB)
      alternativas = List<String>.from(jsonDecode(map['alternativas']));
    else {
      alternativas = List<String>.from(jsonDecode(map['alternativas']));
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "resposta": resposta,
      "questao": questao,
      "alternativas": alternativas,
    };
  }

  Map toMap({@required bool forDB}) {
    var map = new Map<String, dynamic>();
    if (forDB)
      map["alternativas"] = jsonEncode(alternativas);
    else
      map["alternativas"] = alternativas;
    map["resposta"] = resposta;
    map["questao"] = questao;
    return map;
  }
}
