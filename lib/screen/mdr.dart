import 'dart:convert';
import 'dart:ffi';

import 'package:akrivia_vendas/Database/connection.dart';
import 'package:akrivia_vendas/models/customPopupMenu.dart';
import 'package:akrivia_vendas/models/resultado.dart';
import 'package:akrivia_vendas/models/userModel.dart';
import 'package:akrivia_vendas/models/info.dart';
import 'package:akrivia_vendas/rotas/environment.dart';

import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MDR extends StatefulWidget {
  const MDR ({Key?key}) : super(key: key);
  @override
  State<MDR> createState() => _MDRState();
}

/* class Info{
  int? MCC;
  String? MDR;
  
  Info(this.MCC, this.MDR);
} */

class _MDRState extends State<MDR>{

  User user = User();
  Info info = Info();
  Resultado resultadoClass = Resultado();
  Connection conn = Connection();

  bool _preload = false;

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final _emailUser = TextEditingController();
  final _mcc = TextEditingController();
  final _cnpj = TextEditingController();
  final _antecipacaoVM = TextEditingController();
  final _umVM = TextEditingController();
  final _doisaseisVM = TextEditingController();
  final _seteavinteequatroVM = TextEditingController();
  final _debitoVM = TextEditingController();
  final _antecipacao = TextEditingController();
  final _um = TextEditingController();
  final _doisaseis = TextEditingController();
  final _seteavinteequatro = TextEditingController();
  final _debito = TextEditingController();
  final _TPV = TextEditingController();
  final _valorAluguel = TextEditingController();
  final _fantasia = TextEditingController();
  final _email = TextEditingController();
  final _telefone = TextEditingController();

  String _credito = 'Sim';
  int inputLength = 0;
  
  String _1xVM = '';
  String _2a6VM = '';
  String _7a12VM = '';
  String _dbtoVM = '';
  String _1x = '';
  String _2a6 = '';
  String _7a12 = '';
  String _dbto = '';


