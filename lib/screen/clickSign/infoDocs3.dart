import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class infoDocs3 extends StatefulWidget {
  const infoDocs3({super.key});

  @override
  State<infoDocs3> createState() => _infoDocs3State();
}

class _infoDocs3State extends State<infoDocs3> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Campo Vazio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Natureza da Conta'
                  ),
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Campo Vazio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Conta'
                  ),
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Campo Vazio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Banco'
                  ),
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Campo Vazio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Agencia'
                  ),
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Campo Vazio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Conta'
                  ),
                ),
                TextFormField(
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Campo Vazio';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Natureza da Conta'
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
                    print("Próximo");
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