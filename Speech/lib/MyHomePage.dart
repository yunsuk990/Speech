import 'package:flutter/cupertino.dart';
import 'FirstPage.dart';

class MyHomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _myHomePage();

}

class _myHomePage extends State<MyHomePage> {

  CupertinoTabBar? tabBar;

  @override
  void initState() {
    super.initState();
    tabBar = CupertinoTabBar(items: <BottomNavigationBarItem>[
      BottomNavigationBarItem(icon: Icon(CupertinoIcons.home)),
      BottomNavigationBarItem(icon: Icon(CupertinoIcons.list_bullet))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(tabBar: tabBar!, tabBuilder: (context, value){
      if(value ==0){
        return FirstPage();
      }else{
        return Container(
          child: Text('tab2'),
        );
      }
    });
  }
}