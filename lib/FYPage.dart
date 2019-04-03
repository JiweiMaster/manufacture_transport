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
import 'package:manufacture_transport/model/ZXItemData.dart';
import 'package:manufacture_transport/updateApp.dart';
import 'package:manufacture_transport/widget/FYListView.dart';
import 'package:manufacture_transport/widget/ScanCodeWidget.dart';
import 'package:manufacture_transport/widget/Selector.dart';
import 'package:manufacture_transport/widget/datePicker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
/*
需要一个能够选择发运商和发运时间的select
显示的listview,显示的数据源来自于select的之后的网络请求
* */

List<FyInfoListItem> allFYList = new List();
class FYPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _FYPageState();
  }
}

class _FYPageState extends State<FYPage>{
  bool ifRequestEver = false;
  String fyCompany;//发运公司
  StreamController<List<FyInfoListItem>> _streamController = new StreamController();
  int sumPackages=0;//总箱数
  int haveScanPackages=0;//已经扫码的箱数
  List<String> allhadScanCodes = new List();//用来排除重复扫码

  @override
  void initState() {
    List<FyInfoListItem> list =  new List<FyInfoListItem>();
    _streamController.sink.add(list);
    //初始化显示世捷物流
    getFYInfoByTransportCompany("邮政");
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
    return new WillPopScope(
      child: new Scaffold(
        appBar: AppBar(
          title: Text("出库拣配"),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.computer), onPressed: (){
              clearLogin();
            }),
            IconButton(icon: Icon(Icons.search), onPressed: (){
              _showShnoDialog();
            })
          ],

        ),
        body: _showList()
      ),
      onWillPop: _exit,
    );
  }
  //退出app
  Future<bool> _exit(){
    _showAlert();
    return new Future.value(false);
  }
  Future<void> _showAlert() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('警告：\n 请检查,退出应用后不保存数据'),
            actions: <Widget>[
              new CupertinoButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text('去检查')),
              new CupertinoButton(onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
                exitApp();
              }, child: Text('确认退出')),
            ],
          );
        }
    );
  }

  //通过订单号来查询
  Future<void> _showShnoDialog() async {
    TextEditingController _shnoTextController = TextEditingController();
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('通过发运单查询'),
            content: new Material(
              child: new Container(
                color: Color.fromARGB(255, 246, 246, 246),
                child: new Column(
                  children: <Widget>[
                    Text('多个发运单使用英文逗号逗号隔开',style: new TextStyle(color: Colors.red)),
                    TextField(
                      controller: _shnoTextController,
                    )
                  ],
                ),
              )
            ),
            actions: <Widget>[
              new CupertinoButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text('取消')),
              new CupertinoButton(onPressed: () {
                Navigator.of(context).pop();
//                _streamController.sink.add(null);
                getFYInfoByShno(_shnoTextController.text.toString());
              }, child: Text('搜索')),
            ],
          );
        }
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

  Widget _showList(){
    return new Column(
      children: <Widget>[
        new Container(
          margin: EdgeInsets.only(left: 10,right: 10),
          child: new Row(
            children: <Widget>[
              Text("承运商："),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Selector(
                    onSelected:(value){
                      //为了显示菊花的加载界面
                      _streamController.sink.add(null);
                      fyCompany = value;
                      //刷新网络请求
                      getFYInfoByTransportCompany(fyCompany);
                    }
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: new Text("总箱数："+sumPackages.toString()),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: new Text("已扫码："+haveScanPackages.toString()),
              ),
            ],
          ),
          height: 50,
        ),
        new Container(
          margin: EdgeInsets.only(left: 5,right: 5),
          child: new Row(
            children: <Widget>[
              new Expanded(child: new Text("发运号"),flex: 2,),
              new Expanded(child: new Text("装箱数"),flex: 2,),
              new Expanded(child: new Text("项目名称"),flex: 3,)
            ],
          ),
        ),
        new Expanded(
          child: FYListView(_streamController),
          flex: 1,
        ),
        new Container(
          child: ScanCodeWidget(
            onScanFinished:ScanCodeFinish
          ),
        )
      ],
    );
  }
  //对扫码的结果进行处理
  void ScanCodeFinish(shortCode,longCode){
    bool isMatch = false;
    if(allhadScanCodes.contains(longCode)){
      ToastUtil.print(""+longCode+"已经扫过了");
      return;
    }
    for(FyInfoListItem fyListViewItem in allFYList){
      for(ZXItemData zxItemData in fyListViewItem.zxItemDatas){
        if(shortCode == zxItemData.mtno){
          fyListViewItem.hadScanCode += 1;
          zxItemData.haveCode +=1;
          isMatch = true;
          break;
        }
      }
      if(isMatch == true){
        break;
      }
    }
    if(isMatch == true){
      haveScanPackages += 1;//全部已扫码数量
      setState(() {
      });
      //刷新数据
      _streamController.sink.add(allFYList);
      allhadScanCodes.add(longCode);
    }else{
      ToastUtil.print("当前所有发运单中没有装箱码："+shortCode);
    }
  }

  //根据发运公司获取数据
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
    mapJosn.forEach((map) => {
      list.add(FyInfoListItem(map))
    });
    for(FyInfoListItem fyInfoListItem in list){
      sumPackages = sumPackages + fyInfoListItem.sumCode;
    }
    allFYList.clear();
    allFYList.addAll(list);
    setState(() {
    });
    print(sumPackages);
    _streamController.sink.add(list);
  }

  //根据发运单号获取数据
  Future<void> getFYInfoByShno(String shnos) async{
    print(shnos);
//    List<FyInfoListItem> list = new List();
//    var httpClient = new HttpClient();
//    print(fycompany);
//    String url = NetApi.GET_FYINFO_BY_TRANSPORTCOMPANY+"?fycompany="+fycompany;
//    print(url);
//    var request = await httpClient.getUrl(Uri.parse(url));
//    var response = await request.close();
//    var responseBody = await response.transform(utf8.decoder).join();
//    List mapJosn = json.decode(responseBody);
//    mapJosn.forEach((map) => {
//    list.add(FyInfoListItem(map))
//    });
//    for(FyInfoListItem fyInfoListItem in list){
//      sumPackages = sumPackages + fyInfoListItem.sumCode;
//    }
//    allFYList.clear();
//    allFYList.addAll(list);
//    setState(() {
//    });
//    print(sumPackages);
//    _streamController.sink.add(list);
  }
}






