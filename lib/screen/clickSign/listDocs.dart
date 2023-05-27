import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:akrivia_vendas/models/myDocs.dart';
import 'package:akrivia_vendas/Database/connection.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:akrivia_vendas/rotas/environment.dart';

class ListarDocs extends StatefulWidget {
  const ListarDocs({super.key});

  @override
  State<ListarDocs> createState() => _ListarDocsState();
}

class _ListarDocsState extends State<ListarDocs> {

  Connection conn = Connection();
  myDocs mydocs = myDocs();

  bool loading = true;

  var keys = [];
  var pages = '';
  var thisListDocs = [];

  
  Future list() async {
    for(int i = 0; i < keys.length; i++){
      var url = Uri.parse("${environment.baseUrlTeste}/api/v1/documents/${keys[i]}?access_token=${environment.acessToken}");
      try{
        var response = await http.get(url);
        print(response.statusCode);

        if(response.statusCode == 200){
          var content = json.decode(response.body);
          
          print(content['document']['finished_at'].toString());
          if(content['document']['finished_at'].toString() != 'null'){
            var dateFinishedParse = DateTime.parse(content['document']['finished_at'].toString().split('T')[0]);
            var dateNowParse = DateTime.parse(DateTime.now().toString().split(' ')[0]);
            if(
              dateFinishedParse.add(const Duration(days: 2)).isAtSameMomentAs(dateNowParse) ||
              !dateFinishedParse.add(const Duration(days: 2)).isAfter(dateNowParse)
            ){
              setState(() async {
                await conn.deleteMyDocs(keys[i]);
              });
            }
          }

          thisListDocs.add(
              {
                "filename": content['document']['filename'],
                "status": content['document']['status'],
                "uploaded_at": content['document']['uploaded_at'].toString().split('T')[0],
                "finished_at": content['document']['finished_at'].toString().split('T')[0]
              }
            );
        }else if(response.statusCode == 404){
          await conn.deleteMyDocs(keys[i]);
        }else{
          Fluttertoast.showToast(msg: "Problemas com a internet, verifique sua rede e tente novamente.");
        }
      }catch(e){
        print(e);
      }
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    conn.selectMyDocs().then((value){
      value.forEach((e){
        keys.add(e.key);
      });
    });
    Future.delayed(
      const Duration(seconds: 1),
      (){
        setState(() {
          list();
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Documentos Gerados"),
        backgroundColor: const Color.fromRGBO(4, 30, 55, 1),
      ),
      body:
      loading == false ? RefreshIndicator(
        onRefresh: (){
          thisListDocs = [];
          return list();
        },
        child: thisListDocs.isEmpty ?
          const Center(
            child: Text(
              'Você não possui documentos gerados!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            )
          )
        : ListView.builder(
          itemCount: thisListDocs.length,
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.symmetric(vertical: h * 0.01, horizontal: w * 0.02),
                    color: thisListDocs[index]['status'].toString() == 'running' ?
                    Colors.orange : 
                    thisListDocs[index]['status'].toString() == 'canceled' ? 
                    Colors.red : Colors.green,
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.all(h * 0.01),
                      height: h * 0.15,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            thisListDocs[index]['filename'].toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: h * 0.018,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              thisListDocs[index]['status'].toString() == 'running' ? 
                              Text(
                                "Em Processo",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: h * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                              :
                              thisListDocs[index]['status'].toString() == 'canceled' ?
                              Text(
                                "Cancelada",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: h * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                              :
                              Text(
                                "Aprovada",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: h * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Data de Envio: ',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: h * 0.02,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    thisListDocs[index]['uploaded_at'].toString().split('-').reversed.join('/'),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: h * 0.02,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          thisListDocs[index]['status'].toString() != 'running' ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Data de Conclusão: ',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: h * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                thisListDocs[index]['finished_at'].toString().split('-').reversed.join('/'),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: h * 0.02,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          )
                          :
                          Container()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        )
      )
        :
        const Center(
          child: CircularProgressIndicator(),
        )
      );
  }
}