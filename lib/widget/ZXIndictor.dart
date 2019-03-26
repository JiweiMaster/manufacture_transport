import 'package:flutter/material.dart';



class ZXIndictor extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Row(
        children: <Widget>[
          new Expanded(
            child: new Container(
              margin: EdgeInsets.only(left: 5),
              alignment: Alignment.centerLeft,
              child: new Text(
                "承运商",
                maxLines: 1,
              ),
            ),
            flex: 1,
          ),
          new Expanded(
            child: new Container(
              margin: EdgeInsets.only(left: 5),
              child:new Text(
                  "装箱序号",
              ),
            ),
            flex: 2,
          ),
          new Expanded(
            child: new Container(
              alignment: Alignment.center,
              child: new Text(
                  "需发货",
              ),
              margin: EdgeInsets.only(right: 5),
            ),
            flex: 1,
          ),
          new Expanded(
            child: new Container(
              alignment: Alignment.center,
              child: new Text(
                  "已扫码",
              ),
              margin: EdgeInsets.only(right: 5),
            ),
            flex: 1,
          ),
          new Expanded(
            child: new Container(
              alignment: Alignment.center,
              child: new Text(
                  "差异"
              ),
              margin: EdgeInsets.only(right: 5),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}