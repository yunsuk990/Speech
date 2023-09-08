import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speech/modal/Speech.dart';
import 'package:sqflite/sqflite.dart';
import '../modal/Memo.dart';

class UpdateMemoPage extends StatefulWidget {
  // final Future<Database> database;
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  UpdateMemoPage(this._database, this.reference);

  @override
  State<UpdateMemoPage> createState() => _UpdateMemoPage();
}

class _UpdateMemoPage extends State<UpdateMemoPage> {

  TextEditingController? controller;
  TextEditingController? titleController;
  late Memo memo;
  late Map<String, String>? speech;
  List<String?>? speechTitle = List.empty(growable: true);
  List<String?>? speechContent = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    memo = ModalRoute.of(context)!.settings.arguments as Memo;
    speech = {};
    titleController = TextEditingController();
    controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("메모"),
        actions: [
          TextButton(onPressed: (){
            print(controller!.value.text);
            DateTime now = DateTime.now();
            String currentTime = DateFormat('yyyy-MM-dd').format(now);
            Memo updatememo = Memo(memo.id, titleController!.value.text ,memo.folderName, memo.speechTitle, memo.speechContent, currentTime);
            // updateMemo(updatememo);
            Navigator.of(context).pop();
          }, child: Text('완료', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)))
        ],
      ),

      body: Column(
        children: <Widget>[
            Column(
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
    
                                    SizedBox(
                                      height: 30,
                                    ),
    
                                    CupertinoButton(child: Text('면접 질문 추가'),color: Colors.lightBlue,padding: EdgeInsets.only(left: width/3, right: width/3),onPressed: () {
                                      setState(() {
                                        // speech?.add(Speech(null, null, TextEditingController(), TextEditingController()));
                                      });
                                    }),
    
                                    SizedBox(
                                      height: 20,
                                    ),

                                    Container(
                                      width: width,
                                      height: height*0.6,
                                      child: ListView.separated(
                                        itemBuilder: (BuildContext context, int index){
                                          return Column(
                                            children: <Widget>[
                                              Card(
                                                  color: Colors.white60,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                                  ),
                                                  elevation: 3,
                                                  child: CupertinoTextField(
                                                    decoration: BoxDecoration(),
                                                    padding: EdgeInsets.only(top: 20, left: 5, bottom: 15, right: 5),
                                                    placeholder: "면접 질문을 작성해주세요.",
                                                    controller: TextEditingController(),
                                                    autofocus: true,
                                                    keyboardType: TextInputType.multiline,
                                                    prefix: Padding(padding: EdgeInsets.only(left: 10), child: Icon(CupertinoIcons.checkmark_alt),),
                                                  ),
                                              ),
                                              SizedBox(height: 10),
                                              CupertinoTextField(
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black),
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                ),
                                                padding: EdgeInsets.only(top: 10, left: 15, bottom: 10),
                                                keyboardType: TextInputType.multiline,
                                                placeholder: '질문에 대한 답을 작성해주세요.',
                                                maxLines: 6,
                                                controller: TextEditingController()
                                              ),
                                            ],
                                          );

                                        },itemCount: speech!.length, separatorBuilder: (BuildContext context, int index) { return Divider(); },),
                                    ),
                              ]
                            ),
                          ),
                        ),
                ]
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
        ),
      );
  }

  // void updateMemo(Memo memo) async {
  //   final Database database = await widget.database!;
  //   await database
  //       .update('memo', memo.toMap(), where: 'id=?', whereArgs: [memo.id]).then((value){
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('메모를 수정하였습니다.')));
  //   });
  // }

  // Future<Memo> getMemo() async {
  //   final Database database = await widget.database!;
  //   final List<Map<String, dynamic>> maps = await database.query('memo');
  //   return Memo(maps[0]['id'],maps[0]['title'], maps[0]['folderName'], maps[0]['content'], maps[0]['dateTime']);
  // }

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
