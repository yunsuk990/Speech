import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'modal/Folder.dart';

class FirstPage extends StatefulWidget{
  final Future<Database> database;
  FirstPage(this.database);

  @override
  State<StatefulWidget> createState()  => _firstPage();
}

class _firstPage extends State<FirstPage>{

  late Future<List<Folder>?> list;
  bool newFolder = false;

  @override
  void initState() {
    super.initState();
    list = getFolderList();
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
                onPressed: () async {
                  List<String>? items = await list.then((value){
                    return List.generate(value!.length, (index){
                      return value[index].name;
                    });
                  });
                  int index = 0;
                  for(int i=0;i<items!.length; i++){
                    if(items.contains("무제폴더${i+1}")){
                      index = i+2;
                    }
                  }
                  if(index == 0){
                    if(items.contains('무제폴더')){
                      FocusNode focusNode = FocusNode();
                      insertFolder(Folder("무제폴더1",focusNode, TextEditingController(text: "무제폴더${index}"), DateTime.now().toIso8601String()));
                      FocusScope.of(context).requestFocus(focusNode);
                    }else{
                      FocusNode focusNode = FocusNode();
                      insertFolder(Folder("무제폴더",focusNode, TextEditingController(text: "무제폴더${index}"), DateTime.now().toIso8601String()));
                      FocusScope.of(context).requestFocus(focusNode);
                    }
                  }else{
                    FocusNode focusNode = FocusNode();
                    insertFolder(Folder("무제폴더${index}",focusNode, TextEditingController(text: "무제폴더${index}"), DateTime.now().toIso8601String()));
                    WidgetsBinding.instance.addPostFrameCallback((_){
                      FocusScope.of(context).requestFocus(focusNode);
                    });
                  }
                  newFolder = true;
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
                              child: FutureBuilder(
                                builder: (context, snapshot){
                                  switch(snapshot.connectionState){
                                    case ConnectionState.none:
                                      return CupertinoActivityIndicator();
                                    case ConnectionState.waiting:
                                      return CupertinoActivityIndicator();
                                    case ConnectionState.active:
                                      return CupertinoActivityIndicator();
                                    case ConnectionState.done:
                                      if(snapshot.hasData){
                                        return GridView.builder(
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3),
                                            itemCount: (snapshot.data! as List<Folder>).length,
                                            padding: EdgeInsets.only(bottom: 80),
                                            itemBuilder: (BuildContext context, int index) {
                                              List<Folder> folderList = snapshot.data as List<Folder>;

                                              return Container(
                                                child:  Column(
                                                  children: <Widget>[
                                                    CupertinoContextMenu(
                                                      actions: <Widget>[
                                                        CupertinoContextMenuAction(
                                                          child: Text('삭제'),
                                                          isDestructiveAction: true,
                                                          onPressed: () { setState(() {
                                                            deleteFolder(folderList[index]);
                                                            deleteMemos(folderList[index]);
                                                            Navigator.of(context).pop();
                                                          });},
                                                          trailingIcon: CupertinoIcons.delete,),
                                                        CupertinoContextMenuAction(
                                                          child: Text('이름 변경'),
                                                          isDefaultAction: true,
                                                          onPressed: () {
                                                            folderList![index].focusNode!.requestFocus();
                                                            Navigator.pop(context);},
                                                          trailingIcon: CupertinoIcons.pencil,),
                                                      ],
                                                      child: CupertinoButton(onPressed: () {
                                                        Navigator.of(context,).pushNamed('/folder', arguments: folderList![index].name);
                                                      }, child: Icon(CupertinoIcons.folder_fill, size: 90),padding: EdgeInsets.zero,
                                                      ),
                                                    ),
                                                    TextField(
                                                        style: TextStyle(color: Colors.black),
                                                        autofocus: false,
                                                        decoration: null,
                                                        keyboardType: TextInputType.text,
                                                        focusNode: folderList![index].focusNode,
                                                        textAlign: TextAlign.center,
                                                        controller: folderList![index].controller,
                                                        onSubmitted: (text){
                                                          print(folderList![index].name);
                                                          updateFolder(folderList![index], text);
                                                        }
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                        );
                                      }else{
                                        return Center(
                                          child: Text('No Data'),
                                        );
                                      }
                                  }
                                },
                                future: list,
                              )
                          )
                      )
                    ]
                )
            )
                ,onTap: (){
                    FocusScope.of(context).unfocus();
                    newFolder = false;
              },
        )


    );
  }

  void insertFolder(Folder folder) async {
    final Database database = await widget.database!;
    await database
        .insert('folder', folder.toMap(), conflictAlgorithm: ConflictAlgorithm.fail).then((value){
          setState(() {
            list = getFolderList();
          });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('폴더를 생성하였습니다.')));
    });
  }

  Future<List<Folder>> getFolderList() async {
    final Database database = await widget.database!;
    final List<Map<String, dynamic>> maps = await database.query('folder');
    return List.generate(maps.length, (index){
      return Folder(maps[index]['name'], FocusNode(), TextEditingController(text: maps[index]['name']), DateTime.now().toIso8601String());
    });
  }

  void deleteFolder(Folder folder) async {
    final Database database = await widget.database!;
    await database.delete('memo',
        where: 'folderName=?', whereArgs: [folder.name]).then((value){
      setState(() {
        list = getFolderList();
      });
    });
  }

  void deleteMemos(Folder folder) async {
    final Database database = await widget.database!;
    await database.delete('folder',
        where: 'name=?', whereArgs: [folder.name]).then((value){
      setState(() {
        list = getFolderList();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('폴더를 삭제하였습니다.')));
    });
  }

  void updateFolder(Folder folder, String name) async {
    final Database database = await widget.database;
    await database.update('folder',
    {
      'name' : name,
      'dateTime' : folder.dateTime
    },
    where: 'name = ?', whereArgs: [folder.name]).then((value){
      setState(() {
        list = getFolderList();
      });
    });
  }
}