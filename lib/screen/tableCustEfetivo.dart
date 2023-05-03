import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CustoEfetivo extends StatefulWidget {
  const CustoEfetivo({super.key});

  @override
  State<CustoEfetivo> createState() => _CustoEfetivoState();
}

class _CustoEfetivoState extends State<CustoEfetivo> {

  @override
  Widget build(BuildContext context) {
    Map teste = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(4,30,55,1),
        title: const Text("Tabela de Custo Efetivo"),
      ),
      body: SingleChildScrollView(
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
                            'Avaliar',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        print("Cliquei");
                      },
                    ),
                  ),
                )
            ],
          )
        )
      )
    );
  }
}