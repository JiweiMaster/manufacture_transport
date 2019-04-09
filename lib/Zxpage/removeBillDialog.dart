import 'package:flutter/material.dart';

//移库单dialog添加选择list
class RemoveBillDialog{
  //获取源仓库
  static List<DropdownMenuItem> getFRWH(){
    List<DropdownMenuItem> items = new List();
    DropdownMenuItem dropdownMenuItem0=new DropdownMenuItem(
      child:new Text('南瑞继保'),
      value: '1',
    );
    DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
      child:new Text('世捷物流'),
      value: '2',
    );
    items.add(dropdownMenuItem0);
    items.add(dropdownMenuItem1);
    return items;
  }

  //获取目标仓库
  static List<DropdownMenuItem> getTOWH(){
    List<DropdownMenuItem> items = new List();
    DropdownMenuItem dropdownMenuItem0=new DropdownMenuItem(
      child:new Text('南瑞继保'),
      value: '1',
    );
    DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
      child:new Text('世捷物流'),
      value: '2',
    );
    items.add(dropdownMenuItem0);
    items.add(dropdownMenuItem1);
    return items;
  }

  //获取传递标志
  static List<DropdownMenuItem> getMVFG(){
    List<DropdownMenuItem> items = new List();
    DropdownMenuItem dropdownMenuItem0=new DropdownMenuItem(
      child:new Text('初始'),
      value: '1',
    );
    DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
      child:new Text('下达'),
      value: '2',
    );
    DropdownMenuItem dropdownMenuItem2=new DropdownMenuItem(
      child:new Text('传递'),
      value: '3',
    );
    DropdownMenuItem dropdownMenuItem3=new DropdownMenuItem(
      child:new Text('完成'),
      value: '4',
    );
    DropdownMenuItem dropdownMenuItem4=new DropdownMenuItem(
      child:new Text('取消'),
      value: '5',
    );
    items.add(dropdownMenuItem0);
    items.add(dropdownMenuItem1);
    items.add(dropdownMenuItem2);
    items.add(dropdownMenuItem3);
    items.add(dropdownMenuItem4);
    return items;
  }

  //获取关联标志
  static List<DropdownMenuItem> getLKTY(){
    List<DropdownMenuItem> items = new List();
    DropdownMenuItem dropdownMenuItem0=new DropdownMenuItem(
      child:new Text('普通方式'),
      value: '1',
    );
    DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
      child:new Text('集装方式'),
      value: '2',
    );
    items.add(dropdownMenuItem0);
    items.add(dropdownMenuItem1);
    return items;
  }
}


class RemoveBillSelector extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return RemoveBillSelectorState();
  }
}
//通过静态变量传递数据
class RemoveBillSelectorState extends State<RemoveBillSelector>{
  static String _FRWHValue;
  static String _TOWHValue;
  static String _MVFGValue;
  static String _LKTYValue;
  static get FRWHValue => _FRWHValue;
  static get TOWHValue => _TOWHValue;
  static get MVFGValue => _MVFGValue;
  static get LKTYValue => _LKTYValue;

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Color.fromARGB(255, 250, 250, 250),
      child: new Column(
        children: <Widget>[
          new Container(
            alignment: Alignment.centerLeft,
            child: new Row(
              children: <Widget>[
                new Text("源仓库：",style: new TextStyle(fontSize: 17),),
                new DropdownButton(
                  items: RemoveBillDialog.getFRWH(),
                  hint: new Text("选择源仓库"),
                  value: _FRWHValue,
                  onChanged: (T){
                    setState(() {
                      _FRWHValue = T;
                    });
                  },
                ),
              ],
            )
          ),
          new Container(
            alignment: Alignment.centerLeft,
            child: new Row(
              children: <Widget>[
                new Text("目的仓库：",style: new TextStyle(fontSize: 17),),
                new DropdownButton(
                  items: RemoveBillDialog.getTOWH(),
                  hint: new Text("选择目标仓库"),
                  value: _TOWHValue,
                  onChanged: (T){
                    setState(() {
                      _TOWHValue = T;
                    });
                  },
                ),
              ],
            )
          ),
//          new Container(
//            alignment: Alignment.centerLeft,
//            child: new Row(
//              children: <Widget>[
//                new Text("传递标志：",style: new TextStyle(fontSize: 17),),
//                new DropdownButton(
//                  items: RemoveBillDialog.getMVFG(),
//                  hint: new Text("选择传递标志"),
//                  value: _MVFGValue,
//                  onChanged: (T){
//                    setState(() {
//                      _MVFGValue = T;
//                    });
//                  },
//                ),
//              ],
//            ),
//          ),
          new Container(
            alignment: Alignment.centerLeft,
            child: new Row(
              children: <Widget>[
                new Text("关联方式：",style: new TextStyle(fontSize: 17),),
                new DropdownButton(
                  items: RemoveBillDialog.getLKTY(),
                  hint: new Text("选择关联方式"),
                  value: _LKTYValue,
                  onChanged: (T){
                    setState(() {
                      _LKTYValue = T;
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
