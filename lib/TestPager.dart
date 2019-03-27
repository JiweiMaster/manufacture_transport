import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

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
    getVersion();
    return new MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("标题"),),
        body: Text("hahha"),
      ),
    );
  }

  Future<void> getVersion() async {
    String updateUrl = "http://106.14.14.212:8002/apk?format=json";
//    String updateUrl = "http://www.baidu.com";
    var dio = new Dio();
    Response response = await dio.get(updateUrl);
    print(response.data);
  }
}

