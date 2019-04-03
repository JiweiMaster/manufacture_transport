import 'package:flutter/material.dart';


class SearchEditText extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return SearchEditTextState();
  }

}

class SearchEditTextState extends State<SearchEditText>{
  TextEditingController _searchTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.all(5),
      child: new Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _searchTextController,
            ),
            flex: 1,
          ),
          
          Container(
            margin: EdgeInsets.only(left: 10),
            child: new RaisedButton(
              color: Colors.lightBlue,
              onPressed: (){
                print(_searchTextController.text.toString());
              },
              child: new Text("查找",
                  style: new TextStyle(color: Colors.white)),
            ),
          ),

        ],
      ),
    );
  }
}