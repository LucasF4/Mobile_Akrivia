class Info{
  String? cnpj;
  String? mcc;
  String? razaoSocial;
  String? fantasia;
  String? abertura;
  String? email;
  String? telefone;

  Info();

  Info.fromMap(Map map){
    cnpj = map['cnpj'];
    mcc = map['mcc'];
    razaoSocial = map['razaoSocial'];
    fantasia = map['fantasia'];
    abertura = map['abertura'];
    email = map['email'];
    telefone = map['telefone'];
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic> {
      "cnpj": cnpj,
      "mcc": mcc,
      "razaoSocial": razaoSocial,
      "fantasia": fantasia,
      "abertura": abertura,
      "email": email,
      "telefone": telefone
    };
    return map;
  }

  @override
  String toString(){
    return "{cnpj: $cnpj, mcc: $mcc, razaoSocial: $razaoSocial, fantasia: $fantasia, abertura: $abertura, email: $email, telefone: $telefone}";
  }

}