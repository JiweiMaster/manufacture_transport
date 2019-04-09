import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:manufacture_transport/Zxpage/removeBillDialog.dart';
import 'package:manufacture_transport/model/FyInfoListItem.dart';
import 'package:manufacture_transport/model/MyUtil.dart';
import 'package:manufacture_transport/model/NetApi.dart';
import 'package:manufacture_transport/model/ZXItemData.dart';
import 'package:manufacture_transport/widget/ZXIndictor.dart';

String barcode = "";
List<ZXItemData> zxlist = new List();
List<String> allScanedCode = new List();
//承运商
class ZXPage extends StatelessWidget {
  ZXPage({Key key,@required this.fyInfoListItem}):super(key: key);
  final FyInfoListItem fyInfoListItem;
  TextEditingController _removeBillTextController = TextEditingController();
  TextEditingController _operatorController = TextEditingController();
  TextEditingController _additionalController = TextEditingController();

  BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    print(fyInfoListItem.scarr);
    zxlist.clear();
    zxlist.addAll(fyInfoListItem.zxItemDatas);
    return new Material(
        child: new Scaffold(
            appBar: new AppBar(
              leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
                Navigator.pop(context);
              }),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.cloud_upload),onPressed: (){
                  _connectRemoveBill();
                },)
              ],
              title: new Text(fyInfoListItem.shno),
            ),
            body: Stack(
              children: <Widget>[
                new Column(
                  children: <Widget>[
                    Container(
                      child: ZXIndictor(),
                    ),
                    Expanded(
                      child: new ListViewAndScan(fyInfoListItem),
                      flex: 1,
                    ),
                  ],
                ),
              ],
            )
        ),
        );
  }

  Future<void> _connectRemoveBill() async{
    //判断装箱数据和已经扫码的数据是不是吻合的
    String content="";
    for(ZXItemData zxData in zxlist){
      if(zxData.pknm == zxData.haveCode.toString()){
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
          title: Text("创建并关联移库单"),
          content: Card(
            color: Color.fromARGB(255, 248, 248, 248),
            elevation: 0.0,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  child: Text(content,style: new TextStyle(color: Colors.red),),
                ),
                //移库单号
                TextField(
                  controller: _removeBillTextController,
                  decoration: InputDecoration(
                      labelText: "输入移库单号",
                      filled: true,
                      fillColor: Colors.grey.shade50),
                ),
                //下单人
                TextField(
                  controller: _operatorController,
                  decoration: InputDecoration(
                      labelText: "输入下单人",
                      filled: true,
                      fillColor: Colors.grey.shade50),
                ),
                //备注
                TextField(
                  controller: _additionalController,
                  decoration: InputDecoration(
                      labelText: "备注",
                      filled: true,
                      fillColor: Colors.grey.shade50),
                ),
                new RemoveBillSelector(),
              ],
            ),
          ),
          actions: <Widget>[
            new CupertinoButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: Text('取消关联')),
            new CupertinoButton(onPressed: () {
              Navigator.of(context).pop();
              //进行网络操作去关联移库单
              String removeBill = _removeBillTextController.text.toString();//获取移库单号
              String operatorText = _operatorController.text.toString();
              String additionalText = _additionalController.text.toString();

              _connectRemoveBillRequest(removeBill.toUpperCase(),operatorText,additionalText,
                  RemoveBillSelectorState.FRWHValue,//源仓库
                  RemoveBillSelectorState.TOWHValue,//目的仓库
                  "1",//传递标志只能是1，由于下面需要对移库单的校验
                  RemoveBillSelectorState.LKTYValue);//传递标志-->去进行网络请求
            }, child: Text('确认关联')),
          ],
        );
      }
    );
  }

  //使用showdialog的方法显示可以使用Navigator.pop(context);的方法取消dialog
  Future<void> _showUpLoading(BuildContext context) async{
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return CupertinoActivityIndicator(
            radius: 20,
          );
        }
    );
  }

  //net request to connect 移库单
  Future<void> _connectRemoveBillRequest(removeBillText,operator,additional,sourceHub,destHub,mvFlag,lkty) async{
    _showUpLoading(context);
    //获取装箱号
    String ZXNumbers = "";
    for(ZXItemData zxItemData in zxlist){
      ZXNumbers=ZXNumbers+zxItemData.mtno+",";
    }
    ZXNumbers = ZXNumbers.substring(0,ZXNumbers.length-1);//所有的装箱号

    print(NetApi.createAndConnectYKBill
        +"?shno=$removeBillText&frwh=$sourceHub&towh=$destHub&iner=$operator"+
            "&mvfg=$mvFlag&comm=$additional&lkty=$lkty&zxnos=$ZXNumbers");
    //发起网络请求，去关联服务单
    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(NetApi.createAndConnectYKBill
        +"?shno=$removeBillText&frwh=$sourceHub&towh=$destHub&iner=$operator&mvfg=$mvFlag&comm=$additional&lkty=$lkty&zxnos=$ZXNumbers"));
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    Navigator.pop(context);
    print(responseBody);

    if(responseBody.toString().trim() == "关联移库单成功"){
      Navigator.pop(context,""+fyInfoListItem.shno);//将数据返回回去
    }else if(responseBody == "关联移库单失败"){
      ToastUtil.print("关联移库单失败");
    }else{
      ToastUtil.print(responseBody);
    }
