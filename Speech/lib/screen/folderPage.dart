import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FolderPage extends StatefulWidget {
  @override
  State<FolderPage> createState() => _FolderPageState();
}


class _FolderPageState extends State<FolderPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(ModalRoute.of(context)!.settings.arguments as String),
        leadingWidth: 120,
        leading: Row(children: <Widget>[
            BackButton(),
            Text('폴더', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
          ]),
        actions: <Widget>[
          CupertinoButton(child: Image.asset('images/edit.png', color: Colors.white), onPressed: (){
            Navigator.of(context).pushNamed('/memo');
          })
        ],
      ),

      body: Container()

    );
  }
}
