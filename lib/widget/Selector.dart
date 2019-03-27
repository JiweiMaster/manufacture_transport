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
      child:new Text('邮政'),
      value: '2',
    );
    DropdownMenuItem dropdownMenuItem3=new DropdownMenuItem(
      child:new Text('宅急送'),
      value: '3',
    );
    DropdownMenuItem dropdownMenuItem4=new DropdownMenuItem(
      child:new Text('世捷物流'),
      value: '4',
    );
    DropdownMenuItem dropdownMenuItem5=new DropdownMenuItem(
      child:new Text('天恒'),
      value: '5',
    );
    items.add(dropdownMenuItem0);
    items.add(dropdownMenuItem1);
    items.add(dropdownMenuItem2);
    items.add(dropdownMenuItem3);
    items.add(dropdownMenuItem4);
    items.add(dropdownMenuItem5);
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
          });
          String fycompany;
          if(value == '0'){
            fycompany = "";
          }else if(value == '1'){
            fycompany = "顺丰";
          }else if(value =='2'){
            fycompany = "邮政";
          }else if(value == '3'){
            fycompany = "宅急送";
          }else if(value == '4'){
            fycompany = "世捷物流";
          }else if(value == '5'){
            fycompany = "天恒";
          }
          _streamController.sink.add(List<FyInfoListItem>());
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
    String url = NetApi.GET_FYINFO_BY_TRANSPORTCOMPANY+"?fycompany="+fycompany;
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
    _streamController.sink.add(list);
  }

}