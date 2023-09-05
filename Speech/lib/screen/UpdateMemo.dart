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
                                      // showCupertinoDialog(context: context, builder: (BuildContext context){
                                      //   return CupertinoAlertDialog(
                                      //     title: Text('면접 질문 추가',),
                                      //     content: Padding(
                                      //       padding: EdgeInsets.only(top: 20),
                                      //       child: CupertinoTextField(
                                      //         padding: EdgeInsets.only(left: 50, right: 20),
                                      //         decoration: BoxDecoration(
                                      //           borderRadius: BorderRadius.circular(8),
                                      //           color: Colors.white
                                      //         ),
                                      //
                                      //       ),
                                      //     ),
                                      //     actions: <Widget>[
                                      //       CupertinoButton(child: Text('등록'), onPressed: (){}),
                                      //       CupertinoButton(child: Text('취소'), onPressed: (){
                                      //         Navigator.of(context).pop();
                                      //       }),
                                      //     ],
                                      //   );
                                      // });
                                      setState(() {
                                        items.add("면접 질문 입력하세요");
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
                                                  child: Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: CupertinoTextField(
                                                      decoration: BoxDecoration(\
                                                          border: InputBorder.none
                                                      ),
                                                      placeholder: "면접 질문을 작성해주세요.",
                                                      controller: TextEditingController(),
                                                      autofocus: true,
                                                    ),
                                                  )
                                              ),
                                              CupertinoTextField(
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black),
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                ),
                                                padding: EdgeInsets.all(10),
                                                placeholder: '질문에 대한 답을 작성해주세요.'


                                              ),
                                            ],
                                          );

                                        },itemCount: items.length, separatorBuilder: (BuildContext context, int index) { return Divider(); },),
                                    ),
    
                                    // Column(
                                    //   children: <Widget>[
                                        // ...items.map((e) => Column(
                                        //   children: <Widget>[
                                        //         Card(
                                        //             color: Colors.white60,
                                        //             shape: RoundedRectangleBorder(
                                        //               borderRadius: BorderRadius.all(Radius.circular(15)),
                                        //             ),
                                        //             elevation: 3,
                                        //             child: Padding(
                                        //               padding: EdgeInsets.all(5),
                                        //               child: TextField(
                                        //                 decoration: InputDecoration(
                                        //                     hintText: e.toString(),
                                        //                     border: InputBorder.none
                                        //                 ),
                                        //                 controller: TextEditingController(),
                                        //                 autofocus: true,
                                        //               ),
                                        //             )
                                        //         ),
                                        //         TextField(
                                        //           decoration: InputDecoration(
                                        //               hintText: "질문에 대한 답을 작성해주세요."
                                        //           ),
                                        //           maxLines: 10,
                                        //         )
                                        //
                                        //   ],
                                        // ))
                                    //   ],
                                    // ),
    
    
                                    // SingleChildScrollView(
                                    //   child: Container(
                                    //     width: width,
                                    //     height: height*0.5,
                                    //
                                    //     child: ListView.builder(itemCount: items.length ,itemBuilder: (BuildContext context, int index) {
                                    //       return Container(
                                    //         child: Text('${items[index]}'),
                                    //       );
                                    //     }),
                                    //   )
                                    // )
    
    
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
