import 'package:flutter/material.dart';
import 'package:manufacture_transport/FYPage.dart';
import 'package:manufacture_transport/Login.dart';


class Root extends StatefulWidget{
  Root(this.isFirstLogin);
  final bool isFirstLogin;
  @override
  State<StatefulWidget> createState() {
    return RootState(isFirstLogin);
  }

}

class RootState extends State<Root>{
  RootState(this.isFirstLogin);
  final bool isFirstLogin;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: new Scaffold(
        body: isFirstLogin == true?Login():FYPage(),
      ),
    );
  }
}