//    await Future.delayed(Duration(seconds: 2), () {
//    });
  }
}

class ZXData{
  ZXData(this.carrier,this.scarr,this.mtno,this.pknm,this.haveCode,this.maxValue,this.odno,this.odln,this.odnm,this.whls);
  String carrier;
  String scarr;//承运商
  String mtno;//物料的名称
  String pknm;//数量
  String haveCode;
  double maxValue;

  String odno;//销售订单号
  String odln;//销售行数
  String odnm;//销售物品名称
  String whls;

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
  }

  @override
  Widget build(BuildContext context) {
    return zxlist.length == 0?_showLoading():_buildListViewAndScanState();
  }

  //显示加载数据的菊花
  Widget _showLoading(){
    return Center(
      child: CupertinoActivityIndicator(
        radius: 20,
      ),
    );
  }

  Widget _buildListViewAndScanState(){
    return new Column(
      children: <Widget>[
        new Expanded(
            child: _buildListView(),
            flex: 12
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



  Future<void> showZXDetail(int position) async{
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('装箱详情'),
            content: Column(
              children: <Widget>[
                new Text("装箱序号："+zxlist[position].mtno, style: new TextStyle(fontSize: 15),),
                new Text("销售订单号："+zxlist[position].odno,style: new TextStyle(fontSize: 15),),
                new Text("装箱内容："+zxlist[position].odnm,style: new TextStyle(fontSize: 15,),),
                new Text("一级承运商："+(zxlist[position].carrier=="2"?"世捷物流":"南瑞继保"),style: new TextStyle(fontSize: 15),),
                new Text("二级承运商："+zxlist[position].scarr,style: new TextStyle(fontSize: 15),),
                new Text("库位："+zxlist[position].whls,style: new TextStyle(fontSize: 15),),
              ],
            ),
            actions: <Widget>[
              new CupertinoButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('确认')),
            ],
          );
        });
  }

  Widget _buildListViewItem(BuildContext context, int position){
    if (zxlist != null) {
      return GestureDetector(
          onTap: () {
            showZXDetail(position);
          },
          child: Container(
              height: 50,
//              color: Color.fromARGB(255, 245, 245, 245),
              child: new Column(
                children: <Widget>[
                  new Container(
                      height: 50,
//                      color: Colors.red,
                      child: new Column(
                        children: <Widget>[
                          new Stack(
                            children: <Widget>[
                              Container(
                                height: 49,
                                child: new Align(
                                  alignment: new FractionalOffset(0.0, 0.5),
                                  child: new Row(
                                    children: <Widget>[
                                      new Expanded(
                                        child: new Container(
                                          margin: EdgeInsets.only(left: 5),
                                          child:new Text(
                                              zxlist[position].mtno,
                                              style: TextStyle(color: Colors.black)
                                          ),
                                        ),
                                        flex: 2,
                                      ),
                                      new Expanded(
                                        child: new Container(
                                          margin: EdgeInsets.only(left: 5),
                                          alignment: Alignment.centerLeft,
                                          child: new Text(
                                            zxlist[position].odnm,
                                            style: TextStyle(color: Colors.black),
                                            maxLines: 2,
                                          ),
                                        ),
                                        flex: 3,
                                      ),

                                      new Expanded(
                                        child: new Container(
                                          alignment: Alignment.center,
                                          child: new Text(
                                              zxlist[position].pknm,
                                              style: TextStyle(color: Colors.black)
                                          ),
                                          margin: EdgeInsets.only(right: 5),
                                        ),
                                        flex: 1,
                                      ),
                                      new Expanded(
                                        child: new Container(
                                          alignment: Alignment.center,
                                          child: new Text(
                                              zxlist[position].haveCode.toString(),
                                              style: TextStyle(color: Colors.black)
                                          ),
                                          margin: EdgeInsets.only(right: 5),
                                        ),
                                        flex: 1,
                                      ),
                                      new Expanded(
                                        child: new Container(
                                          alignment: Alignment.center,
                                          child: new Text(
                                              (zxlist[position].haveCode-int.parse(zxlist[position].pknm)).toString(),
                                              style: TextStyle(color:Colors.red)
                                          ),
                                          margin: EdgeInsets.only(right: 5),
                                        ),
                                        flex: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 0.5,
                            color: Color.fromARGB(255, 220, 220,220),
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


}


