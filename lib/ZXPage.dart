import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:manufacture_transport/loading_dialog/ProgressDialog.dart';
import 'package:manufacture_transport/model/FyInfoListItem.dart';
import 'package:manufacture_transport/model/MyUtil.dart';
import 'package:manufacture_transport/model/NetApi.dart';
import 'package:manufacture_transport/widget/ZXIndictor.dart';


String barcode = "";
List<ZXData> zxlist = new List();
//承运商
class ZXPage extends StatelessWidget {
  ZXPage({Key key,@required this.fyInfoListItem}):super(key: key);
  final FyInfoListItem fyInfoListItem;
  TextEditingController _removeBillTextController = TextEditingController();
  StreamController<bool> _streamControllerDialog = new StreamController();
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    //初始化不显示加载框
    _streamControllerDialog.sink.add(false);
    return new WillPopScope(
        child: new Scaffold(
            appBar: new AppBar(
              leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
                _showAlert();
              }),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.cloud_download),onPressed: (){

                  _connectRemoveBill();
                },)
              ],
              title: new Text(fyInfoListItem.shno),
            ),

            body: Stack(
              children: <Widget>[
                new StreamBuilder<bool>(
                    stream: _streamControllerDialog.stream,
                    builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
                      return new ProgressDialog(
                        loading: snapshot.data != null?snapshot.data:false,
                        msg: '正在创建',
                        child: Center(
                        ),
                      );
                    }
                ),
                new Column(
                  children: <Widget>[
                    Container(
                      height: 40,
                      child: ZXIndictor(),
                    ),
                    Expanded(
                      child: new ListViewAndScan(fyInfoListItem),
                      flex: 1,
                    ),
                  ],
                )
              ],
            )
        ),
        onWillPop: _exit);
  }

  Future<void> _connectRemoveBill() async{
    //判断装箱数据和已经扫码的数据是不是吻合的
    String content="";
    for(ZXData zxData in zxlist){
      if(zxData.pknm == zxData.haveCode){
      }else{
        //需要发货和扫码数量对不上
        content = content +zxData.mtno+"发货扫码数据不吻合";
      }
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return CupertinoAlertDialog(
          title: Text("关联移库单"),
          content: Card(
            elevation: 0.0,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  color: Color.fromARGB(255, 250, 250, 250),
                  child: Text(content,style: new TextStyle(color: Colors.red),),
                ),
                TextField(
                  controller: _removeBillTextController,
                  decoration: InputDecoration(
                      labelText: "输入移库单号",
                      filled: true,
                      fillColor: Colors.grey.shade50),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new CupertinoButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: Text('取消关联')),
            new CupertinoButton(onPressed: () {
              //进行网络操作去关联移库单
              String removeBill = _removeBillTextController.text.toString();//获取移库单号
              _connectRemoveBillRequest(removeBill);//去进行网络请求
              Navigator.of(context).pop();

            }, child: Text('确认关联')),
          ],
        );
      }
    );
  }

  //net request to connect 移库单
  Future<void> _connectRemoveBillRequest(removeBillText) async{
    _streamControllerDialog.sink.add(true);
    //获取装箱号
    String ZXNumbers = "";
    for(ZXData data in zxlist){
      ZXNumbers=ZXNumbers+data.mtno+",";
    }
    ZXNumbers = ZXNumbers.substring(0,ZXNumbers.length-1);
    //发起网络请求，去关联服务单
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(NetApi.connectRemoveHubBillUrl
        +"?YKNumber="+removeBillText+"&ZXNumbers="+ZXNumbers));
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();

    ToastUtil.print(responseBody);
    if(responseBody != ""){
      _streamControllerDialog.sink.add(false);
    }
//    await Future.delayed(Duration(seconds: 2), () {
//      _streamControllerDialog.sink.add(false);
//    });
  }

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
            title: Text('警告：\n 请检查该单号装箱是否完成，退出界面后不保存数据'),
            actions: <Widget>[
              new CupertinoButton(onPressed: () {
                Navigator.of(context).pop();
              }, child: Text('去检查')),
              new CupertinoButton(onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              }, child: Text('确认退出')),
            ],
          );
        }
    );
  }
}


class ZXData{
  ZXData(this.scarr,this.mtno,this.pknm,this.haveCode,this.maxValue);
  String scarr;//承运商
  String mtno;//物料的名称
  String pknm;//数量
  String haveCode;
  double maxValue;
}

class ListViewAndScan extends StatefulWidget{
  ListViewAndScan(FyInfoListItem fyInfoListItem):
        this.fyInfoListItem =fyInfoListItem,
        super(key: new ObjectKey(fyInfoListItem));
  final FyInfoListItem fyInfoListItem;
  createState() => new ListViewAndScanState(fyInfoListItem);
}

class ListViewAndScanState extends State<ListViewAndScan>{
  ListViewAndScanState(FyInfoListItem fyInfoListItem):
        this.fyInfoListItem = fyInfoListItem;
  FyInfoListItem fyInfoListItem;
  @override
  void initState() {
    super.initState();
    _GetTransportZXData(fyInfoListItem);
  }

  @override
  Widget build(BuildContext context) {
    return _buildListViewAndScanState();
  }

