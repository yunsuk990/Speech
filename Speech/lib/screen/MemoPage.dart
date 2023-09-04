import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../modal/Folder.dart';
import '../modal/Memo.dart';

class MemoPage extends StatefulWidget {
  final Future<Database> database;

  MemoPage(this.database);

  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  TextEditingController? controller;
  TextEditingController? titleController;

  @override
  void initState() {
    titleController = TextEditingController();
    controller = TextEditingController();
    super.initState();
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
            DateTime now = DateTime.now();
            String currentTime = DateFormat('yyyy-MM-dd').format(now);
            Memo memo = Memo(null,titleController!.value.text.toString(),folderName, controller?.value.text.toString(), currentTime);
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
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[

                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(hintText: 'Title'),
                          scrollPadding: EdgeInsets.all(20),
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          autofocus: true,
                          style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)
                        ),

                        TextField(
                            controller: controller,
                            decoration: InputDecoration(hintText: "Insert your message",),
                            scrollPadding: EdgeInsets.all(20.0),
                            keyboardType: TextInputType.multiline,
                            maxLines: 99999,
                            autofocus: true,
                            style: TextStyle(fontSize: 18, color: Colors.black)
                        )
                    ],
                  )
              ),

              Padding(padding: EdgeInsets.only(left: 20, bottom: 20, right: 20),
                child: Row(
                  children: <Widget>[
                    MaterialButton(onPressed: (){},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      color: Colors.lightBlue,
                      padding: EdgeInsets.only(left: 45, right: 45, top:15, bottom: 15),
                      child: Text('면접 시작하기',style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),),

                    Expanded(child: Container()),

                    MaterialButton(onPressed: (){},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        color: Colors.grey,
                        padding: EdgeInsets.only(left: 45, right: 45, top:15, bottom: 15),
                        child: Text('면접 설정하기', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),)

                    ),
                  ],
                ),)

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
