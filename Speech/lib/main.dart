import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:speech/screen/MemoPage.dart';
import 'package:speech/screen/UpdateMemo.dart';
import 'package:speech/screen/folderPage.dart';
import 'MyHomePage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // Future<Database> initDatabase() async {
  //   return openDatabase(
  //     join(await getDatabasesPath(), 'speech_database_db'),
  //     onCreate: (db, version){
  //       db.execute('CREATE TABLE '
  //               'folder(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, speechTitle TEXT, speechContent TEXT, dateTime TEXT');
  //     },
  //       onUpgrade: _onUpgrade ,
  //       version: 20
  //   );
  // }
  //
  // Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  //   if (oldVersion < newVersion) {
  //     // db.execute('CREATE TABLE '
  //     //     'folder(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, dateTime TEXT)');
  //
  //     // db.execute('CREATE TABLE '
  //     //     'memo(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT ,folderName TEXT, content TEXT, dateTime TEXT)',);
  //
  //     db.execute('ALTER TABLE memo ADD COLUMN speechTitle TEXT');
  //     db.execute('ALTER TABLE memo ADD COLUMN speechContent TEXT');
  //
  //
  //   }
  // }


  @override
  Widget build(BuildContext context){
    FirebaseDatabase? _database = FirebaseDatabase.instance;
    DatabaseReference? reference = _database!.ref();
    //Future<Database> database = initDatabase();
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/':(context) => MyHomePage(_database, reference),
        '/folder':(context) => FolderPage(_database, reference),
        '/memo': (context) => MemoPage(_database, reference),
        '/memoUpdate': (context) => UpdateMemoPage(_database, reference)
      }
    );
  }
}

