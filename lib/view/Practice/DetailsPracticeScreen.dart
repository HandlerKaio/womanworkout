


import 'dart:isolate';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:healthygympractice/Routes/RoutesManager.dart';
import 'package:healthygympractice/Routes/ad_mob.dart';
import 'package:healthygympractice/Sharepre/SharePrefercens.dart';
import 'package:healthygympractice/extensions/color.dart';
import 'package:healthygympractice/models/CategoryModel.dart';
import 'package:healthygympractice/models/PlansModel.dart';
import 'package:healthygympractice/remote/remote_config.dart';
import 'package:healthygympractice/translations/locale_key.g.dart';

import 'package:healthygympractice/view/Home/HomeScreen.dart';
import 'package:healthygympractice/view/MINE/remove_ads.dart';
import 'package:healthygympractice/view/Practice/ExcersieScreen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:intl/intl.dart' as intl;

import '../../Routes/events_ga.dart';
import '../../models/SplasModel.dart';

class DetailsPracticeScreen extends StatefulWidget{
  CategoryModel splasModel;
  DetailsPracticeScreen(this.splasModel);
  @override
  State<StatefulWidget> createState()=> _DetailsPracticeScreen();

}
class _DetailsPracticeScreen extends State<DetailsPracticeScreen>
 with WidgetsBindingObserver{
  List<PlansModel> list_plan = [];
  int indexSelects = 0;
  double percent = 0;
  bool isAds  = false;
  int currentIndex = 0;
  int perCent = 0;
  bool isRewardExcers = false;

  int countPause =0;
  int countInActive = 0;
  AppOpenAd ? _appOpenAd;
  static InterstitialAd ? interstitialAd;
  int ads = 0;
  int tapLoad = 0;
  int load = 0;

  void _createInterstitialAd() {

    InterstitialAd.load(
        adUnitId: AdMobManager.rewardInterExcercise,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {

              setState(() {
                interstitialAd= ad;
                isAds=true;
                tapLoad=1;
              });


          },
          onAdFailedToLoad: (LoadAdError error) {
            setState(() {
              isAds=false;
              tapLoad=1;
            });

          },
        ));
  }
  init() async{
    final f_list = await PlansModel.instances.getDataList(widget.splasModel.id!.toInt());

     setState(() {

        list_plan = f_list;
        for(var i in list_plan){
          percent+= double.parse(i.dayprogress.toString().trim());

        }
        for(int i = 0 ;i <list_plan.length;i++){
          if(i>0){
            double checkPractice = double.parse(list_plan[i-1].dayprogress.toString()) * 100;
            if(checkPractice>=99){
              currentIndex = i;
            }
          }else{
            currentIndex = 0;
          }


        }
        percent=(percent/28)*100;
     });
  }
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    initAds();
    init();



  }
  initAds() async{
    final fads = await SharePrefercens.instances.getAds();
    ads = fads;
    if(ads<1){
      interAds();
      loadAd();
    }else{
      setState(() {
        tapLoad=1;
      });
    }
  }
   void interAds() async{

    final port = ReceivePort();
    final isolate =  await  Isolate.spawn(interAdsIsolate, port.sendPort);
     port.listen((message) {
       _createInterstitialAd();
     });
    isolate.kill(priority: Isolate.immediate);
  }
  static void interAdsIsolate(SendPort sendPort) {
      sendPort.send(0);
  }


  void loadAd() {
    AppOpenAd.load(
      adUnitId: AdMobManager.openResumed,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          EventsGA.instances.adImpressioInterOpenApp(ad);
        },
        onAdFailedToLoad: (error) {

        },
      ),
    );
  }
  @override
  void setState(VoidCallback fn) {
    if(!mounted) return;
    super.setState(fn);
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(child: Scaffold(


      body:  Column(
        children: [
          Container(
            width: double.infinity,
            height: 225,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,

                    image: AssetImage(widget.splasModel.background.toString())
                )
            ),
            child: Stack(
              children: [
                Positioned(

                  child: Container(
                    margin: EdgeInsets.only(right: 45,top: 25),

                    child: Image.asset(widget.splasModel.icon.toString()),
                  ),
                  right: 0,
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      IconButton(onPressed: (){
                        RoutesManager.instances.RoutesGotoPage(context, HomeScreen());
                      }, icon: const Icon(Icons.arrow_back,color: Colors.white,size: 20,)),
                      Padding(padding: const EdgeInsets.only(left: 2,),child: Text("7X4 CHALLENGE",style: GoogleFonts.robotoFlex(
                          fontSize: 14,
                          color: Colors.white
                      ),),),
                      const Spacer(flex: 1,),
                      IconButton(onPressed: (){
                        showReset();
                      }, icon: Image.asset("assets/icon/reset.png",color: Colors.white,))

                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 240,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 50,
                        margin: const EdgeInsets.only(top: 110),
                        alignment: Alignment.centerLeft,
                        child:  Padding(padding: EdgeInsets.only(left: 15),child: Text(widget.splasModel.name.toString(),style: GoogleFonts.robotoFlex(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),),),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 10, right: 10,top: 15),
                        width: double.infinity,
                        height: 5,
                        child: FAProgressBar(
                          maxValue: 100,
                          currentValue: percent,
                          borderRadius: BorderRadius.circular(0),
                          progressColor: Colors.pink.shade600,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Container(
                        height: 30,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  LocaleKeys.t_days_28.tr(),
                                  style: TextStyle(color: Colors.white,fontSize: 14),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10,right: 10),
                                child: Text(
                                  "${percent.toStringAsFixed(1)}%",
                                  style: const TextStyle(color: Colors.white),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                )


              ],
            ),

          ),
          list_plan.isNotEmpty ?Expanded(child: ListView.builder(
              itemCount: list_plan.length,
              itemBuilder: (context, index) =>
                  itemsPlanDay(list_plan[index], index)),) : Container(),
          ads<1 ? tapLoad==1 ?  InkWell(
            onTap: (){
              if(isAds){
                 interstitialAd!.show();
                 interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(

                     onAdShowedFullScreenContent:  (InterstitialAd ad) {
                       RoutesManager.instances.RoutePush(context, ExcersieScreen(widget.splasModel, list_plan[currentIndex]));
                     },
                     onAdImpression: (InterstitialAd ad) {
                       EventsGA.instances.adImpressionWelcome(ad);
                     }
                 );
              }else{
                _createInterstitialAd();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(LocaleKeys.ads_description_no_network.tr()),duration: const Duration(seconds: 2),),);

              }


            },
            splashColor:  Colors.grey.shade200,
            highlightColor: Colors.grey.shade200,
            child: Container(
                width: 328,
                height: 48,
                margin: const EdgeInsets.only(bottom: 35,left: 25,right: 25,top: 5,),
                decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                        colors: [
                          Colors.orange.withOpacity(0.8),
                          Colors.pink.withOpacity(0.7)
                        ]
                    )
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(LocaleKeys.t_go.tr(),style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.white
                    ),),
                  ],
                )
            ),
          ) :Container(
              width: double.infinity,
              height: 30,
              alignment: Alignment.center,
              child: SizedBox(
                width: 24,
                height: 24,
                child: const CircularProgressIndicator(),
              )
          ): InkWell(
            onTap: (){
              RoutesManager.instances.RoutePush(context, ExcersieScreen(widget.splasModel, list_plan[currentIndex]));
            },
            splashColor:  Colors.grey.shade200,
            highlightColor: Colors.grey.shade200,
            child: Container(
              width: 328,
              height: 48,
              margin: EdgeInsets.only(bottom: 35,left: 25,right: 25),
              decoration:  BoxDecoration(
                  color: Colors.pink.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(50)
              ),
              alignment: Alignment.center,
              child: Text(LocaleKeys.t_go.tr(),style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 23,
                  color: Colors.white
              ),),
            ),
          ),



        ],
      ),


    ), onWillPop: ()async{
      RoutesManager.instances.RoutesGotoPage(context, HomeScreen());
      return true;
    });
  }
 
  itemsPlanDay(PlansModel planDaysModel, index_select) {
    double percent = double.parse(planDaysModel.dayprogress.toString()) * 100;
    double checkPractice = 0;
    if(index_select>0){
       checkPractice = double.parse(list_plan[index_select-1].dayprogress.toString()) * 100;
    }


    return index_select==0 || checkPractice>=99  ? InkWell(
      onTap: () {
        if(indexSelects == 0 || checkPractice>=99){
          if(ads<1){
            if(isAds){
              interstitialAd!.show();
              interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(

                  onAdShowedFullScreenContent:  (InterstitialAd ad) {
                    RoutesManager.instances.RoutePush(context, ExcersieScreen(widget.splasModel, list_plan[currentIndex]));
                  },
                  onAdImpression: (InterstitialAd ad) {
                    EventsGA.instances.adImpressionWelcome(ad);
                  }
              );
            }else{
              _createInterstitialAd();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(LocaleKeys.ads_description_no_network.tr()),duration: const Duration(seconds: 2),),);

            }

           
          }else{
            RoutesManager.instances.RoutePush(context, ExcersieScreen(widget.splasModel, planDaysModel));

          }

        }else{
        }





      },
      child:  Container(
        width: double.infinity,
        height: 80,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(left: 15, right: 15, top: 10,bottom: 10),
        decoration: BoxDecoration(
            color:  Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 6,
                  offset: const Offset(1.0, 1.0))
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                "${LocaleKeys.description_day.tr()} ${planDaysModel.DayName}",
                style: GoogleFonts.robotoFlex(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
            ),
            const Spacer(
              flex: 1,
            ),
            percent<100  ? Container(
              margin: EdgeInsets.only(right: 8),
              width: 60,
              height: 60,
              child: CircularPercentIndicator(
                radius: 45,
                animation: true,
                backgroundWidth: 3.5,
                percent: double.parse(planDaysModel.dayprogress.toString().trim()),
                lineWidth: 3.0,
                backgroundColor: Colors.grey,
                center: Text(
                  "${percent.toStringAsFixed(0)} % ",
                  style: const TextStyle(
                      color: Colors.red,
                      fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ),
            )  : Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(right: 8),
              child:  Image.asset("assets/icon/final_sucess.png",height: 45,width: 45,),
            )

          ],
        ),
      )
    ) :InkWell(

        child:  Container(
          width: double.infinity,
          height: 80,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(left: 15, right: 15, top: 10,bottom: 10),
          decoration: BoxDecoration(
              color:  Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 6,
                    offset: Offset(1.0, 1.0))
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  "${LocaleKeys.description_day.tr()} ${planDaysModel.DayName}",
                  style: GoogleFonts.robotoFlex(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const Spacer(flex: 1),
              percent<100  ? Container(
                margin: const EdgeInsets.only(right: 8),
                width: 60,
                height: 60,
                child: CircularPercentIndicator(
                  radius: 45,
                  animation: true,
                  backgroundWidth: 3.5,
                  percent: double.parse(planDaysModel.dayprogress.toString().trim()),
                  lineWidth: 3.0,
                  backgroundColor: Colors.grey,
                  center: Text(
                    "${percent.toStringAsFixed(0)} % ",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ),
              )  : Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.only(right: 8),
                child:  Image.asset("assets/icon/final_sucess.png",height: 45,width: 45,),
              )

            ],
          ),
        )
    );
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state== AppLifecycleState.inactive){
      countInActive=1;
    }
    if(state==AppLifecycleState.paused){
      countPause=1;
    }
    if(state==AppLifecycleState.resumed){
      if(countInActive==1 && countPause==1 && ads<1){
        _appOpenAd!.show();
        countInActive=0;
        countInActive=0;
      }
    }
  }
  void showReset() {

    showDialog(context: context, builder: (context){

      return AlertDialog(
        title: Text(LocaleKeys.notifications_progress.tr(),style: GoogleFonts.robotoFlex(
          fontSize: 14,
          color: Colors.grey.shade700
        ),),
        actions: [
          SizedBox(
            width: 90,
            height: 30,
            child: RaisedButton(onPressed: (){
              PlansModel.instances.UpdateAllProgess(0);
              setState(() {
                init();
              });
              Navigator.pop(context);
            },
              color: Colors.pink.shade400,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              child: const Text("OK"),),
          ),
          SizedBox(
            width: 90,
            height: 30,
            child: RaisedButton(onPressed: (){

              Navigator.pop(context);
            },
              color: Colors.grey.shade400,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              child: const Text("Cancel"),),
          )
        ],
      );
    });
  }

  @override
  void dispose() {
    if(ads<1){
      if(_appOpenAd!=null) _appOpenAd!.dispose();
      if(interstitialAd!=null) interstitialAd!.dispose();
    }
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

}