  Widget _buildListViewAndScanState(){
    return new Column(
      children: <Widget>[
        new Expanded(
            child: _buildListView(),
            flex: 12
        ),
        new Expanded(
          child: new Container(
            padding: EdgeInsets.only(top: 7,bottom: 7),
            child: _buildScancode(),
          ),
          flex: 1,
        ),
      ],
    );
  }

  Widget _buildListView(){
    return ListView.builder(
        itemCount: zxlist == null ? 0 : zxlist.length,
        itemBuilder: (BuildContext context, int position) {
          return _buildListViewItem(context, position);
        });
  }

  Widget _buildScancode(){
    return new Container(
      child: new RaisedButton(
        color: Colors.lightBlue,
        onPressed: scan,
        child: new Text("          扫描二维码          ",
            style: new TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildListViewItem(BuildContext context, int position){
    if (zxlist != null) {
      return GestureDetector(
          onTap: () {
          },
          child: Container(
              height: 50,
//              color: Color.fromARGB(255, 245, 245, 245),
              child: new Column(
                children: <Widget>[
                  new Container(
                      height: 50,
//                      color: Colors.white,
                      child: new Stack(
                        children: <Widget>[
                          new SizedBox(
                            height: 49,
                            child: new LinearProgressIndicator(
                              value: (int.parse(zxlist[position].haveCode)/zxlist[position].maxValue),
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation(Color.fromARGB(255, 158, 158, 158)),
                            ),
                          ),
                          new Align(
                            alignment: new FractionalOffset(0.0, 0.5),
                            child: new Row(
                              children: <Widget>[
                                new Expanded(
                                    child: new Container(
                                      margin: EdgeInsets.only(left: 5),
                                      alignment: Alignment.centerLeft,
                                      child: new Text(
                                        zxlist[position].scarr,
                                        style: TextStyle(color: ((int.parse(zxlist[position].haveCode)/zxlist[position].maxValue)>=1)?Colors.white:Colors.black),
                                        maxLines: 2,
                                      ),
                                    ),
                                  flex: 2,
                                ),
                                new Expanded(
                                  child: new Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child:new Text(
                                        zxlist[position].mtno,
                                        style: TextStyle(color: ((int.parse(zxlist[position].haveCode)/zxlist[position].maxValue)>=1)?Colors.white:Colors.black)
                                    ),
                                  ),
                                  flex: 3,
                                ),
                                new Expanded(
                                  child: new Container(
                                    alignment: Alignment.center,
                                    child: new Text(
                                        zxlist[position].pknm,
                                        style: TextStyle(color: ((int.parse(zxlist[position].haveCode)/zxlist[position].maxValue)>=1)?Colors.white:Colors.black)
                                    ),
                                    margin: EdgeInsets.only(right: 5),
                                  ),
                                  flex: 1,
                                ),
                                new Expanded(
                                  child: new Container(
                                    alignment: Alignment.center,
                                    child: new Text(
                                        zxlist[position].haveCode,
                                        style: TextStyle(color: ((int.parse(zxlist[position].haveCode)/zxlist[position].maxValue)>=1)?Colors.white:Colors.black)
                                    ),
                                    margin: EdgeInsets.only(right: 5),
                                  ),
                                  flex: 1,
                                ),
                                new Expanded(
                                  child: new Container(
                                    alignment: Alignment.center,
                                    child: new Text(
                                        (int.parse(zxlist[position].haveCode)-int.parse(zxlist[position].pknm)).toString(),
                                        style: TextStyle(color:Colors.red)
                                    ),
                                    margin: EdgeInsets.only(right: 5),
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  )
                ],
              )
          )
      );
    }else{
      return GestureDetector();
    }
  }

  //获取fy单号对应的物料信息
  _GetTransportZXData(FyInfoListItem fyInfoListItem) async {
    try{
      final String FYNumberUrl = NetApi.GetTransportZXDataUrl+"?fyNumber="+fyInfoListItem.shno;
      zxlist.clear();
      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse(FYNumberUrl));
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();
      List mapJosn = json.decode(responseBody);
      mapJosn.forEach((map) => {
      zxlist.add(ZXData(fyInfoListItem.scarr,map['mtno'],map['pknm'],"0",double.parse(map['pknm'])))
      });
      setState(() {
      });
    }on SocketException{
      Fluttertoast.showToast(
        msg: "网络请求失败",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
      );
    }
  }
  //进行扫码工作
  Future scan() async {
    try {
      String barcodeData = await BarcodeScanner.scan();
      if(barcodeData.length != 10){
        barcodeData = barcodeData.substring(0,10);
      }
      setState((){
        for(var zxData in zxlist){
          if(zxData.mtno == barcodeData){
              zxData.haveCode = (int.parse(zxData.haveCode)+1).toString();
            break;
          }else{
            Fluttertoast.showToast(
              msg: "未发现该装箱："+barcodeData,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIos: 1,
            );
          }
        }
      }
      );
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          barcode = 'permission refused error';
        });
        Fluttertoast.showToast(
          msg: "权限被拒绝",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
        );
      } else {
        setState(() => barcode = 'error');
        Fluttertoast.showToast(
          msg: "扫码失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
        );
      }
    } on FormatException{
      setState(() => barcode = 'back');
      Fluttertoast.showToast(
        msg: "未扫码",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
      );
    } catch (e) {
      setState(() => barcode = 'error');
      Fluttertoast.showToast(
        msg: "扫码失败",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
      );
    }
  }
}


