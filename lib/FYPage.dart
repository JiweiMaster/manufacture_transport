import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manufacture_transport/model/FyInfoListItem.dart';
import 'package:manufacture_transport/model/NetApi.dart';
import 'package:manufacture_transport/widget/FYListView.dart';
import 'package:manufacture_transport/widget/Selector.dart';
/*
需要一个能够选择发运商和发运时间的select
显示的listview,显示的数据源来自于select的之后的网络请求
* */
class FYPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _FYPageState();
  }
}

class _FYPageState extends State<FYPage>{
  StreamController<List<FyInfoListItem>> _streamController = StreamController();
  StreamController<bool> _streamControllerLoading = StreamController();
  @override
  void initState() {
    // TODO: implement initState
    _streamControllerLoading.sink.add(false);
    getFYInfoByTransportCompany("");
    super.initState();
  }
  @override
  void dispose() {
    _streamController.close();
    _streamControllerLoading.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Scaffold(
        appBar: AppBar(title: Text("发运信息"),),
//        body: _showList(_streamController)
//        body: _showLoading(),
        body: StreamBuilder<bool>(
          stream: _streamControllerLoading.stream,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot){

              return snapshot.data == false ? _showLoading():_showList(_streamController);
            },
        ),
      ),
    );
  }

  Future<void> getFYInfoByTransportCompany(String fycompany) async{
    List<FyInfoListItem> list = new List();
    var httpClient = new HttpClient();
    print(fycompany);
    String url = NetApi.GET_FYINFO_BY_TRANSPORTCOMPANY+"?fycompany="+fycompany;
    print(url);
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    List mapJosn = json.decode(responseBody);
    Map titleMap = new Map();
    titleMap['SHNO']='发运号';
    titleMap['ODNO']='销售订单号';
    titleMap['PJNM']='项目名称';
    titleMap['SCARR']='承运商';
    list.add(FyInfoListItem(titleMap));
    mapJosn.forEach((map) => {
    list.add(FyInfoListItem(map))
    });
    print(list);
    _streamControllerLoading.sink.add(true);
  }
}


Widget _showList(_streamController){
  return new Column(
    children: <Widget>[
      new Container(
        margin: EdgeInsets.only(left: 10),
        child: new Row(
          children: <Widget>[
            Text("承运商："),
            Container(
              margin: EdgeInsets.only(left: 5),
              child: Selector(_streamController),
            )
          ],
        ),
        height: 50,
      ),
      new Expanded(
        child: FYListView(_streamController),
        flex: 1,
      )
    ],
  );
}

Widget _showLoading(){
  return Center(
    child: CupertinoActivityIndicator(
      radius: 20,
    ),
  );
}


