import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:akrivia_vendas/models/userModel.dart';
import 'package:akrivia_vendas/models/info.dart';
import 'package:akrivia_vendas/models/doc.dart';
import 'package:akrivia_vendas/models/conta.dart';

class Connection {

  static final Connection _instance = Connection.internal();

  factory Connection() => _instance;

  Connection.internal();

  Database? _db;

  Future<Database?> get db async {
    if(_db != null){
      return _db;
    }else{
      _db = await initializeDatabase();
      return _db;
    }
  }

  Future<Database> initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "table.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newVersion) async {
        await db.execute("CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, email TEXT)");
        await db.execute("CREATE TABLE info (cnpj TEXT, mcc TEXT, razaoSocial TEXT, fantasia TEXT, abertura TEXT, email TEXT, telefone TEXT)");
        await db.execute("CREATE TABLE doc (cep TEXT, complemento TEXT, logradouro TEXT, bairro TEXT, localidade TEXT, uf TEXT, numero TEXT, nome TEXT, cpf TEXT, datanascimento TEXT, rg TEXT, wpp TEXT)");
        await db.execute("CREATE TABLE conta (tipoConta TEXT, natureza TEXT, banco TEXT, agencia TEXT, conta TEXT, nomeFav TEXT)");
      }
    );
  }
  
  Future selectConta() async {
    Database? dbUser = await db;
    List listMap = await dbUser!.query("conta");
    List<Conta> listUser = [];
    listMap.forEach((element) {
      print(element);
      listUser.add(Conta.fromMap(element));
    });
    /* for(Map m in listMap){
      print(User.fromMap(m));
      listUser.add(User.fromMap(m));
    } */
    return listUser;
  }

  Future updateConta(Conta conta) async {
    Database? dbUser = await db;
    await dbUser!.update("conta", conta.toMap());
  }

  Future insertConta(Conta conta) async {
    Database? dbUser = await db;
    await dbUser!.insert("conta", conta.toMap());
  }

  Future<Doc?> updateDoc(Doc doc) async {
    Database? dbUser = await db;
    await dbUser!.update("doc", doc.toMap());
  }

  Future<Doc?> insertDoc(Doc doc) async {
    Database? dbUser = await db;
    await dbUser!.insert("doc", doc.toMap());
  }

  Future<List> selectDoc() async {
    Database? dbUser = await db;
    List listMap = await dbUser!.query("doc");
    List<Doc> listUser = [];
    listMap.forEach((element) {
      print(element);
      listUser.add(Doc.fromMap(element));
    });
    /* for(Map m in listMap){
      print(User.fromMap(m));
      listUser.add(User.fromMap(m));
    } */
    return listUser;
  }

  Future<Info?> createInf(Info info) async {
    Database? dbUser = await db;
    await dbUser!.insert("info", info.toMap());
  }

  Future<Info?> updateInf(Info info) async {
    Database? dbUser = await db;
    await dbUser!.update("info", info.toMap());
  }

  Future<List> select() async {
    Database? dbUser = await db;
    List listMap = await dbUser!.query("user");
    List<User> listUser = [];
    listMap.forEach((element) {
      print(element);
      listUser.add(User.fromMap(element));
    });
    /* for(Map m in listMap){
      print(User.fromMap(m));
      listUser.add(User.fromMap(m));
    } */
    return listUser;
  }

  Future<List> selectInfo() async {
    Database? dbUser = await db;
    List listMap = await dbUser!.query("info");
    List<Info> listUser = [];
    listMap.forEach((element) {
      print(element);
      listUser.add(Info.fromMap(element));
    });
    /* for(Map m in listMap){
      print(User.fromMap(m));
      listUser.add(User.fromMap(m));
    } */
    return listUser;
  }

  Future<User?> update(User user) async {
    Database? dbUser = await db;
    await dbUser!.update("user", user.toMap());
    return user;
  }

  Future<User?> insert(User user) async {
    Database? dbUser = await db;
    await dbUser!.insert("user", user.toMap());
    return user;
  }

  Future<User?> delete(table) async {
    Database? dbUser = await db;
    await dbUser!.rawQuery("DELETE FROM $table");
  }

  Future<Doc?> deleteDoc() async {
    Database? dbUser = await db;
    await dbUser!.rawQuery("DELETE FROM doc");
  }

  Future<Info?> deleteInfo() async {
    Database? dbUser = await db;
    await dbUser!.rawQuery("DELETE FROM info");
  }

  Future deleteConta() async {
    Database? dbUser = await db;
    await dbUser!.rawQuery("DELETE FROM conta");
  }

  Future updateFantasia(fantasia) async {
    Database? dbUser = await db;
    await dbUser!.rawQuery("UPDATE info SET fantasia = '$fantasia'");
  }

}