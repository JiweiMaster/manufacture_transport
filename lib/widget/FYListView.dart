import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manufacture_transport/ZXPage.dart';
import 'package:manufacture_transport/model/FyInfoListItem.dart';
import 'package:manufacture_transport/model/MyUtil.dart';

List<FyInfoListItem> fyInfoListItems = new List();
class FYListView extends StatefulWidget{
  FYListView(this._streamController);
  final StreamController<List<FyInfoListItem>> _streamController;
  @override
  State<StatefulWidget> createState() {
    return _FYListViewState(_streamController);
  }
}

class _FYListViewState extends State<FYListView>{
  _FYListViewState(this._streamController);
  final StreamController<List<FyInfoListItem>> _streamController;


  @override
  void initState() {

  }

  Widget _buildListView(List<FyInfoListItem> list) {
    return ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (BuildContext context, int position) {
          return _buildListViewItem(context, list, position);
        });
  }

  //进入下一个界面并且回去下一个界面返回的数据,
  // 如果返回的是FY单号，代表单号已经完成发运操作，将当前的发运单号置灰
  void enterZXPager(BuildContext context,fyInfoListItem ) async{
    String result = await Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) =>
          new ZXPage(fyInfoListItem:fyInfoListItem),));
    if(result != null){//如果返回的是实际的数据单，那么就会将原来的发运单号置成灰色
      for(FyInfoListItem data in fyInfoListItems){
        if(data.shno == result){
          data.isComplete = true;
//          ToastUtil.print(result.toString());
        }
      }
      List<FyInfoListItem> temp = new List();
      temp.addAll(fyInfoListItems);
      _streamController.sink.add(temp);
    }
  }

  Widget _buildListViewItem(BuildContext context, List<FyInfoListItem> list, int position) {
    if (list != null) {
      return GestureDetector(
          onTap: () {
            //跳转到下一个界面
//            Navigator.push(
//                context,
//                new MaterialPageRoute(
//                    builder: (context) =>
//                    new ZXPage(fyInfoListItem: list[position]),));
            enterZXPager(context,list[position]);
          },
          child: Container(
              height: 50,
              color: Color.fromARGB(255, 238, 238, 238),
              child: new Column(
                children: <Widget>[
                  new Container(
                    color: list[position].isComplete == true?Colors.grey:Color.fromARGB(255, 250, 250, 250),
                    height: 49,
                    padding: EdgeInsets.only(left: 10),
                    child: new Align(
                      alignment: new FractionalOffset(0.0, 0.5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: new Text(list[position].shno,maxLines: 2,),
                            flex: 2,
                          ),
                          Expanded(
                            child: new Text(list[position].odno,maxLines: 2,),
                            flex: 2,
                          ),
                          Expanded(
                            child: new Text(list[position].pjnm,maxLines: 2,),
                            flex: 3,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )));
    } else {
      return GestureDetector();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Scaffold(
        body: Container(
          child: StreamBuilder<List<FyInfoListItem>>(
            stream: _streamController.stream,
            builder: (BuildContext context, AsyncSnapshot<List<FyInfoListItem>> snapshot){
              List<FyInfoListItem> list = snapshot.data;
              //数据添加到全局变量里面
              fyInfoListItems.clear();
              if(list!=null){
                fyInfoListItems.addAll(list);
              }
              if(list == null){
                return _showLoading();
              }else{
                return (list.length>0)?_buildListView(snapshot.data):_showLoading();
              }
            },
          ),
        ),
      ),
    );
  }
  //显示加载菊花
  Widget _showLoading(){
    return Center(
      child: CupertinoActivityIndicator(
        radius: 20,
      ),
    );
  }
}