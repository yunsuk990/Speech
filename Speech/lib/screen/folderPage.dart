import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../modal/Folder.dart';
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

  late Future<List<Memo>>? memoList;
  late Folder folder;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    folder = ModalRoute.of(context)!.settings.arguments as Folder;
    // memoList = getMemoList(folderName, widget.reference);

    return Scaffold(
      appBar: AppBar(
        title: Text(folder.name),
        leadingWidth: 120,
        leading: Row(children: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(CupertinoIcons.back),
              constraints: BoxConstraints()),
          Text('폴더',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
        ]),
        actions: <Widget>[
          CupertinoButton(
              child: Image.asset('images/edit.png', color: Colors.white),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/memo', arguments: folder.name)
                    .then((_) {
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
                height: height * 0.83,
                child: FutureBuilder(
                    future: widget.reference?.child("memo").orderByChild("folderName").equalTo(folder.name).once(),
                    builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return CupertinoActivityIndicator();
                    case ConnectionState.waiting:
                      return CupertinoActivityIndicator();
                    case ConnectionState.active:
                      return CupertinoActivityIndicator();
                    case ConnectionState.done:
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data?.snapshot.children.length,
                            padding: EdgeInsets.only(top: 10),
                            itemBuilder: (BuildContext context, int index) {
                              List<Memo> folderList = List.empty(growable: true);
                              for(final child in snapshot.data!.snapshot.children){
                                folderList.add(Memo.fromSnapshot(child));
                              }
                              return Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: ListTile(
                                      leading: Text(
                                          '${folderList[index].title}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      title: Text(
                                        "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300),
                                        maxLines: 1,
                                      ),
                                      trailing:
                                          Text('${folderList[index].dateTime}'),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed('/memoUpdate',
                                                arguments: folderList[index])
                                            .then((value) {
                                          setState(() {
                                            // memoList = getMemoList(folderName);
                                          });
                                        });
                                      },
                                      onLongPress: () {
                                        // deleteMemo(folderList[index], folderList[index].folderName);
                                      },
                                    ),
                                  ));
                            });
                      } else {
                        return Text('No Data');
                      }
                  }
                }))
          ],
        ),
      )),
    );
  }

  // Future<List<Memo>> getMemoList(String folderName, DatabaseReference? reference) async {
  //   reference?.child("memo").orderByChild(folderName).onValue.listen((event) {
  //       // List<Memo> list = List.empty(growable: true);
  //       // for (final child in event.snapshot.children) {
  //       //   list.add(Memo.fromSnapshot(child));
  //       // }
  //           return List.generate(event.snapshot.children.length, (index){
  //             return Memo.fromSnapshot(event.snapshot.children.elementAt(index));
  //       });
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
