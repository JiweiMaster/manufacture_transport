import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manufacture_transport/ZXPage.dart';
import 'package:manufacture_transport/model/FyInfoListItem.dart';


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

  Widget _buildListView(List<FyInfoListItem> list) {
    return ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (BuildContext context, int position) {
          return _buildListViewItem(context, list, position);
        });
  }

  Widget _buildListViewItem(BuildContext context, List<FyInfoListItem> list, int position) {
    if (list != null) {
      return GestureDetector(
          onTap: () {
            print(list[position].PJNM);
            //跳转到下一个界面
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                    new ZXPage(fyInfoListItem: list[position]),));
          },
          child: Container(
              height: 50,
              color: Color.fromARGB(255, 238, 238, 238),
              child: new Column(
                children: <Widget>[
                  new Container(
                    height: 49,
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 10),
                    child: new Align(
                      alignment: new FractionalOffset(0.0, 0.5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: new Text(list[position].SHNO,maxLines: 2,),
                            flex: 2,
                          ),
                          Expanded(
                            child: new Text(list[position].ODNO,maxLines: 2,),
                            flex: 2,
                          ),
                          Expanded(
                            child: new Text(list[position].PJNM,maxLines: 2,),
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
              return _buildListView(snapshot.data);
            },
          ),
        ),
      ),
    );
  }

}