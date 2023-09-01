import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../modal/Memo.dart';

class MemoPage extends StatefulWidget {
  final Future<Database> database;

  MemoPage(this.database);

  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {

  late Future<Memo> memo;

  TextEditingController? controller;

  @override
  void initState() {
    super.initState();
    memo = getMemo();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    String folderName = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text("메모"),
        actions: [
          TextButton(onPressed: (){
            print(controller!.value.text);
            Memo memo = Memo(null, folderName, controller?.value.text.toString(), DateTime.now().toIso8601String());
            insertMemo(memo);
            Navigator.of(context).pop();
          }, child: Text('완료', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)))
        ],
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(builder: (context, snapshot){
                controller = TextEditingController(text: snapshot.data?.content);
                switch(snapshot.connectionState){
                  case ConnectionState.none:
                    return CupertinoActivityIndicator();
                  case ConnectionState.waiting:
                    return CupertinoActivityIndicator();
                  case ConnectionState.active:
                    return CupertinoActivityIndicator();
                  case ConnectionState.done:
                    return Padding(
                        padding: EdgeInsets.all(10),
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(hintText: "Insert your message",),
                          scrollPadding: EdgeInsets.all(20.0),
                          keyboardType: TextInputType.multiline,
                          maxLines: 99999,
                          autofocus: true,
                          style: TextStyle(fontSize: 18, color: Colors.black),));
                }
              }
                ,future: memo,)
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

  Future<Memo> getMemo() async {
    final Database database = await widget.database!;
    final List<Map<String, dynamic>> maps = await database.query('memo');
    return Memo(maps[0]['id'], maps[0]['folderName'], maps[0]['content'], maps[0]['dateTime']);
  }

// void updateMemo(Memo memo, String name) async {
//   final Database database = await widget.database;
//   await database.update('memo',
//       {
//         'folderName' : memo.folderName,
//         'content' : memo.content,
//         'dateTime' : memo.folderName
//       },
//       where: 'id = ?', whereArgs: [memo.id]).then((value){
//     setState(() {
//       memoList = getMemoList();
//     });
//   });
// }
}