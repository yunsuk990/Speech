import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../modal/Folder.dart';

class FirstPage extends StatefulWidget{
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  FirstPage(this._database, this.reference);

  @override
  State<StatefulWidget> createState()  => _firstPage();
}

class _firstPage extends State<FirstPage>{

  List<Folder>? list = List.empty(growable: true);
  List<String>? items = List.empty(growable: true);
  bool canTap = false;

  @override
  void initState() {
    super.initState();
    getFolderList(widget.reference);
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
                  FocusScope.of(context).unfocus();
                  items = List.generate(list!.length, (index){
                    return list![index].name;
                  });
                  int index = 0;
                  for(int i=0;i<items!.length; i++){
                    if(items!.contains("무제폴더${i+1}")){
                      index = i+2;
                    }
                  }
                  if(index == 0){
                    if(items!.contains('무제폴더')){
                      Folder folder = Folder(null,"무제폴더1",null, null, DateTime.now().toIso8601String());
                      folder.id = folder.hashCode.toString();
                      insertFolder(folder, widget.reference);
                    }else{
                      Folder folder = Folder(null,"무제폴더",null, null, DateTime.now().toIso8601String());
                      folder.id = folder.hashCode.toString();
                      insertFolder(folder, widget.reference);
                    }
                  }else{
                    Folder folder = Folder(null,"무제폴더${index}",null, null, DateTime.now().toIso8601String());
                    folder.id = folder.hashCode.toString();
                    insertFolder(folder, widget.reference);
                  }
                })
          ],
        ),

        body: GestureDetector(
            child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 30, left: 15, right: 15),
                          child: Container(
                              width: width,
                              height: height - 240,
                              child: GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                                  itemCount: list?.length,
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
                                                  deleteFolder(list![index], widget.reference);
                                                  // deleteMemos(folderList[index]);
                                                  Navigator.of(context).pop();
                                                });},
                                                trailingIcon: CupertinoIcons.delete,),
                                              CupertinoContextMenuAction(
                                                child: Text('이름 변경'),
                                                isDefaultAction: true,
                                                onPressed: () {
                                                  list?[index].focusNode?.requestFocus();
                                                  Navigator.pop(context);},
                                                trailingIcon: CupertinoIcons.pencil,),
                                            ],
                                            child: CupertinoButton(onPressed: () {
                                              Navigator.of(context,).pushNamed('/folder', arguments: list?[index]);
                                            }, child: Icon(CupertinoIcons.folder_fill, size: 90),padding: EdgeInsets.zero,
                                            ),
                                          ),
                                          TextField(
                                              style: TextStyle(color: Colors.black),
                                              decoration: null,
                                              keyboardType: TextInputType.text,
                                              focusNode: list?[index].focusNode,
                                              textAlign: TextAlign.center,
                                              controller: list?[index].controller,
                                              // onChanged: (value){
                                              //   updateFolder(list![index], value, widget.reference);
                                              // },
                                              onTapOutside: (v){
                                                updateFolder(list![index], list![index].controller!.value.text, widget.reference);
                                              },
                                          ),
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

  void insertFolder(Folder folder, DatabaseReference? reference) {
    reference?.child("yunsuk990").child(folder.id!).set(folder.toJson())
        .then((_){
          print("success");
          FocusScope.of(context).requestFocus(list?[list!.length-1].focusNode);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('폴더를 생성하였습니다.')));
        })
        .catchError((error){
          print("fail");
    });
  }
  //
  void getFolderList(DatabaseReference? reference) {
    reference?.child("yunsuk990").onValue.listen((event) {
      if(event.snapshot != null){
        list?.clear();
        setState(() {
          for(final child in event.snapshot.children){
            list?.add(Folder.fromSnapshot(child));
          };
          list?.sort((a,b) => a.name.compareTo(b.name));
        });
      }
    });
  }
  //
  void deleteFolder(Folder folder, DatabaseReference? reference) {
    reference?.child("yunsuk990").child(folder.id!).remove().then((value){
      setState(() {
        getFolderList(reference);
      });
    });
  }
  //
  // void deleteMemos(Folder folder) async {
  //   final Database database = await widget.database!;
  //   await database.delete('folder',
  //       where: 'name=?', whereArgs: [folder.name]).then((value){
  //     setState(() {
  //       list = getFolderList();
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('폴더를 삭제하였습니다.')));
  //   });
  // }

  void updateFolder(Folder folder, String name, DatabaseReference? reference) {
    Map<String,String> map = Map();
    map['name'] = name;
    reference?.child("yunsuk990").child(folder.id!).update(map);
    FocusScope.of(context).unfocus();
  }
}