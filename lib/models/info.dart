class Info{
  String? cnpj;
  String? mcc;

  Info();

  Info.fromMap(Map map){
    cnpj = map['cnpj'];
    mcc = map['mcc'];
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic> {
      "cnpj": cnpj,
      "mcc": mcc
    };
    return map;
  }

  @override
  String toString(){
    return "{cnpj: $cnpj, mcc: $mcc}";
  }

}