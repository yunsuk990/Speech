import 'package:flutter/cupertino.dart';

class FirstPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState()  => _firstPage();
}

class _firstPage extends State<FirstPage>{
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Speech', style: TextStyle(fontSize: 20),),
      ),
      child: Container(
        child: Center(
          child: Row(children: <Widget>[CupertinoButton(child: Icon(CupertinoIcons.add), onPressed: (){

          })],),
        )
      )
    );
  }
}