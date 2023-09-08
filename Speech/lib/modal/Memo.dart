
import 'package:flutter/cupertino.dart';
import 'package:speech/modal/Speech.dart';

class Memo {
  int? id;
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

}