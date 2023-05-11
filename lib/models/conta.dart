class Conta{
  String? tipoConta;
  String? natureza;
  String? banco;
  String? agencia;
  String? conta;
  String? nomeFav;

  Conta();

  Conta.fromMap(Map map){
    tipoConta = map['tipoConta'];
    natureza = map['natureza'];
    banco = map['banco'];
    agencia = map['agencia'];
    conta = map['conta'];
    nomeFav = map['nomeFav'];
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic> {
      "tipoConta": tipoConta,
      "natureza": natureza,
      "banco": banco,
      "agencia": agencia,
      "conta": conta,
      "nomeFav": nomeFav
    };
    return map;
  }

  @override
  String toString(){
    return "{tipoConta: $tipoConta, natureza: $natureza, banco: $banco, agencia: $agencia, conta: $conta, nomeFav: $nomeFav}";
  }

}