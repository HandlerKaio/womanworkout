


import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:healthygympractice/Routes/RoutesManager.dart';
import 'package:healthygympractice/Routes/ad_mob.dart';
import 'package:healthygympractice/Routes/events_ga.dart';
import 'package:healthygympractice/Sharepre/SharePrefercens.dart';
import 'package:healthygympractice/extensions/color.dart';
import 'package:healthygympractice/translations/locale_key.g.dart';
import 'package:healthygympractice/view/Home/HomeScreen.dart';
import 'package:intl/intl.dart' as intl;

import '../../Routes/reminder.dart';

class WelComeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_WelComeScreen();

}

class _WelComeScreen extends State<WelComeScreen> with WidgetsBindingObserver{
  int currentSelect = 0;
  int currentPage = 0 ;
 int currentTypeWeight=0;
  double weight = 65;
  double height = 165;
  double constPound = 0.45;
  double constInch = 2.54;
  String date ="07/07/1996";
  int hour = 0;
  int minutes = 0;
  InterstitialAd ? interstitialAd;
  bool is_load = false;
  bool isAds= true;
  int Skip = 0;
  int currentWeight = 0;
  int ads = 0;
  int tapWeight = 0;
  int tapHome = 0;

  static SendPort? uiSendPort;
  final ReceivePort port = ReceivePort();


