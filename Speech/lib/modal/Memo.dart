
import 'package:flutter/cupertino.dart';
import 'package:speech/modal/Speech.dart';

class Memo {
  int? id;
  String? title;
  String folderName;
  List<Speech>? content;
  String dateTime;

  Memo(this.id,this.title,this.folderName, this.content, this.dateTime);

  Map<String, dynamic> toMap(){
    Map<String, dynamic> sp = {};

    for(int i=0; i<content!.length; i++){
      sp.addAll(content![i].toMap());
    }

    return{
      'id' : id,
      'title' : title,
      'folderName' : folderName,
      'content' : sp,
      'dateTime': dateTime
    };
  }

}