class FyInfoListItem{
  String odno;
  String pjnm;
  String shno;
  String scarr;
  FyInfoListItem(responseStr){
    this.odno = responseStr['odno'];
    this.pjnm = responseStr['pjnm'];
    this.shno = responseStr['shno'];
    this.scarr = responseStr['scarr'];
  }
}