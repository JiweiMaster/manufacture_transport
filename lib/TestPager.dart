import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:manufacture_transport/widget/SearchEditText.dart';
import 'package:manufacture_transport/widget/datePicker.dart';

void main() => runApp(TestPage());

class TestPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return TestPageState();
  }
}

class TestPageState extends State<TestPage>{

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("标题"),),
        body: new Container(
          child: new Column(
            children: <Widget>[
              new SearchEditText(),
            ],
          )
        ),
      ),
    );
  }
}

