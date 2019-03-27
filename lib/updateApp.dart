
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:manufacture_transport/model/NetApi.dart';
import 'package:package_info/package_info.dart';
import 'package:manufacture_transport/model/MyUtil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VersionUpdateModel{
  String app_name;
  String update_content;
  String version_name;
  String version_code;
  String file;
  VersionUpdateModel(jsonRes){
    this.app_name = jsonRes['version_code'];
    this.app_name = jsonRes['update_content'];
    this.app_name = jsonRes['version_name'];
    this.app_name = jsonRes['version_code'];
    this.app_name = jsonRes['file'];
  }
}

class UpdateApp {
  static VersionUpdateModel versionUpdateModel;
  static String TAG = "UpdateApp";
  //向服务器获取版本号
  static Future<void> getVersion(BuildContext context) async {
    String updateUrl = "";//更新app的url
    if (Platform.isAndroid == true) {
      updateUrl = NetApi.appUpdateAndroidUrl;
    } else if (Platform.isIOS == true) {
      updateUrl = NetApi.appUpdateIOSUrl;
    }
    var dio = new Dio();
    Options options = Options(headers: {HttpHeaders.contentTypeHeader :"application/json"});
    Response response = await dio.get(updateUrl,options: options);
    var jsonRes = json.decode(response.data);
    versionUpdateModel = new VersionUpdateModel(jsonRes);
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version; //1.0.1+1--版本号和构建号
    Log.e(TAG, "当前版本号=>" + version);
    if(version != versionUpdateModel.version_name){
      _showUpdateDialog(context);
    }
  }

  //返回是否更新app的对话框
  static Future<void> _showUpdateDialog(BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('更新APP'),
            content: Text(versionUpdateModel.update_content??"新版本"),
            actions: <Widget>[
              new CupertinoButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('暂不更新')),
              new CupertinoButton(
                  onPressed: () {
                    _updateApp();
                    Navigator.of(context).pop();
                  },
                  child: Text('立即更新')),
            ],
          );
        });
  }

  //校验是否授权读取磁盘权限
  static Future<void> _updateApp() async {
    PermissionStatus permissionHave = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permissionHave.value == 2) {
      //PermissionStatus.grant
      _downloadApp();
    } else {
      Map<PermissionGroup, PermissionStatus> permissionsRequestMap =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
      if (permissionsRequestMap[PermissionGroup.storage].value == 2) {
        _downloadApp();
      } else {
        ToastUtil.print("权限被拒绝");
      }
    }
  }

  //下载App
  static Future<void> _downloadApp() async {
    Directory appDocDir = await getExternalStorageDirectory();
    String appDocPath = appDocDir.path;
    String StringdownloadUrl =versionUpdateModel.file;

    final taskId = await FlutterDownloader.enqueue(
        url: StringdownloadUrl,
        savedDir: appDocPath,
        showNotification: true,
        openFileFromNotification: true);
    FlutterDownloader.registerCallback((id, status, progress) {
      // 当下载完成时，调用安装
      if (taskId == id && status == DownloadTaskStatus.complete) {
        FlutterDownloader.open(taskId: id);
      }
    });
    final tasks = await FlutterDownloader.loadTasks();
  }
}