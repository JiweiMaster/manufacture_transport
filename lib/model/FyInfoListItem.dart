class FyInfoListItem{
  String odno;
  String pjnm;
  String shno;
  String scarr;
  bool isComplete = false;
  FyInfoListItem(responseStr){
    this.odno = responseStr['odno'];
    this.pjnm = responseStr['pjnm'];
    this.shno = responseStr['shno'];
    this.scarr = responseStr['scarr'];
  }
}