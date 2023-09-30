import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  final FlutterTts tts = FlutterTts();
  TextEditingController? titleController;
  late Memo memo;
  List<dynamic> map = List.empty(growable: true);

  _UpdateMemoPage(){
    setting();
  }
  @override
  void initState() {
    map.clear();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      memo = ModalRoute.of(context)!.settings.arguments as Memo;
      map = memo.speech;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    titleController = TextEditingController(text: memo.title);

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              child: Text('저장',
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
                        map?.add(Speech(null, null, TextEditingController(),
                            TextEditingController()));
                      });
                    }),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                    child:  ListView.separated(
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index){
                        print("speech_length: ${map!.length}");
                        print("index: ${index}");
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
                                  contentPadding: EdgeInsets.only(top: 20, left: 7,bottom: 15, right: 5),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      IconButton(onPressed: () {
                                        _speak(map[index].title);
                                      }, icon: Icon(CupertinoIcons.mic, color: CupertinoColors.black,), visualDensity: VisualDensity(horizontal: -4), constraints: BoxConstraints(),padding: EdgeInsets.only(right: 5),),
                                      IconButton(onPressed: (){
                                        setState(() {
                                          map?.removeAt(index);
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('삭제하였습니다')));
                                      }, icon: Icon(CupertinoIcons.delete, color: CupertinoColors.systemRed), visualDensity: VisualDensity(horizontal: -4), constraints: BoxConstraints(), padding: EdgeInsets.only(right: 8),)
                                    ],
                                  )
                                ),
                                onChanged: (v){
                                  map[index].title = v;
                                },
                                controller: map?[index].titleController,
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
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              minLines: 2,
                              onChanged: (v){
                                map[index].content = v;
                              },
                              controller: map?[index].contentController,
                            ),
                            SizedBox(height: 8),
                          ],
                        );
                      },itemCount: map!.length, separatorBuilder: (BuildContext context, int index) { return Divider(thickness: 2,); },),)
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
                EdgeInsets.only(left: width*0.08, right: width*0.08, top: 15, bottom: 15),
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
                  EdgeInsets.only(left: width*0.08, right: width*0.08, top: 15, bottom: 15),
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

  void updateMemo(DatabaseReference? reference) async {

    try{
      print("update");
      List<Object> list = List.empty(growable: true);
      for(Speech item in map){
        list.add((item.toMap()));
      }

      Map<String, dynamic> updateMap = Map();
      updateMap["title"] = titleController!.value.text.toString();
      updateMap["speech"] = list;
      updateMap["dateTime"] = memo.dateTime;
      reference?.child("memo").child(memo.id!).update(updateMap).then((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("메모를 수정하였습니다.")));
      });
    }catch(e){
      print(e);
    }
  }

  Future _speak(String text) async{
    var result = await tts.speak(text);
  }

  Future<void> setting() async {
    await tts.setSharedInstance(true);
    await tts.setIosAudioCategory(IosTextToSpeechAudioCategory.ambient,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers
        ],
        IosTextToSpeechAudioMode.voicePrompt
    );
    await tts.setLanguage('kor');
    await tts.setSpeechRate(0.4);
  }
}
