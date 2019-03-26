class FyInfoListItem{
  String ODNO;
  String PJNM;
  String SHNO;
  String SCARR;
  FyInfoListItem(responseStr){
    this.ODNO = responseStr['ODNO'];
    this.PJNM = responseStr['PJNM'];
    this.SHNO = responseStr['SHNO'];
    this.SCARR = responseStr['SCARR'];
  }
}