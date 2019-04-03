import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:manufacture_transport/model/MyUtil.dart';

typedef OnScanFinished = void Function(String shortCode,
    String longCode);

class ScanCodeWidget extends StatefulWidget{
  ScanCodeWidget({Key key,this.onScanFinished});
  final OnScanFinished onScanFinished;
  @override
  State<StatefulWidget> createState() {
    return ScanCodeWidgetState(onScanFinished);
  }
}

class ScanCodeWidgetState extends State<ScanCodeWidget>{
  ScanCodeWidgetState(this.onScanFinished);
  final OnScanFinished onScanFinished;
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: EdgeInsets.only(top: 5,bottom: 5),
      height: 40,
      child: new RaisedButton(
        color: Colors.lightBlue,
        onPressed: scan,
        child: new Text("          扫描二维码          ",
            style: new TextStyle(color: Colors.white)),
      ),
    );
  }

  //进行扫码工作
  Future scan() async {
    try {
      String barcodeDataLong = await BarcodeScanner.scan();
      String barcodeDataShort;
      //获取短码
      if(barcodeDataLong.length != 10){
        barcodeDataShort = barcodeDataLong.substring(0,10);
      }else{
        barcodeDataShort = barcodeDataLong;
      }
      onScanFinished(barcodeDataShort,barcodeDataLong);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        ToastUtil.print("权限被拒绝");
      } else {
        ToastUtil.print("扫码失败");
      }
    } on FormatException{
      ToastUtil.print("未扫码");
    } catch (e) {
      ToastUtil.print("扫码失败");
    }
  }
}