import 'package:flutter/material.dart';
//承运商任务看板

class TransportCompanyBoard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Scaffold(
        appBar: AppBar(title: Text("承运商任务看板"),),
        body: Container(
          child: Text("承运商任务看板"),
        ),
      ),
    );
  }
}


