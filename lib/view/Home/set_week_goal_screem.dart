


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthygympractice/extensions/color.dart';
import 'package:healthygympractice/translations/locale_key.g.dart';

import '../../Sharepre/SharePrefercens.dart';

class SetWeekGoalScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()   => _SetWeekGoalScreen();
}
class _SetWeekGoalScreen extends State<SetWeekGoalScreen>{
  List<int> days = [1,2,3,4,5,6,7];
  List<String> days_week = ["MonDay","TuesDay","Wednesday","ThursDay","Friday","Saturday","Sunday"];
  int daysNow= 1;
  String dayweek= "MonDay";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:
    Scaffold(

        body:  Stack(
          children: [
            Container(
              width: 150,
              height: 210,
              child: Image.asset("assets/bg/bg_language1.png",fit: BoxFit.fitHeight,),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.topRight,
              child: Image.asset("assets/bg/bg_language.png",fit: BoxFit.fitHeight,width: 140,height: 320,),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: 80,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 150),
                  child: Image.asset("assets/icon/goal.png"),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text("SET YOUR WEEKLY GOAL",style: GoogleFonts.oswald(
                    fontWeight: FontWeight.w500,
                    fontSize: 23,
                    color: "#676767".toColor()
                  ),),
                ),
                Container(
                  margin: EdgeInsets.only(left: 25,right: 25),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text("We recommend training at least 3 days weekly for a better result",style: GoogleFonts.oswald(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: "#676767".toColor()
                  ),textAlign: TextAlign.center,),
                ),
                Container(
                  margin: EdgeInsets.only(left: 25,right: 25,top: 30),
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Text("Weekly traning days",style: GoogleFonts.oswald(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: "#3E3E3E".toColor()
                  ),textAlign: TextAlign.center,),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 25,right: 25),
                  height: 50,
                  child: DropdownButton<int>(
                    value: daysNow,
                    isExpanded: true,
                    icon: Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: Icon(Icons.keyboard_arrow_down,color: "#FF193D".toColor(),),
                    ),
                    underline: Divider(
                      color: "#DADADA".toColor(),
                    ),
                    onChanged: (daysChange){
                      setState(() {
                        daysNow = daysChange!;
                      });
                    },
                    items: days.map((e) {
                      return DropdownMenuItem(value: e,child: Padding(padding: EdgeInsets.only(bottom: 12),child: Text("$e days",style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:  "#FF193D".toColor()
                      ),),),);
                    }).toList(),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 25,right: 25,top: 30),
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Text("First day week",style: GoogleFonts.oswald(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: "#3E3E3E".toColor()
                  ),textAlign: TextAlign.center,),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 25,right: 25),
                  height: 50,
                  child: DropdownButton<String>(
                    value: dayweek,
                    isExpanded: true,
                    icon: Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: Icon(Icons.keyboard_arrow_down,color: "#FF193D".toColor(),),
                    ),
                    underline: Divider(
                      color: "#DADADA".toColor(),
                    ),
                    onChanged: (daysChange){
                      setState(() {
                        dayweek = daysChange!;
                      });
                    },
                    items: days_week.map((e) {
                      return DropdownMenuItem(value: e,child: Padding(padding: EdgeInsets.only(bottom: 12),child: Text("$e",style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:  "#FF193D".toColor()
                      ),),),);
                    }).toList(),
                  ),
                ),
                Spacer(flex: 1,),
                InkWell(

                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async{
                       SharePrefercens.instances.setTrainingDays(daysNow);
                  },

                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 25,right: 25,bottom: 25,),
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient:  LinearGradient(

                            begin:  Alignment.centerLeft,
                            end: Alignment.centerRight,

                            colors: [
                              "#FF4A61".toColor().withOpacity(0.8),
                              "#FF193D".toColor().withOpacity(0.9)
                            ]
                        )
                    ),
                    alignment: Alignment.center,
                    child: Text(LocaleKeys.button_go.tr(),style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white

                    ),),
                  ),
                ),
              ],
            )

          ],
        )
    ), onWillPop: ()async=>false);
  }

}