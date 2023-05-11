import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:akrivia_vendas/Database/connection.dart';

import 'package:akrivia_vendas/models/conta.dart';

class infoDocs3 extends StatefulWidget {
  const infoDocs3({super.key});

  @override
  State<infoDocs3> createState() => _infoDocs3State();
}

class _infoDocs3State extends State<infoDocs3> {

  Conta conta = Conta();

  Connection conn = Connection();

  final _natureza = TextEditingController();
  final _banco = TextEditingController();
  final _agencia = TextEditingController();
  final _conta = TextEditingController();
  final _nomeFav = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _tipoConta = 'Interna';

  @override
  void initState(){
    super.initState();
    conn.selectConta().then((result){
      print(",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,");
      print(result);
      if(result.length == 0){
        conta.tipoConta = _tipoConta;
        conta.natureza = '';
        conta.banco = '';
        conta.agencia = '';
        conta.conta = '';
        conta.nomeFav = '';
        conn.insertConta(conta);
      }else{
        setState(() {
          _tipoConta = result[0].tipoConta;
          _natureza.text = result[0].natureza;
          _banco.text = result[0].banco;
          _agencia.text = result[0].agencia;
          _conta.text = result[0].conta;
          _nomeFav.text = result[0].nomeFav;
        });
      }
      
    });
  }

  @override
  Widget build(BuildContext context) {

    Map argumentos = ModalRoute.of(context)!.settings.arguments as Map;

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
          height: MediaQuery.of(context).size.height * 1.02,
        color: const Color.fromARGB(223, 201, 201, 201),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Column(
            children: [
              Padding(
        padding: const EdgeInsets.only(
          top: 40,
          right: 40,
          left: 40,
          bottom: 20
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  "Dados Bancários",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Tipo de Conta: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(width: 10,),
                    DropdownButton(
                      hint: Text(_tipoConta),
                      items: ['Interna', 'Externa'].map((String value){
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value)
                        );
                      }).toList(),
                      onChanged: (_){
                        setState(() {
                          _tipoConta = _.toString();
                        });
                    })
                  ],
                ),
              ),
                TextFormField(
                  controller: _natureza,
                  validator: (value){
                    if(value!.isEmpty && _tipoConta == 'Externa'){
                      return 'Campo Vazio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Natureza da Conta'
                  ),
                ),
                TextFormField(
                  controller: _banco,
                  validator: (value){
                    if(value!.isEmpty && _tipoConta == 'Externa'){
                      return 'Campo Vazio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Banco'
                  ),
                ),
                TextFormField(
                  controller: _agencia,
                  validator: (value){
                    if(value!.isEmpty && _tipoConta == 'Externa'){
                      return 'Campo Vazio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Agencia'
                  ),
                ),
                TextFormField(
                  controller: _conta,
                  validator: (value){
                    if(value!.isEmpty && _tipoConta == 'Externa'){
                      return 'Campo Vazio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Conta'
                  ),
                ),
                TextFormField(
                  controller: _nomeFav,
                  validator: (value){
                    if(value!.isEmpty && _tipoConta == 'Externa'){
                      return 'Campo Vazio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Nome do Favorecido'
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
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
                      conta.tipoConta = _tipoConta;
                      conta.natureza = _natureza.text;
                      conta.banco = _banco.text;
                      conta.agencia = _agencia.text;
                      conta.conta = _conta.text;
                      conta.nomeFav = _nomeFav.text;
                      conn.updateConta(conta);
                      print("Passando pelo natureza");
                      print(conta.natureza);
                      Navigator.pushNamed(context, '/document4', arguments: {"taxas": argumentos['taxas'], "infos": argumentos['arguments']});
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
      ),
            ])
    ))])));
  }
}