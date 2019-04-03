
class NetApi{
  static final ServerAddress = "http://218.94.37.243";
  static final StringServerurl = "http://218.94.37.243:8081";
  //根据承运商来获取发运信息
//  static final String _GET_FYINFO_BY_TRANSPORTCOMPANY = "/winningBid/Service1.asmx/GetTransportFYNumber";

  static final String _GET_FYINFO_BY_TRANSPORTCOMPANY = "/winningBid/Service1.asmx/GetTransportFYNumberNew";
  static get GET_FYINFO_BY_TRANSPORTCOMPANY => StringServerurl+_GET_FYINFO_BY_TRANSPORTCOMPANY;
  //根据发运单号来获取装箱信息
  static get GetTransportZXDataUrl => StringServerurl+"/winningBid/Service1.asmx/GetTransportZXData";
  //关联移库单
  static final String _connectRemoveHubBill = "/winningBid/Service1.asmx/ConnectYKNumber";
  static get connectRemoveHubBillUrl => StringServerurl+_connectRemoveHubBill;

  static get appUpdateAndroidUrl => "http://218.94.37.243:8081/winningBid/Service1.asmx/ManuTransAppDownload";
  static get appUpdateIOSUrl => "http://106.14.14.212:8002/apk?app=制造物流扫码Android&format=json";


}