import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;

import 'package:akrivia_vendas/Database/connection.dart';
import 'package:akrivia_vendas/models/info.dart';
import 'package:akrivia_vendas/rotas/environment.dart';
import 'package:akrivia_vendas/models/doc.dart';

class infoDocs extends StatefulWidget {
  const infoDocs({super.key});

  @override
  State<infoDocs> createState() => _infoDocsState();
}

class _infoDocsState extends State<infoDocs> {

  Info info = Info();
  Doc doc = Doc();
  Connection conn = Connection();

  final _cep = TextEditingController();
  final _logradouro = TextEditingController();
  final _bairro = TextEditingController();
  final _localidade = TextEditingController();
  final _uf = TextEditingController();
  final _numero = TextEditingController();
  final _complemento = TextEditingController();
  final _email = TextEditingController();
  final _fantasia = TextEditingController();
  final _tipo = TextEditingController();
  final _abertura = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final maskData = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy
  );

  final maskInputCEP = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy
  );

  @override
  void initState(){
    super.initState();
    conn.selectInfo().then((res){
      print("---------------");
      print(res);
      conn.selectDoc().then((resp){
        print("-------------------");
        print(resp);
        setState(() {
          info.fantasia = res[0].fantasia;
          info.abertura = res[0].abertura;
          info.email = res[0].email;
          info.telefone = res[0].telefone;
          _abertura.text = info.abertura.toString() == 'null' ? '' : info.abertura.toString();
          _fantasia.text = info.fantasia.toString() == 'null' ? '' : info.fantasia.toString();
          _email.text = info.email.toString() == 'null' ? '' : info.email.toString();
          _logradouro.text = resp[0].logradouro;
          _tipo.text = resp[0].tipo;
          _bairro.text = resp[0].bairro;
          _localidade.text = resp[0].localidade;
          _uf.text = resp[0].uf;
          _numero.text = resp[0].numero;
          _cep.text = resp[0].cep;
      });
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    Map teste = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      body: SingleChildScrollView(child: Stack(children: [
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
        padding: const EdgeInsets.only(
          top: 40,
          left: 40,
          right: 40
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 120,
                            child: TextField(
                              autofocus: true,
                              controller: _cep,
                              decoration: InputDecoration(
                                labelText: 'Informe um CEP'
                              ),
                              inputFormatters: [maskInputCEP],
                            ),
                          ),
                          Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.3,
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
                          child: SizedBox.expand(
                            child: TextButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Text('Pesquisar CEP',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                var cep = _cep.text.replaceAll('-', '');
                                var url = Uri.parse('https://viacep.com.br/ws/$cep/json/');

                                try{
                                  var response = await http.get(url);
                                  if(response.statusCode == 200){
                                    var content = json.decode(response.body);
                                    setState(() {
                                      _logradouro.text = content['logradouro'];
                                      _bairro.text = content['bairro'];
                                      _localidade.text = content['localidade'];
                                      _uf.text = content['uf'];
                                    });
                                  }
                                }catch(e){
                                  print(e);
                                }
                              },
                            ),
                          ),
                        )
                        ],
                      ),
                      TextField(
                        controller: _complemento,
                        decoration: InputDecoration(
                          labelText: 'Complemento'
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Vazio';
                                }
                                return null;
                              },
                              controller: _logradouro,
                              decoration: InputDecoration(
                                labelText: 'Logradouro *'
                              ),
                            ),
                            TextFormField(
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Vazio';
                                }
                                return null;
                              },
                              controller: _bairro,
                              decoration: InputDecoration(
                                labelText: 'Bairro *'
                              ),
                            ),
                            TextFormField(
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Vazio';
                                }
                                return null;
                              },
                              controller: _localidade,
                              decoration: InputDecoration(
                                labelText: 'Localidade *'
                              ),
                            ),
                            TextFormField(
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Vazio';
                                }
                                return null;
                              },
                              controller: _uf,
                              decoration: InputDecoration(
                                labelText: 'UF *'
                              ),
                            ),
                            TextFormField(
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Vazio';
                                }
                                return null;
                              },
                              controller: _numero,
                              decoration: const InputDecoration(
                                labelText: 'Número *'
                              ),
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: false,
                                signed: true,
                              ),
                            ),
                            TextFormField(
                              controller: _fantasia,
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Vazio';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Nome Fantasia *'
                              ),
                            ),
                            TextFormField(
                              controller: _tipo,
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Vazio';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Tipo de Empresa *'
                              ),
                            ),
                            TextFormField(
                              controller: _abertura,
                              inputFormatters: [maskData],
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Vazio';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Data Abertura *'
                              ),
                            ),
                            TextFormField(
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Vazio';
                                }
                                return null;
                              },
                              controller: _email,
                              decoration: InputDecoration(
                                labelText: 'E-mail *'
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.3,
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
                              if(_formKey.currentState!.validate()){
                                  await conn.updateFantasia(_fantasia.text);
                                  await conn.updateAbertura(_abertura.text);
                                  await conn.selectDoc().then((resp) async {
                                  print(resp.length);
                                  if(resp.length == 0){
                                    doc.cep = _cep.text;
                                    doc.tipo = _tipo.text;
                                    doc.logradouro = _logradouro.text;
                                    doc.bairro = _bairro.text;
                                    doc.localidade = _localidade.text;
                                    doc.uf = _uf.text;
                                    doc.numero = _numero.text;
                                    await conn.insertDoc(doc);
                                  }else{
                                    doc.cep = _cep.text;
                                    doc.tipo = _tipo.text;
                                    doc.complemento = _complemento.text;
                                    doc.logradouro = _logradouro.text;
                                    doc.bairro = _bairro.text;
                                    doc.localidade = _localidade.text;
                                    doc.uf = _uf.text;
                                    doc.numero = _numero.text;
                                    doc.nome = resp[0].nome;
                                    doc.cpf = resp[0].cpf;
                                    doc.datanascimento = resp[0].datanascimento;
                                    doc.rg = resp[0].rg;
                                    doc.wpp = resp[0].wpp;
                                    await conn.updateDoc(doc);
                                  }
                                });
                                Navigator.pushNamed(context, '/document2', arguments: {"taxas": teste['info'], "info": [_complemento.text, _email.text, info.telefone]});
                              }
                            }, child: 
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const <Widget>[
                                  Text("Próximo",
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
                      )
                    ],
                  ),
                )
            ],
          )
        ),
      ),
        )]))
    );
  }
}