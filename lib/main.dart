import 'package:akrivia_vendas/screen/clickSign/InfoDocs.dart';
import 'package:akrivia_vendas/screen/clickSign/InfoDocs2.dart';
import 'package:akrivia_vendas/screen/clickSign/infoDocs3.dart';
import 'package:akrivia_vendas/screen/clickSign/infoDocs4.dart';
import 'package:akrivia_vendas/screen/clickSign/listDocs.dart';
import 'package:akrivia_vendas/screen/confirmacao/confirmacao.dart';
import 'package:akrivia_vendas/screen/mdr.dart';
import 'package:flutter/material.dart';
import 'package:akrivia_vendas/rotas/app_rotas.dart';
import 'package:akrivia_vendas/screen/home.dart';
import 'package:akrivia_vendas/screen/tableCustEfetivo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Vendas',
      initialRoute: '/',
      routes: {
        GlobalRoutes.HOME: (context) => const Home(),
        GlobalRoutes.MDR: (context) => const MDR(),
        GlobalRoutes.EFETIVO: (context) => const CustoEfetivo(),
        GlobalRoutes.DOC: (context) => const infoDocs(),
        GlobalRoutes.DOC2: (context) => const infoDocs2(),
        GlobalRoutes.DOC3: (context) => const infoDocs3(),
        GlobalRoutes.DOC4: (context) => const infoDocs4(),
        GlobalRoutes.CONFIRM: (context) => const Confirmacao(),
        GlobalRoutes.LISTDOCS: (context) => const ListarDocs()
      },
    );
  }
}