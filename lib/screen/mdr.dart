import 'dart:convert';
import 'dart:ffi';

import 'package:akrivia_vendas/Database/connection.dart';
import 'package:akrivia_vendas/models/customPopupMenu.dart';
import 'package:akrivia_vendas/models/resultado.dart';
import 'package:akrivia_vendas/models/userModel.dart';
import 'package:akrivia_vendas/models/info.dart';
import 'package:akrivia_vendas/rotas/environment.dart';

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

  bool _preload = false;

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final _emailUser = TextEditingController();
  final _mcc = TextEditingController();
  final _cnpj = TextEditingController();
  final _antecipacaoVM = TextEditingController();
  final _umVM = TextEditingController();
  final _doisaseisVM = TextEditingController();
  final _seteavinteequatroVM = TextEditingController();
  final _debitoVM = TextEditingController();
  final _antecipacao = TextEditingController();
  final _um = TextEditingController();
  final _doisaseis = TextEditingController();
  final _seteavinteequatro = TextEditingController();
  final _debito = TextEditingController();
  final _TPV = TextEditingController();
  final _valorAluguel = TextEditingController();
  String _credito = 'Sim';
  int inputLength = 0;

  final maskInputCNPJ = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy
  );

  final maskInputCPF = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy
  );

  final maskTaxa = MaskTextInputFormatter(
    mask: '#,##',
    filter: {'#': RegExp(r'[0-9]'),},
  );

  Connection connection = Connection();
  List<Map<String, dynamic>> _items = [
    {"mcc": 742, "mdr": "Veterinários e Clínicas Veterinárias", "VM":{"debito": 1.12, "credito": 2.25, "2a6": 2.39, "7a12": 2.73}},
    {"mcc": 763, "mdr": "Cooperativas Agrícolas", "VM":{"debito": 1.10, "credito": 1.98, "2a6": 1.92, "7a12": 2.34}},
    {"mcc": 780, "mdr": "Jardinagem e Paisagismo", "VM":{"debito": 1.22, "credito": 2.21, "2a6": 2.37, "7a12": 2.66}},
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
        info.mcc = result[0].mcc.toString();
        _cnpj.text = result[0].cnpj.toString();
        info.razaoSocial = result[0].razaoSocial.toString();
        info.telefone = result[0].telefone.toString();
        info.email = result[0].email.toString();
        info.abertura = result[0].abertura.toString();
        print("${result[0].mcc.toString()}");
        print("=======================");
      });
    });
  }

  Future sendMail(array, tpv, aluguel) async {
    String username = environment.mail;
    String password = environment.passwordmail;

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
    ..subject = "Proposta para Avaliação - Mensagem Automática"
    ..html = """
              <h1>Solicitação de Avaliação.</h1>
              <p><b>Consultor:</b> ${user.email}</p>
              <div style="display: flex; justify-content: space-around;">
                <div>
                  <h3>Dados do Cliente</h3>
                  <hr>
                  <p><b>CNPJ:</b> ${info.cnpj == null ? 'Não Informado' : info.cnpj == '' ? 'Não Informado' : info.cnpj}</p>
                  <p><b>Fantasia:</b> ${info.fantasia == null ? 'Não Informado' : info.fantasia == '' ? 'Não Informado' : info.fantasia}</p>
                  <p><b>Razão Social:</b> ${info.razaoSocial}</p>
                  <p><b>Abertura:</b> ${info.abertura}</p>
                  <p><b>E-mail:</b> ${info.email}</p>
                  <p><b>Telefone:</b> ${info.telefone}</p>
                </div>
                <div>
                  <h3>Dados da Proposta</h3>
                  <hr>
                  <p><b>MCC:</b> ${info.mcc}</p>
                  <p><b>1X:</b> ${array[1].toString()}</p>
                  <p><b>2 A 6X:</b> ${array[2].toString()}</p>
                  <p><b>7 A 24X:</b> ${array[3].toString()}</p>
                  <p><b>Crédito:</b> ${array[5].toString()}</p>
                  <p><b>1X VISA/MASTER:</b> ${array[1].toString()}</p>
                  <p><b>2 A 6X VISA/MASTER:</b> ${array[2].toString()}</p>
                  <p><b>7 A 24X VISA/MASTER:</b> ${array[3].toString()}</p>
                  <p><b>Crédito VISA/MASTER:</b> ${array[5].toString()}</p>
                  <p><b>Antecipação Automática:</b> ${array[0].toString()}</p>
                  <p><b>Débito Automático:</b> ${array[4].toString()}</p>
                  <p><b>TPV:</b> ${tpv.toString()}</p>
                  <p><b>Aluguel:</b> ${aluguel.toString()}</p>
                </div>
                <div>
                  <h3>Média Visa/Master</h3>
                  <hr>
                  <p>Débito: ${(array[11]['VM']['debito']).toString().replaceAll('.', ',')}</p>
                  <p>1X: ${array[11]['VM']['credito']}</p>
                  <p>2X a 6X: ${array[11]['VM']['2a6']}</p>
                  <p>7X a 12X: ${array[11]['VM']['7a12']}</p>
                </div>
              </div>
              <br>
              <P style="color: red"><b>Atenção:</b> Essa mensagem é automática. Por favor, caso necessite de alguma resposta referente a essa solicitação, encaminhar para os e-mails citados neste.</p>
              <p style="display: center;">Atenciosamente, Grupo Akrivia!</p>
            """;
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
                    initialValue: TextEditingValue(text: info.mcc.toString() == 'null' ? items[0] : info.mcc.toString()),
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
                onPressed: () async{
                  if(_cnpj.text.length == 18){
                    await _consultarCnpj();
                  }
                  if(_mcc.text == ''){
                    _mcc.text = info.mcc.toString() == 'null' ? items[0] : info.mcc.toString();
                  }
                  print(info.mcc.toString());
                  print("......................");
                  user.email = _emailUser.text;
                  info.cnpj = _cnpj.text;
                  info.mcc = _mcc.text;
                  info.razaoSocial = resultadoClass.nome;
                  info.fantasia = resultadoClass.fantasia;
                  info.abertura = resultadoClass.abertura;
                  info.email = resultadoClass.email;
                  info.telefone = resultadoClass.telefone;
                  connection.selectInfo().then((resp) async {
                    if(resp.isEmpty){
                      await connection.createInf(info);
                    }else{
                      await connection.updateInf(info);
                    }
                    print(resp);
                    await connection.update(user);
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

  void showDialogMail(array){
    
    showDialog(
      context: context,
      builder: (context){
        return SingleChildScrollView(
          child:StatefulBuilder(builder: (context, setState){
            return Form(
              key: _formKey2,
              child: AlertDialog(
              title: Text(
                "Avaliação Necessária!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark
                ),
              ),
              content: Container(
                child: Column(
                  children: [
                    const Text(
                      'Verificamos que você utilizou taxas menores do que o mínimo estabelecido pela empresa, com isso é necessário enviar um email para a realização da avaliação de sua proposta pelos responsáveis.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    TextFormField(
                      controller: _TPV,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Informar Valor';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "TPV Negociado"
                      ),
                    ),
                    TextFormField(
                      controller: _valorAluguel,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Informar Valor';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Valor Aluguel"
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                !_preload ?
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            if(_formKey2.currentState!.validate()){
                              setState((){
                                _preload = true;
                              });
                              await sendMail(array, _TPV.text, _valorAluguel.text);
                              setState((){
                                _preload = false;
                              });
                            }
                          }, child: const Text("Enviar")
                        ),
                        TextButton(
                          onPressed: (){
                            print(array);
                            Navigator.pop(context);
                          }, child: const Text("Cancelar")
                        )
                      ],
                    ),
                  )
                :
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.height *0.03,
                      height: MediaQuery.of(context).size.height * 0.03,
                      child: const CircularProgressIndicator(),
                    )
                  ],
                )
              ],
            ));
          })
        );
      }
    );

  }

  void calc(txAnt, um, doisseis, setevintequatro, credito, debito, umVm, doisVm, seteVm, txAntVM, debitoVM){
    List<dynamic> parcelasCET = [];
    List<dynamic> parcelasCETVM = [];
    List<dynamic> custoEfetivo = [];
    List<dynamic> custoEfetivoVM = [];
    int dias = 29;
    int aux = 0;
    int aux2_ = 0;
    int aux2 = 1;
    double parse = double.parse(txAnt.replaceAll(',','.'));
    double parseVM = double.parse(txAntVM.replaceAll(",", "."));

    double firstField = double.parse(um.replaceAll(',', '.'));
    double secondField = double.parse(doisseis.replaceAll(',', '.'));
    double thirdField = double.parse(setevintequatro.replaceAll(',', '.'));
    double firstFieldVM = double.parse(umVm.replaceAll(',', '.'));
    double secondFieldVM = double.parse(doisVm.replaceAll(',', '.'));
    double thirdFieldVM = double.parse(seteVm.replaceAll(',', '.'));

    for(int i = 1; i <= 24; i++){
      if(i == 1){
        String result = ((parse/30)*((dias*i))).toStringAsFixed(2);
      }
      
      String result = ((parse/30)*((dias*i)+i-1)).toStringAsFixed(2);

      parcelasCET.add(result);
      
    }

    for(int i = 1; i <= 24; i++){
      if(i == 1){
        String result = ((parseVM/30)*((dias*i))).toStringAsFixed(2);
      }
      
      String result = ((parseVM/30)*((dias*i)+i-1)).toStringAsFixed(2);

      parcelasCETVM.add(result);
      
    }
    
    for(int i = 1; i <= 12; i++){
      if(i == 1){
        double result = (firstField + double.parse(parcelasCET[aux]));
        custoEfetivo.add((result).toStringAsFixed(2));
      }else if(i >= 2 && i <= 6){
        double result = (((double.parse(parcelasCET[0]) + double.parse(parcelasCET[aux]))/2)+secondField);
        custoEfetivo.add((result).toStringAsFixed(2));
      }else if(i >= 7 && i <= 12){
        double result = (((double.parse(parcelasCET[0]) + double.parse(parcelasCET[aux]))/2)+thirdField);
        custoEfetivo.add((result).toStringAsFixed(2));
      }
      // ------------------> CRIAÇÃO DA TABELA A PARTIR DE 24 VEZES <-----------------
      /* else if(i >= 13 && i <= 24){
        double result = (((double.parse(parcelasCET[aux2]) + double.parse(parcelasCET[aux]))/2)+thirdField);
        custoEfetivo.add((result + 0.005).toStringAsFixed(2));
        aux2++;
      } */
      aux ++;
    }

    for(int i = 1; i <= 12; i++){
      if(i == 1){
        double result = (firstFieldVM + double.parse(parcelasCETVM[aux2_]));
        custoEfetivoVM.add((result).toStringAsFixed(2));
      }else if(i >= 2 && i <= 6){
        double result = (((double.parse(parcelasCETVM[0]) + double.parse(parcelasCETVM[aux2_]))/2)+secondFieldVM);
        custoEfetivoVM.add((result).toStringAsFixed(2));
      }else if(i >= 7 && i <= 12){
        double result = (((double.parse(parcelasCETVM[0]) + double.parse(parcelasCETVM[aux2_]))/2)+thirdFieldVM);
        custoEfetivoVM.add((result).toStringAsFixed(2));
      }
      // ------------------> CRIAÇÃO DA TABELA A PARTIR DE 24 VEZES <-----------------
      /* else if(i >= 13 && i <= 24){
        double result = (((double.parse(parcelasCETVM[aux2_]) + double.parse(parcelasCETVM[aux2_]))/2)+thirdField);
        custoEfetivoVM.add((result + 0.005).toStringAsFixed(2));
        aux2_++;
      } */
      aux2_ ++;
    }

    Navigator.pushNamed(context, '/efetivo', arguments: {"table": custoEfetivo, "tableVM": custoEfetivoVM, "first": [txAnt, um, doisseis, setevintequatro, credito, debito, umVm, doisVm, seteVm, txAntVM, debitoVM], "email": user.email.toString(), "info": info});

  }

  @override
  void initState(){
    super.initState();
      Future.delayed(
        const Duration(milliseconds: 800),
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
        title: Text(info.mcc.toString() == 'null' ? 'Nome do MCC' : info.mcc.toString()),
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
        child: Stack(children: [
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
                            resultadoClass.nome.toString() == 'null' ? "PRECISA INFORMAR UM CNPJ VÁLIDO" : '${info.razaoSocial}',
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
                            resultadoClass.telefone.toString() == 'null' ? "CNPJ Inválido" : '${info.telefone}',
                            style: const TextStyle(
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
                            resultadoClass.email.toString() == 'null' ? "CNPJ Inválido" : '${info.email}',
                            style: const TextStyle(
                              fontSize: 18
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              const Text(
                "VISA/MASTER",
                style: TextStyle(
                  fontWeight: FontWeight.bold
                )
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _umVM,
                      decoration: const InputDecoration(
                          labelText: "1X",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                    const SizedBox(width: 20,),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _doisaseisVM,
                      decoration: const InputDecoration(
                          labelText: "2X A 6X",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                    const SizedBox(width: 20,),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _seteavinteequatroVM,
                      decoration: const InputDecoration(
                          labelText: "7X A 12X",
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
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _debitoVM,
                      decoration: const InputDecoration(
                          labelText: "Débito",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                    const SizedBox(width: 10,),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _antecipacaoVM,
                        decoration: const InputDecoration(
                          labelText: "Antecipação",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                  ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                color: Colors.black,
              ),
              const Text(
                "DEMAIS BANDEIRAS",
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _um,
                      decoration: const InputDecoration(
                          labelText: "1X",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                    const SizedBox(width: 20,),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _doisaseis,
                      decoration: const InputDecoration(
                          labelText: "2X A 6X",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                    const SizedBox(width: 20,),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _seteavinteequatro,
                      decoration: const InputDecoration(
                          labelText: "7X A 12X",
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
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _debito,
                      decoration: const InputDecoration(
                          labelText: "Débito",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                    const SizedBox(width: 10,),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _antecipacao,
                        decoration: const InputDecoration(
                          labelText: "Antecipação",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                  ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Crédito Automático: ",
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
                          Text('Avaliar Proposta',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        if(resultadoClass.fantasia.toString() == 'null'){
                          Fluttertoast.showToast(msg: "CNPJ não informado!\nVocê está trabalhando com CPF.");
                        }
                        if(_formKey.currentState!.validate()){
                          for(int i = 0; i < _items.length; i++){
                            if(info.mcc.toString().split(' - ')[0].contains(_items[i]['mcc'].toString())){
                              print(_items[i]);
                              if(double.parse(_debitoVM.text.replaceAll(',', '.')) < _items[i]['VM']['debito'] || 
                              double.parse(_umVM.text.replaceAll(',', '.')) < _items[i]['VM']['credito'] ||
                              double.parse(_doisaseisVM.text.replaceAll(',', '.')) < _items[i]['VM']['2a6'] ||
                              double.parse(_seteavinteequatroVM.text.replaceAll(',', '.')) < _items[i]['VM']['7a12'] ||
                              double.parse(_antecipacaoVM.text.replaceAll(',', '.')) < 1.69){
                                return showDialogMail([_antecipacao.text, _um.text, _doisaseis.text, _seteavinteequatro.text, _debito.text, _antecipacaoVM.text, _umVM.text, _doisaseisVM.text, _seteavinteequatroVM.text, _debitoVM.text, _credito, _items[i]]);
                              }
                            }
                          }
                          print(_items[0]['VM']['debito']);
                          print(info.mcc.toString().split(' - ')[0]);

                          setState(() {
                            print(resultadoClass.cnpj.toString());
                            print(_cnpj.text);
                            calc(_antecipacao.text, _um.text, _doisaseis.text, _seteavinteequatro.text, _credito, _debito.text, _umVM.text, _doisaseisVM.text, _seteavinteequatroVM.text, _antecipacaoVM.text, _debitoVM.text);
                          });
                        }
                      },
                    ),
                  ),
                )
            ],
          )
        )
      )
      ])
    ),
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
          resultadoClass.abertura = dados['abertura'];
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