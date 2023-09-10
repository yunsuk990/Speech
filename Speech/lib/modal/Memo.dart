
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:speech/modal/Speech.dart';

class Memo {
  String? id;
  String? title;
  String folderName;
  List<String?>? speechTitle;
  List<String?>? speechContent;
  String dateTime;

  Memo(this.id,this.title,this.folderName, this.speechTitle, this.speechContent, this.dateTime);

  Map<String, dynamic> toMap(){
    return{
      'id' : id,
      'title' : title,
      'folderName' : folderName,
      'speechTitle' : speechTitle,
      'speechContent' : speechContent,
      'dateTime': dateTime
    };
  }

  Memo.fromSnapshot(DataSnapshot snapshot):
        id = snapshot.key,
        title = (snapshot.value as Map)['title'],
        folderName = (snapshot.value as Map)['folderName'],
        // speechTitle = (snapshot.value as Map)['speechTitle'],
        // speechContent = (snapshot.value as Map)['speechContent'],
        dateTime = (snapshot.value as Map)['dateTime'];

}