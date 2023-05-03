import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:akrivia_vendas/models/userModel.dart';
import 'package:akrivia_vendas/models/info.dart';

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
      }
    );
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


}