import 'package:flutter/material.dart';
import 'package:manufacture_transport/FYPage.dart';
import 'package:manufacture_transport/Root.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLogin = await prefs.getBool("isFirstLogin");
  if(isFirstLogin == null){
    isFirstLogin = true;
  }
  print("isFirstLogin=>"+isFirstLogin.toString());
  runApp(new Root(isFirstLogin));
}
