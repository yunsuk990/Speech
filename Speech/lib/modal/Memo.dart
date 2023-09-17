
import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:speech/modal/Speech.dart';

class Memo {
  String? id;
  String? title;
  String folderName;
  List<dynamic> speech = List.empty(growable: true);
  String dateTime;

  Memo(this.id,this.title,this.folderName, this.speech, this.dateTime);

  Map<String, dynamic> toMap(){
    List<Object> list = List.empty(growable: true);
    for(Speech item in speech){
      list.add((item.toMap()));
    }

    return{
      'id' : id,
      'title' : title,
      'folderName' : folderName,
      'speech' : list,
      'dateTime': dateTime
    };
  }

  Memo.fromSnapshot(DataSnapshot snapshot):
        id = snapshot.key,
        title = (snapshot.value as Map)['title'],
        folderName = (snapshot.value as Map)['folderName'],
        dateTime = (snapshot.value as Map)['dateTime']
  {
    List<dynamic> list = List.empty(growable: true);
    for(final item in (snapshot.value as Map)['speech']){
      list.add(Speech(item["title"], item["content"], TextEditingController(text: item["title"]), TextEditingController(text: item["content"])));
    }
    speech = list;
  }

}