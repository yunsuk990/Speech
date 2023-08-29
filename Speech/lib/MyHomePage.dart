import 'package:flutter/material.dart';
import 'package:speech/screen/ListPage.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'FirstPage.dart';

class MyHomePage extends StatefulWidget{
  final Future<Database> database;
  MyHomePage(this.database);

  @override
  State<StatefulWidget> createState() => _myHomePage();

}

class _myHomePage extends State<MyHomePage> with SingleTickerProviderStateMixin {

  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
          children: <Widget>[FirstPage(widget.database), ListPage()],
          controller: controller,
      ),
      bottomNavigationBar:
      Padding(
          padding: EdgeInsets.all(20),
          child: TabBar(tabs: [
            Tab(icon: Icon(Icons.home, size: 30, color: Colors.blue)),
            Tab(icon: Icon(Icons.list, size: 30,color: Colors.blue)),
          ], controller: controller,))
    );
  }
}