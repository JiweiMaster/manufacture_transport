import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:manufacture_transport/model/FyInfoListItem.dart';
import 'package:manufacture_transport/model/MyUtil.dart';
import 'package:manufacture_transport/model/NetApi.dart';
import 'package:manufacture_transport/updateApp.dart';
import 'package:manufacture_transport/widget/FYListView.dart';
import 'package:manufacture_transport/widget/Selector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  bool ifRequestEver = false;

  @override
  void initState() {
    _streamController.sink.add(List<FyInfoListItem>());
    getFYInfoByTransportCompany("");
    super.initState();
  }
  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    //更新app的函数
    if(ifRequestEver == false){
//      UpdateApp.getVersion(context);
      ifRequestEver = true;
    }

    return new Material(
      child: new Scaffold(
        appBar: AppBar(
          title: Text("出库拣配"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.computer), onPressed: (){
              clearLogin();
            })
          ],
        ),
        body: _showList(_streamController)
      ),
    );
  }


  void clearLogin() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isFirstLogin", true);
    exitApp();
  }

  Future<void> exitApp() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

//初始化请求数据
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
    titleMap['shno']='发运号';
    titleMap['odno']='销售订单号';
    titleMap['pjnm']='项目名称';
    titleMap['scarr']='承运商';
    list.add(FyInfoListItem(titleMap));
    mapJosn.forEach((map) => {
    list.add(FyInfoListItem(map))
    });
    print(list);
    _streamController.sink.add(list);
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




