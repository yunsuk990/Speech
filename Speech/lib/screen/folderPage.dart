import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';

import '../modal/Memo.dart';

class FolderPage extends StatefulWidget {
  final Future<Database> database;
  FolderPage(this.database);

  @override
  State<FolderPage> createState() => _FolderPageState();
}


class _FolderPageState extends State<FolderPage> {

  Future<List<Memo>>? memoList;

  @override
  void initState() {
    memoList = getMemoList();
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
        title: Text(folderName),
        leadingWidth: 120,
        leading: Row(children: <Widget>[
            BackButton(),
            Text('폴더', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
          ]),
        actions: <Widget>[
          CupertinoButton(child: Image.asset('images/edit.png', color: Colors.white), onPressed: (){
            Navigator.of(context).pushNamed('/memo', arguments: folderName).then((_){
              setState(() {
                memoList = getMemoList();
              });
            });
          })
        ],
      ),

      body: Container(
        child: Center(
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
                        padding: EdgeInsets.only(bottom: 80),
                        itemBuilder: (BuildContext context, int index) {
                          List<Memo> folderList = snapshot.data as List<Memo>;
                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: ListTile(
                                title: Text('folderList[index].title'),
                                subtitle:Text(folderList[index].content.toString()),
                                trailing: Text(folderList[index].dateTime),
                                onTap: (){},
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
      )

    );
  }

  Future<List<Memo>> getMemoList() async {
    final Database database = await widget.database!;
    final List<Map<String, dynamic>> maps = await database.query('memo');
    return List.generate(maps.length, (index){
      return Memo(maps[index]['id'],maps[index]['folderName'], maps[index]['content'], maps[index]['dateTime']);
    });
  }

  void deleteMemo(Memo memo) async {
    final Database database = await widget.database!;
    await database.delete('memo',
        where: 'id=?', whereArgs: [memo.id]).then((value){
      setState(() {
        memoList = getMemoList();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('메모를 삭제하였습니다.')));
    });
  }
}

class Argument{
  String folderName;
  String id;

  Argument(this.folderName, this.id);
}
