import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:akrivia_vendas/screen/mdr.dart';

import 'package:akrivia_vendas/Database/connection.dart';

class Confirmacao extends StatefulWidget {
  const Confirmacao({super.key});

  @override
  State<Confirmacao> createState() => _ConfirmacaoState();
}

class _ConfirmacaoState extends State<Confirmacao> {

  Connection conn = Connection();

  @override
  void initState(){
    super.initState();
    conn.deleteDoc();
    conn.deleteInfo();
    conn.deleteConta();
    Future.delayed(
      const Duration(seconds: 3),
      (){
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MDR()),
          (Route<dynamic> route) => false,
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/confirm.png"),
                fit: BoxFit.fitWidth)
              ),
            )
          ],
        ),
      ),
    );
  }
}