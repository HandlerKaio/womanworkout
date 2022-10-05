
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:healthygympractice/Sharepre/SharePrefercens.dart';

class RemoteConfigAd {

    RemoteConfigAd.init();
    static String interSplash = "Inter_splash";

   static RemoteConfigAd instances = RemoteConfigAd.init();

   getCheckInternet()async {
     try {

       final result = await InternetAddress.lookup('google.com');
       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
       }
     } on SocketException catch (e) {
        return false;
     }
     if(await SharePrefercens.instances.getAds()>0){
       return false;
     }else{
       return true;
     }

   }
   
   Future<bool> getInter_splash() async{
      if(await getCheckInternet()){
        return true;
      }
      return false;

   }
    Future<bool> getNative_language() async{
      if(await getCheckInternet()){
        return true;
      }
      return false;

    }
    Future<bool> getBanner_home() async{
      if(await getCheckInternet()){
        return true;
      }
      return false;

    }

    Future<bool> getBanner_rest_page() async{
      if(await getCheckInternet()){
        return true;
      }
      return false;

    }
    Future<bool> getNative_complete() async{
      if(await getCheckInternet()){
        return true;
      }
      return false;

    }
    Future<bool> getInter_complete() async{
      if(await getCheckInternet()){
        return true;
      }
      return false;

    }
    Future<bool> getInter_exit_exercise() async{
      if(await getCheckInternet()){
        return true;
      }
      return false;

    }
    Future<bool> getReward_exercise() async{
      if(await getCheckInternet()){
        return true;
      }
      return false;
    }
    Future<bool> getOpen_resume() async{
      if(await getCheckInternet()){
        return true;
      }
      return false;

    }
    Future<bool> getBanner_exercise() async{
      if(await getCheckInternet()){
        return true;
      }
      return false;

    }
}