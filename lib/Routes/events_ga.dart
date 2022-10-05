

import 'dart:collection';
import 'dart:ffi';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:healthygympractice/Routes/ad_mob.dart';
import 'package:shared_preferences/shared_preferences.dart';



class EventsGA {
  static EventsGA instances= EventsGA.init();
  FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;

   EventsGA.init();

   void adImpressionWelcome(InterstitialAd bannerAd) {

     Map<String,dynamic> map = HashMap();
     bannerAd.onPaidEvent = ( ad,  valueMicros,  precision,  currencyCode) {
       map.putIfAbsent("currency", () => currencyCode);
       map.putIfAbsent("precision", () => precision.toString());
       map.putIfAbsent("adUnit", () => bannerAd.adUnitId);
       map.putIfAbsent("value", () => valueMicros/1000000);
       map.putIfAbsent("network", () => ad.responseInfo!.mediationAdapterClassName.toString());
       firebaseAnalytics.logEvent(
           name: "paid_ad_impression",
           parameters: map,
           
       );
     };







   }
   void adImpressioInter_exit_exercise(InterstitialAd bannerAd) {

     Map<String,dynamic> map = HashMap();
     bannerAd.onPaidEvent = ( ad,  valueMicros,  precision,  currencyCode) {
       map.putIfAbsent("currency", () => currencyCode);
       map.putIfAbsent("precision", () => precision.toString());
       map.putIfAbsent("adUnit", () => bannerAd.adUnitId);
       map.putIfAbsent("value", () => valueMicros/1000000);
       map.putIfAbsent("network", () => ad.responseInfo!.mediationAdapterClassName.toString());

       firebaseAnalytics.logEvent(
           name: "paid_ad_impression",
           parameters: map,
           
       );
     };







   }
   void adImpressioInter_complete(InterstitialAd bannerAd) {

     Map<String,dynamic> map = HashMap();
     bannerAd.onPaidEvent = ( ad,  valueMicros,  precision,  currencyCode) {
       map.putIfAbsent("currency", () => currencyCode);
       map.putIfAbsent("precision", () => precision.toString());
       map.putIfAbsent("adUnit", () => bannerAd.adUnitId);
       map.putIfAbsent("value", () => valueMicros/1000000);
       map.putIfAbsent("network", () => ad.responseInfo!.mediationAdapterClassName.toString());
       firebaseAnalytics.logEvent(
           name: "paid_ad_impression",
           parameters: map,
           
       );
     };







   }
  void adImpressioInterOpenApp(AppOpenAd bannerAd) {

    Map<String,dynamic> map = HashMap();
    bannerAd.onPaidEvent = ( ad,  valueMicros,  precision,  currencyCode) {
      map.putIfAbsent("currency", () => currencyCode);
      map.putIfAbsent("precision", () => precision.toString());
      map.putIfAbsent("adUnit", () => bannerAd.adUnitId);
      map.putIfAbsent("value", () => valueMicros/1000000);
      map.putIfAbsent("network", () => ad.responseInfo!.mediationAdapterClassName.toString());
      firebaseAnalytics.logEvent(
        name: "paid_ad_impression",
        parameters: map,

      );
    };







  }
   void adImpressioNative_complete( BannerAd nativeAd) {



   }

   void adImpressionRewardExcercise(InterstitialAd bannerAd) async{

    Map<String,dynamic> map = HashMap();
    bannerAd.onPaidEvent = ( ad,eMicros,  preciscyCode,currencyCode) {
      map.putIfAbsent("currency", () => currencyCode);
      map.putIfAbsent("precision", () => preciscyCode.toString());
      map.putIfAbsent("adUnit", () => AdMobManager.rewardInterExcercise);
      map.putIfAbsent("value", () => eMicros/1000000);
      map.putIfAbsent("network", () => ad.responseInfo!.mediationAdapterClassName.toString());
      firebaseAnalytics.logEvent(
          name: "paid_ad_impression",
          parameters: map,
        
      );
    };







  }




}