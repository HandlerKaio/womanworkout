



import 'dart:isolate';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:healthygympractice/Sharepre/SharePrefercens.dart';
import 'package:healthygympractice/extensions/color.dart';
import 'package:healthygympractice/models/CategoryModel.dart';
import 'package:healthygympractice/models/PracticeModel.dart';
import 'package:healthygympractice/translations/locale_key.g.dart';
import 'package:healthygympractice/view/Home/HomeScreen.dart';
import 'package:healthygympractice/view/MINE/remove_ads.dart';
import 'package:healthygympractice/view/Practice/DescriptionLevelScreen.dart';
import 'package:healthygympractice/view/Practice/WorkPlayPlanLevelScreen.dart';
import 'package:healthygympractice/view/Practice/WorkPlayScreen.dart';

import '../../Routes/RoutesManager.dart';
import '../../Routes/ad_mob.dart';
import '../../Routes/events_ga.dart';
import '../../remote/remote_config.dart';
import 'DescriptionExerciseScreen.dart';

class PlanLevelScreen extends StatefulWidget{
  CategoryModel categoryModel;
  PlanLevelScreen(this.categoryModel);
  @override
  State<StatefulWidget> createState()  => _PlanLevelScreen();
}
class  _PlanLevelScreen extends State<PlanLevelScreen>{
  List<PracticeModel> list_practice = [];
  int numWorkOut = 0;
  int numMinutes = 0;
  bool isRewardExcers = false;
  int perCent = 0;
  int showingAds = 0;
  int ads = 0;
  int tapLoad =0;
  int load =0;
  int tapAll = 0;
  InterstitialAd? interstitialAd;
  init()async{

     final f_list = await PracticeModel.instances.getDataListPractice(widget.categoryModel.id!.toInt(), 1);
     setState(() {
       list_practice = f_list;
       numWorkOut = list_practice.length;
       numMinutes= list_practice.length-4;

     });
  }

