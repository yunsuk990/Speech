import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'modal/Folder.dart';

class FirstPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState()  => _firstPage();
}

class _firstPage extends State<FirstPage>{

  List<Folder> list = new List.empty(growable: true);
  int index = -1;

  @override
  void initState() {
    super.initState();
    list.add(Folder("a",FocusNode(), TextEditingController(text: "a"),DateTime.now().toIso8601String()));
    list.add(Folder("b",FocusNode(), TextEditingController(text: "b"),DateTime.now().toIso8601String()));
    list.add(Folder("c",FocusNode(), TextEditingController(text: "c"),DateTime.now().toIso8601String()));
    list.add(Folder("d",FocusNode(), TextEditingController(text: "d"),DateTime.now().toIso8601String()));
    list.add(Folder("e",FocusNode(), TextEditingController(text: "e"),DateTime.now().toIso8601String()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    double width = size.width;
    double height = size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text('Speech', style: TextStyle(fontSize: 20)),
          actions: [
            CupertinoButton(
                child: Icon(
                    CupertinoIcons.folder_badge_plus, color: Colors.white,
                    size: 30),
                padding: EdgeInsets.only(right: 10),
                onPressed: () {
                  // showCupertinoDialog(context: context, builder: (context){
                  //   return CupertinoAlertDialog(
                  //     title: Text('폴더 제목'),
                  //     content: CupertinoTextField(),
                  //     actions: [
                  //       CupertinoButton(child: Text('확인'), onPressed: (){
                  //         Navigator.of(context).pop();
                  //       })
                  //     ],
                  //   );
                  // });
                  setState(() {
                    list.add(Folder("무제폴더",FocusNode(), TextEditingController(text: "무제폴더"), DateTime.now().toIso8601String()));
                    });
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    FocusScope.of(context).requestFocus(list[list.length-1].focusNode);
                  });
                })
          ],
        ),

        body: GestureDetector(
            child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Padding(
                      //     padding: EdgeInsets.only(top: 15, left: 15),
                      //     child: Text('폴더', style: TextStyle(color: CupertinoColors.black, fontSize: 40, fontWeight: FontWeight.bold)),),

                      Padding(
                          padding: EdgeInsets.only(top: 30, left: 15, right: 15),
                          child: Container(
                              width: width,
                              height: height - 240,
                              child: GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                                  itemCount: list.length,
                                  padding: EdgeInsets.only(bottom: 80),
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      child:  Column(
                                        children: <Widget>[
                                          CupertinoContextMenu(
                                              actions: <Widget>[
                                                CupertinoContextMenuAction(
                                                  child: Text('삭제'),
                                                  isDestructiveAction: true,
                                                  onPressed: () { setState(() {
                                                    list.removeAt(index);
                                                    Navigator.of(context).pop();
                                                  });},
                                                  trailingIcon: CupertinoIcons.delete,),
                                                CupertinoContextMenuAction(
                                                  child: Text('이름 변경'),
                                                  isDefaultAction: true,
                                                  onPressed: () {
                                                    this.index = index;
                                                    list[index].focusNode.requestFocus();
                                                    Navigator.pop(context);},
                                                  trailingIcon: CupertinoIcons.pencil,),
                                              ],
                                              child: CupertinoButton(onPressed: () {
                                                  Navigator.of(context,).pushNamed('/folder', arguments: list[index].name);
                                                }, child: Icon(CupertinoIcons.folder_fill, size: 90),padding: EdgeInsets.zero,
                                              ),

                                          ),
                                          TextField(
                                            style: TextStyle(color: Colors.black),
                                            autofocus: false,
                                            decoration: null,
                                            keyboardType: TextInputType.text,
                                            focusNode: list[index].focusNode,
                                            textAlign: TextAlign.center,
                                            controller: list[index].controller,
                                            onChanged: (text){
                                              list[index].name = text;
                                              list[index].controller = TextEditingController(text: text);
                                              print(list[index].name);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }
                              )
                          )
                      )
                    ]
                )
            )
                ,onTap: (){
                    FocusScope.of(context).unfocus();
              },
        )


    );
  }
}