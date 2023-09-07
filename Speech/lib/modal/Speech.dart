import 'package:flutter/cupertino.dart';

class Speech{
  String? title;
  String? content;
  TextEditingController? titleController;
  TextEditingController? contentController;

  Speech(this.title, this.content,this.titleController, this.contentController);

  Map<String, String?> toMap(){
    return{
      'title' : title,
      'content' : content,
    };
  }


}