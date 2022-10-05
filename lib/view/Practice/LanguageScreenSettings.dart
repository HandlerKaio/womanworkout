

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:healthygympractice/Routes/RoutesManager.dart';
import 'package:healthygympractice/Routes/ad_mob.dart';
import 'package:healthygympractice/Sharepre/SharePrefercens.dart';
import 'package:healthygympractice/main.dart';
import 'package:healthygympractice/remote/remote_config.dart';
import 'package:healthygympractice/translations/locale_key.g.dart';
import 'package:healthygympractice/view/Home/HomeScreen.dart';


import '../../models/Languagemodel.dart';

class LanguageScreenSettings extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return _LanguageScreenSettings();
  }

}
class _LanguageScreenSettings extends State<LanguageScreenSettings>{

  List<Languagemodel> list = [];
  int current_index = 0;
  AdWidget? adWidget;
  NativeAd ?bannerAd;
  bool isBannerLoaded = false;
  bool isBannerNative = false;
  int ads = 0;
  String language ="en";
  init() async{
    final f_language   = await SharePrefercens.instances.getLanguage();
    final fBannerNative   = await RemoteConfigAd.instances.getNative_language();
    String language_switch ="en";
    if(f_language!=null){
      language_switch = f_language;
      language = f_language;
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
    setState(() {
      list = Languagemodel.instances.getDataListLanguage();
      isBannerNative = fBannerNative;
      for(var i =  0 ; i<list.length ;i++){
        final  language = list[i];
        if(language.language.toString() == f_language){
          current_index = i;

        }
      }
    });
  }
  @override
  void initState() {
    super.initState();
    init();
    initAds();

  }
  initAds() async{
    final fads  =await SharePrefercens.instances.getAds();
    ads = fads;
    if(ads<1){
      createBannerNative();
    }
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(child:  Scaffold(
      backgroundColor: Colors.white,
      body:  SingleChildScrollView(
        child: Stack(
          children: [

            Container(
              width: 100,
              height: 180,
              child: Image.asset("assets/bg/bg_language1.png",fit: BoxFit.fitHeight,),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.topRight,
              child: Image.asset("assets/bg/bg_language.png",fit: BoxFit.fitHeight,width: 140,height: 320,),
            ),
            Container(
              width: double.infinity,
              height: 75,
              padding: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin:  Alignment.centerLeft,
                      end:  Alignment.centerRight,
                      colors: [
                        Colors.red.shade400,
                        Colors.red.shade800
                      ]

                  )
              ),
              child: Row(

                children: [
                  Expanded(child: Text(LocaleKeys.mine_language_options.tr(),style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),textAlign: TextAlign.center,)),
                  IconButton(onPressed: (){
                    SharePrefercens.instances.setLanguage(list[current_index].language.toString());
                     context.setLocale(Locale(list[current_index].language.toString()));
                     if(language == list[current_index].language.toString()){
                       RoutesManager.instances.RoutesGotoPage(context, HomeScreen());
                     }else{
                       RoutesManager.instances.RoutesGotoPage(context, MyApp(0));
                     }

                  }, icon: const Icon(Icons.check,color: Colors.white,))
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
                  Expanded(flex: 1,child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context,index)=>itemsLanguage(list[index],index)),),
                  isBannerLoaded && isBannerNative && ads<1? Container(
                      height: 305,
                      width: 350,
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(15)
                      ),


                      child: bannerAd!=null ? AdWidget(ad: bannerAd!) : Container()

                  ) : Container()
                ],
              ),
            )



          ],
        ),
      )

    ), onWillPop: ()async=>false);

  }
  itemsLanguage(Languagemodel languagemodel,int index){
    return InkWell(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 10,right: 10),
        height: 60,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Image.asset(languagemodel.icon.toString(),width: 24,height: 24,),
                  Padding(padding: EdgeInsets.only(left: 5),child: Text(languagemodel.name.toString()),),
                  Spacer(flex: 1,),
                  index == current_index ? Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.blueAccent
                        )
                    ),
                    child:  Container(
                        width: 16,
                        height: 16,
                        margin: EdgeInsets.all(3),

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.blueAccent
                        )
                    ),
                  ) : Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),

                          border: Border.all(
                              color: Colors.blueAccent
                          )
                      )
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey.shade300,height: 3,)

          ],
        ),
      ),
      onTap: (){
        setState(() {
          current_index =index;
        });
      },
    );
  }
  void createBannerNative(){

    bannerAd = NativeAd(
      adUnitId: AdMobManager.nativeLanguage,
      request: AdRequest(),

      listener: NativeAdListener(
          onAdLoaded: (ad){
            setState(() {
              isBannerLoaded = true;
            });

          }
      ), factoryId: 'Listitle',
    )..load();


  }
  @override
  void dispose() {
   if(ads<1){
     bannerAd!.dispose();
   }
    super.dispose();
  }

}