

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthygympractice/Routes/reminder.dart';
import 'package:healthygympractice/translations/locale_key.g.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Routes/RoutesManager.dart';
import '../../Sharepre/SharePrefercens.dart';
import '../Home/HomeScreen.dart';
import 'dart:developer' as developer;
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';


class ReminderScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_ReminderScreen();

}
class _ReminderScreen extends State<ReminderScreen>{
  int hour = 0;
  int minutes = 0;
   List<int> items_hours =[];
   List<int> items_minutes =[];
  String timer="";
  int currentMinutes = 0;
  int currentHours = 0;
  static SendPort? uiSendPort;
  final ReceivePort port = ReceivePort();
  @override
  void initState() {
    super.initState();
    Reminder.instances.init();
     init();

    port.listen((data) async{

      return data;
    });

  }
  init()async{
    final fMinutes = await SharePrefercens.instances.getMinutes();
    final fHours = await SharePrefercens.instances.getHour();

    for(int i=0;i<=59;i++){
      items_minutes.add(i);
    }
    for(int i=0;i<=23;i++){
      items_hours.add(i);
    }

    Future.delayed(const Duration(milliseconds: 230),(){
      setState(() {
        currentHours = fHours;
        currentMinutes = fMinutes;
        hour = fHours;
        minutes = fMinutes;
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.mine_reminder.tr().toUpperCase()),
        elevation: 0,
        backgroundColor: Colors.pink.shade400,
        leading: IconButton(onPressed: (){
       Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
      ),
      body:  getAlarm(),
    ), onWillPop: ()async{
      Navigator.pop(context);
      return true;
    });
  }
  getAlarm(){

    return Column(

      children: [
        Container(
          width: 94,
          height: 64,
          margin: const EdgeInsets.only(top: 100),
          child: Image.asset("assets/icon/alarm.png"),
        ),

        Padding(padding: const EdgeInsets.only(left: 5,right: 5,),child: Text(LocaleKeys.description_set_reminder.tr(),style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700
        ),),),
        Padding(padding: EdgeInsets.only(left: 5,right: 5,top: 9),child: Text(LocaleKeys.description_reminder.tr(),style: GoogleFonts.roboto(
            fontSize: 15,
            color: Colors.grey.shade500
        ),textAlign: TextAlign.center,),),
        Container(
          width: 220,
          margin: const EdgeInsets.only(top: 30),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              items_hours.isNotEmpty ? Expanded(child: Container(
                width: 120,
                margin: const EdgeInsets.only(left: 50,),
                child: CupertinoPicker(
                    itemExtent: 80,
                    scrollController: FixedExtentScrollController(initialItem: currentHours),
                    backgroundColor: Colors.transparent,


                    onSelectedItemChanged: (int value) {
                      setState(() {
                        hour = items_hours[value];
                        SharePrefercens.instances.setTimer(hour, minutes);

                      });
                    },
                    selectionOverlay:  Container(),
                    children: items_hours.map((e) => Center(child: Column(
                      children: [
                        Padding(padding: EdgeInsets.only(top: 10,),child: Text(e> 9 ? "$e":"0$e",style: GoogleFonts.roboto(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700
                        ),),),
                        Container(
                          width: 40,
                          child: Divider(thickness: 1,color: Colors.grey.shade400,),
                        )
                      ],
                    ),)).toList()
                ),
              )) : Container(),

              Padding(padding: EdgeInsets.only(left: 5,right: 5,top: 8),child: Text(":",style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),),),

             items_minutes.isNotEmpty  ?  Expanded(child: Container(
               width: 180,
               margin: const EdgeInsets.only(right: 50),
               child: CupertinoPicker(
                   itemExtent: 80,
                   backgroundColor: Colors.transparent,
                   scrollController: FixedExtentScrollController(initialItem: currentMinutes),

                   onSelectedItemChanged: (int value) {
                     setState(() {
                       minutes = items_minutes[value];
                       SharePrefercens.instances.setTimer(hour, minutes);

                     });
                   },
                   selectionOverlay:  Container(),
                   children: items_minutes.map((e) => Center(child: Column(
                     children: [
                       Padding(padding: EdgeInsets.only(top: 10,),child: Text(e>9? "$e":"0$e",style: GoogleFonts.roboto(
                           fontSize: 24,
                           fontWeight: FontWeight.bold,
                           color: Colors.grey.shade700
                       ),),),
                       Container(
                         width: 40,
                         child: Divider(thickness: 1,color: Colors.grey.shade400,),
                       )
                     ],
                   ),)).toList()
               ),
             )) : Container()
            ],
          ),
        ),

        const Spacer(flex: 1,),
        InkWell(

          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: (){
            setState(() {
              SharePrefercens.instances.setTimer(hour,minutes);
              Navigator.pop(context);



            });
          },

          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 25,right: 25,bottom: 25),
            height: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                gradient:  LinearGradient(

                    begin:  Alignment.centerLeft,
                    end: Alignment.centerRight,

                    colors: [
                      Colors.pink.shade200,
                      Colors.pink.shade300
                    ]
                )
            ),
            alignment: Alignment.center,
            child: Text(LocaleKeys.t_confirm.tr(),style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white

            ),),
          ),
        ),

      ],
    );
  }

  void runAlarm()  async{

    final int isolateId = Isolate.current.hashCode;
    int hours = hour;
    int minutess = minutes;
     if(DateTime.now().hour>= hour){
       hours = DateTime.now().hour - hour;
     }else{
       hours  = hour - DateTime.now().hour;
     }
    if(DateTime.now().minute>= minutes){
      minutess =  DateTime.now().minute - minutes;
    }else{
      minutess = minutes - DateTime.now().minute;
    }

    AndroidAlarmManager.oneShot( Duration(hours: hours,minutes: minutess),isolateId,  callback,wakeup: true,exact: true,rescheduleOnReboot: true,allowWhileIdle: true);

  }
   Future<void> callback() async {
    if(hour>=DateTime.now().hour &&minutes>DateTime.now().minute+2){

    }else{
      Reminder.instances.showNotifications();
    }
    uiSendPort ??= IsolateNameServer.lookupPortByName("reminder");
    uiSendPort?.send("hi");
  }
}