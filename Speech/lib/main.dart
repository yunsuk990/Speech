import 'package:flutter/material.dart';
import 'package:speech/FirstPage.dart';
import 'package:speech/screen/MemoPage.dart';
import 'package:speech/screen/folderPage.dart';
import 'MyHomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
      routes: {
        '/folder':(context) => FolderPage(),
        '/memo': (context) => MemoPage()
      }
    );
  }
}

