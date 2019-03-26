import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:manufacture_transport/model/FyInfoListItem.dart';
import 'package:manufacture_transport/model/NetApi.dart';

class Selector extends StatefulWidget{
  Selector(this._streamController);
  final StreamController<List<FyInfoListItem>> _streamController;
  @override
  State<StatefulWidget> createState() {
    return _SelectorState(_streamController);
  }
}

class _SelectorState extends State<Selector>{
  _SelectorState(this._streamController);
  final StreamController<List<FyInfoListItem>> _streamController;

  List<DropdownMenuItem> getListData(){
    List<DropdownMenuItem> items = new List();
    DropdownMenuItem dropdownMenuItem0=new DropdownMenuItem(
      child:new Text('所有承运商'),
      value: '0',
    );
    DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
      child:new Text('顺丰'),
      value: '1',
    );
    DropdownMenuItem dropdownMenuItem2=new DropdownMenuItem(
      child:new Text('江宁区邮政局'),
      value: '2',
    );
    DropdownMenuItem dropdownMenuItem3=new DropdownMenuItem(
      child:new Text('宅急送南京分公司'),
      value: '3',
    );
    items.add(dropdownMenuItem0);
    items.add(dropdownMenuItem1);
    items.add(dropdownMenuItem2);
    items.add(dropdownMenuItem3);
    return items;
  }
  var value;
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new DropdownButton(
        items: getListData(),
        hint: new Text("请选择"),
        value: value,
        onChanged: (T){
          setState(() {
            value = T;
            print(value);
          });
          String fycompany;
          print("value=>"+value);
          if(value == '0'){
            fycompany = "";
          }else if(value == '1'){
            fycompany = "顺丰";
          }else if(value =='2'){
            fycompany = "江宁区邮政局";
          }else if(value == '3'){
            fycompany = "宅急送南京分公司";
          }
          getFYInfoByTransportCompany(fycompany);
        },
        elevation: 24,//设置阴影的高度
        style: new TextStyle(//设置文本框里面文字的样式
            color: Colors.blue
        ),
        iconSize: 40.0,
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
    _streamController.sink.add(list);
  }

}