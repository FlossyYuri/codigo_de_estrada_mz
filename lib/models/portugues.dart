import 'dart:convert';

class Portugues {
  String resposta;
  String questao;
  List<String> alternativas;

  Portugues({
    required this.resposta,
    required this.questao,
    required this.alternativas,
  });

  factory Portugues.fromJson(Map<String, dynamic> json) {
    return Portugues(
      resposta: json['resposta'],
      questao: json['questao'],
      alternativas: json['alternativas'],
    );
  }

  factory Portugues.fromMap(Map<String, dynamic> map, {required bool fromDB}) {
    final alternativasData = fromDB
        ? jsonDecode(map['alternativas'] as String)
        : jsonDecode(map['alternativas'] as String);

    return Portugues(
      resposta: map["resposta"] as String,
      questao: map["questao"] as String,
      alternativas: List<String>.from(alternativasData),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "resposta": resposta,
      "questao": questao,
      "alternativas": alternativas,
    };
  }

  Map toMap({required bool forDB}) {
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
