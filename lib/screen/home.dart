import 'dart:io';

import 'package:akrivia_vendas/Database/connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:akrivia_vendas/models/userModel.dart';

class Home extends StatefulWidget{
  const Home({ Key? key }) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  User user = User();
  Connection connection = Connection();

  @override
  void initState(){
    super.initState();
    print('super initState');
    connection.select().then((res) {
      print(res[0].email);
      if(res.length != 0){
        Navigator.pushReplacementNamed(context, '/mdr');
      }
    });
  }

  void userSaving(email){

    user.email = email;
    connection.insert(user);
    print('Email salvo com sucesso!');
    Navigator.pushReplacementNamed(
      context,
      '/mdr'
    );

  }
  
  @override
  Widget build(BuildContext context){

  double h = MediaQuery.of(context).size.height;
  double w = MediaQuery.of(context).size.width;


    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40
        ),
        color: Colors.white,
        child: ListView(
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset('assets/images/AKRIVIA-QUADRADO-Fundo.png'),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Container(
                height: h,
                width: w,
                child: Column(
                children: [
                  TextFormField(
                  controller: _email,
                  validator: (value) {
                    if(value!.isEmpty){
                      return 'O campo não pode está vazio!';
                    }
                    else if(!value.contains('@akrivia.com.br')){
                      return 'Informe um E-mail válido!';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "E-mail",
                    labelStyle: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w400,
                      fontSize: 20
                    )
                  ),
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 40),
                Container(
                  height: 60,
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
                          Text('Entrar',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      onPressed: () => {
                        if(_formKey.currentState!.validate()){
                          setState(() {
                            print("E-mail informado: " + _email.text.toString());
                            //connection.insertUser('lucas.felix@akrivia.com.br');
                            userSaving(_email.text.toString());
                          })
                        }
                      },
                    ),
                  ),
                )
                ],
              ),
              )
            )
          ],
        ),
      )
    );
  }

}