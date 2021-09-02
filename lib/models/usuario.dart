import 'package:codigo_de_estrada_mz/helpers/usuario_helper.dart';
import 'package:flutter/foundation.dart';

class Usuario {
  String id;
  String username;
  String email;
  String cell;
  String imgUrl;
  int nrTestes;
  int cs;
  bool premium;
  Usuario({
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.cell,
    @required this.imgUrl,
    @required this.nrTestes,
    @required this.cs,
    @required this.premium,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      cell: json['cell'],
      imgUrl: json['imgUrl'],
      nrTestes: json['nrTestes'],
      cs: json['cs'],
      premium: json.containsKey("premium") ? json['premium'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "cell": cell,
      "imgUrl": imgUrl,
      "nrTestes": nrTestes,
      "cs": cs,
      "premium": premium,
    };
  }

  Map toMap({@required bool forDB}) {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["username"] = username;
    map["email"] = email;
    map["cell"] = cell;
    map["imgUrl"] = imgUrl;
    map["nrTestes"] = nrTestes;
    map["cs"] = cs;
    if (forDB)
      map["premium"] = premium ? 1 : 0;
    else
      map["premium"] = premium;
    return map;
  }

  Usuario.fromMap(Map map, {@required bool fromDB}) {
    id = map[idColumn];
    username = map[usernameColumn];
    email = map[emailColumn];
    cell = map[cellColumn];
    imgUrl = map[imgUrlColumn];
    cs = map[csColumn];
    nrTestes = map[testesColumn];
    if (fromDB)
      premium = map[premiumColumn] == 0 ? false : true;
    else
      premium = map[premiumColumn];
  }

  @override
  String toString() {
    return "Usuario(id: $id, username: $username, email:  $email, cell: $cell, imgUrl: $imgUrl, cs: $cs, testes: $nrTestes, Anuncios: $premium)";
  }
}
