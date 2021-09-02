import 'package:flutter/cupertino.dart';

class Tema {
  int id;
  String tema;
  String icon;
  Tema({
    @required this.tema,
    @required this.icon,
    @required this.id,
  });

  factory Tema.fromJson(Map<String, dynamic> json) {
    return Tema(
      tema: json['tema'],
      icon: json['icon'],
      id: int.parse(json['id_tema']),
    );
  }

  Tema.fromMap(Map<String, dynamic> map) {
    id = int.parse(map["id_tema"]);
    tema = map["tema"];
    icon = map["icon"];
  }

  

  Map<String, dynamic> toJson() {
    return {
      "id_tema": id,
      "tema": tema,
      "icon": icon,
    };
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id_tema"] = id;
    map["tema"] = tema;
    map["icon"] = icon;
    return map;
  }
}
