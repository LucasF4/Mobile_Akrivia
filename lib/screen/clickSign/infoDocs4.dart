import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:http/http.dart' as http;

import 'package:fluttertoast/fluttertoast.dart';

import 'package:akrivia_vendas/rotas/environment.dart';
import 'package:akrivia_vendas/models/info.dart';
import 'package:akrivia_vendas/Database/connection.dart';
import 'package:akrivia_vendas/models/userModel.dart';
import 'package:akrivia_vendas/models/doc.dart';
import 'package:akrivia_vendas/models/conta.dart';
import 'package:akrivia_vendas/models/myDocs.dart';

class infoDocs4 extends StatefulWidget {
  const infoDocs4({super.key});

  @override
  State<infoDocs4> createState() => _infoDocs4State();
}

class _infoDocs4State extends State<infoDocs4> {

  Info info = Info();
  User user = User();
  Doc doc = Doc();
  Conta conta = Conta();
  myDocs mydocs = myDocs();
  Connection conn = Connection();
  
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final _tpv = TextEditingController();
  final _operadora = TextEditingController();
  final _mensalidade = TextEditingController();
  final _consultMensal = TextEditingController();
  final _pos = TextEditingController();
  //final _equipamento = TextEditingController();
  final _carencia = TextEditingController();

  final _nomeConsultor = TextEditingController();
  String _AMPP = 'Ao Mês';

  bool checked1 = false;
  bool checked2 = false;
  bool checked3 = false;
  bool checked4 = false;
  bool checked5 = false;

  @override
  void initState(){
    super.initState();
    conn.select().then((res){
      conn.selectInfo().then((resp){
        conn.selectDoc().then((value){
          
          conn.selectConta().then((valueCont){

            user.email = res[0].email;

            doc.cep = value[0].cep;
            doc.tipo = value[0].tipo;
            doc.complemento = value[0].complemento;
            doc.logradouro = value[0].logradouro;
            doc.bairro = value[0].bairro;
            doc.localidade = value[0].localidade;
            doc.uf = value[0].uf;
            doc.numero = value[0].numero;
            doc.nome = value[0].nome;
            doc.cpf = value[0].cpf;
            doc.datanascimento = value[0].datanascimento;
            doc.rg = value[0].rg;
            doc.wpp = value[0].wpp;

            info.fantasia = resp[0].fantasia;
            info.email = resp[0].email;
            info.telefone = resp[0].telefone;
            info.cnpj = resp[0].cnpj;
            info.razaoSocial = resp[0].razaoSocial;
            info.abertura = resp[0].abertura;

            conta.tipoConta = valueCont[0].tipoConta;
            conta.natureza = valueCont[0].natureza;
            conta.banco = valueCont[0].banco;
            conta.agencia = valueCont[0].agencia;
            conta.conta = valueCont[0].conta;
            conta.nomeFav = valueCont[0].nomeFav;

          });
          
        });
      });
    });
  }