  final List<int> items =[];
  final itemsType =["kg","lb"];
  final List<int> items_hours =[];
  final List<int> items_minutes =[];
  int currentEmotion  = 1;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    initAds();
    setState(() {
      for(int i = 1 ; i <=150;i++){
        items.add(i);
      }
    });
    init();
    InitWeight();

  }
  initAds()async{

    final fads = await SharePrefercens.instances.getAds();

    ads = fads;
    if(ads<1){
      _createInterstitialAd();
    }else{
      setState(() {
        tapHome=1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SharePrefercens.instances.setWidth(MediaQuery.of(context).size.width.toInt());
    return  WillPopScope(child: Scaffold(

      body:  Container(
        padding: const EdgeInsets.only(bottom: 40),
        child: Stack(
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
            Container(
              child: currentPage == 0 ? getPageWeight():  currentPage==1 ?  Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 70,bottom: 20,),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          children: [
                            TextSpan(text: "${LocaleKeys.t_welcome.tr()}\n",style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.red.shade400
                            )),
                            TextSpan(text: LocaleKeys.t_how_can_help_you.tr(),style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.grey.shade600
                            )),
                          ]
                      ),),
                  ),
                  InkWell(

                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: (){
                      setState(() {
                        currentSelect=0;
                      });
                    },

                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 25,right: 25),
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: currentSelect == 0 ? LinearGradient(

                              begin:  Alignment.centerLeft,
                              end: Alignment.centerRight,

                              colors: [
                                Colors.orange.shade300,
                                Colors.pink.shade300
                              ]
                          ) : LinearGradient(colors: [
                            Colors.grey.shade200,
                            Colors.grey.shade200,
                          ])
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(flex: 2,child: Column(

                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Padding(padding: const EdgeInsets.only(top: 0,left: 24),child: Text(LocaleKeys.t_lose_weight.tr(),style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: currentSelect == 0 ?  Colors.white : Colors.grey.shade800
                              ),),),
                              Padding(padding: const EdgeInsets.only(top: 1,left: 24),child: Text(LocaleKeys.t_lose_weight_description.tr(),style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: currentSelect == 0 ?  Colors.white : Colors.grey.shade800
                              ),textAlign: TextAlign.center,),),
                            ],
                          ),),


                          IconButton(onPressed: (){}, icon: Icon(Icons.navigate_next,color: currentSelect == 0 ?  Colors.white : Colors.grey.shade800,))



                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 25,right: 25,top: 25),
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: currentSelect == 1 ? LinearGradient(

                              begin:  Alignment.centerLeft,
                              end: Alignment.centerRight,

                              colors: [
                                Colors.orange.shade300,
                                Colors.pink.shade300
                              ]
                          ) : LinearGradient(colors: [
                            Colors.grey.shade200,
                            Colors.grey.shade200,
                          ])
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(flex: 1,child: Column(

                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Padding(padding: const EdgeInsets.only(top: 0,left: 25),child: Text(LocaleKeys.t_lose_get_stronger.tr(),style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: currentSelect == 1 ?  Colors.white : Colors.grey.shade800
                              ),),),
                              Padding(padding: const EdgeInsets.only(top: 1,left: 25),child: Text(LocaleKeys.t_lose_get_stronger_description.tr(),style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: currentSelect == 1 ?  Colors.white : Colors.grey.shade800
                              ),textAlign: TextAlign.center,),),
                            ],
                          ),),

                          IconButton(onPressed: (){}, icon: Icon(Icons.navigate_next,color: currentSelect == 1 ?  Colors.white : Colors.grey.shade800,))

                        ],
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        currentSelect=1;
                      });
                    },
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 25,right: 25,top: 25),
                      height: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient: currentSelect == 2 ? LinearGradient(

                              begin:  Alignment.centerLeft,
                              end: Alignment.centerRight,

                              colors: [
                                Colors.orange.shade300,
                                Colors.pink.shade300
                              ]
                          ) : LinearGradient(colors: [
                            Colors.grey.shade200,
                            Colors.grey.shade200,
                          ])
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(flex: 1,child: Column(

                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Padding(padding: const EdgeInsets.only(top: 0,left: 24),child: Text(LocaleKeys.t_keep_it.tr(),style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: currentSelect == 2 ?  Colors.white : Colors.grey.shade800
                              ),),),
                              Padding(padding: const EdgeInsets.only(top: 1,left: 24),child: Text(LocaleKeys.t_keep_it_description.tr(),style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: currentSelect == 2 ?  Colors.white : Colors.grey.shade800
                              ),textAlign: TextAlign.center,),),
                            ],
                          ),),

                          IconButton(onPressed: (){}, icon: Icon(Icons.navigate_next,color: currentSelect == 2 ?  Colors.white : Colors.grey.shade800,))
                        ],
                      ),
                    ),
                    onTap: (){
                      setState(() {
                        currentSelect=2;
                      });
                    },
                  ),
                  const Spacer(flex: 1,),
                  InkWell(

                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: (){
                      setState(() {
                        currentPage=2;
                      });
                    },

                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 25,right: 25,bottom: 25),
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          gradient:  LinearGradient(

                              begin:  Alignment.centerLeft,
                              end: Alignment.centerRight,

                              colors: [
                                Colors.orange.shade300,
                                Colors.pink.shade300
                              ]
                          )),
                      alignment: Alignment.center,
                      child: Text(LocaleKeys.t_next.tr(),style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white

                      ),),
                    ),
                  ),
                ],
              ) : currentPage==2 ?getPageMyprofile()  : getAlarm(),
            )
          ],
        ),
      )
    ), onWillPop: ()async=>false);
  }
  getPageWeight(){
     return Column(
       children: [
         Container(
           width: double.infinity,
           height: 50,
           margin: const EdgeInsets.only(top: 70),
           alignment: Alignment.center,
           child: Text(LocaleKeys.t_how_are_you_today.tr(),style: GoogleFonts.roboto(
             fontSize: 26,

             color: "#FF4275".toColor()
           ),),
         ),
         SizedBox(
           width: double.infinity,
           height: 90,
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               InkWell(
                 splashColor: Colors.transparent,
                 highlightColor: Colors.transparent,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     currentEmotion ==1 ?  Image.asset("assets/icon/awesome.png",height: 64,width: 64,) :  Image.asset("assets/icon/awesome_un.png",height: 64,width: 64,),
                     Padding(padding: const EdgeInsets.only(top: 2),child: Text(LocaleKeys.t_awesome.tr(),style: GoogleFonts.roboto(
                         fontSize: 16,
                         color: '#FF4275'.toColor()
                     ),),)
                   ],
                 ),
                 onTap: (){
                   setState(() {
                     currentEmotion=1;
                   });
                 },
               ),
               InkWell(

                 splashColor: Colors.transparent,
                 highlightColor: Colors.transparent,
                 onTap: (){
                   setState(() {
                     currentEmotion=2;
                   });
                 },

                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     currentEmotion==2 ? Image.asset("assets/icon/good.png",height: 64,width: 64,) : Image.asset("assets/icon/good_un.png",height: 64,width: 64,),
                     Padding(padding: const EdgeInsets.only(top: 2),child: Text(LocaleKeys.t_good.tr(),style: GoogleFonts.roboto(
                         fontSize: 16,
                         color: '#FF7936'.toColor()
                     ),),)
                   ],
                 ),
               ),
               InkWell(
                 splashColor: Colors.transparent,
                 highlightColor: Colors.transparent,
                 onTap: (){
                   setState(() {
                     currentEmotion=3;
                   });
                 },
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                    currentEmotion== 3?  Image.asset("assets/icon/tired.png",height: 64,width: 64,) :  Image.asset("assets/icon/tired_un.png",height: 64,width: 64,),
                     Padding(padding: const EdgeInsets.only(top: 2),child: Text(LocaleKeys.t_tired.tr(),style: GoogleFonts.roboto(
                         fontSize: 16,
                         color: '#73B8E6'.toColor()
                     ),),)
                   ],
                 ),
               )

             ],
           ),
         ),
         Container(
           width: double.infinity,
           height: 50,
           margin: const EdgeInsets.only(top: 10),
           alignment: Alignment.center,
           child: Text(LocaleKeys.t_does_your_weight_change.tr(),style: GoogleFonts.roboto(
               fontSize: 18,

               color: "#676767".toColor()
           ),),
         ),
         Container(
           width: 220,
           margin: const EdgeInsets.only(top: 15),

           child: Row(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Expanded(child: Container(
                 width: 120,
                 margin: const EdgeInsets.only(left: 50,),
                 child: tapWeight==1 ? CupertinoPicker(
                     itemExtent: 64,
                     scrollController: FixedExtentScrollController(initialItem: currentWeight),
                     backgroundColor: Colors.transparent,


                     onSelectedItemChanged: (int value) {
                       SharePrefercens.instances.setWeight(items[value].toDouble()+1);
                     },
                     selectionOverlay:  Container(),
                     children: items.map((e) => Center(child: Column(
                       children: [
                         Padding(padding: const EdgeInsets.only(top: 10,),child: Text("$e",style: GoogleFonts.inter(
                             fontSize: 24,
                             fontWeight: FontWeight.w500,
                             color: "#3E3E3E".toColor()
                         ),),),
                         SizedBox(
                           width: 40,
                           child: Divider(thickness: 1,color: Colors.grey.shade400,),
                         )
                       ],
                     ),)).toList()
                 ) : Container(),
               )),

               Padding(padding: const EdgeInsets.only(left: 5,right: 5,top: 25),child: Text(":",style: GoogleFonts.roboto(
                   fontSize: 18,
                   color: Colors.black
               ),),),

               Expanded(child: Container(
                 width: 120,
                 margin: const EdgeInsets.only(right: 50),
                 child: CupertinoPicker(
                     itemExtent: 64,
                     backgroundColor: Colors.transparent,



                     onSelectedItemChanged: (int value) {
                     },
                     selectionOverlay:  Container(),
                     children: itemsType.map((e) => Center(child: Column(
                       children: [
                         Padding(padding: const EdgeInsets.only(top: 10,),child: Text(e,style: GoogleFonts.inter(
                             fontSize: 24,
                             fontWeight: FontWeight.w500,
                             color: "#3E3E3E".toColor()
                         ),),),
                         SizedBox(
                           width: 40,
                           child: Divider(thickness: 1,color: Colors.grey.shade400,),
                         )
                       ],
                     ),)).toList()
                 ),
               ))
             ],
           ),
         ),
         const Spacer(flex: 1,),
         tapHome==1 ?InkWell(

           splashColor: Colors.transparent,
           highlightColor: Colors.transparent,
           onTap: () async{
             setState(() {

               try{

                 if(Skip<2){
                   if(ads<1){
                     if(interstitialAd!=null){
                       interstitialAd!.show();
                       interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(

                           onAdShowedFullScreenContent:  (InterstitialAd ad) {
                             RoutesManager.instances.RoutePush(context, HomeScreen());
                           },
                           onAdImpression: (InterstitialAd ad) {
                             EventsGA.instances.adImpressionWelcome(ad);
                           }
                       );
                     }else{
                       RoutesManager.instances.RoutePush(context, HomeScreen());
                     }



                   }else{
                     RoutesManager.instances.RoutePush(context, HomeScreen());
                   }
                 }else{
                   currentPage=1;
                 }
               }catch(e){
                 RoutesManager.instances.RoutesGotoPage(context, HomeScreen());
               }





             });
           },

           child: Container(
             width: double.infinity,
             margin: const EdgeInsets.only(left: 25,right: 25,bottom: 25),
             height: 50,
             decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(100),
                 gradient: currentSelect == 0 ? LinearGradient(

                     begin:  Alignment.centerLeft,
                     end: Alignment.centerRight,

                     colors: [
                       "#FF4A61".toColor().withOpacity(0.8),
                       "#FF193D".toColor().withOpacity(0.9)
                     ]
                 ) : LinearGradient(colors: [
                   Colors.grey.shade200,
                   Colors.grey.shade200,
                 ])
             ),
             alignment: Alignment.center,
             child: Text(LocaleKeys.t_go.tr(),style: GoogleFonts.roboto(
                 fontWeight: FontWeight.bold,
                 fontSize: 16,
                 color: Colors.white

             ),),
           ),
         ) : Container(
             width: double.infinity,
             height: 30,
             alignment: Alignment.center,
             child: SizedBox(
               width: 24,
               height: 24,
               child: const CircularProgressIndicator(),
             )
         ),
       ],
     );
  }

  getPageMyprofile(){

    return SingleChildScrollView(
      child:  Container(
        width: double.infinity,
        height: 750,
        child: Column(

          children: [
            Container(
              width: double.infinity,
              height: 64,
              margin: EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              child: Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(64)
                ),
                child:  Image.asset("assets/icon/person.png",width: 42,height: 64,fit: BoxFit.fitHeight,),
              ),
            ),
            Padding(padding: const EdgeInsets.only(left: 5,right: 5,top: 9),child: Text(LocaleKeys.t_my_profile.tr(),style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700
            ),),),
            Padding(padding: const EdgeInsets.only(left: 5,right: 5,top: 9),child: Text(LocaleKeys.t_my_profile_description.tr(),style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.grey.shade700
            ),textAlign: TextAlign.center,),),
            Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(left: 20,right: 20,top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(

                    onTap: (){
                      setState(() {
                        if(currentTypeWeight==1){
                          height*=constInch;
                          weight*=constPound;
                        }

                        currentTypeWeight=0;
                      });
                    },
                    child: Container(
                      width: 150,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: currentTypeWeight == 0? Colors.pink.shade300 : Colors.white,
                          border:  currentTypeWeight == 0 ? Border.all(color: Colors.transparent):Border.all(color: Colors.pink.shade300)
                      ),
                      child:  Text("kg,cm",style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color:  currentTypeWeight == 0 ? Colors.white: Colors.pink.shade300
                      ),),
                    ),

                  ),
                  const SizedBox(width: 10,),
                  InkWell(
                    onTap: (){
                      setState(() {
                       if(currentTypeWeight==0){
                         height/=constInch;
                         weight/=constPound;
                       }
                        currentTypeWeight=1;

                      });
                    },

                    child: Container(
                      width: 150,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: currentTypeWeight == 1? Colors.pink.shade300 : Colors.white,
                          border:  currentTypeWeight == 1 ?   Border.all(color: Colors.transparent):Border.all(color: Colors.pink.shade300)
                      ),
                      child:  Text("lb,ft",style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color:  currentTypeWeight == 1 ? Colors.white: Colors.pink.shade300
                      ),),
                    ),
                  )

                ],
              ),
            ),
            InkWell(
              onTap: (){
                ShowInputHeight();
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 20,right: 20),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(padding: const EdgeInsets.only(left: 17),child: Text(LocaleKeys.t_height.tr(),style: GoogleFonts.roboto(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700

                    ),),),
                    Padding(padding: const EdgeInsets.only(right: 17),child: Text(currentTypeWeight == 0? "${intl.NumberFormat.decimalPattern().format(height)}cm":"${intl.NumberFormat.decimalPattern().format(height)}ft",style: GoogleFonts.roboto(
                        fontSize: 17,
                        color: Colors.pink.shade300

                    ),),),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                ShowInputHeight();
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20,right: 20),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(padding: const EdgeInsets.only(left: 17),child: Text(LocaleKeys.t_weight.tr(),style: GoogleFonts.roboto(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700

                    ),),),
                    Padding(padding: const EdgeInsets.only(right: 17),child: Text(currentTypeWeight == 0? "${intl.NumberFormat.decimalPattern().format(weight)}kg":"${intl.NumberFormat.decimalPattern().format(weight)}lb",style: GoogleFonts.roboto(
                        fontSize: 17,
                        color: Colors.pink.shade300

                    ),),),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                ShowDob();
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20,right: 20),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(padding: const EdgeInsets.only(left: 17),child: Text(LocaleKeys.t_dob.tr(),style: GoogleFonts.roboto(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700

                    ),),),
                    Padding(padding: const EdgeInsets.only(right: 17),child: Text(date,style: GoogleFonts.roboto(
                        fontSize: 17,
                        color: Colors.pink.shade300

                    ),),),
                  ],
                ),
              ),
            ),
            const Spacer(flex: 1,),
            InkWell(

              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: (){
                setState(() {
                  for(int i=1;i<=150;i++){
                    items.add(i);
                  }
                  for(int i=0;i<=59;i++){
                    items_minutes.add(i);

                  }
                  for(int i=0;i<=23;i++){
                    items_hours.add(i);

                  }
                  currentPage=4;
                  SharePrefercens.instances.setAge(date);
                  SharePrefercens.instances.setHeight(height);
                  SharePrefercens.instances.setWeight(weight);
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
                child: Text(LocaleKeys.t_next.tr(),style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white

                ),),
              ),
            ),

          ],
        ),
      ),
    );
  }
  getAlarm(){

    return Column(

      children: [
        Container(
          width: 94,
          height: 64,
          margin: EdgeInsets.only(top: 100),
          child: Image.asset("assets/icon/alarm.png"),
        ),

        Padding(padding: const EdgeInsets.only(left: 5,right: 5,),child: Text(LocaleKeys.t_set_reminder.tr(),style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade700
        ),),),
        Padding(padding: const EdgeInsets.only(left: 5,right: 5,top: 9),child: Text(LocaleKeys.t_set_reminder_description.tr(),style: GoogleFonts.roboto(
            fontSize: 15,
            color: Colors.grey.shade500
        ),textAlign: TextAlign.center,),),
        Container(
          width: 220,
          margin: EdgeInsets.only(top: 30),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Container(
                width: 120,
                margin: const EdgeInsets.only(left: 50,),
                child: CupertinoPicker(
                    itemExtent: 64,
                    scrollController: FixedExtentScrollController(initialItem: 5),
                    backgroundColor: Colors.transparent,


                    onSelectedItemChanged: (int value) {
                      setState(() {
                        hour = items_hours[value];


                      });
                    },
                    selectionOverlay:  Container(),
                    children: items_hours.map((e) => Center(child: Column(
                      children: [
                        Padding(padding: const EdgeInsets.only(top: 10,),child: Text(e>9 ? "$e" : "0$e",style: GoogleFonts.roboto(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700
                        ),),),
                        SizedBox(
                          width: 40,
                          child: Divider(thickness: 1,color: Colors.grey.shade400,),
                        )
                      ],
                    ),)).toList()
                ),
              )),

              Padding(padding: const EdgeInsets.only(left: 5,right: 5,top: 25),child: Text(":",style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),),),

              Expanded(child: Container(
                width: 180,
                margin: const EdgeInsets.only(right: 50),
                child: CupertinoPicker(
                    itemExtent: 64,
                    backgroundColor: Colors.transparent,
                    scrollController: FixedExtentScrollController(initialItem: 5),

                    onSelectedItemChanged: (int value) {
                      setState(() {
                        minutes = items_minutes[value];

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
              ))
            ],
          ),
        ),

        const Spacer(flex: 1,),

        if(ads>0)  InkWell(

          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: (){
            setState(() {

              SharePrefercens.instances.setTimer(hour,minutes);
              SharePrefercens.instances.setSkipTutorial(1);
              port.listen((data) async{
                return data;
              });

              if(ads<1){
                if(isAds){
                  interstitialAd!.show();
                  interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
                      onAdShowedFullScreenContent: (ad){
                        RoutesManager.instances.RoutePush(context, HomeScreen());
                      },
                      onAdImpression: (ad){
                        EventsGA.instances.adImpressioInter_complete(ad);
                      }


                  );
                }else{
                  RoutesManager.instances.RoutePush(context, HomeScreen());
                }

              }else{
                RoutesManager.instances.RoutesGotoPage(context, HomeScreen());
              }



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
            child: Text(LocaleKeys.t_go.tr(),style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white

            ),),
          ),
        ) else
        tapHome==1? InkWell(

          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: (){
            setState(() {

              SharePrefercens.instances.setTimer(hour,minutes);
              SharePrefercens.instances.setSkipTutorial(1);
              port.listen((data) async{
                return data;
              });

              if(ads<1){
                if(isAds){
                  interstitialAd!.show();
                  interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
                    onAdShowedFullScreenContent: (ad){
                     RoutesManager.instances.RoutePush(context, HomeScreen());
                    },
                    onAdImpression: (ad){
                      EventsGA.instances.adImpressioInter_complete(ad);
                    }


                  );
                }else{
                  RoutesManager.instances.RoutePush(context, HomeScreen());
                }

              }else{
                RoutesManager.instances.RoutesGotoPage(context, HomeScreen());
              }



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
            child: Text(LocaleKeys.t_go.tr(),style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white

            ),),
          ),
        ) : Container(
          width: double.infinity,
          height: 30,
          alignment: Alignment.center,
          child: Container(
            width: 24,
            height: 24,
            child: const CircularProgressIndicator(),
          )
        )

      ],
    );
  }

  void ShowInputHeight() async {

    final f_height = await SharePrefercens.instances.getHeight();
    final f_weight = await SharePrefercens.instances.getWeight();
    if(f_height!=null){
      height = f_height;
    }
    if(f_weight!=null){
      weight = f_weight;
    }
    int curent_weight = 0;

    TextEditingController txtheight = TextEditingController();
    TextEditingController txtweight = TextEditingController();
    txtheight.text = height.toString();
    txtweight.text = weight.toString();
    showModalBottomSheet(context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))
        ),
        builder: (context){

          return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {

            return Padding(padding: MediaQuery.of(context).viewInsets,child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [


                Padding(padding: EdgeInsets.only(left: 15,top: 50),child: Text("Weight",style: GoogleFonts.robotoFlex(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),),),
                Container(
                  width: double.infinity,
                  height: 30,
                  margin: EdgeInsets.only(top: 15,bottom: 15,left: 15,right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),

                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 1,child: TextFormField(
                        controller: txtweight,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.robotoFlex(
                            fontSize: 16,
                            color: Colors.black
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],


                        decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black
                              )
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black
                              )
                          ),
                        ),
                      ),),
                      InkWell(

                        onTap: (){
                          setState(() {
                            if(curent_weight==1){
                              height*=constInch;
                              weight*=constPound;

                            }else{
                              height  = double.parse(txtheight.text.toString());
                              weight = double.parse(txtweight.text.toString());

                            }

                            curent_weight=0;
                            txtweight.text = intl.NumberFormat.decimalPattern().format(weight);
                            txtheight.text = intl.NumberFormat.decimalPattern().format(height);


                          });
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          margin: EdgeInsets.only(left: 5,right: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: curent_weight == 0? Colors.pink.shade300 : Colors.white,
                              border:  curent_weight == 0 ? Border.all(color: Colors.transparent):Border.all(color: Colors.pink.shade300)
                          ),
                          child:  Text("KG",style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:  curent_weight == 0 ? Colors.white: Colors.pink.shade300
                          ),),
                        ),

                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            height  = double.parse(txtheight.text.toString());
                            weight = double.parse(txtweight.text.toString());
                            if(curent_weight==0){
                              height/=constInch;
                              weight/=constPound;
                            }

                            txtweight.text = intl.NumberFormat.decimalPattern().format(weight);
                            txtheight.text = intl.NumberFormat.decimalPattern().format(height);
                            curent_weight=1;

                          });
                        },

                        child: Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: curent_weight == 1? Colors.pink.shade300 : Colors.white,
                              border:  curent_weight == 1 ?   Border.all(color: Colors.transparent):Border.all(color: Colors.pink.shade300)
                          ),
                          child:  Text("LB",style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:  curent_weight == 1 ? Colors.white: Colors.pink.shade300
                          ),),
                        ),
                      )

                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.only(left:15,top: 10,),child: Text("Height",style: GoogleFonts.robotoFlex(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),),),
                Container(
                  width: double.infinity,
                  height: 30,
                  margin: const EdgeInsets.only(top: 15,bottom: 15,left: 15,right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),

                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 1,child: TextFormField(
                        controller: txtheight,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.robotoFlex(
                            fontSize: 16,
                            color: Colors.black
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],


                        decoration: const InputDecoration(


                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black
                              )
                          ),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black
                              )
                          ),

                        ),
                      ),),
                      InkWell(

                        onTap: (){
                          setState(() {

                            if(curent_weight==1){
                              height*=constInch;
                              weight*=constPound;
                            }else{
                              height  = double.parse(txtheight.text.toString());
                              weight = double.parse(txtweight.text.toString());
                            }

                            curent_weight=0;
                            txtweight.text = intl.NumberFormat.decimalPattern().format(weight);
                            txtheight.text = intl.NumberFormat.decimalPattern().format(height);


                          });
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          margin: const EdgeInsets.only(left: 5,right: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: curent_weight == 0? Colors.pink.shade300 : Colors.white,
                              border:  curent_weight == 0 ? Border.all(color: Colors.transparent):Border.all(color: Colors.pink.shade300)
                          ),
                          child:  Text("CM",style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:  curent_weight == 0 ? Colors.white: Colors.pink.shade300
                          ),),
                        ),

                      ),
                      InkWell(
                        onTap: (){
                          setState(() {

                            height  = double.parse(txtheight.text.toString());
                            weight = double.parse(txtweight.text.toString());
                            if(curent_weight==0){
                              height/=constInch;
                              weight/=constPound;
                            }

                            txtweight.text = intl.NumberFormat.decimalPattern().format(weight);
                            txtheight.text = intl.NumberFormat.decimalPattern().format(height);
                            curent_weight=1;
                          });
                        },

                        child: Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: curent_weight == 1? Colors.pink.shade300 : Colors.white,
                              border:  curent_weight == 1 ?   Border.all(color: Colors.transparent):Border.all(color: Colors.pink.shade300)
                          ),
                          child:  Text("FT",style: GoogleFonts.roboto(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color:  curent_weight == 1 ? Colors.white: Colors.pink.shade300
                          ),),
                        ),
                      )

                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  margin: const EdgeInsets.only(top: 15,bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 40,
                        child: RaisedButton(onPressed: (){

                          setState(() {
                            if(weight>0){
                              SharePrefercens.instances.setWeight(double.parse(txtweight.text.toString().trim()));
                            }else{
                              ShowToast(LocaleKeys.t_weight_description.tr());
                            }
                            if(height>0){
                              SharePrefercens.instances.setHeight(double.parse(txtheight.text.toString().trim()));

                            }else{
                              ShowToast(LocaleKeys.t_height_description.tr());
                            }
                            InitWeight();
                            SharePrefercens.instances.setType(curent_weight);
                            Navigator.pop(context);
                          });

                        },

                          color: Colors.pink.shade400,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Text(LocaleKeys.button_save.tr(),style: GoogleFonts.robotoFlex(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),),),
                      ),
                      Container(
                        width: 120,
                        height: 50,
                        margin: const EdgeInsets.only(left: 25),
                        child: RaisedButton(onPressed: (){
                          Navigator.pop(context);
                        },

                          color: Colors.grey.shade400,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Text(LocaleKeys.button_quit.tr(),style: GoogleFonts.robotoFlex(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),),),
                      )
                    ],
                  ),
                )
              ],
            ),);
          },

          );
        });

  }

  void ShowToast(String s) {
    Fluttertoast.showToast(msg: s,fontSize: 16,textColor: Colors.black,backgroundColor: Colors.white);
  }

  void ShowDob()  async{
    final timerSelect  = DateTime.now();

    final dialogTimer =  await showDatePicker(context: context,

      confirmText: LocaleKeys.button_save.tr(),
      cancelText: LocaleKeys.button_quit.tr(),
      fieldLabelText: LocaleKeys.t_select_dob.tr(),
      initialDate: timerSelect,

      firstDate: DateTime(1950), lastDate: DateTime(DateTime.now().year+1),);

    if(dialogTimer!=null && dialogTimer!=timerSelect){
       String date_ = intl.DateFormat("dd/MM/yyyy").format(dialogTimer);
        if(dialogTimer.year>= timerSelect.year-10){
           ShowToast(LocaleKeys.t_date_valid.tr(),);
        }else{
          setState(() {
            date = date_;

          });
        }


    }


  }
  InitWeight() async{
    final f_height = await SharePrefercens.instances.getHeight();
    final f_weight = await SharePrefercens.instances.getWeight();
   setState(() {
     if(f_height!=null){
       height = f_height;
     }
     if(f_weight!=null){
       weight = f_weight;

     }
     for(int i=1;i<items.length;i++){
       if(i== weight.toInt()){
         currentWeight = i-1;
         tapWeight=1;

       }
     }
   });
  }
   void  _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdMobManager.interSplash,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
               setState(() {
                 isAds=true;
                 interstitialAd=ad;
                 tapHome=1;
               });
          },

          onAdFailedToLoad: (LoadAdError error) {
            setState(() {
              interstitialAd= null;
              isAds=false;
              tapHome=1;
            });
          },
        ));
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void init()   async{


    final f_skip   = await SharePrefercens.instances.getSkipTutorial();
    setState(() {
      Skip=f_skip;
      if(Skip==1){
        currentPage=0;
      }else{
        currentPage = 1;
      }
    });

  }
  void runAlarm()  async{
    Reminder.instances.init();
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

    AndroidAlarmManager.oneShot( Duration(hours: hours,minutes: minutess),0,  callback,wakeup: true,exact: true,rescheduleOnReboot: true,alarmClock: true,allowWhileIdle: true);
  }
   Future<void> callback() async {
    if(hour>=DateTime.now().hour &&minutes>DateTime.now().minute){

    }else{
      Reminder.instances.showNotifications();
    }
    uiSendPort ??= IsolateNameServer.lookupPortByName("reminder");
    uiSendPort?.send("hi");
  }


}