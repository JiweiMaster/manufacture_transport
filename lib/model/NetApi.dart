
class NetApi{
  static final ServerAddress = "http://218.94.37.243";
  static final StringServerurl = "http://218.94.37.243:8081";
  //根据承运商来获取发运信息
  static final String _GET_FYINFO_BY_TRANSPORTCOMPANY = "/winningBid/Service1.asmx/GetTransportFYNumberNew";
  static get GET_FYINFO_BY_TRANSPORTCOMPANY => StringServerurl+_GET_FYINFO_BY_TRANSPORTCOMPANY;
  //关联移库单
  static final String _connectRemoveHubBill = "/winningBid/Service1.asmx/ConnectYKNumber";
  static get connectRemoveHubBillUrl => StringServerurl+_connectRemoveHubBill;
  //appupdate
  static get appUpdateAndroidUrl => "http://218.94.37.243:8081/winningBid/Service1.asmx/ManuTransAppDownload";
  static get appUpdateIOSUrl => "http://106.14.14.212:8002/apk?app=制造物流扫码Android&format=json";
  //根据发运单号获取完整的装箱信息
  static get shnoInfoByShno => StringServerurl+"/winningBid/Service1.asmx/GetTransportFYShno";
  static get createAndConnectYKBill=>StringServerurl+"/winningBid/Service1.asmx/CreateAndConnectServiceBill";

//-------------------------------------------测试服务器数据------------------------
//  static final StringServerurl = "http://192.168.38.95:50859";
//  static final StringServerurl = "http://192.168.38.95:80/winbid";//本地iis服务器访问地址
//  //根据承运商来获取完整的发运单和装箱信息
//  static get GET_FYINFO_BY_TRANSPORTCOMPANY => StringServerurl+"/WebService1.asmx/GetTransportFYNumberNew";
//  //关联移库单
//  static get connectRemoveHubBillUrl => StringServerurl+"/WebService1.asmx/ConnectYKNumber";
//  //appupdate
//  static get appUpdateAndroidUrl => "http://218.94.37.243:8081/winningBid/Service1.asmx/ManuTransAppDownload";
//  static get appUpdateIOSUrl => "http://106.14.14.212:8002/apk?app=制造物流扫码Android&format=json";
//
//  static get shnoInfoByShno => StringServerurl+"/WebService1.asmx/GetTransportFYShno";
//  static get createAndConnectYKBill=>StringServerurl+"/WebService1.asmx/CreateAndConnectServiceBill";
}