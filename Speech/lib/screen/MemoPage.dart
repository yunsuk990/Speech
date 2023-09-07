import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../modal/Folder.dart';
import '../modal/Memo.dart';
import '../modal/Speech.dart';

class MemoPage extends StatefulWidget {
  final Future<Database> database;

  MemoPage(this.database);

  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  TextEditingController? controller;
  TextEditingController? titleController;
  List<Speech>? speech = List.empty(growable: true);

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
            Memo memo = Memo(null,titleController!.value.text.toString(),folderName,speech, currentTime);
            insertMemo(memo);
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
                                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
                            ),

                            SizedBox(
                              height: 30,
                            ),

                            CupertinoButton(child: Text('면접 질문 추가'),color: Colors.lightBlue,padding: EdgeInsets.only(left: width/3, right: width/3),onPressed: () {
                              setState(() {
                                speech?.add(Speech(null, null, TextEditingController(), TextEditingController()));
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
                                          controller: speech?[index].titleController,
                                          autofocus: true,
                                          keyboardType: TextInputType.multiline,
                                          prefix: Padding(padding: EdgeInsets.only(left: 10), child: Icon(CupertinoIcons.checkmark_alt),),
                                          onChanged: (v){
                                            speech?[index].title = v;
                                          },
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
                                        controller: speech?[index].contentController,
                                        onChanged: (v){
                                          speech?[index].content = v;
                                        },
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

  void insertMemo(Memo memo) async {
    final Database database = await widget.database!;
    await database
        .insert('memo', memo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace).then((value){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('메모를 생성하였습니다.')));
    });
  }
}
