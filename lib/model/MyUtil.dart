import 'package:fluttertoast/fluttertoast.dart';

class Log{
  static void e(String TAG , String msg){
    print(TAG+"==>"+msg);
  }
}

class ToastUtil{
  static void print(String msg){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: 1,
    );
  }
}