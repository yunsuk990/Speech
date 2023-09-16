import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../modal/Memo.dart';

class ListPage extends StatefulWidget {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  ListPage(this._database, this.reference);
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("최근 작성한 메모"),
      ),
      body: Container(
        child: StreamBuilder(
            stream: widget.reference?.child("memo").orderByChild("dateTime").onValue,
            builder: (context, snapshot){
              if(snapshot.hasData){
                return ListView.builder(
                    itemCount: snapshot.data?.snapshot.children.length,
                    padding: EdgeInsets.only(top: 10),
                    itemBuilder: (BuildContext context, int index){
                      List<Memo>? memoList = List.empty(growable: true);
                      for(final child in snapshot.data!.snapshot.children){
                        memoList.add(Memo.fromSnapshot(child));
                      }
                      memoList.reversed;
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
              }else{
                return Center(
                  child: Text('No Data'),
                );
              }
            }
        ),
      ),
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
