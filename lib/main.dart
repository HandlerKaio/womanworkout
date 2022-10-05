
import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



import 'package:healthygympractice/Routes/RoutesManager.dart';
import 'package:healthygympractice/Routes/reminder.dart';
import 'package:healthygympractice/remote/remote_config.dart';
import 'package:healthygympractice/translations/codegen_loader.g.dart';
import 'package:healthygympractice/view/Home/HomeScreen.dart';

import 'package:healthygympractice/view/Spass/LanguageScreen.dart';
import 'package:healthygympractice/view/Spass/WelComeScreen.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';

import 'Sharepre/SharePrefercens.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:facebook_app_events/facebook_app_events.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  EasyLocalization.ensureInitialized();
 final facebookAppEvents = FacebookAppEvents();

  MobileAds.instance.initialize();
  Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  AndroidAlarmManager.initialize();
  final ReceivePort port = ReceivePort();
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    "reminder",
  );
  final f_language   = await SharePrefercens.instances.getLanguage();
  String language ="en";
  String language_switch ="en";
   if(f_language!=null){
     language_switch = f_language;
   }
   switch(language_switch){
     case "English": language="en";break;
     case "Spanish": language="es";break;
     case "Portuguese": language="pt";break;
     case "Chinese": language="zh";break;
     case "Indonesian": language="in";break;
     case "India": language="hi";break;
     case "Vietnamese": language="vi";break;
   }

  runApp(EasyLocalization(
      child: MyApp(0),
      fallbackLocale: Locale(language),
      startLocale: Locale(language),
      assetLoader: const CodegenLoader(),
      supportedLocales: const [
        Locale(
          'vi',
        ),
        Locale(
          'en',
        ),
        Locale(
          'es',
        ),
        Locale(
          'hi',
        ),

        Locale(
          'zh',
        ),
        Locale(
          'pt',
        ),
      ], path: 'assets/translations',));
}

class MyApp extends StatelessWidget {
 int current = 0;
 MyApp(this.current, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: "Women's Home Workout: Fat Burn",
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,

        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(current));
  }
}

class HomePage extends StatefulWidget {
  int current;
  HomePage(this.current);
  @override
  State<StatefulWidget> createState() {
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> with TickerProviderStateMixin {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Container(
              width: double.infinity,
              height: double.infinity,
              child: Lottie.asset("assets/data.json",
                  fit: BoxFit.fill,
                  animate: true, reverse: false)),

        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
     init();




  }

  init()async{
    final facebook = FacebookAppEvents();
    facebook.setAutoLogAppEventsEnabled(true);
    Reminder.instances.init();
    final f_skip   = await SharePrefercens.instances.getSkipTutorial();

    Future.delayed(Duration(seconds: 4), () {
      RemoteConfigAd.instances.getNative_language();

      if(f_skip!=null){
         if(f_skip==1){
           RoutesManager.instances.RoutePush(context, WelComeScreen());
         }else if(f_skip==2){
           RoutesManager.instances.RoutePush(context, WelComeScreen());
         }else if(f_skip==0){
           RoutesManager.instances.RoutePush(context, LanguageScreen());
         }
      }else{
        if(widget.current>1){
          RoutesManager.instances.RoutePush(context, HomeScreen());
        }else{
          RoutesManager.instances.RoutePush(context, LanguageScreen());
        }
     }


    });
  }


  @override
  void setState(VoidCallback fn) {
    if(!mounted) return;
    super.setState(fn);

  }


}
