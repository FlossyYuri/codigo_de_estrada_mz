class Cupom {
  final String codigo;
  final String username;
  final String dataI;
  final String dataU;
  final int cs;
  final bool usado;
  Cupom({
    this.codigo,
    this.username,
    this.dataI,
    this.dataU,
    this.cs,
    this.usado,
  });

  factory Cupom.fromJson(Map<String, dynamic> json){
    return Cupom(
      codigo: json['codigo'],
      username: json['username'],
      cs: json['cs'],
      usado: json['usado'],
      dataI: json['dataI'],
      dataU: json['dataU']
    );
  }

  Map<String, dynamic> toJson(){
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
