class Cupom {
  final String codigo;
  String username;
  final String dataI;
  String dataU;
  final int cs;
  bool usado;
  Cupom({
    required this.codigo,
    required this.username,
    required this.dataI,
    required this.dataU,
    required this.cs,
    required this.usado,
  });

  factory Cupom.fromJson(Map<String, dynamic> json) {
    return Cupom(
        codigo: json['codigo'],
        username: json['username'],
        cs: json['cs'],
        usado: json['usado'],
        dataI: json['dataI'],
        dataU: json['dataU']);
  }

  Map<String, dynamic> toJson() {
    return {
      "codigo": codigo,
      "username": username,
      "cs": cs,
      "usado": usado,
      "dataI": dataI,
      "dataU": dataU
    };
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["codigo"] = codigo;
    map["cs"] = cs;

    return map;
  }
}
