


import 'package:flutter/cupertino.dart';

class ResponSiveScreen{

  double height  = 0 ;
  double width = 0;
  ResponSiveScreen.init();
  static ResponSiveScreen instances  = ResponSiveScreen.init();
  static getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  static getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}