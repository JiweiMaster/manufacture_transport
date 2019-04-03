import 'dart:async';
import 'package:flutter/material.dart';

/**
 * 传入一个StreamController进行数据的传递
 */
typedef OnDataChanged = void Function(DateTime dateTime);
class DataPicker extends StatefulWidget{
  DataPicker({
    Key key,
    @required this.onDataChanged
  });
  final OnDataChanged onDataChanged;
  @override
  State<StatefulWidget> createState() {
    return DataPickerState(onDataChanged);
  }
}

class DataPickerState extends State<DataPicker>{
  DataPickerState(this.onDataChanged);
  final OnDataChanged onDataChanged;

  String currentStr;
  DateTime selectTime;
  @override
  void initState() {
    super.initState();
    selectTime = new DateTime.now();
  }

  String formatTime(DateTime dataTime){
    return dataTime.toString().substring(0,10);
  }

  Future<void> _selectData(BuildContext context) async{
    final DateTime _picked = await showDatePicker(
        context: context,
        initialDate: selectTime,
        firstDate: new DateTime(2016),
        lastDate: new DateTime(3019),
    );
    if(_picked != null){
      setState(() {
        selectTime = _picked;
      });
      //接口回调数据数据
      if(onDataChanged != null){
        onDataChanged(selectTime);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: (){
        _selectData(context);

      },
      child: new Container(
        child: new Row(
          children: <Widget>[
            new Text(selectTime != null?formatTime(selectTime):""),
            new IconButton(icon: Icon(Icons.calendar_today))
          ],
        ),
      )
    );
  }

}