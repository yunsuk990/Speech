import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:speech/FirstPage.dart';
import 'package:speech/screen/MemoPage.dart';
import 'package:speech/screen/folderPage.dart';
import 'MyHomePage.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'speech_database_db'),
      onCreate: (db, version){
        return db.execute(
            'CREATE TABLE '
                'folder(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, dateTime TEXT'), '
                'memo(id INTEGER PRIMARY KEY AUTOINCREMENT,'
                'folderName TEXT, content TEXT, dateTime TEXT)',

        );
      },
      version: 1
    );
  }

  @override
  Widget build(BuildContext context){
    Future<Database> database = initDatabase();
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/':(context) => MyHomePage(database),
        '/folder':(context) => FolderPage(database),
        '/memo': (context) => MemoPage(database)
      }
    );
  }
}

