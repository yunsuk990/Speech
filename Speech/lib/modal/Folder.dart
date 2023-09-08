import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class Folder {
  String name;
  FocusNode? focusNode;
  TextEditingController? controller;
  String dateTime = "";

  Folder(this.name, this.focusNode, this.controller, this.dateTime);

  Folder.fromJson(Map data): name = data['contentid'], dateTime = data['dateTime'];

  Folder.fromSnapshot(DataSnapshot snapshot):
        name = (snapshot.value as Map)['name'],
        focusNode = FocusNode(),
        controller = TextEditingController(text: (snapshot.value as Map)['name']),
        dateTime = (snapshot.value as Map)['dateTime'];

  toJson() {
    return {
      'name': name,
      'dateTime': dateTime,
    };
  }

  Map<String, dynamic> toMap(){
    return{
      'name' : name,
      'dateTime': dateTime
    };
  }


}