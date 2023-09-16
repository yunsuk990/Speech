import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../modal/Folder.dart';
import '../modal/Memo.dart';

class FolderPage extends StatefulWidget {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  FolderPage(this._database, this.reference);

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  late Folder folder;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    folder = ModalRoute.of(context)!.settings.arguments as Folder;

    
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
                    .pushNamed('/memo', arguments: folder.name);
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
                child: StreamBuilder(
                    stream: widget.reference
                        ?.child("memo")
                        .orderByChild("folderName")
                        .equalTo(folder.name)
                        .onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data?.snapshot.children.length,
                            padding: EdgeInsets.only(top: 10),
                            itemBuilder: (BuildContext context, int index) {
                              List<Memo> memoList = List.empty(growable: true);
                              for (final child
                                  in snapshot.data!.snapshot.children) {
                                memoList.add(Memo.fromSnapshot(child));
                              }
                              DateTime date = DateTime.parse(memoList[index].dateTime);
                              String currentTime = DateFormat('yyyy-MM-dd').format(date);
                              return Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: ListTile(
                                      leading: Text('${memoList[index].title}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      title: Text(
                                          memoList[index].speech.isNotEmpty ? "${memoList[index].speech?.keys.elementAt(0)}": "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300),
                                        maxLines: 1,
                                      ),
                                      trailing:
                                          Text(currentTime),
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed('/memoUpdate',
                                                arguments: memoList[index]);
                                      },
                                      onLongPress: () {
                                        deleteMemo(
                                            memoList[index], widget.reference);
                                      },
                                    ),
                                  ));
                            });
                      } else {
                        return Container();
                      }
                    }))
          ],
        ),
      )),
    );
  }

  void deleteMemo(Memo memo, DatabaseReference? reference) async {
    await reference?.child("memo").child(memo.id!).remove().then((_) {
      print(memo.id!);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('메모를 삭제하였습니다.')));
    });
  }
}
