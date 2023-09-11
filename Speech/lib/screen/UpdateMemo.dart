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
  List<Speech>? speech = List.empty(growable: true);
  List<dynamic?>? speechTitle = List.empty(growable: true);
  List<dynamic?>? speechContent = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // if(memo.speechTitle != null){
    //   for(int i=0; i<memo.speechContent!.length; i++){
    //     speech?.add(Speech(memo.speechTitle?[i], memo.speechContent?[i], TextEditingController(text: memo.speechTitle?[i]), TextEditingController(text: memo.speechContent?[i])));
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    memo = ModalRoute.of(context)!.settings.arguments as Memo;
    titleController = TextEditingController(text: memo.title);
    controller = TextEditingController();
    speech = getMemo(widget.reference) as List<Speech>?;

    return Scaffold(
      appBar: AppBar(
        title: Text("메모"),
        actions: [
          TextButton(
              onPressed: () {
                DateTime now = DateTime.now();
                String currentTime = DateFormat('yyyy-MM-dd').format(now);
                setState(() {
                  for (Speech item in speech!) {
                    speechTitle?.add(item.title);
                    speechContent?.add(item.content);
                  }
                });
                memo.dateTime = currentTime;
                updateMemo(memo, widget.reference);
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
                    child: FutureBuilder(builder: builder)
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

  Future<List<Speech>?> getMemo(DatabaseReference? reference) async{
    List<dynamic?>? title;
    List<dynamic?>? content;
    await reference?.child("memo").child(memo.id!).onValue.listen((event) {
      title = (event.snapshot.value as Map)['speechTitle'];
      content = (event.snapshot.value as Map)['speechContent'];
    });
    return List.generate(title!.length, (index){
      return Speech(title?[index], content?[index], TextEditingController(), TextEditingController());
    });
  }

  void updateMemo(Memo memo, DatabaseReference? reference) async {
    Map<String, dynamic> updateMap = Map();
    updateMap["title"] = titleController!.value.text.toString();
    updateMap["speechContent"] = speechContent;
    updateMap["speechTitle"] = speechTitle;
    updateMap["dateTime"] = memo.dateTime;
    reference?.child("memo").child(memo.id!).update(updateMap).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("메모를 수정하였습니다.")));
    });
  }
}
