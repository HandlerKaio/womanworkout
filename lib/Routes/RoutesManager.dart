


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoutesManager {
  RoutesManager._();

  static RoutesManager instances = RoutesManager._();

  Future<void> RoutesGotoPage(BuildContext context, Widget Screen) async {
    Navigator.pushReplacement(context, PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 120),
        transitionsBuilder:  (BuildContext context, Animation<double> animation,
        Animation<double> second,Widget screen){
          return ScaleTransition(
            child: screen,
            alignment: Alignment.bottomRight, scale: animation,
          );
        },
        pageBuilder:
        (BuildContext context, Animation<double> animation,
            Animation<double> second) {
      return Screen;
    }));

  }
  Future<void> RoutePush(BuildContext context, Widget Screen) async {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Screen), (route) => false);
  }
  Future<void> routesNewPage(BuildContext context, Widget Screen) async {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Screen));
  }

}
