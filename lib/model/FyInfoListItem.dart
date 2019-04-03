import 'ZXItemData.dart';
class FyInfoListItem{
  String odno;
  String pjnm;
  String shno;
  String carrier;
  String scarr;

  bool isComplete = false;

  int sumCode = 0;//发运号所有的装箱
  int hadScanCode = 0;//该发运号已经扫码的装箱

  List<ZXItemData> zxItemDatas = new List();//所有的装箱数据一起请求出来
  FyInfoListItem(responseStr){
    this.odno = responseStr['odno'];
    this.pjnm = responseStr['pjnm'];
    this.shno = responseStr['shno'];
    this.carrier = responseStr['carrier'];
    this.scarr = responseStr['scarr'];

    responseStr['zxDatas'].forEach((zxData) => {
      zxItemDatas.add(
        new ZXItemData(zxData['mtno'],zxData['pknm'],zxData['odno'],zxData['odln'],zxData['odnm'],zxData['whls'],this.carrier,this.scarr)
      )
    });
    zxItemDatas.forEach((zxItemData) => {
      this.sumCode = this.sumCode + int.parse(zxItemData.pknm)
    });

  }
}