  @override
  void initState() {
    super.initState();
    interAdsInter();
    init();
   
  }
  void interAdsInter() async{
    final fAds = await SharePrefercens.instances.getAds();
    ads = fAds;
    if(ads<1){
      final port = ReceivePort();
      final isolate =  await  Isolate.spawn(interAdsIsolate, port.sendPort);
      port.listen((message) {
        _createInterstitialAd();
      });
      isolate.kill(priority: Isolate.immediate);
    }else{
      setState(() {
        tapLoad=1;
        tapAll=0;
      });
    }


  }
  static void interAdsIsolate(SendPort sendPort) {
    sendPort.send(0);
  }
  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdMobManager.rewardInterExcercise,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(

          onAdLoaded: (InterstitialAd ad) {
              setState(() {
                isRewardExcers=true;
                tapLoad=1;
                interstitialAd=ad;

              });




          },

          onAdFailedToLoad: (LoadAdError error) {
            setState(() {
              tapLoad=1;
              isRewardExcers = false;

            });


          },
        ));
  }

  @override
  Widget build(BuildContext context) {

     return WillPopScope(child: Scaffold(
         backgroundColor: Colors.white,


         body:   tapAll == 0 ?  Column(
           children: [
             Container(
               width: double.infinity,
               height: 225,
               decoration: BoxDecoration(
                   image: DecorationImage(
                       fit: BoxFit.cover,

                       image: AssetImage(widget.categoryModel.background.toString())
                   )
               ),
               child: Stack(
                 children: [
                   Positioned(

                     right: 0,

                     child: Container(
                       margin: EdgeInsets.only(right: 0,top: 75),

                       child: Image.asset(widget.categoryModel.icon.toString()),
                     ),
                   ),
                   Container(
                     width: double.infinity,
                     height: 50,
                     margin: EdgeInsets.only(top: 20),
                     child: Row(
                       children: [
                         IconButton(onPressed: (){
                           RoutesManager.instances.RoutesGotoPage(context, HomeScreen());

                         }, icon: const Icon(Icons.arrow_back,color: Colors.white,size: 20,)),
                         Padding(padding: EdgeInsets.only(left: 2,),child: Text(widget.categoryModel.name.toString().contains("ABS")? "ABS WORKOUT":widget.categoryModel.name.toString().contains("ARM")?"ARM WORKOUT":widget.categoryModel.name.toString().contains("THING")?"THING WORKOUT":"BUTT WORKOUT",style: GoogleFonts.robotoFlex(
                             fontSize: 14,
                             color: Colors.white
                         ),),),
                         const Spacer(flex: 1,),

                       ],
                     ),
                   ),
                   Container(
                     width: double.infinity,
                     height: 100,
                     margin: EdgeInsets.only(top: 80),
                     child: Row(
                       children: [
                         Column(
                           children: [
                             Padding(padding: const EdgeInsets.only(top: 15,left: 15),child: RichText(
                               text:  TextSpan(
                                   children: [
                                     TextSpan(text: "$numWorkOut\n",style: GoogleFonts.robotoFlex(
                                         fontSize: 22,
                                         color: Colors.white,
                                         fontWeight: FontWeight.bold
                                     )),
                                     TextSpan(text: LocaleKeys.description_work_out.tr(),style: GoogleFonts.robotoFlex(
                                       fontSize: 16,
                                       color: Colors.white,

                                     )),
                                   ]
                               ),
                             ),)
                           ],
                         ),
                         Column(
                           children: [
                             Padding(padding: const EdgeInsets.only(top: 15,left: 25),child: RichText(
                               text:  TextSpan(
                                   children: [
                                     TextSpan(text: "$numMinutes\n",style: GoogleFonts.robotoFlex(
                                         fontSize: 22,
                                         color: Colors.white,
                                         fontWeight: FontWeight.bold
                                     )),
                                     TextSpan(text: LocaleKeys.description_minutes.tr(),style: GoogleFonts.robotoFlex(
                                       fontSize: 16,
                                       color: Colors.white,

                                     )),
                                   ]
                               ),
                             ),)
                           ],
                         )
                       ],
                     ),
                   )


                 ],
               ),

             ),
             Expanded(child: ListView.builder(
                 itemCount: list_practice.length,
                 itemBuilder: (context, index) =>
                     itemsPlanDay(list_practice[index]))),
             ads <1 ? tapLoad==1? InkWell(
               onTap: (){
                 if(isRewardExcers){
                   interstitialAd!.show();
                   interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(

                       onAdShowedFullScreenContent:  (InterstitialAd ad) {
                         setState(() {
                           tapAll=1;
                         });
                       },
                       onAdDismissedFullScreenContent: (InterstitialAd ad){
                         tapAll=1;
                         RoutesManager.instances.RoutesGotoPage(context, WorkPlayPlanLevelScreen(list_practice,widget.categoryModel.name.toString(),widget.categoryModel));

                       },
                       onAdImpression: (InterstitialAd ad) {
                         EventsGA.instances.adImpressionWelcome(ad);
                       }
                   );
                 }else{
                   _createInterstitialAd();
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(LocaleKeys.ads_description_no_network.tr()),duration: const Duration(seconds: 1),),);
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

                       Text(LocaleKeys.button_go.tr(),style: GoogleFonts.inter(
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
                 child: const SizedBox(
                   width: 24,
                   height: 24,
                   child: CircularProgressIndicator(),
                 )
             ) : InkWell(
               onTap: (){
                 RoutesManager.instances.routesNewPage(context, WorkPlayPlanLevelScreen(list_practice,widget.categoryModel.name.toString(),widget.categoryModel));
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
                       const Icon(Icons.play_circle_outline,color: Colors.white,),
                       const SizedBox(width: 5,),
                       Text(LocaleKeys.button_go.tr(),style: GoogleFonts.inter(
                           fontWeight: FontWeight.w500,
                           fontSize: 15,
                           color: Colors.white
                       ),),
                     ],
                   )
               ),
             ),





           ],
         ) : Column(children: [
           Container(
             width: double.infinity,
             height: 50,
             margin: const EdgeInsets.only(top: 150),
             alignment: Alignment.center,
             child: const SizedBox(
               width: 24,
               height: 24,
               child: CircularProgressIndicator(),
             ),
           )
         ],)


     ), onWillPop: ()async{
      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
       return true;
     });
  }
  itemsPlanDay(PracticeModel excersieModel){
    return InkWell(
      onTap: (){
        RoutesManager.instances.routesNewPage(context, DescriptionLevelScreen(excersieModel,widget.categoryModel));

      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 25, right: 25, top: 5),
        height: 85,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            excersieModel.ExName.toString().toUpperCase(),
                            style: GoogleFonts.oswald(
                                fontSize: 18,
                                color: excersieModel.IsCompleted!.toInt() > 0
                                    ? "#FF4275".toColor()
                                    : Colors.black,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          width: 150,
                          height: 25,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 5, right: 5),
                                child: Text(
                                  excersieModel.replaceTime.toString(),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color:
                                    excersieModel.IsCompleted!.toInt() > 0
                                        ? "#FF4275".toColor()
                                        : "#7B7B7B".toColor(),
                                  ),
                                ),
                              ),
                              excersieModel.IsCompleted!.toInt() > 0
                                  ? Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Image.asset(
                                  "assets/icon/ic_sucess.png",
                                  height: 12,
                                  width: 12,
                                ),
                              )
                                  : Container()
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  excersieModel.ExPath.toString().contains(".gif") ? Container(
                    width: 85,
                    height: 85,
                    margin: const EdgeInsets.only(right: 15,left: 15),
                    child: Image.asset(excersieModel.ExPath.toString(),width: 85,height: 85,),
                  )
                      :Container(
                    margin: const EdgeInsets.only(right: 15,left: 15),
                    child: Image.asset(excersieModel.ExPath.toString(),width: 75,height: 75,),
                  )

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: Divider(
                thickness: 1,
                color: Colors.grey.shade200,
              ),
            )
          ],
        ),
      ),
    );
  }
  
  }
