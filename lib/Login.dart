import 'package:flutter/material.dart';
import 'package:manufacture_transport/FYPage.dart';
import 'package:manufacture_transport/model/MyUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget{
  Login({ Key key }) : super(key: key);
  TextEditingController usernameController = TextEditingController();
  TextEditingController passswdController = TextEditingController();
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage('assets/image/loginBackground.png'),
                      fit: BoxFit.cover
                  )
              )
          ),
          new Align(
            alignment: Alignment(0.0,-0.7),
            child: Image(image: new AssetImage('assets/image/loginLogo.png'),width: 80,height: 80,),
          ),
          new Align(
            alignment: Alignment(0.0,-0.1),
            child: new Container(
                margin: EdgeInsets.all(15),
                height: 230,
                child: new Column(
                  children: <Widget>[
                    TextField(
                      controller: usernameController,
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        icon: Icon(Icons.person_outline),
                        labelText: '请输入你的用户名',
                      ),
                    ),

                    TextField(
                      controller: passswdController,
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        icon: Icon(Icons.remove_red_eye),
                        labelText: '请输入你的密码',
                      ),
                    ),
                    Container(
                      height: 48,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 50),
                      child: RaisedButton(
                        color: Color.fromARGB(255, 234, 138, 88),
                        splashColor: Colors.grey[300],
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        onPressed: () => {
                        _login(usernameController.text,
                            passswdController.text)
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                        child: Text('登 录',style: new TextStyle(fontSize: 20,color: Colors.white),),
                      ),
                    )
                  ],
                )
            ),
          )
//            new Text("hello"),
        ],
      ),
    );
  }

  Future<void> _login(String userName,String password) async{
    if(userName == "" || password == ""){
      ToastUtil.print("信息不完整");
    } else{
      if(userName == "111111" && password == "111111"){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isFirstLogin", false);
        Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                new FYPage()),
                (route) => route == null);
      }
    }
  }
}