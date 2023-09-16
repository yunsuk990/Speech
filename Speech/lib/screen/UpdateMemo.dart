import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:speech/modal/Speech.dart';
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
  List<Speech>? speech = List.empty(growable: true);
  Map<String, dynamic> map = Map();
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    memo = ModalRoute.of(context)!.settings.arguments as Memo;
    map = memo.speech;
    if(map.isNotEmpty){
      for(int i=0; i<map.length; i++){
        speech?.add(Speech(map.keys.elementAt(i), map.values.elementAt(i), TextEditingController(text: map.keys.elementAt(i)), TextEditingController(text: map.values.elementAt(i))));
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    titleController = TextEditingController(text: memo.title);
    controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text("메모"),
        actions: [
          TextButton(
              onPressed: () {
                DateTime now = DateTime.now();
                String currentTime = DateFormat('yyyy-MM-dd').format(now);
                memo.dateTime = currentTime;
                updateMemo(widget.reference);
                Navigator.of(context).pop();
              },
              child: Text('완료',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)))
        ],
      ),
      body: Column(children: <Widget>[
        Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Container(
            width: width,
            height: height * 0.78,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(children: <Widget>[
                TextField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: 'Title'),
                    scrollPadding: EdgeInsets.all(20),
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 30,
                ),
                CupertinoButton(
                    child: Text('면접 질문 추가'),
                    color: Colors.lightBlue,
                    padding: EdgeInsets.only(left: width / 3, right: width / 3),
                    onPressed: () {
                      setState(() {
                        speech?.add(Speech(null, null, TextEditingController(),
                            TextEditingController()));
                      });
                    }),
                SizedBox(
                  height: 20,
                ),
                Container(
                    width: width,
                    height: height * 0.6,
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
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "면접 질문을 작성해주세요.",
                                  contentPadding: EdgeInsets.only(top: 20, left: 5, bottom: 15, right: 5),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Icon(CupertinoIcons.checkmark_alt, color: Colors.black,)),
                                  suffixIcon: IconButton(onPressed: (){
                                    setState(() {
                                      speech?.removeAt(index);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('삭제하였습니다')));
                                  }, icon: Icon(CupertinoIcons.delete, color: CupertinoColors.systemRed))
                                ),
                                controller: speech?[index].titleController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.black),
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Colors.black),
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                hintText: '질문에 대한 답을 작성해주세요.',
                              ),
                              // padding: EdgeInsets.only(top: 10, left: 15, bottom: 10),
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              minLines: 2,
                              controller: speech?[index].contentController,
                            ),
                          ],
                        );

                      },itemCount: speech!.length, separatorBuilder: (BuildContext context, int index) { return Divider(); },),)
              ]),
            ),
          ),
        ]),
        Padding(
          padding: EdgeInsets.only(left: 20, bottom: 20, right: 20),
          child: Row(
            children: <Widget>[
              MaterialButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                color: Colors.lightBlue,
                padding:
                    EdgeInsets.only(left: 45, right: 45, top: 15, bottom: 15),
                child: Text(
                  '면접 시작하기',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(child: Container()),
              MaterialButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  color: Colors.grey,
                  padding:
                      EdgeInsets.only(left: 45, right: 45, top: 15, bottom: 15),
                  child: Text(
                    '면접 설정하기',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        )
      ]),
    );
  }

  // void updateMemo(Memo memo) async {
  //   final Database database = await widget.database!;
  //   await database
  //       .update('memo', memo.toMap(), where: 'id=?', whereArgs: [memo.id]).then((value){
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('메모를 수정하였습니다.')));
  //   });
  // }

  // Future<List<Speech>?> getMemo(DatabaseReference? reference) async{
  //   List<dynamic?>? title;
  //   List<dynamic?>? content;
  //   await reference?.child("memo").child(memo.id!).onValue.listen((event) {
  //     title = (event.snapshot.value as Map)['speechTitle'];
  //     content = (event.snapshot.value as Map)['speechContent'];
  //   });
  //   return List.generate(title!.length, (index){
  //     return Speech(title?[index], content?[index], TextEditingController(), TextEditingController());
  //   });
  // }

  void updateMemo(DatabaseReference? reference) async {
    Map<String, dynamic> map = Map();
    try{
      for(int i=0; i<speech!.length; i++){
        map[speech![i].titleController!.value.text] = speech![i].contentController?.value.text;
      }
      Map<String, dynamic> updateMap = Map();
      updateMap["title"] = titleController!.value.text.toString();
      updateMap["speech"] = jsonEncode(map);
      updateMap["dateTime"] = memo.dateTime;
      reference?.child("memo").child(memo.id!).update(updateMap).then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("메모를 수정하였습니다.")));
      });
    }catch(e){

    }
    // showCupertinoDialog(context: context, builder: (context) {
    //   return CupertinoAlertDialog(
    //     title: Text("asdfasf"),
    //     content: Text("asdfadf"),
    //     actions: [
    //       CupertinoDialogAction(isDefaultAction: true, child: Text("확인"), onPressed: () {
    //         Navigator.pop(context);
    //       })
    //     ],
    //   );
    // });
  }
}