  void showDialogDoc(BuildContext context, taxas, infos, loading){
    showDialog(context: context, builder: (context){
      return SingleChildScrollView(
        child: StatefulBuilder(builder: (context, setState){
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Confirmação dos Dados",
                style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark),
                ),
              ],
            ),
            content: Column(
              children: [
                const Text("Atenção: Ao inserir seu nome e continuar, você concorda que todos os dados foram inseridos corretamente para a criação do documento para assinatura.",
                  style: TextStyle(fontWeight: FontWeight.bold),),
                Form(
                  key: _formKey2,
                  child:
                TextFormField(
                  controller: _nomeConsultor,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Necessário informar o seu nome';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Nome do Consultor"
                  ),
                )
                )
              ],
            ),
            actions: [
              !loading ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                    child: Text("Continuar"),
                    onPressed: () async{
                      if(_formKey2.currentState!.validate()){
                        setState(() {
                          loading = true;
                        });
                        var url = Uri.parse('${environment.baseUrlTeste}/api/v1/signers?access_token=${environment.acessToken}');
                        print(url);
                        try{
                          print("Entrei no try");
                          var data = doc.datanascimento.toString();
                          var dataFormated = '${data.split('/')[2]}-${data.split('/')[1]}-${data.split('/')[0]}';
                          print(dataFormated);
                          var response = await http.post(
                            url,
                            headers: {
                              "Content-Type": "application/json"
                            },
                            body: json.encode(
                              {
                                "signer": {
                                  "email": "${infos[1]}",
                                  "phone_number": "${doc.wpp}",
                                  "auths": [
                                    "email"
                                  ],
                                  "name": "${doc.nome}",
                                  "documentation": "${doc.cpf}",
                                  "birthday": "${dataFormated}",
                                  "has_documentation": true,
                                  "selfie_enabled": false,
                                  "handwritten_enabled": false,
                                  "official_document_enabled": false,
                                  "liveness_enabled": false,
                                  "facial_biometrics_enabled": false
                                }
                              }
                            )
                          );
                          
                          print(response.statusCode);
                          if(response.statusCode == 201){
                            var url = Uri.parse('${environment.baseUrlTeste}/api/v1/templates/${environment.documentKey}/documents?access_token=${environment.acessToken}');
                            var content = json.decode(response.body);
                            var sigKey = content['signer']['key'];
                            print('-------------------------------');
                            print("---------------------------------");
                            print(url);
                            try{
                              print('Entrei no segundo try');
                              
                              var response = await http.post(url,
                              headers: {
                                "Content-Type": "application/json"
                              },
                              body: json.encode({
                                "document": {
                                  "path": "/Contratos Vendas App/${(_nomeConsultor.text).toUpperCase()}/CONTRATO ${info.razaoSocial.toString() == 'null' ? info.fantasia : info.fantasia.toString() == 'null' ? doc.nome : info.razaoSocial}.docx",
                                  "template": {
                                    "data": {
                                      "Razão Social": "${info.razaoSocial.toString() == 'null' ? doc.nome : info.razaoSocial}",
                                      "Nome Fantasia": "${info.fantasia}",
                                      "CNPJ": "${info.cnpj.toString() == 'null' ? doc.cpf : info.cnpj.toString() == '' ? doc.cpf : info.cnpj}",
                                      "Inscrição Estadual": "",
                                      "Tipo da Empresa": "${doc.tipo}",
                                      "Data de Abertura": "${info.abertura}",
                                      "E-mail": "${infos[1]}",
                                      "Telefone": "${info.telefone.toString() == 'null' ? '' : info.telefone}",
                                      "Whatsapp": "${doc.wpp}",
                                      "Endereço": "${doc.logradouro}",
                                      "Número": "${doc.numero}",
                                      "Bairro": "${doc.bairro}",
                                      "Complemento": doc.complemento.toString() == 'null' ? "" : "${doc.complemento}",
                                      "Cidade": "${doc.localidade}",
                                      "Estado": "${doc.uf}",
                                      "CEP": "${doc.cep}",
                                      "Nome Completo": "${doc.nome}",
                                      "CPF": "${doc.cpf}",
                                      "Data de Nascimento": "${doc.datanascimento}",
                                      "RG": "${doc.rg}",
                                      "natureza da conta": "${conta.natureza}",
                                      "Tipo de conta": "${conta.tipoConta}",
                                      "Banco": "${conta.banco}",
                                      "Agência": "${conta.agencia}",
                                      "Conta": "${conta.conta}",
                                      "Nome do Favorecido": "${conta.nomeFav}",
                                      "CPF FAVORECIDO": "${doc.cpf}",
                                      "CNPJ FAVORECIDO": "${info.cnpj}",
                                      "TPV Negociado": "${_tpv.text}",
                                      "Operadora": "${_operadora.text.toUpperCase()}",
                                      "Mensalidade": "${_mensalidade.text}",
                                      "Consultoria Mensal": "${_consultMensal.text.toUpperCase()}",
                                      "MARCA": " ${checked1 == true ? 'EP5855' : ''} ${checked2 == true ? 'A910' : ''} ${checked3 == true ? 'S920' : ''} ${checked4 == true ? 'A920' : ''} ${checked5 == true ? 'N910' : ''}",
                                      "Quantidade de POS": "${_pos.text}",
                                      "Carência Aluguel": "${_carencia.text}",
                                      "DÉBITO VISA/MASTER": "${taxas[10]}%",
                                      "À VISTA VISA/MASTER": "${taxas[6]}%",
                                      "2X A 6X VISA/MASTER": "${taxas[7]}%",
                                      "7X A 12X VISA/MASTER": "${taxas[8]}%",
                                      "DÉBITO": "${taxas[5]}%",
                                      "À VISTA": "${taxas[1]}%",
                                      "2X A 6X": "${taxas[2]}%",
                                      "7X A 12X": "${taxas[3]}%",
                                      "Antecipação": "${taxas[4]}. ${taxas[0]}",
                                      " A.M - P.P.": "${_AMPP}",
                                      "Consultor": "${_nomeConsultor.text}",
                                      "E-mail Consultor": "${user.email}"
                                    }
                                  }
                                }
                              }));
                              print(response.statusCode);
                              if(response.statusCode == 201){
                                var  content = json.decode(response.body);
                                var documentKey = content['document']['key'];
                                mydocs.key = documentKey;
                                conn.insertMyDocs(mydocs);
                                
                                var keysSig = [environment.keySigContratante[0], environment.keySigTestemunha1[0], environment.keySigTestemunha2[0], sigKey];
                                var sign_as = [environment.keySigContratante[1], environment.keySigTestemunha1[1], environment.keySigTestemunha2[1], 'contractor'];
                                //var keysSig = [environment.keySig[0], sigKey];
                                //var sign_as = [environment.keySig[1], 'contractor'];
                                var url = Uri.parse('${environment.baseUrlTeste}/api/v1/lists?access_token=${environment.acessToken}');
                                var url2 = Uri.parse('${environment.baseUrlTeste}/api/v1/notifications?access_token=${environment.acessToken}');

                                // Envio de Notificação via WPP
                                //var url2 = Uri.parse('${environment.baseUrlTeste}/api/v1/notify_by_whatsapp?access_token=${environment.acessToken}');

                                try{
                                  print("Entrei no terceiro try");

                                  for(int i = 0; i <= keysSig.length; i++){
                                    print(keysSig[i]);
                                    print(documentKey);

                                    var response = await http.post(url,
                                      headers: {
                                        "Content-Type": "application/json"
                                      },
                                      body: json.encode(
                                        {
                                          "list": {
                                            "document_key": "${documentKey}",
                                            "signer_key": "${keysSig[i]}",
                                            "sign_as": "${sign_as[i]}",
                                            "refusable": true,
                                            "group": 0,
                                            "message": "Prezados,\nFavor validar contrato e posteriormente assinar.\n\nQualquer dúvida, tratar com seu consultor.\n\nAtenciosamente,\nGrupo Akrivia!"
                                          }
                                        }
                                      )
                                    );
                                    var content = json.decode(response.body);
                                    print('--------------------------------------------');
                                    print(content);
                                    print(content['list']['request_signature_key']);
                                    print('---------------------------------------------');

                                    var response2 = await http.post(
                                      url2,
                                      headers: {
                                        "Content-Type": "application/json"
                                      },
                                      body: json.encode(
                                        {
                                          "request_signature_key": "${content['list']['request_signature_key']}",
                                          "message": "Prezados,\nFavor validar contrato e posteriormente assinar.\n\nQualquer dúvida, tratar com seu consultor.\n\nAtenciosamente,\nGrupo Akrivia!"
                                        }
                                      )
                                    );
                                    print(response2.statusCode);
                                  }

                                }catch(e){
                                  print(e);
                                }
                                finally{
                                  setState(() {
                                    loading = false;
                                  });
                                  Navigator.pushReplacementNamed(context, '/confirmar');
                                }
                              }else if(response.statusCode == 422){
                                var content = json.decode(response.body);
                                Fluttertoast.showToast(msg: '${content['errors'][0]}');
                                return;
                              }else{
                                Fluttertoast.showToast(msg: "Erro! Verifique sua conexão com a internet.");
                              }

                            }catch(e){
                              print(e);
                            }
                          }else if(response.statusCode == 422){
                            var content = json.decode(response.body);
                            setState((){
                              loading = false;
                            });
                            Fluttertoast.showToast(msg: '${content['errors'][0]}',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM
                            );
                            print("Dados informados Incorretamente");
                            return;
                          }else{
                            Fluttertoast.showToast(msg: "Erro! Verifique sua conexão com a internet.");
                          }
                        }catch(e){
                          print("Entrei no catch");
                          print(e);
                        }
                      }
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      print(taxas);
                      Navigator.pop(context);
                    },
                    child: Text("Verificar dados"),
                  )
                ],
              )
              :
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                    width: MediaQuery.of(context).size.height * 0.03,
                    child: const CircularProgressIndicator(),
                  )
                ],
              )
            ],
          );
        })
        );
    });
  }

  @override
  Widget build(BuildContext context) {

    final loading = ValueNotifier<bool>(false);

    Map argumentos = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
        children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/AKRIVIA-QUADRADO-Fundo.png"),
              fit: BoxFit.fitWidth
            )
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
        color: const Color.fromARGB(223, 201, 201, 201),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: SingleChildScrollView(child: Column(
            children: [
              Padding(
        padding: const EdgeInsets.only(
          top: 40,
          right: 40,
          left: 40,
          bottom: 20
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Negociação / Plano Contratado",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22
                  ),
              ),
              TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return 'Informe os dados';
                  }
                  return null;
                },
                controller: _tpv,
                decoration: const InputDecoration(
                  labelText: 'TPV Negociado *'
                ),
              ),
              TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return 'Informe os dados';
                  }
                  return null;
                },
                controller: _operadora,
                decoration: const InputDecoration(
                  labelText: 'Operadora *'
                ),
              ),
              TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return 'Informe os dados';
                  }
                  return null;
                },
                controller: _mensalidade,
                decoration: const InputDecoration(
                  labelText: 'Mensalidade *'
                ),
              ),
              TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return 'Informe os dados';
                  }
                  return null;
                },
                controller: _consultMensal,
                decoration: const InputDecoration(
                  labelText: 'Consultoria Mensal *'
                ),
              ),
              TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return 'Informe os dados';
                  }
                  return null;
                },
                controller: _pos,
                decoration: const InputDecoration(
                  labelText: 'Qnt. POS *'
                ),
              ),
              TextFormField(
                validator: (value){
                  if(value!.isEmpty){
                    return 'Informe os dados';
                  }
                  return null;
                },
                controller: _carencia,
                decoration: const InputDecoration(
                  labelText: 'Carência *'
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CheckboxListTile(
                title: Text("EP5855"), 
                value: checked1, 
                onChanged: (bool? value){
                setState(() {
                  checked1 = value!;
                });
              }),
              CheckboxListTile(
                title: Text("A910"),
                value: checked2, 
                onChanged: (bool? value){
                setState(() {
                  checked2 = value!;
                });
              }),
              CheckboxListTile(
                title: Text("S920"),
                value: checked3, 
                onChanged: (bool? value){
                setState(() {
                  checked3 = value!;
                });
              }),
              CheckboxListTile(
                title: Text("A920"),
                value: checked4, 
                onChanged: (bool? value){
                setState(() {
                  checked4 = value!;
                });
              }),
              CheckboxListTile(
                title: Text("N910"),
                value: checked5, 
                onChanged: (bool? value){
                setState(() {
                  checked5 = value!;
                });
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text("Antecipação: ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  DropdownButton(
                    hint: Text(_AMPP),
                    items: ['Ao Mês', 'Por Parcela'].map((String value){
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value)
                      );
                    }).toList(),
                    onChanged: (_){
                      setState(() {
                        _AMPP = _.toString();
                      });
                  }),
                ],
              ),
              const SizedBox(
                height: 60,
              ),
              Container(
              height: 60,
              width: MediaQuery.of(context).size.width * 0.5,
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3, 1],
                  colors: [
                    Color.fromRGBO(4,30,55,1),
                    Color.fromRGBO(3,15,30,.7),
                  ],
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(5)
                )
              ),
              child: TextButton(onPressed: () async {
                if(checked1 == false && checked2 == false && checked3 == false && checked4 == false && checked5 == false){
                  Fluttertoast.showToast(msg: "É necessário selecionar ao menos um equipamento.");
                  return;
                }
                if(_formKey.currentState!.validate()){
                  showDialogDoc(context, argumentos['taxas'], argumentos['infos'], loading.value);
                }
                }, child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text("Gerar Documento",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      )
                    ],
                  )
                )
              )
            ],
          ),
        ),)
            ]))))]))
    );
  }
}