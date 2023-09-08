import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';
import '../modal/Memo.dart';

class FolderPage extends StatefulWidget {
  // final Future<Database> database;

  FirebaseDatabase? _database;
  DatabaseReference? reference;
  FolderPage(this._database, this.reference);

  @override
  State<FolderPage> createState() => _FolderPageState();
}


class _FolderPageState extends State<FolderPage> {

  Future<List<Memo>>? memoList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    String folderName = ModalRoute.of(context)!.settings.arguments as String;
    // memoList = getMemoList(folderName);

    return Scaffold(
      appBar: AppBar(
        title: Text(folderName),

        leadingWidth: 120,
        leading: Row(children: <Widget>[
            IconButton(onPressed: (){
              Navigator.of(context).pop();
            }, icon: Icon(CupertinoIcons.back),
                constraints: BoxConstraints()),
            Text('폴더', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
          ]),
        actions: <Widget>[
          CupertinoButton(child: Image.asset('images/edit.png', color: Colors.white), onPressed: (){
            Navigator.of(context).pushNamed('/memo', arguments: folderName).then((_){
              setState(() {
                // memoList = getMemoList(folderName);
              });
            });
          })
        ],
      ),

      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                width: width,
                height: height*0.83,
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
                          return ListView.builder(
                              itemCount: (snapshot.data! as List<Memo>).length,
                              padding: EdgeInsets.only(top: 10),
                              itemBuilder: (BuildContext context, int index) {
                                List<Memo> folderList = snapshot.data as List<Memo>;
                                return Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: ListTile(
                                        leading: Text('${folderList[index].title}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                        title:Text("", style: TextStyle(fontWeight: FontWeight.w300), maxLines: 1,),
                                        trailing: Text('${folderList[index].dateTime}'),
                                        onTap: (){
                                          Navigator.of(context).pushNamed('/memoUpdate', arguments: folderList[index]).then((value){
                                            setState(() {
                                              // memoList = getMemoList(folderName);
                                            });
                                          });
                                        },
                                        onLongPress: (){
                                          // deleteMemo(folderList[index], folderList[index].folderName);
                                        },
                                      ),
                                    )
                                );
                              }
                          );
                        }else{
                          return Text('No Data');
                        }
                    }
                  },
                  future: memoList,
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  // Future<List<Memo>> getMemoList(String folderName) async {
  //   final Database database = await widget.database!;
  //   final List<Map<String, dynamic>> maps = await database.query('memo',
  //     where: 'folderName=?', whereArgs: [folderName]
  //   );
  //
  //   return List.generate(maps.length, (index){
  //     return Memo(maps[index]['id'],maps[index]['title'],maps[index]['folderName'], maps[index]['speechTitle'], maps[index]['speechContent'], maps[index]['dateTime']);
  //   });
  // }
  //
  // void deleteMemo(Memo memo, String folderName) async {
  //   final Database database = await widget.database!;
  //   await database.delete('memo',
  //       where: 'id=?', whereArgs: [memo.id]).then((value){
  //     setState(() {
  //       memoList = getMemoList(folderName);
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('메모를 삭제하였습니다.')));
  //   });
  // }
}