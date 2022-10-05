import 'dart:collection';
import 'dart:isolate';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:healthygympractice/Routes/RoutesManager.dart';
import 'package:healthygympractice/Routes/ad_mob.dart';
import 'package:healthygympractice/Sharepre/SharePrefercens.dart';
import 'package:healthygympractice/main.dart';
import 'package:healthygympractice/remote/remote_config.dart';
import 'package:healthygympractice/view/Spass/WelComeScreen.dart';

import '../../models/Languagemodel.dart';

class LanguageScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LanguageScreen();
  }
}

class _LanguageScreen extends State<LanguageScreen> {
  List<Languagemodel> list = [];
  int current_index = 0;
  AdWidget? adWidget;
 static NativeAd? bannerAd;
  bool isBannerLoaded = false;
  int ads = 0;
  int tapload = 0;
  String language ="";

  init() async {
    final fNameLanguage = await SharePrefercens.instances.getLanguage();
    setState(() {
      language=fNameLanguage;
      list = Languagemodel.instances.getDataListLanguage();
      for (var i = 0; i < list.length; i++) {
        final language = list[i];
        if (language.name.toString() == fNameLanguage) {
          current_index = i;
        }
      }
    });

  }

  @override
  void initState() {
    super.initState();
    initAds();
    init();
  }


  initAds() async {
    final fads = await SharePrefercens.instances.getAds();
    ads = fads;
    if(ads<1){
      createBannerNative();
    }



  }



  @override
  Widget build(BuildContext context) {
    SharePrefercens.instances
        .setWidth(MediaQuery.of(context).size.width.toInt());
    return WillPopScope(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 180,
                    child: Image.asset(
                      "assets/bg/bg_language1.png",
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      "assets/bg/bg_language.png",
                      fit: BoxFit.fitHeight,
                      width: 140,
                      height: 320,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 75,
                    padding: const EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                          Colors.red.shade400,
                          Colors.red.shade800
                        ])),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          "LANGUAGE",
                          style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )),
                         tapload==1 ? IconButton(
                             onPressed: () {
                               if(language.toLowerCase() == list[current_index].language.toString().toLowerCase()){
                                 RoutesManager.instances.RoutesGotoPage(context, WelComeScreen());
                               }else{
                                 RoutesManager.instances.RoutesGotoPage(context, MyApp(0));
                               }
                               SharePrefercens.instances.setLanguage(list[current_index].language.toString());
                               SharePrefercens.instances.setSkipTutorial(2);
                               context.setLocale(Locale(
                                   list[current_index].language.toString()));

                             },
                             icon: const Icon(
                               Icons.check,
                               color: Colors.white,
                             )) : Container(
                           width: 24,
                           height: 24,
                           child: const CircularProgressIndicator(),
                         )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 700,
                    margin: EdgeInsets.only(top: 65),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) =>
                                  ItemsLanguage(list[index], index)),
                        ),
                        isBannerLoaded && ads < 1
                            ? Container(
                                height: 305,
                                width: 350,
                                margin: const EdgeInsets.only(bottom: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(color: Colors.grey.shade200),
                                    borderRadius: BorderRadius.circular(15)),
                                child: bannerAd != null
                                    ? AdWidget(ad: bannerAd!)
                                    : Container())
                            : Container()
                      ],
                    ),
                  )
                ],
              ),
            )),
        onWillPop: () async => false);
  }

  ItemsLanguage(Languagemodel languagemodel, int index) {
    return InkWell(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 10, right: 10),
        height: 60,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Image.asset(
                    languagemodel.icon.toString(),
                    width: 24,
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(languagemodel.name.toString()),
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  index == current_index
                      ? Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                              border: Border.all(color: Colors.blueAccent)),
                          child: Container(
                              width: 16,
                              height: 16,
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.blueAccent)),
                        )
                      : Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.blueAccent))),
                ],
              ),
            ),
            Divider(
              color: Colors.grey.shade300,
              height: 3,
            )
          ],
        ),
      ),
      onTap: () {
        setState(() {
          current_index = index;
          SharePrefercens.instances.setLanguage(languagemodel.name.toString());
        });
      },
    );
  }

  void createBannerNative() {
   bannerAd =  NativeAd(
      adUnitId: AdMobManager.nativeLanguage,
      request: const AdRequest(),
      listener: NativeAdListener(

        onAdLoaded: (ad) {
          isBannerLoaded=true;
          tapload=1;


        },
        onAdFailedToLoad: (ad,_){
          isBannerLoaded=false;
          tapload=1;

        },
        onAdImpression: (ad){
        },
        onPaidEvent: (ad, eMicros, preciscyCode, currencyCode) {
          FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
          Map<String, dynamic> map = HashMap();
          map.putIfAbsent("currency", () => currencyCode);
          map.putIfAbsent("precision", () => preciscyCode.toString());
          map.putIfAbsent("adUnit", () => ad.adUnitId);
          map.putIfAbsent("value", () => eMicros / 1000000);
          map.putIfAbsent("network",
              () => ad.responseInfo!.mediationAdapterClassName.toString());
          firebaseAnalytics.logEvent(
            name: "paid_ad_impression",
            parameters: map,
          );
        },
      ),
      factoryId: 'Listitle',
    )..load();


  }


}
