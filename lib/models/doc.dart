class Doc{
  String? cep;
  String? tipo;
  String? complemento;
  String? logradouro;
  String? bairro;
  String? localidade;
  String? uf;
  String? numero;
  String? nome;
  String? cpf;
  String? datanascimento;
  String? rg;
  String? wpp;

  Doc();

  Doc.fromMap(Map map){
    cep = map['cep'];
    tipo = map['tipo'];
    complemento = map['complemento'];
    logradouro = map['logradouro'];
    bairro = map['bairro'];
    localidade = map['localidade'];
    uf = map['uf'];
    numero = map['numero'];
    nome = map['nome'];
    cpf = map['cpf'];
    datanascimento = map['datanascimento'];
    rg = map['rg'];
    wpp = map['wpp'];
  }

  Map<String, dynamic> toMap(){
    var map = <String, dynamic> {
      "cep": cep,
      "tipo": tipo,
      "complemento": complemento,
      "logradouro": logradouro,
      "bairro": bairro,
      "localidade": localidade,
      "uf": uf,
      "numero": numero,
      "nome": nome,
      "cpf": cpf,
      "datanascimento": datanascimento,
      "rg": rg,
      "wpp": wpp
    };
    return map;
  }

  @override
  String toString(){
    return "{cep: $cep, tipo: $tipo, complemento: $complemento, logradouro: $logradouro, bairro: $bairro, localidade: $localidade,uf: $uf,numero: $numero,nome: $nome,cpf: $cpf,datanascimento: $datanascimento,rg: $rg,wpp: $wpp}";
  }

}