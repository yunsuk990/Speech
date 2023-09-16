
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:speech/modal/Speech.dart';

class Memo {
  String? id;
  String? title;
  String folderName;
  Map<String, dynamic> speech = Map();
  String dateTime;

  Memo(this.id,this.title,this.folderName, this.speech, this.dateTime);

  Map<String, dynamic> toMap(){
    return{
      'id' : id,
      'title' : title,
      'folderName' : folderName,
      'speech' : jsonEncode(speech),
      'dateTime': dateTime
    };
  }

  Memo.fromSnapshot(DataSnapshot snapshot):
        id = snapshot.key,
        title = (snapshot.value as Map)['title'],
        folderName = (snapshot.value as Map)['folderName'],
        speech = jsonDecode((snapshot.value as Map)['speech']),
        dateTime = (snapshot.value as Map)['dateTime']{
  }

}