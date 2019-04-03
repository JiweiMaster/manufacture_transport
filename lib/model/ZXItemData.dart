class ZXItemData{
  ZXItemData(this.mtno,this.pknm,this.odno,this.odln,this.odnm,this.whls,this.carrier,this.scarr);
  String mtno;//物料的名称
  String pknm;//数量

  int maxValue=1;//最大值
  int haveCode = 0;//已经被扫描过的数量

  String odno;//销售订单号
  String odln;//销售行数
  String odnm;//销售物品名称
  String whls;//仓位

  String carrier;
  String scarr;

}