  final maskInputCNPJ = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy
  );

  final maskInputCPF = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy
  );

  final maskTaxa = MaskTextInputFormatter(
    mask: '#,##',
    filter: {'#': RegExp(r'[0-9]'),},
  );

  final maskPhone = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy
  );
  
  final List<Map<String, dynamic>> _items = [
    {"mcc": 742, "mdr": "Veterinários e Clínicas Veterinárias", "VM":{"debito": 1.12, "credito": 2.25, "2a6": 2.39, "7a12": 2.73}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 763, "mdr": "Cooperativas Agrícolas", "VM":{"debito": 1.10, "credito": 1.98, "2a6": 1.92, "7a12": 2.34}, "DB": {"debito": 1.30 , "credito": 2.12, "2a6": 2.52, "7a12": 2.75}},
    {"mcc": 780, "mdr": "Jardinagem e Paisagismo", "VM":{"debito": 1.22, "credito": 2.21, "2a6": 2.37, "7a12": 2.66}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 1711, "mdr": "Encanadores, Consertos de Ar Condicionado, Aquecimento, Fornos e Refrigeradores", "VM": {"debito": 1.27, "credito": 2.29, "2a6": 2.43, "7a12": 2.60}, "DB": {"debito": 1.70 , "credito": 2.64, "2a6": 2.78, "7a12": 3.03}},
    {"mcc": 1731, "mdr": "Eletricistas", "VM": {"debito": 1.13, "credito": 2.26, "2a6": 2.34, "7a12": 2.91}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 1740, "mdr": "Serviços de alvenaria, trabalhos com pedras, reboco, isolamento e Colocação de Azulejos", "VM": {"debito": 1.15, "credito": 2.18, "2a6": 2.39, "7a12": 2.67}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 1750, "mdr": "Carpinteiros", "VM": {"debito": 1.13, "credito": 1.97, "2a6":	2.42, "7a12":	2.40}, "DB": {"debito": 1.70 , "credito": 2.39, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 1761, "mdr": "Serralherias", "VM": {"debito": 1.15, "credito": 2.22, "2a6":	2.35, "7a12":	2.64}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 2.94}},
    {"mcc": 4131, "mdr": "Linhas de Ônibus ", "VM": {"debito": 1.13, "credito": 1.67, "2a6":	2.31, "7a12":	2.77}, "DB": {"debito": 1.70 , "credito": 2.11, "2a6": 2.65, "7a12": 2.88}},
    {"mcc": 4722, "mdr": "Agências de Viagem e Operadoras de Turismo", "VM": {"debito": 1.21, "credito":	2.55, "2a6":	2.38, "7a12":	2.63}, "DB": {"debito": 1.72 , "credito": 2.63, "2a6": 2.80, "7a12": 3.07}},
    {"mcc": 4789, "mdr": "Transporte - outros (taxis de bicicleta, teleféricos, translado para aeroporto)", "VM": {"debito": 1.20, "credito":	2.03, "2a6":	2.30, "7a12":	2.74}, "DB": {"debito": 1.70 , "credito": 2.24, "2a6": 2.59, "7a12": 2.81}},
    {"mcc": 4812, "mdr": "Lojas de Telefones Celulares, fixo e outros equip de comunicação", "VM": {"debito": 1.26, "credito":	2.13, "2a6":	2.32, "7a12":	2.65}, "DB": {"debito": 1.72 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 4816, "mdr": "Provedores de internet / Serviços de Informação", "VM": {"debito": 1.03, "credito":	1.48, "2a6":	1.78, "7a12":	2.42}, "DB": {"debito": 1.70 , "credito": 2.07, "2a6": 2.30, "7a12": 3.01}},
    {"mcc": 5013, "mdr": "Atacadistas/distribuidores de Peças e equipamentos para veículos", "VM": {"debito": 1.23, "credito":	2.22, "2a6":	2.29, "7a12":	2.65}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 2.94}},
    {"mcc": 5021, "mdr": "Móveis - Fabricantes/distribuidores de móveis para escritorios, escolas, restaurantes, igrejas", "VM": {"debito": 1.35, "credito":	2.14, "2a6":	2.39, "7a12":	2.70}, "DB": {"debito": 1.74 , "credito": 2.47, "2a6": 2.78, "7a12": 3.02}},
    {"mcc": 5039, "mdr": "Materiais de Construção - Atacadistas/fabricantes de cimento, aço, conexões e outros  ", "VM": {"debito": 1.10, "credito":	1.88, "2a6":	2.04, "7a12":	2.33}, "DB": {"debito": 1.67 , "credito": 2.08, "2a6": 2.48, "7a12": 2.71}},
    {"mcc": 5046, "mdr": "Distribuidores de equipamentos para cozinha industrial, balanças, acessórios para lojas, manequins ", "VM": {"debito": 1.18, "credito":	2.31, "2a6":	2.38, "7a12":	2.56}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 5047, "mdr": "Distribuidores de Equip p/Consultórios, Clínicas e Hospitais", "VM": {"debito": 1.28, "credito":	2.40, "2a6":	2.48, "7a12":	2.73}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 5051, "mdr": "Distribuidores de tubos e chapas metálicos, pregos, arames, barras, trilhos", "VM": {"debito": 1.09, "credito":	1.94, "2a6":	2.06, "7a12":	2.31}, "DB": {"debito": 1.30 , "credito": 2.08, "2a6": 2.48, "7a12": 2.71}},
    {"mcc": 5065, "mdr": "Distribuidores de peças elétricas - capacitores, bobinas e outros", "VM": {"debito": 1.32, "credito":	2.35, "2a6":	2.28, "7a12":	2.95}, "DB": {"debito": 1.72 , "credito": 2.34, "2a6": 2.74, "7a12": 2.97}},
    {"mcc": 5094, "mdr": "Distribuidores Pedras Preciosas, relógios, bijouterias, talheres e troféus", "VM": {"debito": 1.22, "credito":	2.22, "2a6":	2.42, "7a12":	2.71}, "DB": {"debito": 1.72 , "credito": 2.38, "2a6": 2.78, "7a12": 3.02}},
    {"mcc": 5099, "mdr": "Fabricação de esquadrias de madeira e de peças de madeira para instalações industriais e comerciais e  artigos de carpintaria par a construção.", "VM": {"debito": 1.10, "credito":	1.83, "2a6":	1.89, "7a12":	2.81}, "DB": {"debito": 1.74 , "credito": 2.34, "2a6": 2.74, "7a12": 2.97}},
    {"mcc": 5131, "mdr": "Piece Goods, Notions, and Other Dry Goods 1", "VM": {"debito": 1.26, "credito":	2.18, "2a6":	2.39, "7a12":	2.74}, "DB": {"debito": 1.74 , "credito": 2.34, "2a6": 2.74, "7a12": 2.97}},
    {"mcc": 5137, "mdr": "Distribuidores de uniformes - profissionais, esportivos e escolares", "VM": {"debito": 1.10, "credito":	1.77, "2a6":	1.95, "7a12":	2.40}, "DB": {"debito": 1.70 , "credito": 2.34, "2a6": 2.74, "7a12": 2.97}},
    {"mcc": 5199, "mdr": "Materiais de Consumo não duráveis - não classificados", "VM": {"debito": 1.10, "credito":	1.79, "2a6":	1.95, "7a12":	2.23}, "DB": {"debito": 1.70 , "credito": 2.34, "2a6": 2.74, "7a12": 2.97}},
    {"mcc": 5211, "mdr": "Madeireiras - Varejistas de materiais de contrução", "VM": {"debito": 1.22, "credito":	2.08, "2a6":	2.32, "7a12":	2.68}, "DB": {"debito": 1.70 , "credito": 2.34, "2a6": 2.74, "7a12": 2.97}},
    {"mcc": 5231, "mdr": "Lojas de tintas, vidro e papel de parede", "VM": {"debito": 1.19, "credito":	2.25, "2a6":	2.39, "7a12":	2.69}, "DB": {"debito": 1.70 , "credito": 2.20, "2a6": 2.60, "7a12": 2.83}},
    {"mcc": 5251, "mdr": "Ferragens - varejo de materiais diversos (ferramentas, parafusos, suprimentos elétricos, etc)", "VM": {"debito": 1.29, "credito":	2.19, "2a6":	2.42, "7a12":	2.73}, "DB": {"debito": 1.70 , "credito": 2.34, "2a6": 2.74, "7a12": 2.97}},
    {"mcc": 5300, "mdr": "Comércio Atacadista de alimentos (Makro, Sam's Club, etc)", "VM": {"debito": 1.15, "credito":	1.78, "2a6":	2.49, "7a12":	2.75}, "DB": {"debito": 1.70 , "credito": 2.08, "2a6": 2.61, "7a12": 2.84}},
    {"mcc": 5311, "mdr": "Lojas de Departamentos", "VM": {"debito": 1.11, "credito":	2.16, "2a6":	2.31, "7a12":	2.63}, "DB": {"debito": 1.37 , "credito": 2.13, "2a6": 2.53, "7a12": 2.76}},
    {"mcc": 5331, "mdr": "Lojas de Produtos com preços populares (ex. Lojas de 'RS 1,99')", "VM": {"debito": 1.19, "credito":	2.25, "2a6":	2.39, "7a12":	2.69}, "DB": {"debito": 1.72 , "credito": 2.34, "2a6": 2.74, "7a12": 2.97}},
    {"mcc": 5411, "mdr": "Supermercados", "VM": {"debito": 1.00, "credito":	76.02, "2a6":	2.23, "7a12":	2.56}, "DB": {"debito": 1.17 , "credito": 1.94, "2a6": 2.42, "7a12": 2.70}},
    {"mcc": 5422, "mdr": "Açougues, peixarias e frutos do mar (frescos e congelados)", "VM": {"debito": 1.04, "credito":	1.91, "2a6":	2.21, "7a12":	2.65}, "DB": {"debito": 1.17 , "credito": 2.21, "2a6": 2.61, "7a12": 2.88}},
    {"mcc": 5441, "mdr": "Docerias e Confeitarias", "VM": {"debito": 1.15, "credito":	1.98, "2a6":	2.30, "7a12":	2.67}, "DB": {"debito": 1.17 , "credito": 2.21, "2a6": 2.61, "7a12": 2.88}},
    {"mcc": 5462, "mdr": "Padarias", "VM": {"debito": 1.04, "credito":	1.93, "2a6":	2.21, "7a12":	2.72}, "DB": {"debito": 1.17 , "credito": 2.07, "2a6": 2.47, "7a12": 2.70}},
    {"mcc": 5499, "mdr": "Lojas de Alimentos especiais (Conveniência, empórios, delicatessens/alimentos dietéticos, naturais e suplementos)", "VM": {"debito": 1.04, "credito":	1.56, "2a6":	2.25, "7a12":	2.71}, "DB": {"debito": 1.70 , "credito": 2.06, "2a6": 2.55, "7a12": 2.78}},
    {"mcc": 5511, "mdr": "Vendas de veículos novos - inclui serviços (concessionárias)", "VM": {"debito": 1.24, "credito":	2.31, "2a6":	2.37, "7a12":	2.70}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.03}},
    {"mcc": 5532, "mdr": "Lojas de Pneus", "VM": {"debito": 1.25, "credito":	2.11, "2a6":	2.33, "7a12":	2.75}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 5533, "mdr": "Lojas de Autopeças e Acessórios para Veículos Automotivos", "VM": {"debito": 1.25, "credito":	2.15, "2a6":	2.33, "7a12":	2.66}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 5541, "mdr": "Postos de Combustíveis", "VM": {"debito": 1.07, "credito":	1.90, "2a6":	2.20, "7a12":	2.54}, "DB": {"debito": 1.37 , "credito": 2.11, "2a6": 2.49, "7a12": 2.63}},
    {"mcc": 5571, "mdr": "Vendas de motocicletas - inclui peças e acessórios como capacetes, luvas, etc)", "VM": {"debito": 1.22, "credito":	2.06, "2a6":	2.27, "7a12":	2.68}, "DB": {"debito": 1.70 , "credito": 2.34, "2a6": 2.74, "7a12": 3.01}},
    {"mcc": 5651, "mdr": "Lojas de Roupas e acessórios - feminino, masculino e infantil", "VM": {"debito": 1.15, "credito":	2.10, "2a6":	2.34, "7a12":	2.68}, "DB": {"debito": 1.70 , "credito": 2.13, "2a6": 2.56, "7a12": 2.76}},
    {"mcc": 5661, "mdr": "Lojas de Calçados", "VM": {"debito": 1.13, "credito":	2.07, "2a6":	2.30, "7a12":	2.68}, "DB": {"debito": 1.70 , "credito": 2.34, "2a6": 2.74, "7a12": 3.01}},
    {"mcc": 5699, "mdr": "Lojas de Artigos Unissex", "VM": {"debito": 1.20, "credito":	1.97, "2a6":	2.25, "7a12":	2.83}, "DB": {"debito": 1.70 , "credito": 2.34, "2a6": 2.74, "7a12": 3.01}},
    {"mcc": 5712, "mdr": "Lojas de Móveis em Geral - Exceto eletrodomésticos", "VM": {"debito": 1.25, "credito":	2.26, "2a6":	2.41, "7a12":	2.76}, "DB": {"debito": 1.74 , "credito": 2.39, "2a6": 2.79, "7a12": 3.06}},
    {"mcc": 5722, "mdr": "Lojas de Aparelhos Eletrodomésticos", "VM": {"debito": 1.18, "credito":	2.14, "2a6":	2.36, "7a12":	2.65}, "DB": {"debito": 1.70 , "credito": 2.34, "2a6": 2.74, "7a12": 3.01}},
    {"mcc": 5732, "mdr": "Vendas de Eletrônicos (exceto celulares)", "VM": {"debito": 1.17, "credito":	2.12, "2a6":	2.38, "7a12":	2.60}, "DB": {"debito": 1.70 , "credito": 2.34, "2a6": 2.74, "7a12": 3.01}},
    {"mcc": 5733, "mdr": "Vendas de Instrumentos Musicais", "VM": {"debito": 1.12, "credito":	2.08, "2a6":	2.30, "7a12":	2.62}, "DB": {"debito": 1.70 , "credito": 2.34, "2a6": 2.74, "7a12": 3.01}},
    {"mcc": 5811, "mdr": "Fornecedores de Comidas/Bebidas prontas para festas, casamentos e aviação", "VM": {"debito": 1.22, "credito":	2.07, "2a6":	2.33, "7a12":	2.97}, "DB": {"debito": 1.70 , "credito": 2.41, "2a6": 2.81, "7a12": 3.05}},
    {"mcc": 5812, "mdr": "Lanchonetes, Restaurantes, pizzarias ", "VM": {"debito": 1.15, "credito":	2.18, "2a6":	2.30, "7a12":	2.71}, "DB": {"debito": 1.65 , "credito": 2.41, "2a6": 2.81, "7a12": 3.05}},
    {"mcc": 5813, "mdr": "Bar, Lounge, Discoteca, Clube Noturno", "VM": {"debito": 1.14, "credito":	2.09, "2a6":	2.34, "7a12":	2.54}, "DB": {"debito": 1.65 , "credito": 2.41, "2a6": 2.81, "7a12": 3.05}},
    {"mcc": 5814, "mdr": "Restaurantes de Fast-Food", "VM": {"debito": 1.14, "credito":	1.71, "2a6":	2.35, "7a12":	2.73}, "DB": {"debito": 1.65 , "credito": 2.28, "2a6": 2.76, "7a12": 3.00}},
    {"mcc": 5912, "mdr": "Farmácias e Drogarias ", "VM": {"debito": 1.05, "credito":	1.94, "2a6":	2.23, "7a12":	2.61}, "DB": {"debito": 1.37 , "credito": 2.13, "2a6": 2.53, "7a12": 2.76}},
    {"mcc": 5921, "mdr": "Lojas de Bebidas (somente alcóolicas)", "VM": {"debito": 1.11, "credito":	1.90, "2a6":	2.24, "7a12":	2.75}, "DB": {"debito": 1.17 , "credito": 2.28, "2a6": 2.63, "7a12": 2.85}},
    {"mcc": 5942, "mdr": "Livrarias e sebos", "VM": {"debito": 1.35, "credito":	2.11, "2a6":	2.37, "7a12":	2.75}, "DB": {"debito": 1.70 , "credito": 2.34, "2a6": 2.74, "7a12": 3.02}},
    {"mcc": 5943, "mdr": "Papelarias, material escolar e de escritório", "VM": {"debito": 1.39, "credito":	2.09, "2a6":	2.40, "7a12":	2.78}, "DB": {"debito": 1.70 , "credito": 2.34, "2a6": 2.74, "7a12": 3.01}},
    {"mcc": 5944, "mdr": "Joalherias, Relojoarias", "VM": {"debito": 1.26, "credito":	2.18, "2a6":	2.38, "7a12":	2.80}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.06}},
    {"mcc": 5947, "mdr": "Lojas de presentes, cartoes e souveniers ", "VM": {"debito": 1.25, "credito":	2.08, "2a6":	2.32, "7a12":	2.70}, "DB": {"debito": 1.72 , "credito": 2.34, "2a6": 2.74, "7a12": 2.97}},
    {"mcc": 5949, "mdr": "Lojas de Tecidos / Armarinhos", "VM": {"debito": 1.21, "credito":	2.11, "2a6":	2.33, "7a12":	2.65}, "DB": {"debito": 1.70 , "credito": 2.34, "2a6": 2.74, "7a12": 2.97}},
    {"mcc": 5977, "mdr": "Perfumarias e Cosméticos", "VM": {"debito": 1.20, "credito":	2.09, "2a6":	2.32, "7a12":	2.66}, "DB": {"debito": 1.70 , "credito": 2.34, "2a6": 2.74, "7a12": 2.97}},
    {"mcc": 5992, "mdr": "Floriculturas, Floristas", "VM": {"debito": 1.23, "credito":	2.26, "2a6":	2.39, "7a12":	2.81}, "DB": {"debito": 1.70 , "credito": 2.34, "2a6": 2.74, "7a12": 2.97}},
    {"mcc": 5995, "mdr": "Pet Shops", "VM": {"debito": 1.21, "credito":	2.09, "2a6":	2.33, "7a12":	2.66}, "DB": {"debito": 1.70 , "credito": 2.34, "2a6": 2.74, "7a12": 2.97}},
    {"mcc": 5999, "mdr": "Lojas Diversas - não classificadas anteriormente", "VM": {"debito": 1.24, "credito":	2.07, "2a6":	2.30, "7a12":	2.72}, "DB": {"debito": 1.70 , "credito": 2.34, "2a6": 2.74, "7a12": 2.97}},
    {"mcc": 6300, "mdr": "Seguradoras - agentes de seguros - planos de saude", "VM": {"debito": 1.01, "credito":	1.19, "2a6":	0.71, "7a12":	0.92}, "DB": {"debito": 1.00 , "credito": 2.12, "2a6": 2.52, "7a12": 2.75}},
    {"mcc": 6513, "mdr": "Agentes imobiliarios e  Corretores de Imóveis ", "VM": {"debito": 0.91, "credito":	1.44, "2a6":	1.57, "7a12":	1.84}, "DB": {"debito": 1.72 , "credito": 1.97, "2a6": 2.10, "7a12": 2.24}},
    {"mcc": 7011, "mdr": "Hotéis, Pousadas, Motéis e Resorts", "VM": {"debito": 1.22, "credito":	2.41, "2a6":	2.46, "7a12":	2.71}, "DB": {"debito": 1.72 , "credito": 2.48, "2a6": 2.88, "7a12": 3.11}},
    {"mcc": 7230, "mdr": "Barbearias e Salões de Beleza", "VM": {"debito": 1.14, "credito":	2.16, "2a6":	2.38, "7a12":	2.69}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 7261, "mdr": "Serviços Funerários e Crematórios", "VM": {"debito": 1.13, "credito":	2.04, "2a6":	2.35, "7a12":	2.78}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 7298, "mdr": "Spas de Saúde e Beleza", "VM": {"debito": 1.12, "credito":	2.23, "2a6":	2.32, "7a12":	2.65}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 7311, "mdr": "Serviços de Publicidade e Propaganda", "VM": {"debito": 1.16, "credito":	1.85, "2a6":	2.36, "7a12":	2.76}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 7392, "mdr": "Serviços de Consultoria ", "VM": {"debito": 1.17, "credito":	2.40, "2a6":	2.42, "7a12":	2.73}, "DB": {"debito": 1.70 , "credito": 2.44, "2a6": 2.79, "7a12": 3.01}},
    {"mcc": 7394, "mdr": "Aluguel de Equipamentos, ferramentas e móveis", "VM": {"debito": 1.18, "credito":	2.34, "2a6":	2.29, "7a12":	2.84}, "DB": {"debito": 1.70 , "credito": 2.53, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 7399, "mdr": "Outros Comércios - Não classificados anteriormente", "VM": {"debito": 1.22, "credito":	2.12, "2a6":	2.35, "7a12":	2.83}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 7512, "mdr": "Locadoras de Automóveis ", "VM": {"debito": 1.57, "credito":	2.28, "2a6":	2.44, "7a12":	2.84}, "DB": {"debito": 1.72 , "credito": 2.67, "2a6": 2.84, "7a12": 3.11}},
    {"mcc": 7523, "mdr": "Estacionamentos e Garagens", "VM": {"debito": 1.15, "credito":	1.78, "2a6":	2.49, "7a12":	2.75}, "DB": {"debito": 1.70 , "credito": 2.08, "2a6": 2.61, "7a12": 2.84}},
    {"mcc": 7531, "mdr": "Funilaria/chapeação/pintura de Automóveis", "VM": {"debito": 1.24, "credito":	2.15, "2a6":	2.38, "7a12":	2.59}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 7538, "mdr": "Oficinas Automotivas", "VM": {"debito": 1.23, "credito":	2.19, "2a6":	2.35, "7a12":	2.69}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 7941, "mdr": "Clubes desportivos, arenas, estádios e escolas que fornecem formação esportiva, Profissional e Semiprofissional. ", "VM": {"debito": 1.19, "credito":	2.15, "2a6":	2.49, "7a12":	2.72}, "DB": {"debito": 1.70 , "credito": 2.43, "2a6": 2.84, "7a12": 3.07}},
    {"mcc": 7997, "mdr": "Clubes, Assoc Atléticas, Recreativas, Esportivas - exige sócio", "VM": {"debito": 0.98, "credito":	1.52, "2a6":	1.80, "7a12":	2.53}, "DB": {"debito": 1.70 , "credito": 2.10, "2a6": 2.83, "7a12": 3.07}},
    {"mcc": 7999, "mdr": "Serviços de aluguel de bicicletas, pistas de patinação, campos de corrida kart, piscinas publicas, etc...", "VM": {"debito": 1.22, "credito":	2.12, "2a6":	2.35, "7a12":	2.83}, "DB": {"debito": 1.70 , "credito": 2.44, "2a6": 2.79, "7a12": 3.01}},
    {"mcc": 8011, "mdr": "Médicos ", "VM": {"debito": 1.15, "credito":	2.27, "2a6":	2.36, "7a12":	3.06}, "DB": {"debito": 1.70 , "credito": 2.44, "2a6": 2.79, "7a12": 3.01}},
    {"mcc": 8021, "mdr": "Dentistas, Ortodontistas", "VM": {"debito": 1.13, "credito":	2.14, "2a6":	2.35, "7a12":	2.69}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.02}},
    {"mcc": 8043, "mdr": "Oticas ", "VM": {"debito": 1.20, "credito":	2.09, "2a6":	2.32, "7a12":	2.67}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 8050, "mdr": "Enfermarias e Casas de Repouso para idosos", "VM": {"debito": 1.13, "credito":	2.15, "2a6":	2.36, "7a12":	2.81}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 8062, "mdr": "Hospitais", "VM": {"debito": 1.14, "credito":	2.12, "2a6":	2.40, "7a12":	2.77}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 8071, "mdr": "Laboratórios médicos e odontológicos - análises clínicas, raio-X, dentaduras, aparelhos ortodônticos", "VM": {"debito": 1.16, "credito":	2.15, "2a6":	2.36, "7a12":	2.67}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.02}},
    {"mcc": 8099, "mdr": "Clinicas  e profissionais da Saúde (bancos de sangue, tratamento para dependencia quimica, fisioterapias, massoterapeutas, psicólogos, etc...)", "VM": {"debito": 1.16, "credito":	2.16, "2a6":	2.41, "7a12":	2.80}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 8111, "mdr": "Advogados, Serviços Jurídicos", "VM": {"debito": 1.17, "credito":	2.44, "2a6":	2.32, "7a12":	2.67}, "DB": {"debito": 1.70 , "credito": 2.44, "2a6": 2.79, "7a12": 3.01}},
    {"mcc": 8211, "mdr": "Escolas de Ensino Fundamental e Médio", "VM": {"debito": 0.80, "credito":	1.04, "2a6":	1.17, "7a12":	1.35}, "DB": {"debito": 1.30 , "credito": 1.68, "2a6": 1.82, "7a12": 2.00}},
    {"mcc": 8220, "mdr": "Faculdades, Universidades, Escolas Profissionalizantes - emitem diploma", "VM": {"debito": 0.79, "credito":	1.01, "2a6":	1.60, "7a12":	1.49}, "DB": {"debito": 1.00 , "credito": 1.89, "2a6": 2.12, "7a12": 2.18}},
    {"mcc": 8299, "mdr": "Autoescolas, escolas de linguas, teatro, artes, culinária", "VM": {"debito": 0.84, "credito":	1.09, "2a6":	1.23, "7a12":	1.57}, "DB": {"debito": 1.00 , "credito": 1.74, "2a6": 1.88, "7a12": 2.02}},
    {"mcc": 8911, "mdr": "Serviços de Arquitetura, Engenharia e Topografia", "VM": {"debito": 1.15, "credito":	2.28, "2a6":	2.50, "7a12":	2.72}, "DB": {"debito": 1.70 , "credito": 2.44, "2a6": 2.79, "7a12": 3.01}},
    {"mcc": 8931, "mdr": "Serviços de Contabilidade  e Auditoria", "VM": {"debito": 1.22, "credito":	2.14, "2a6":	2.41, "7a12":	2.81}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 9399, "mdr": "Serviços Governamentais (cartórios, órgão da administração pública, taxas registro de veículos) ", "VM": {"debito": 0.76, "credito":	1.59, "2a6":	1.80, "7a12":	2.70}, "DB": {"debito": 1.35 , "credito": 2.06, "2a6": 2.41, "7a12": 2.63}},
    {"mcc": 7995, "mdr": "Apostas, Casas Lotéricas e Bingos Bandeira", "VM": {"debito": 1.19, "credito":	2.12, "2a6":	2.36, "7a12":	2.83}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 5399, "mdr": "", "VM": {"debito": 1.13, "credito":	2.00, "2a6":	2.27, "7a12":	2.60}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 5734, "mdr": " SOFTWARE DE COMPUTADOR", "VM": {"debito": 1.14, "credito":	2.22, "2a6":	2.47, "7a12":	2.75}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 6012, "mdr": " INSTITUIÇÕES FINANCEIRAS", "VM": {"debito": 1.70, "credito":	1.87, "2a6":	2.56, "7a12":	2.81}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 7994, "mdr": "LOJAS DE DIVERSÃO / VIDEO GAME / LAN HOUSE / CIBER CAFÉ", "VM": {"debito": 1.19, "credito":	2.22, "2a6":	2.58, "7a12":	2.94}, "DB": {"debito": 1.70 , "credito": 2.38, "2a6": 2.78, "7a12": 3.01}},
    {"mcc": 8249, "mdr": "ESCOLAS PROFISSIONALIZANTES", "VM": {"debito": 0.82, "credito":	0.86, "2a6":	1.23, "7a12":	1.49}, "DB": {"debito": 1.00 , "credito": 1.72, "2a6": 1.84, "7a12": 2.75}},
  ];

  List<CustomPopupMenu> choice = [
    CustomPopupMenu('config', "Configurações", Icons.engineering_rounded),
    CustomPopupMenu('listar', "Listar Documentos", Icons.list_alt),
    CustomPopupMenu('exit', "Sair", Icons.exit_to_app),
  ];

  static const List<String> items = [
      '742 - veterinários e clínicas veterinárias',
      '763 - cooperativas agrícolas',
      '780 - jardinagem e paisagismo',
      '1711 - encanadores, consertos de ar condicionado, aquecimento, fornos e refrigeradores',
      '1731 - eletricistas',
      '1740 - serviços de alvenaria, trabalhos com pedras, reboco, isolamento e colocação de azulejos',
      '1750	- carpinteiros',
      '1761 -	serralherias',
      '4131	- linhas de ônibus ',
      '4722 -	Agências de Viagem e Operadoras de Turismo',
      '4789 -	Transporte - outros (taxis de bicicleta, teleféricos, translado para aeroporto)',
      '4812	- Lojas de Telefones Celulares, fixo e outros equip de comunicação',
      '4816 -	Provedores de internet / Serviços de Informação',
      '5013	- Atacadistas/distribuidores de Peças e equipamentos para veículos',
      '5021 -	Móveis - Fabricantes/distribuidores de móveis para escritorios, escolas, restaurantes, igrejas',
      '5039	- Materiais de Construção - Atacadistas/fabricantes de cimento, aço, conexões e outros',
      '5046 -	Distribuidores de equipamentos para cozinha industrial, balanças, acessórios para lojas, manequins',
      '5047 -	Distribuidores de Equip p/Consultórios, Clínicas e Hospitais',
      '5051 -	Distribuidores de tubos e chapas metálicos, pregos, arames, barras, trilhos',
      '5065 -	Distribuidores de peças elétricas - capacitores, bobinas e outros',
      '5094 -	Distribuidores Pedras Preciosas, relógios, bijouterias, talheres e troféus',
      '5099 -	Fabricação de esquadrias de madeira e de peças de madeira para instalações industriais e comerciais e  artigos de carpintaria par a construção.',
      '5131 -	Piece Goods, Notions, and Other Dry Goods 1',
      '5137 -	Distribuidores de uniformes - profissionais, esportivos e escolares',
      '5199 -	Materiais de Consumo não duráveis - não classificados',
      '5211 -	Madeireiras - Varejistas de materiais de contrução',
      '5231 -	Lojas de tintas, vidro e papel de parede',
      '5251 -	Ferragens - varejo de materiais diversos (ferramentas, parafusos, suprimentos elétricos, etc)',
      '5300 -	Comércio Atacadista de alimentos (Makro, Sams Club, etc)',
      '5311 -	Lojas de Departamentos',
      '5331 -	Lojas de Produtos com preços populares (ex. Lojas de "RS 1,99")',
      '5411 -	Supermercados',
      '5422 -	Açougues, peixarias e frutos do mar (frescos e congelados)',
      '5441 -	Docerias e Confeitarias',
      '5462 -	Padarias',
      '5499 -	Lojas de Alimentos especiais (Conveniência, empórios, delicatessens/alimentos dietéticos, naturais e suplementos)',
      '5511 -	Vendas de veículos novos - inclui serviços (concessionárias)',
      '5532 -	Lojas de Pneus',
      '5533 -	Lojas de Autopeças e Acessórios para Veículos Automotivos',
      '5541 -	Postos de Combustíveis',
      '5571 -	Vendas de motocicletas - inclui peças e acessórios como capacetes, luvas, etc)',
      '5651 -	Lojas de Roupas e acessórios - feminino, masculino e infantil',
      '5661 -	Lojas de Calçados',
      '5699 -	Lojas de Artigos Unissex',
      '5712 -	Lojas de Móveis em Geral - Exceto eletrodomésticos',
      '5722 -	Lojas de Aparelhos Eletrodomésticos',
      '5732 -	Vendas de Eletrônicos (exceto celulares)',
      '5733 -	Vendas de Instrumentos Musicais',
      '5811 -	Fornecedores de Comidas/Bebidas prontas para festas, casamentos e aviação',
      '5812 -	Lanchonetes, Restaurantes, pizzarias ',
      '5813 -	Bar, Lounge, Discoteca, Clube Noturno',
      '5814 -	Restaurantes de Fast-Food',
      '5912 -	Farmácias e Drogarias ',
      '5921 -	Lojas de Bebidas (somente alcóolicas)',
      '5942 -	Livrarias e sebos',
      '5943 -	Papelarias, material escolar e de escritório',
      '5944 -	Joalherias, Relojoarias',
      '5947 -	Lojas de presentes, cartoes e souveniers ',
      '5949 -	Lojas de Tecidos / Armarinhos',
      '5977 -	Perfumarias e Cosméticos',
      '5992 -	Floriculturas, Floristas',
      '5995 -	Pet Shops',
      '5999 -	Lojas Diversas - não classificadas anteriormente',
      '6300 -	Seguradoras - agentes de seguros - planos de saude',
      '6513 -	Agentes imobiliarios e  Corretores de Imóveis ',
      '7011 -	Hotéis, Pousadas, Motéis e Resorts',
      '7230 -	Barbearias e Salões de Beleza',
      '7261 -	Serviços Funerários e Crematórios',
      '7298 -	Spas de Saúde e Beleza',
      '7311 -	Serviços de Publicidade e Propaganda',
      '7392 -	Serviços de Consultoria ',
      '7394 -	Aluguel de Equipamentos, ferramentas e móveis',
      '7399 -	Outros Comércios - Não classificados anteriormente',
      '7512 -	Locadoras de Automóveis ',
      '7523 -	Estacionamentos e Garagens',
      '7531 -	Funilaria/chapeação/pintura de Automóveis',
      '7538 -	Oficinas Automotivas',
      '7941 -	Clubes desportivos, arenas, estádios e escolas que fornecem formação esportiva, Profissional e Semiprofissional. ',
      '7997 -	Clubes, Assoc Atléticas, Recreativas, Esportivas - exige sócio',
      '7999 -	Serviços de aluguel de bicicletas, pistas de patinação, campos de corrida kart, piscinas publicas, etc...',
      '8011 -	Médicos ',
      '8021 -	Dentistas, Ortodontistas',
      '8043 -	Oticas ',
      '8050 -	Enfermarias e Casas de Repouso para idosos',
      '8062 -	Hospitais',
      '8071 -	Laboratórios médicos e odontológicos - análises clínicas, raio-X, dentaduras, aparelhos ortodônticos',
      '8099 -	Clinicas  e profissionais da Saúde (bancos de sangue, tratamento para dependencia quimica, fisioterapias, massoterapeutas, psicólogos, etc...)',
      '8111 -	Advogados, Serviços Jurídicos',
      '8211 -	Escolas de Ensino Fundamental e Médio',
      '8220 -	Faculdades, Universidades, Escolas Profissionalizantes - emitem diploma',
      '8299 -	Autoescolas, escolas de linguas, teatro, artes, culinária',
      '8911 -	Serviços de Arquitetura, Engenharia e Topografia',
      '8931 -	Serviços de Contabilidade  e Auditoria',
      '9399 -	Serviços Governamentais (cartórios, órgão da administração pública, taxas registro de veículos) ',
      '7995 -	Apostas, Casas Lotéricas e Bingos Bandeira',
      '5734 -	SOFTWARE DE COMPUTADOR',
      '6012 -	INSTITUIÇÕES FINANCEIRAS',
      '7994 -	LOJAS DE DIVERSÃO / VIDEO GAME / LAN HOUSE / CIBER CAFÉ',
      '8249 -	ESCOLAS PROFISSIONALIZANTES',
    ];

  void deletUser() async {
    print("DELETANDO USUÁRIO");
    await conn.delete("user");
    Navigator.pushReplacementNamed(context, '/');
  }

  void selectUser(){
    print('Entrei no selectUser');
    conn.select().then((result) {
      setState(() {
        user.email = result[0].email;
        _emailUser.text = user.email.toString();
      });
    });
  }

  void selectInfo(){
    conn.selectInfo().then((result){
      setState(() {
        info.mcc = result[0].mcc.toString();
        _cnpj.text = result[0].cnpj.toString();
        info.razaoSocial = result[0].razaoSocial.toString();
        info.telefone = result[0].telefone.toString();
        info.email = result[0].email.toString();
        info.abertura = result[0].abertura.toString();
        print("${result[0].mcc.toString()}");
        print("=======================");
      });
    });
  }

  Future sendMail(array, tpv, aluguel) async {
    String username = environment.mail;
    String password = environment.passwordmail;

    final smtpServer = SmtpServer(
      "smtp.office365.com",
      port: 587,
      username: username,
      password: password,
    );

    var mails = [environment.emailSupervisor];
    
    var diff1 = (double.parse(array[11]['VM']['credito'].toString().replaceAll(',', '.')) - 0.11).toStringAsFixed(2);
    var diff2 = (double.parse(array[11]['VM']['2a6'].toString().replaceAll(',', '.')) - 0.11).toStringAsFixed(2);
    var diff3 = (double.parse(array[11]['VM']['7a12'].toString().replaceAll(',', '.')) - 0.11).toStringAsFixed(2);
    var diff5 = (double.parse(array[11]['VM']['debito'].toString().replaceAll(',', '.')) - 0.11).toStringAsFixed(2);
    var diff6 = (double.parse(array[11]['DB']['credito'].toString().replaceAll(',', '.')) - 0.11).toStringAsFixed(2);
    var diff7 = (double.parse(array[11]['DB']['2a6'].toString().replaceAll(',', '.')) - 0.11).toStringAsFixed(2);
    var diff8 = (double.parse(array[11]['DB']['7a12'].toString().replaceAll(',', '.')) - 0.11).toStringAsFixed(2);
    var diff9 = (double.parse(array[11]['DB']['debito'].toString().replaceAll(',', '.')) - 0.11).toStringAsFixed(2);

    print(diff6);
    print(diff7);
    print(diff8);
    print(diff9);
    
    if(
        double.parse(array[6].toString().replaceAll(',', '.')) <= double.parse(diff1) ||
        double.parse(array[7].toString().replaceAll(',', '.')) <= double.parse(diff2) ||
        double.parse(array[8].toString().replaceAll(',', '.')) <= double.parse(diff3) ||
        double.parse(array[9].toString().replaceAll(',', '.')) <= double.parse(diff5) ||
        double.parse(array[1].toString().replaceAll(',', '.')) <= double.parse(diff6) ||
        double.parse(array[2].toString().replaceAll(',', '.')) <= double.parse(diff7) ||
        double.parse(array[3].toString().replaceAll(',', '.')) <= double.parse(diff8) ||
        double.parse(array[4].toString().replaceAll(',', '.')) <= double.parse(diff9)
      ){
      mails.add(environment.emailGestor);
    }

    final message = Message()
    ..from = Address(username)
    ..recipients.add(user.email)
    ..ccRecipients.addAll(mails)
    ..subject = "Proposta para Avaliação - Mensagem Automática"
    ..html = """
              <h1>Solicitação de Avaliação.</h1>
              <p><b>Consultor:</b> ${user.email}</p>
              <div style="display: flex; justify-content: space-around;">
                <div>
                  <h3>Dados do Cliente</h3>
                  <hr>
                  <p><b>CNPJ:</b> ${info.cnpj == null ? 'Não Informado' : info.cnpj == '' ? 'Não Informado' : info.cnpj}</p>
                  <p><b>Fantasia:</b> ${info.fantasia == null ? _fantasia.text : info.fantasia == '' ? _fantasia.text : info.fantasia}</p>
                  <p><b>Razão Social:</b> ${info.razaoSocial == null ? 'Não Informado' : info.razaoSocial == '' ? 'Não Informado' : info.razaoSocial}</p>
                  <p><b>Abertura:</b> ${info.abertura == null ? 'Não Informado' : info.abertura == '' ? 'Não Informado' : info.abertura}</p>
                  <p><b>E-mail:</b> ${info.email == null ? _email.text : info.email == '' ? _email.text : info.email}</p>
                  <p><b>Telefone:</b> ${info.telefone == null ? _telefone.text : info.telefone == '' ? _telefone.text : info.telefone}</p>
                </div>
                <div>
                  <h3>Dados da Proposta</h3>
                  <hr>
                  <p><b>MCC:</b> ${info.mcc}</p>
                  <p><b>1X:</b> ${array[1].toString()}</p>
                  <p><b>2 A 6X:</b> ${array[2].toString()}</p>
                  <p><b>7 A 24X:</b> ${array[3].toString()}</p>
                  <p><b>Débito:</b> ${array[4].toString()}</p>
                  <p><b>Antecipação: </b> ${array[0].toString()}</p>
                  <p><b>1X VISA/MASTER:</b> ${array[6].toString()}</p>
                  <p><b>2 A 6X VISA/MASTER:</b> ${array[7].toString()}</p>
                  <p><b>7 A 24X VISA/MASTER:</b> ${array[8].toString()}</p>
                  <p><b>Débito VISA/MASTER:</b> ${array[9].toString()}</p>
                  <p><b>Antecipação VISA/MASTER:</b> ${array[5].toString()}</p>
                  <p><b>Débito Automático:</b> ${array[10].toString()}</p>
                  <p><b>TPV:</b> ${tpv.toString()}</p>
                  <p><b>Aluguel:</b> ${aluguel.toString()}</p>
                </div>
                <div>
                  <h3>Médias das Taxas: </h3>
                  <hr>
                  <p><b>Débito:</b> ${(array[11]['DB']['debito']).toString().replaceAll('.', ',')}</p>
                  <p><b>1X:</b> ${array[11]['DB']['credito']}</p>
                  <p><b>2X a 6X:</b> ${array[11]['DB']['2a6']}</p>
                  <p><b>7X a 12X:</b> ${array[11]['DB']['7a12']}</p>
                  <br>
                  <p><b>Débito VISA/MASTER:</b> ${(array[11]['VM']['debito']).toString().replaceAll('.', ',')}</p>
                  <p><b>1X VISA/MASTER:</b> ${array[11]['VM']['credito']}</p>
                  <p><b>2X a 6X VISA/MASTER:</b> ${array[11]['VM']['2a6']}</p>
                  <p><b>7X a 12X VISA/MASTER:</b> ${array[11]['VM']['7a12']}</p>                  
                </div>
              </div>
              <br>
              <P style="color: red"><b>Atenção:</b> Essa mensagem é automática. Por favor, caso necessite de alguma resposta referente a essa solicitação, encaminhar para os e-mails citados neste.</p>
              <p style="display: center;"><b>Atenciosamente, Grupo Akrivia!</b></p>
            """;
    var connection = PersistentConnection(smtpServer);

    try{
      await connection.send(message);
      Fluttertoast.showToast(msg: "Sucesso ao enviar Email");
      Navigator.pop(context);
    }catch(e){
      print(e);
      Fluttertoast.showToast(msg: "Ocorreu um erro na tentativa de enviar o email");
    }finally{
      connection.close();
    }
  }

  void configuracoes(bool menu){
    showDialog(
      context: context,
      builder: (context){
        return SingleChildScrollView(
          child: AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("CONFIGURAÇÕES",
                style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark),
                ),
              ],
            ),
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: _emailUser,
                    decoration: const InputDecoration(
                      labelText: "E-mail"
                    ),
                  ),
                  TextField(
                    controller: _cnpj,
                    decoration: const InputDecoration(
                      labelText: "CNPJ"
                    ),
                    inputFormatters: [maskInputCNPJ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Center(
                    child: Text(
                        '* Deixe esse campo em branco para CPF *',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13
                      )
                    )
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Autocomplete<String>(
                    initialValue: TextEditingValue(text: info.mcc.toString() == 'null' ? items[0] : info.mcc.toString()),
                    optionsBuilder: (TextEditingValue textEditingValue){
                      if(textEditingValue.text == ''){
                        return const Iterable.empty();
                      }
                      return items.where((item){
                        return item.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String item){
                      print("The value selected is $item");
                      _mcc.text = item;
                    },
                  )
                ],
              )
            ),
            actions: [
              TextButton(
                child: Text("Salvar"),
                onPressed: () async{
                  if(_cnpj.text.length == 18){
                    await _consultarCnpj();
                  }
                  if(_cnpj.text.length < 18 && _cnpj.text.length >= 1){
                    Fluttertoast.showToast(msg: "Informe um formato de CNPJ válido!");
                    return;
                  }
                  if(_mcc.text == ''){
                    _mcc.text = info.mcc.toString() == 'null' ? items[0] : info.mcc.toString();
                  }
                  print(info.mcc.toString());

                  for(int i = 0; i < _items.length; i++){
                    if(_mcc.text.toString().split(' - ')[0].contains(_items[i]['mcc'].toString())){
                      print(_items[i]);
                      _1xVM = _items[i]['VM']['credito'].toString();
                      _2a6VM = _items[i]['VM']['2a6'].toString();
                      _7a12VM = _items[i]['VM']['7a12'].toString();
                      _dbtoVM = _items[i]['VM']['debito'].toString();
                      _1x = _items[i]['DB']['credito'].toString();
                      _2a6 = _items[i]['DB']['2a6'].toString();
                      _7a12 = _items[i]['DB']['7a12'].toString();
                      _dbto = _items[i]['DB']['debito'].toString();
                    }
                  }
                  print("======================");
                  print(_1xVM);
                  print("......................");
                  user.email = _emailUser.text;
                  info.cnpj = _cnpj.text;
                  info.mcc = _mcc.text;
                  info.razaoSocial = resultadoClass.nome;
                  info.fantasia = resultadoClass.fantasia;
                  info.abertura = resultadoClass.abertura;
                  info.email = resultadoClass.email;
                  info.telefone = resultadoClass.telefone;
                  conn.selectInfo().then((resp) async {
                    if(resp.isEmpty){
                      await conn.createInf(info);
                    }else{
                      await conn.updateInf(info);
                    }
                    print(resp);
                    await conn.update(user);
                    Navigator.pop(context);
                    setState(() {});
                  });
                },
              ),
              if(menu == true ) TextButton(
                child: Text("Cancelar"),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      }
    );
  }

  void showDialogMail(array){
    
    showDialog(
      context: context,
      builder: (context){
        return SingleChildScrollView(
          child:StatefulBuilder(builder: (context, setState){
            return Form(
              key: _formKey2,
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
                  children: [
                    const Text(
                      'Verificamos que você utilizou taxas menores do que o mínimo estabelecido pela empresa, com isso é necessário enviar um email para a realização da avaliação de sua proposta pelos responsáveis.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    TextFormField(
                      controller: _TPV,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Informar Valor';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "TPV Negociado"
                      ),
                    ),
                    TextFormField(
                      controller: _valorAluguel,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Informar Valor';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Valor Aluguel"
                      ),
                    ),
                    TextFormField(
                      controller: _fantasia,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Informar Valor';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Fantasia"
                      ),
                    ),
                    TextFormField(
                      controller: _email,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Informar Valor';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "E-mail"
                      ),
                    ),
                    TextFormField(
                      controller: _telefone,
                      inputFormatters: [maskPhone],
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Informar Valor';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: "Telefone"
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                !_preload ?
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () async {
                            if(_formKey2.currentState!.validate()){
                              setState((){
                                _preload = true;
                              });
                              await sendMail(array, _TPV.text, _valorAluguel.text);
                              setState((){
                                _preload = false;
                              });
                            }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.height *0.03,
                      height: MediaQuery.of(context).size.height * 0.03,
                      child: const CircularProgressIndicator(),
                    )
                  ],
                )
              ],
            ));
          })
        );
      }
    );

  }

  void calc(txAnt, um, doisseis, setevintequatro, credito, debito, umVm, doisVm, seteVm, txAntVM, debitoVM){
    List<dynamic> parcelasCET = [];
    List<dynamic> parcelasCETVM = [];
    List<dynamic> custoEfetivo = [];
    List<dynamic> custoEfetivoVM = [];
    int dias = 29;
    int aux = 0;
    int aux2_ = 0;
    int aux2 = 1;
    double parse = double.parse(txAnt.replaceAll(',','.'));
    double parseVM = double.parse(txAntVM.replaceAll(",", "."));

    double firstField = double.parse(um.replaceAll(',', '.'));
    double secondField = double.parse(doisseis.replaceAll(',', '.'));
    double thirdField = double.parse(setevintequatro.replaceAll(',', '.'));
    double firstFieldVM = double.parse(umVm.replaceAll(',', '.'));
    double secondFieldVM = double.parse(doisVm.replaceAll(',', '.'));
    double thirdFieldVM = double.parse(seteVm.replaceAll(',', '.'));

    for(int i = 1; i <= 24; i++){
      if(i == 1){
        String result = ((parse/30)*((dias*i))).toStringAsFixed(2);
      }
      
      String result = ((parse/30)*((dias*i)+i-1)).toStringAsFixed(2);

      parcelasCET.add(result);
      
    }

    for(int i = 1; i <= 24; i++){
      if(i == 1){
        String result = ((parseVM/30)*((dias*i))).toStringAsFixed(2);
      }
      
      String result = ((parseVM/30)*((dias*i)+i-1)).toStringAsFixed(2);

      parcelasCETVM.add(result);
      
    }
    
    for(int i = 1; i <= 12; i++){
      if(i == 1){
        double result = (firstField + double.parse(parcelasCET[aux]));
        custoEfetivo.add((result).toStringAsFixed(2));
      }else if(i >= 2 && i <= 6){
        double result = (((double.parse(parcelasCET[0]) + double.parse(parcelasCET[aux]))/2)+secondField);
        custoEfetivo.add((result).toStringAsFixed(2));
      }else if(i >= 7 && i <= 12){
        double result = (((double.parse(parcelasCET[0]) + double.parse(parcelasCET[aux]))/2)+thirdField);
        custoEfetivo.add((result).toStringAsFixed(2));
      }
      // ------------------> CRIAÇÃO DA TABELA A PARTIR DE 24 VEZES <-----------------
      /* else if(i >= 13 && i <= 24){
        double result = (((double.parse(parcelasCET[aux2]) + double.parse(parcelasCET[aux]))/2)+thirdField);
        custoEfetivo.add((result + 0.005).toStringAsFixed(2));
        aux2++;
      } */
      aux ++;
    }

    for(int i = 1; i <= 12; i++){
      if(i == 1){
        double result = (firstFieldVM + double.parse(parcelasCETVM[aux2_]));
        custoEfetivoVM.add((result).toStringAsFixed(2));
      }else if(i >= 2 && i <= 6){
        double result = (((double.parse(parcelasCETVM[0]) + double.parse(parcelasCETVM[aux2_]))/2)+secondFieldVM);
        custoEfetivoVM.add((result).toStringAsFixed(2));
      }else if(i >= 7 && i <= 12){
        double result = (((double.parse(parcelasCETVM[0]) + double.parse(parcelasCETVM[aux2_]))/2)+thirdFieldVM);
        custoEfetivoVM.add((result).toStringAsFixed(2));
      }
      // ------------------> CRIAÇÃO DA TABELA A PARTIR DE 24 VEZES <-----------------
      /* else if(i >= 13 && i <= 24){
        double result = (((double.parse(parcelasCETVM[aux2_]) + double.parse(parcelasCETVM[aux2_]))/2)+thirdField);
        custoEfetivoVM.add((result + 0.005).toStringAsFixed(2));
        aux2_++;
      } */
      aux2_ ++;
    }

    Navigator.pushNamed(context, '/efetivo', arguments: {"table": custoEfetivo, "tableVM": custoEfetivoVM, "first": [txAnt, um, doisseis, setevintequatro, credito, debito, umVm, doisVm, seteVm, txAntVM, debitoVM], "email": user.email.toString(), "info": info});

  }

  @override
  void initState(){
    super.initState();
      Future.delayed(
        const Duration(milliseconds: 800),
        (){
          selectUser();
          selectInfo();
          configuracoes(false);
        }
      );
  }

  @override
  Widget build(BuildContext context){
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(4,30,55,1),
        title: Text(info.mcc.toString() == 'null' ? 'Informe um MCC' : info.mcc.toString()),
        actions: [
          PopupMenuButton<CustomPopupMenu>(
            elevation: 3.2,
            onCanceled: (){
              print("You have not chossed anything");
            },
            tooltip: "Ações do App",
            onSelected: _selectOptionMenu,
            itemBuilder: (BuildContext context) {
              return choice.map((CustomPopupMenu choice){
                return PopupMenuItem(
                  value: choice,
                  enabled: true,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(choice.icon, color: Colors.black),
                      ),
                      Text(choice.title)
                    ],
                  ),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
        child: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/AKRIVIA-QUADRADO-Fundo.png"),
            fit: BoxFit.fitWidth
          )
        ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 1.25,
        color: const Color.fromARGB(223, 201, 201, 201),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(child: Column(
            children: [
              SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                            resultadoClass.nome.toString() == 'null' ? "Você está trabalhando com CPF!" : '${info.razaoSocial}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Situação: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          resultadoClass.situacao == 'ATIVA' 
                          ? 
                          Text(
                            '${resultadoClass.situacao}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          )
                          :
                          Expanded(child: Text(
                            resultadoClass.situacao.toString() == 'null' ? "CNPJ Inválido" : '${resultadoClass.situacao}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),)
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Contato: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Expanded(child: Text(
                            resultadoClass.telefone.toString() == 'null' ? "CNPJ Inválido" : '${info.telefone}',
                            style: const TextStyle(
                              fontSize: 18
                            ),
                          ))
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            "Email: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            resultadoClass.email.toString() == 'null' ? "CNPJ Inválido" : '${info.email}',
                            style: const TextStyle(
                              fontSize: 18
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              const Text(
                "VISA/MASTER",
                style: TextStyle(
                  fontWeight: FontWeight.bold
                )
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _umVM,
                      decoration: const InputDecoration(
                          labelText: "1X",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                    const SizedBox(width: 20,),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _doisaseisVM,
                      decoration: const InputDecoration(
                          labelText: "2X A 6X",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                    const SizedBox(width: 20,),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _seteavinteequatroVM,
                      decoration: const InputDecoration(
                          labelText: "7X A 12X",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _debitoVM,
                      decoration: const InputDecoration(
                          labelText: "Débito",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                    const SizedBox(width: 10,),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _antecipacaoVM,
                        decoration: const InputDecoration(
                          labelText: "Antecipação",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                  ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Text("Taxas Mínimas: ", 
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent
                )
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Text("1X: ", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent
                        ),),
                      Text("${_1xVM}",
                      style: TextStyle(color: Colors.redAccent)),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("2X a 6X: ", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent
                        ),),
                      Text("${_2a6VM}",
                        style: TextStyle(color: Colors.redAccent)
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Text("7X a 12X: ", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent
                        ),),
                      Text("${_7a12VM}",
                      style: TextStyle(color: Colors.redAccent),),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Débito: ", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent
                        ),),
                      Text("${_dbtoVM}",
                      style: TextStyle(color: Colors.redAccent))
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                color: Colors.black,
              ),
              const Text(
                "DEMAIS BANDEIRAS",
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _um,
                      decoration: const InputDecoration(
                          labelText: "1X",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                    const SizedBox(width: 20,),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _doisaseis,
                      decoration: const InputDecoration(
                          labelText: "2X A 6X",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                    const SizedBox(width: 20,),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _seteavinteequatro,
                      decoration: const InputDecoration(
                          labelText: "7X A 12X",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _debito,
                      decoration: const InputDecoration(
                          labelText: "Débito",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                    const SizedBox(width: 10,),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Vazio';
                          }
                          return null;
                        },
                        controller: _antecipacao,
                        decoration: const InputDecoration(
                          labelText: "Antecipação",
                        ),
                        inputFormatters: [maskTaxa],
                      ),
                    ),
                  ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Text("Taxas Mínimas: ", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        "1X: ",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text("${_1x}", style: TextStyle(color: Colors.redAccent)),
                    ],
                  ),
                  Row(
                    children: [
                      Text("2X a 6X: ", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent
                        ),),
                      Text("${_2a6}", style: TextStyle(color: Colors.redAccent))
                    ],
                  ),
                  Row(
                    children: [
                      Text("7X a 12X: ", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent
                        ),),
                      Text("${_7a12}", style: TextStyle(color: Colors.redAccent)),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Débito: ", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent
                        ),),
                      Text("${_dbto}",
                      style: TextStyle(color: Colors.redAccent))
                    ],
                  )
                ],
              ),
              const Divider(
                color: Colors.black
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Antecipação Automático: ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(width: 10,),
                    DropdownButton(
                      hint: Text(_credito),
                      items: ['Sim', 'Não'].map((String value){
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value)
                        );
                      }).toList(),
                      onChanged: (_){
                        setState(() {
                          _credito = _.toString();
                        });
                    })
                  ],
                ),
              ),
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
                          Text('Avaliar Proposta',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        if(info.mcc.toString() == 'null'){
                          Fluttertoast.showToast(msg: "É necessário informar um MCC Válido!");
                          return;
                        }
                        
                        if(_formKey.currentState!.validate()){
                          if(resultadoClass.fantasia.toString() == 'null'){
                            Fluttertoast.showToast(msg: "CNPJ não informado!\nVocê está trabalhando com CPF.");
                          }
                          for(int i = 0; i < _items.length; i++){
                            if(info.mcc.toString().split(' - ')[0].contains(_items[i]['mcc'].toString())){

                              print(_items[i]['VM']['credito']);
                              if(double.parse(_debitoVM.text.replaceAll(',', '.')) < _items[i]['VM']['debito'] || 
                              double.parse(_umVM.text.replaceAll(',', '.')) < _items[i]['VM']['credito'] ||
                              double.parse(_doisaseisVM.text.replaceAll(',', '.')) < _items[i]['VM']['2a6'] ||
                              double.parse(_seteavinteequatroVM.text.replaceAll(',', '.')) < _items[i]['VM']['7a12'] ||
                              double.parse(_debito.text.replaceAll(',', '.')) < _items[i]['DB']['debito'] ||
                              double.parse(_um.text.replaceAll(',', '.')) < _items[i]['DB']['credito'] ||
                              double.parse(_doisaseis.text.replaceAll(',', '.')) < _items[i]['DB']['2a6'] ||
                              double.parse(_seteavinteequatro.text.replaceAll(',', '.')) < _items[i]['DB']['7a12'] ||
                              double.parse(_antecipacaoVM.text.replaceAll(',', '.')) < 1.69){
                                return showDialogMail([_antecipacao.text, _um.text, _doisaseis.text, _seteavinteequatro.text, _debito.text, _antecipacaoVM.text, _umVM.text, _doisaseisVM.text, _seteavinteequatroVM.text, _debitoVM.text, _credito, _items[i]]);
                              }
                            }
                          }
                          print(_items[0]['VM']['debito']);
                          print(info.mcc.toString().split(' - ')[0]);

                          setState(() {
                            print(resultadoClass.cnpj.toString());
                            print(_cnpj.text);
                            calc(_antecipacao.text, _um.text, _doisaseis.text, _seteavinteequatro.text, _credito, _debito.text, _umVM.text, _doisaseisVM.text, _seteavinteequatroVM.text, _antecipacaoVM.text, _debitoVM.text);
                          });
                        }
                      },
                    ),
                  ),
                )
            ],
          )
        )
      )
        )])
    ),
      ));
  }

  void _selectOptionMenu(CustomPopupMenu result){
    switch(result.id){
      case 'exit':
        deletUser();
        break;
      
      case 'config':
        configuracoes(true);
        break;
      
      case 'listar':
        Navigator.pushNamed(context, '/listdocs');
        break;
    }
    setState(() {});
  }

  Future _consultarCnpj() async {
    var cnpjReplacement =
        _cnpj.text.replaceAll('.', '').replaceAll('/', '').replaceAll('-', '');
    print(cnpjReplacement);

    var url =
        Uri.parse('https://www.receitaws.com.br/v1/cnpj/$cnpjReplacement');
    try {
      var response = await http.get(url);
      print('Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        var content = json.decode(response.body);
        print(content['nome']);
        print(content);
        if (content['status'] == "ERROR") {
          await conn.deleteInfo();
          print('${content['message']}');
          resultadoClass.cnpj = null;
          await conn.deleteInfo();
          setState(() {
            _cnpj.text = '';
            Fluttertoast.showToast(msg: '${content['message']}');            
          });
          return;
        }

        Map<String, dynamic> dados = json.decode(response.body);

        setState(() {
          resultadoClass.cnpj = _cnpj.text;
          resultadoClass.nome = dados['nome'];
          resultadoClass.cep = dados['cep'];
          resultadoClass.situacao = dados['situacao'];
          resultadoClass.fantasia = dados['fantasia'];
          resultadoClass.bairro = dados['bairro'];
          resultadoClass.logradouro = dados['logradouro'];
          resultadoClass.numero = dados['numero'];
          resultadoClass.municipio = dados['municipio'];
          resultadoClass.uf = dados['uf'];
          resultadoClass.dataSituacao = dados['data_situacao'];
          resultadoClass.email = dados['email'];
          resultadoClass.telefone = dados['telefone'];
          resultadoClass.motivoSituacao = dados['motivo_situacao'];
          resultadoClass.abertura = dados['abertura'];
        });
      } else if (response.statusCode == 429) {
        print("Ocorreu um erro");
        Fluttertoast.showToast(
            msg: 'Aguarde 1 minuto para fazer uma nova consulta.');
      } else {
        print("Problemas com a conexão");
        print(response.statusCode);
        Fluttertoast.showToast(msg: 'Algo deu errado!');
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Verifique a sua conexão com a internet.");
    }
  }

}