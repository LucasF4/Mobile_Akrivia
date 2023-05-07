import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:akrivia_vendas/models/userModel.dart';
import 'package:akrivia_vendas/rotas/app_rotas.dart';
import 'package:akrivia_vendas/rotas/environment.dart';
import 'package:akrivia_vendas/Database/connection.dart';
import 'package:akrivia_vendas/models/info.dart';

class CustoEfetivo extends StatefulWidget {
  const CustoEfetivo({super.key});

  @override
  State<CustoEfetivo> createState() => _CustoEfetivoState();
}

class _CustoEfetivoState extends State<CustoEfetivo> {

  User user = User();
  Info info = Info();
  Connection conn = Connection();
  bool _preload = false;

  void showDialogMail(array){
    
    showDialog(
      context: context,
      builder: (context){
        return SingleChildScrollView(
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
                children: const [
                  Text(
                    'Verificamos que você utilizou taxas menores do que o mínimo estabelecido pela empresa, com isso é necessário enviar um email para a realização da avaliação de sua proposta pelos responsáveis.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              _preload == false ?
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                          setState(() {
                            _preload = true;
                          });
                          await sendMail(array);
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
                const CircularProgressIndicator()
            ],
          ),
        );
      }
    );

  }

  Future sendMail(array) async {
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
                  <p><b>CNPJ:</b> ${info.cnpj}</p>
                  <p><b>Fantasia:</b> ${info.fantasia}</p>
                  <p><b>Razão Social:</b> ${info.razaoSocial}</p>
                  <p><b>Abertura:</b> ${info.abertura}</p>
                  <p><b>E-mail:</b> ${info.email}</p>
                  <p><b>Telefone:</b> ${info.telefone}</p>
                </div>
                <div>
                  <h3>Dados da Proposta</h3>
                  <p><b>MCC:</b> ${info.mcc}</p>
                  <p><b>1X:</b> ${array[1].toString()}</p>
                  <p><b>2 A 6X:</b> ${array[2].toString()}</p>
                  <p><b>7 A 24X:</b> ${array[3].toString()}</p>
                  <p><b>Crédito:</b> ${array[5].toString()}</p>
                  <p><b>Antecipação Automática:</b> ${array[0].toString()}</p>
                  <p><b>Débito Automático:</b> ${array[4].toString()}</p>
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
      setState(() {
        _preload = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map teste = ModalRoute.of(context)!.settings.arguments as Map;

    user.email = teste['email'].toString();
    info.cnpj = teste['info'].cnpj;
    info.mcc = teste['info'].mcc;
    info.razaoSocial = teste['info'].razaoSocial;
    info.fantasia = teste['info'].fantasia;
    info.abertura = teste['info'].abertura;
    info.email = teste['info'].email;
    info.telefone = teste['info'].telefone;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(4,30,55,1),
        title: const Text("Tabela de Custo Efetivo"),
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
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Table(
                    border: TableBorder.all(color: Colors.black),
                    columnWidths: const {
                      0: FixedColumnWidth(40.0),
                      1: FixedColumnWidth(90.0),
                    },
                    children: [
                      for(int i = 0; i < 12; i++)
                        TableRow(
                          children: [
                            Container(
                              color: i == 11 ? Color.fromRGBO(102, 102, 102, 1) : Color.fromRGBO(4,30,55,1),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                i < 9 
                                ? 
                                "0${(i + 1).toString().replaceAll('.', ',')}X"
                                :
                                "${(i+1).toString().replaceAll('.', ',')}X",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            ),
                            Container(
                              color: i == 11 ? Color.fromRGBO(102, 102, 102, 1) : Color.fromRGBO(14, 95, 170, 1),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Center(
                                  child: Text(
                                    teste['table'][i].toString().replaceAll('.', ','),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              )
                            )
                          ]
                        )
                    ]
                  ),
                  Table(
                    border: TableBorder.all(color: Colors.black),
                    columnWidths: const {
                      0: FixedColumnWidth(40.0),
                      1: FixedColumnWidth(90.0),
                    },
                    children: [
                      for(int i = 12; i < 24; i++)
                        TableRow(
                          children: [
                            Container(
                              color: Color.fromRGBO(4,30,55,1),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                i < 9 
                                ? 
                                "0${(i + 1).toString().replaceAll('.', ',')}X"
                                :
                                "${(i+1).toString().replaceAll('.', ',')}X",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            ),
                            Container(
                              color: Color.fromRGBO(14, 95, 170, 1),
                              child: Padding(
                                padding: EdgeInsets.all(5),
                                child: Center(
                                  child: Text(
                                    teste['table'][i].toString().replaceAll('.', ','),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              )
                            )
                          ]
                        ),
                    ]
                  ),
                ]
          ),
          SizedBox(height: 60,),
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
                          Text(
                            'Gerar Documento',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/document');
                      },
                    ),
                  ),
                )
            ],
          )
        )
        )
        ]
      )
      )
    );
  }
}