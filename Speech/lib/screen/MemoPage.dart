import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../modal/Memo.dart';

class MemoPage extends StatefulWidget {
  final Future<Database> database;

  MemoPage(this.database);

  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {

  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("메모"),
        actions: [
          TextButton(onPressed: (){
            print(controller!.value.text);

            Navigator.of(context).pop();
          }, child: Text('완료', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)))
        ],
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: "Insert your message",),
                  scrollPadding: EdgeInsets.all(20.0),
                  keyboardType: TextInputType.multiline,
                  maxLines: 99999,
                  autofocus: true,

                  style: TextStyle(fontSize: 18, color: Colors.black),))
            ],
          ),
        ),
      ),
    );
  }

  void insertMemo(Memo memo) async {
    final Database database = await widget.database!;
    await database
        .insert('memo', memo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('메모를 생성하였습니다.')));
    });
  }

  Future<List<Folder>> getFolderList() async {
    final Database database = await widget.database!;
    final List<Map<String, dynamic>> maps = await database.query('folder');
    return List.generate(maps.length, (index){
      return Folder(maps[index]['name'], FocusNode(), TextEditingController(text: maps[index]['name']), DateTime.now().toIso8601String());
    });
  }

  void deleteFolder(Folder folder) async {
    final Database database = await widget.database!;
    await database.delete('folder',
        where: 'name=?', whereArgs: [folder.name]).then((value){
      setState(() {
        list = getFolderList();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('폴더를 삭제하였습니다.')));
    });
  }

  void updateFolder(Folder folder, String name) async {
    final Database database = await widget.database;
    await database.update('folder',
        {
          'name' : name,
          'dateTime' : folder.dateTime
        },
        where: 'name = ?', whereArgs: [folder.name]).then((value){
      setState(() {
        list = getFolderList();
      });
    });
  }
}
