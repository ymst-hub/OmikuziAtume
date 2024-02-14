import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//dbの名前
const _dbName = "hakke.db";
const _dbVersion = 1;
//メインテーブルの名前
const hakkeMainTableName = "hakkeMain";
//メインテーブルのカラム名
const hakkeMainColumnId = "id";
const hakkeMainColumnResult = "result";
const hakkeMainColumnSelfResult = "selfResult";
const hakkeMainColumnDate = "date"; //基準時からのミリ秒
const hakkeMainColumnLocation = "location";
const hakkeMainColumnMemo = "memo";

class DbHelper {
  //このクラスのインスタンスを作成する
  DbHelper._privateConstructor();

  static final DbHelper _instance = DbHelper._privateConstructor();

  factory DbHelper() {
    return _instance;
  }
  //DBを開く
  static Database? _database;
  Future<Database> get database async {
        if (_database != null) {
              return _database!;
        } else {
              _database = await _initDatabase();
              return _database!;
        }
  }

  //DBの初期化を行う
  _initDatabase() async {
        //DBファイルのパスを取得する
        var databasesPath = await getDatabasesPath();
        var path = join(databasesPath, _dbName);

        // openDatabaseメソッドの結果を返す
        return await openDatabase(
              path,
              version: _dbVersion,
              onCreate: _onCreate,
        );
  }

  //Create処理
  _onCreate(Database db, int version) {
        db.execute(
            '''
            CREATE TABLE $hakkeMainTableName(
            $hakkeMainColumnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $hakkeMainColumnResult INTEGER NOT NULL,
            $hakkeMainColumnSelfResult INTEGER NOT NULL,
            $hakkeMainColumnDate INTEGER NOT NULL,
            $hakkeMainColumnLocation TEXT,
            $hakkeMainColumnMemo TEXT
            )'''
        );
  }

  //Insert処理
  Future<void> insertHakkeMain(int result, int selfResult, int date, String location,String memo) async {
    final db = await database;
    await db.insert(
      hakkeMainTableName,
      {
        hakkeMainColumnResult: result,
        hakkeMainColumnSelfResult: selfResult,
        hakkeMainColumnDate: date,
        hakkeMainColumnLocation: location,
        hakkeMainColumnMemo: memo,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }

  //Select処理
  Future<List<Map<String, dynamic>>> getHakkeMain() async {
    final db = await database;
    return await db.query(
        hakkeMainTableName,
        orderBy: '$hakkeMainColumnDate DESC',
    );
  }

  //Idを指定してSelect処理
  Future<Map<String, dynamic>> getHakkeMainById(int id) async {
    final db = await database;
    var res = await db.query(
      hakkeMainTableName,
      where: '$hakkeMainColumnId = ?',
      whereArgs: [id],
    );
    return res.first;
  }

  //引数より後のDateでSelect処理
  Future<List<Map<String, dynamic>>> getHakkeMainByDate(int date) async {
    final db = await database;
    return await db.query(
      hakkeMainTableName,
      where: '$hakkeMainColumnDate > ?',
      whereArgs: [date],
    );
  }

  //Update処理
  Future<void> updateHakkeMainById(int id, int result, int selfResult, int date, String location, String memo) async {
    final db = await database;
    await db.update(
      hakkeMainTableName,
      {
        hakkeMainColumnResult: result,
        hakkeMainColumnSelfResult: selfResult,
        hakkeMainColumnDate: date,
        hakkeMainColumnLocation: location,
        hakkeMainColumnMemo: memo,
      },
      where: '$hakkeMainColumnId = ?',
      whereArgs: [id],

    );
  }

  //Delete処理
  Future<void> deleteHakkeMainById(int id) async {
    final db = await database;
    await db.delete(
      hakkeMainTableName,
      where: '$hakkeMainColumnId = ?',
      whereArgs: [id],
    );
  }

  //DBを閉じる
  Future<void> close() async {
    final db = await database;
    db.close();
  }

  Future<List<Map<String, dynamic>>> getHakkeMainByResultAndSelfResult() async{
    final db = await database;
    //ResultとSelfResultをgroup byして、それぞれの数をカウントする
    return await db.query(
      hakkeMainTableName,
      columns: [
        hakkeMainColumnResult,
        hakkeMainColumnSelfResult,
        'COUNT(*) as count',
      ],
      groupBy: '$hakkeMainColumnResult, $hakkeMainColumnSelfResult',
      orderBy: '$hakkeMainColumnResult, $hakkeMainColumnSelfResult',
    );
  }
}
