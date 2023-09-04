import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../modal/Memo.dart';

class UpdateMemoPage extends StatefulWidget {
  final Future<Database> database;

  UpdateMemoPage(this.database);

  @override
  State<UpdateMemoPage> createState() => _UpdateMemoPage();
}

class _UpdateMemoPage extends State<UpdateMemoPage> {

  TextEditingController? controller;
  TextEditingController? titleController;
  late Memo memo;
  List<String> items = List.empty(growable: true);

  @override
  void initState() {
    items.add('asdfsaf');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    memo = ModalRoute.of(context)!.settings.arguments as Memo;
    titleController = TextEditingController(text: memo.title);
    controller = TextEditingController(text: memo.content);

    return Scaffold(
      appBar: AppBar(
        title: Text("메모"),
        actions: [
          TextButton(onPressed: (){
            print(controller!.value.text);
            DateTime now = DateTime.now();
            String currentTime = DateFormat('yyyy-MM-dd').format(now);
            Memo updateMemo = Memo(memo.id, titleController!.value.text ,memo.folderName, controller?.value.text.toString(), currentTime);
            insertMemo(updateMemo);
            Navigator.of(context).pop();
          }, child: Text('완료', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)))
        ],
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                    Container(
                      width: width,
                      height: height*0.78,
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child:
                          Column(
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

                                CupertinoButton(child: Text('면접 질문 추가'), padding: EdgeInsets.only(top: 80), onPressed: () {
                                  setState(() {
                                    items.add('asdfasdfasfasdf');
                                  });
                                }),


                                SingleChildScrollView(
                                  child: Container(
                                    width: width,
                                    height: height*0.5,

                                    child: ListView.builder(itemCount: items.length ,itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        child: Text('${items[index]}'),
                                      );
                                    }),
                                  )
                                )


                                // Padding(
                                //     padding: EdgeInsets.all(10),
                                //     child: TextField(
                                //       controller: controller,
                                //       decoration: InputDecoration(hintText: "Insert your message",),
                                //       scrollPadding: EdgeInsets.all(20.0),
                                //       keyboardType: TextInputType.multiline,
                                //       maxLines: 29,
                                //       autofocus: true,
                                //       style: TextStyle(fontSize: 18, color: Colors.black),)
                                // )
                          ]
                        ),
                      ),
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
              ]
            )
          ),
        ),
      );
  }

  void insertMemo(Memo memo) async {
    final Database database = await widget.database!;
    await database
        .update('memo', memo.toMap(), where: 'id=?', whereArgs: [memo.id]).then((value){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('메모를 생성하였습니다.')));
    });
  }

  Future<Memo> getMemo() async {
    final Database database = await widget.database!;
    final List<Map<String, dynamic>> maps = await database.query('memo');
    return Memo(maps[0]['id'],maps[0]['title'], maps[0]['folderName'], maps[0]['content'], maps[0]['dateTime']);
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
