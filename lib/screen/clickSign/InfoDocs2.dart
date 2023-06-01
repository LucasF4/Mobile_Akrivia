import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:akrivia_vendas/Database/connection.dart';
import 'package:akrivia_vendas/models/doc.dart';

class infoDocs2 extends StatefulWidget {
  const infoDocs2({super.key});

  @override
  State<infoDocs2> createState() => _infoDocs2State();
}

class _infoDocs2State extends State<infoDocs2> {

  Connection conn = Connection();
  Doc doc = Doc();

  final _telefone = TextEditingController();
  final _nome = TextEditingController();
  final _cpf = TextEditingController();
  final _nascimento = TextEditingController();
  final _rg = TextEditingController(); 
  final _wpp = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final maskDate = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy
  );

  final maskCPF = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy
  );

  final maskFone = MaskTextInputFormatter(
    mask: '(##) # ####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy
  );

  @override
  void initState(){
    super.initState();
      conn.selectDoc().then((resp){
        print('.............');
        print(resp);
        setState(() {
          _nome.text = resp[0].nome;
          _cpf.text = resp[0].cpf;
          _nascimento.text = resp[0].datanascimento;
          _rg.text = resp[0].rg;
          _wpp.text = resp[0].wpp;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    
    Map argumentos = ModalRoute.of(context)!.settings.arguments as Map;

    _telefone.text = argumentos['info'][2].toString() == 'null' ? '' : argumentos['info'][2].toString();

    return Scaffold(
      body: SingleChildScrollView(
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
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: SingleChildScrollView(child: Column(
            children: [
              Padding(
          padding: const EdgeInsets.only(
            top: 60,
            left: 40,
            right: 40
          ),
          child: Form(
            key: _formKey,
            child: Column(
          children: [
            const Text("Representante Legal",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22
            ),),
            const SizedBox(
              height: 10,
            ),
             TextFormField(
              validator: (value){
                if(value!.isEmpty){
                  return 'Campo Vazio';
                }
                return null;
              },
              controller: _nome,
              decoration: const InputDecoration(
                labelText: 'Nome Completo *'
              ),
            ),
             TextFormField(
              validator: (value){
                if(value!.isEmpty){
                  return 'Campo Vazio';
                }
                return null;
              },
              controller: _cpf,
              decoration: const InputDecoration(
                labelText: 'CPF *'
              ),
              inputFormatters: [maskCPF],
            ),
            TextFormField(
              validator: (value){
                var verify = value.toString().split('/');
                if(value!.isEmpty || int.parse(verify[0]) < 0 || int.parse(verify[0]) > 31 || int.parse(verify[1]) > 12){
                  return 'Campo Inválido';
                }
                print(verify);
                return null;
              },
              controller: _nascimento,
              decoration: const InputDecoration(
                labelText: 'Data de Nascimento *'
              ),
              inputFormatters: [maskDate],
            ),
             TextFormField(
              controller: _rg,
              decoration: const InputDecoration(
                labelText: 'RG'
              ),
            ),
            TextFormField(
              controller: _telefone,
              decoration: const InputDecoration(
                labelText: 'Telefone'
              ),
            ),
             TextFormField(
              validator: (value){
                if(value!.length < 16){
                  return 'Tamanho do Número Inválido\n Formato Correto: (99) 9 9999-9999';
                }
                if(value.isEmpty){
                  return 'Campo Vazio';
                }
                return null;
              },
              controller: _wpp,
              decoration: const InputDecoration(
                labelText: 'WhatsApp *'
              ),
              inputFormatters: [maskFone],
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
                    await conn.selectDoc().then((res) async{
                    try{
                      doc.cep = res[0].cep;
                      doc.tipo = res[0].tipo;
                      doc.complemento = res[0].complemento;
                      doc.logradouro = res[0].logradouro;
                      doc.bairro = res[0].bairro;
                      doc.localidade = res[0].localidade;
                      doc.uf = res[0].uf;
                      doc.numero = res[0].numero;
                      doc.nome = _nome.text;
                      doc.cpf = _cpf.text;
                      doc.datanascimento = _nascimento.text;
                      doc.rg = _rg.text;
                      doc.wpp = _wpp.text;
                      await conn.updateDoc(doc);
                      Navigator.pushNamed(context, '/document3', arguments: {"arguments": argumentos['info'], "taxas": argumentos['taxas']});
                    }catch(e){
                      Fluttertoast.showToast(msg: "Erro em gravar os dados!");
                    }
                  });
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
        )
        ]
      )
        )))]))
    );
  }
}