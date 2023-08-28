import 'package:flutter/cupertino.dart';

class Folder {
  String name;
  FocusNode focusNode;
  TextEditingController controller;
  String dateTime = "";

  Folder(this.name, this.focusNode, this.controller, this.dateTime);

}