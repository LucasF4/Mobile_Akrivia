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
        GlobalRoutes.HOME: (context) => Home(),
        GlobalRoutes.MDR: (context) => MDR(),
        GlobalRoutes.EFETIVO: (context) => CustoEfetivo(),
      },
    );
  }
}