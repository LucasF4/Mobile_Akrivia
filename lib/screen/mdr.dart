import 'dart:convert';

import 'package:akrivia_vendas/Database/connection.dart';
import 'package:akrivia_vendas/models/customPopupMenu.dart';
import 'package:akrivia_vendas/models/resultado.dart';
import 'package:akrivia_vendas/models/userModel.dart';
import 'package:akrivia_vendas/models/info.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MDR extends StatefulWidget {
  const MDR ({Key?key}) : super(key: key);
  @override
  State<MDR> createState() => _MDRState();
}

/* class Info{
  int? MCC;
  String? MDR;
  
  Info(this.MCC, this.MDR);
} */

class _MDRState extends State<MDR>{

  User user = User();
  Info info = Info();
  Resultado resultadoClass = Resultado();

  TextEditingController _emailUser = TextEditingController();
  TextEditingController _mcc = TextEditingController();
  TextEditingController _cnpj = TextEditingController();
  String _credito = 'Sim';

  final maskInputCNPJ = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy
  );

  final maskTaxa = MaskTextInputFormatter(
    mask: '#,##',
    filter: {'#': RegExp(r'[0-9]'),},
  );

  Connection connection = Connection();
  List<Map<String, dynamic>> _items = [
    {"mcc": 742, "mdr": "Veterinários e Clínicas Veterinárias", "master":[{"debito": "0.98"}]},
    {"mcc": 763, "mdr": "Cooperativas Agrícolas"},
    {"mcc": 780, "mdr": "Jardinagem e Paisagismo"},
  ];

  List<CustomPopupMenu> choice = [
    CustomPopupMenu('config', "Configurações", Icons.engineering_rounded),
    CustomPopupMenu('exit', "Sair", Icons.exit_to_app),
  ];

  static const List<String> items = [
      '742 - Veterinários e Clínicas Veterinárias',
      '763 - Cooperativas Agrícolas',
      '780 - Jardinagem e paisagismo'
    ];

  void deletUser() async {
    print("DELETANDO USUÁRIO");
    await connection.delete("user");
    Navigator.pushReplacementNamed(context, '/');
  }

  void selectUser(){
    print('Entrei no selectUser');
    connection.select().then((result) {
      setState(() {
        user.email = result[0].email;
        _emailUser.text = user.email.toString();
      });
    });
  }

  void selectInfo(){
    connection.selectInfo().then((result){
      setState(() {
        _mcc.text = result.isEmpty ? '742 - Veterinários e Clínicas Veterinárias' : result[0].mcc.toString();
        _cnpj.text = result[0].cnpj.toString();
        print("=======================");
      });
    });
  }

  void configuracoes(bool menu){
    showDialog(
      context: context,
      builder: (context){
        return SingleChildScrollView(
          child: AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("CONFIGURAÇÕES",
                style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark),
                ),
              ],
            ),
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: _emailUser,
                    decoration: InputDecoration(
                      labelText: "E-mail"
                    ),
                  ),
                  TextField(
                    controller: _cnpj,
                    decoration: InputDecoration(
                      labelText: "CNPJ"
                    ),
                    inputFormatters: [maskInputCNPJ],
                  ),
                  Autocomplete<String>(
                    initialValue: TextEditingValue(text: _mcc.text),
                    optionsBuilder: (TextEditingValue textEditingValue){
                    if(textEditingValue.text == ''){
                      return const Iterable.empty();
                    }
                    return items.where((item){
                      return item.contains(textEditingValue.text.toLowerCase());
                    });
                  },
                  onSelected: (String item){
                    print("The value selected is $item");
                    _mcc.text = item;
                  },
                  )
                ],
              )
            ),
            actions: [
              TextButton(
                child: Text("Salvar"),
                onPressed: (){
                  user.email = _emailUser.text;
                  info.cnpj = _cnpj.text;
                  info.mcc = _mcc.text;
                  connection.selectInfo().then((resp) async {
                    if(resp.isEmpty){
                      await connection.createInf(info);
                    }else{
                      await connection.updateInf(info);
                    }
                    print(resp);
                    await connection.update(user);
                    await _consultarCnpj();
                    Navigator.pop(context);
                    setState(() {});
                  });
                },
              ),
              if(menu == true ) TextButton(
                child: Text("Cancelar"),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      }
    );
  }

  void sendMail() async {
    String username = '';
    String password = '';

    final smtpServer = SmtpServer(
      "smtp.office365.com",
      port: 587,
      username: username,
      password: password,
    );

    final message = Message()
    ..from = Address(username)
    ..recipients.add(user.email)
    ..ccRecipients.addAll([])
    ..subject = "Email Teste"
    ..html = "<h1>E-mail via SMTP de teste.</h1>";
    var connection = PersistentConnection(smtpServer);

    try{
      await connection.send(message);
      Fluttertoast.showToast(msg: "Sucesso ao enviar Email");
    }catch(e){
      print(e);
      Fluttertoast.showToast(msg: "Ocorreu um erro na tentativa de enviar o email");
    }finally{
      connection.close();
    }
  }

  @override
  void initState(){
    super.initState();
      Future.delayed(
        Duration(seconds: 1),
        (){
          selectUser();
          selectInfo();
          configuracoes(false);
        }
      );
  }

  @override
  Widget build(BuildContext context){
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(4,30,55,1),
        title: Text(info.mcc.toString()),
        actions: [
          PopupMenuButton<CustomPopupMenu>(
            elevation: 3.2,
            onCanceled: (){
              print("You have not chossed anything");
            },
            tooltip: "Ações do App",
            onSelected: _selectOptionMenu,
            itemBuilder: (BuildContext context) {
              return choice.map((CustomPopupMenu choice){
                return PopupMenuItem(
                  value: choice,
                  enabled: true,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(choice.icon, color: Colors.black),
                      ),
                      Text(choice.title)
                    ],
                  ),
                );
              }).toList();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.88,
          decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/AKRIVIA-QUADRADO-Fundo.png"),
            fit: BoxFit.fitWidth
          )
        ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.88,
        color: const Color.fromARGB(223, 201, 201, 201),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                            resultadoClass.nome.toString() == 'null' ? "PRECISA INFORMAR UM CNPJ VÁLIDO" : '${resultadoClass.nome}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Situação: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          resultadoClass.situacao == 'ATIVA' 
                          ? 
                          Text(
                            '${resultadoClass.situacao}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          )
                          :
                          Expanded(child: Text(
                            resultadoClass.situacao.toString() == 'null' ? "CNPJ Inválido" : '${resultadoClass.situacao}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),)
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Contato: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Expanded(child: Text(
                            resultadoClass.telefone.toString() == 'null' ? "CNPJ Inválido" : '${resultadoClass.telefone}',
                            style: TextStyle(
                              fontSize: 18
                            ),
                          ))
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Email: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            resultadoClass.email.toString() == 'null' ? "CNPJ Inválido" : '${resultadoClass.email}',
                            style: TextStyle(
                              fontSize: 18
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      child: TextField(
                      decoration: const InputDecoration(
                          labelText: "1X",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                    const SizedBox(width: 20,),
                    SizedBox(
                      width: 90,
                      child: TextField(
                      decoration: const InputDecoration(
                          labelText: "2X A 6X",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                    SizedBox(width: 20,),
                    SizedBox(
                      width: 90,
                      child: TextField(
                      decoration: const InputDecoration(
                          labelText: "7X A 24X",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      child: TextField(
                      decoration: const InputDecoration(
                          labelText: "Débito",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                    const SizedBox(width: 10,),
                    SizedBox(
                      width: 90,
                      child: TextField(
                      decoration: const InputDecoration(
                          labelText: "Antecipação",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                  ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Crédito Altomático: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(width: 10,),
                    DropdownButton(
                      hint: Text(_credito),
                      items: ['Sim', 'Não'].map((String value){
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value)
                        );
                      }).toList(),
                      onChanged: (_){
                        setState(() {
                          _credito = _.toString();
                        });
                    })
                  ],
                ),
              ),
              Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width / 1.35,
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
                          Text('Enviar Análise',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        print("Enviando email!");
                        sendMail();
                      },
                    ),
                  ),
                )
            ],
          )
        )
      )
      ])
    ));
  }

  void _selectOptionMenu(CustomPopupMenu result){
    switch(result.id){
      case 'exit':
        deletUser();
        break;
      
      case 'config':
        configuracoes(true);
        break;
    }
    setState(() {});
  }

  Future _consultarCnpj() async {
    var cnpjReplacement =
        _cnpj.text.replaceAll('.', '').replaceAll('/', '').replaceAll('-', '');
    print(cnpjReplacement);

    var url =
        Uri.parse('https://www.receitaws.com.br/v1/cnpj/$cnpjReplacement');
    try {
      var response = await http.get(url);
      print('Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        var content = json.decode(response.body);
        print(content['nome']);
        print(content);
        if (content['status'] == "ERROR") {
          print('${content['message']}');
          Fluttertoast.showToast(msg: '${content['message']}');
        }

        Map<String, dynamic> dados = json.decode(response.body);

        setState(() {
          resultadoClass.cnpj = _cnpj.text;
          resultadoClass.nome = dados['nome'];
          resultadoClass.cep = dados['cep'];
          resultadoClass.situacao = dados['situacao'];
          resultadoClass.fantasia = dados['fantasia'];
          resultadoClass.bairro = dados['bairro'];
          resultadoClass.logradouro = dados['logradouro'];
          resultadoClass.numero = dados['numero'];
          resultadoClass.municipio = dados['municipio'];
          resultadoClass.uf = dados['uf'];
          resultadoClass.dataSituacao = dados['data_situacao'];
          resultadoClass.email = dados['email'];
          resultadoClass.telefone = dados['telefone'];
          resultadoClass.motivoSituacao = dados['motivo_situacao'];
        });
      } else if (response.statusCode == 429) {
        print("Ocorreu um erro");
        Fluttertoast.showToast(
            msg: 'Aguarde 1 minuto para fazer uma nova consulta.');
      } else {
        print("Problemas com a conexão");
        print(response.statusCode);
        Fluttertoast.showToast(msg: 'Algo deu errado!');
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Verifique a sua conexão com a internet.");
    }
  }

}