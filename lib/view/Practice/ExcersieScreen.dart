import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:healthygympractice/Routes/RoutesManager.dart';
import 'package:healthygympractice/Routes/ad_mob.dart';
import 'package:healthygympractice/Sharepre/SharePrefercens.dart';
import 'package:healthygympractice/extensions/color.dart';
import 'package:healthygympractice/models/PracticeModel.dart';
import 'package:healthygympractice/translations/locale_key.g.dart';
import 'package:healthygympractice/view/Practice/DescriptionExerciseScreen.dart';
import 'package:healthygympractice/view/Practice/DetailsPracticeScreen.dart';
import 'package:healthygympractice/view/Practice/WorkPlayScreen.dart';

import '../../Routes/events_ga.dart';
import '../../models/CategoryModel.dart';
import '../../models/PlansModel.dart';

class ExcersieScreen extends StatefulWidget {
  CategoryModel splasModel;
  PlansModel plansModel;

  ExcersieScreen(
    this.splasModel,
    this.plansModel,
  );

  @override
  State<StatefulWidget> createState() => _ExcersieScreen();
}

class _ExcersieScreen extends State<ExcersieScreen>
    with WidgetsBindingObserver {
  List<PracticeModel> list_practice = [];
  int num_workout = 0;
  int num_minutes = 0;
  int days = 0;
  AppOpenAd? _appOpenAd;
  int width = 360;
  int count_pause =0;
  int count_inactive = 0;
  int ads = 0;



  init() async {
    days = widget.plansModel.DayName!.toInt();
    if (days > 7 && days <= 14) {
      days -= 7;
    } else if (days > 14 && days <= 21) {
      days -= 14;
    } else if (days > 21) {
      days -= 21;
    }

    final f_list = await PracticeModel.instances.getDataListPractice(widget.plansModel.PlanID!.toInt(), days);


    setState(() {
      list_practice = f_list;
      num_workout = list_practice.length;
      num_minutes = list_practice.length - 4;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    init();
    initAds();


  }
  initAds() async{
    final fads = await SharePrefercens.instances.getAds();
    ads = fads;
    if(ads<1){
      loadAd();
    }

  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 225,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              widget.splasModel.background.toString()))),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 0,
                        child: Container(
                          margin: const EdgeInsets.only(right: 45, top: 5),
                          child: Image.asset(widget.splasModel.icon.toString()),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        margin: EdgeInsets.only(top: 25),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  RoutesManager.instances.RoutePush(context,
                                      DetailsPracticeScreen(widget.splasModel));
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 20,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 2,
                              ),
                              child: Text(
                                widget.splasModel.name
                                        .toString()
                                        .contains("abs")
                                    ? "ABS WORKOUT"
                                    : "7X4 CHALLENGE",
                                style: GoogleFonts.robotoFlex(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 100,
                        margin: const EdgeInsets.only(top: 80),
                        child: Row(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 15, left: 15),
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: "$num_workout\n",
                                          style: GoogleFonts.robotoFlex(
                                              fontSize: 22,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: LocaleKeys.description_work_out
                                              .tr(),
                                          style: GoogleFonts.robotoFlex(
                                            fontSize: 16,
                                            color: Colors.white,
                                          )),
                                    ]),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 15, left: 25),
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: "$num_minutes\n",
                                          style: GoogleFonts.robotoFlex(
                                              fontSize: 22,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: LocaleKeys.description_minutes
                                              .tr(),
                                          style: GoogleFonts.robotoFlex(
                                            fontSize: 16,
                                            color: Colors.white,
                                          )),
                                    ]),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),


                Expanded(
                  flex: 1,
                  child: ListView.builder(
                      itemCount: list_practice.length,
                      itemBuilder: (context, index) =>
                          itemPlanDay(list_practice[index])),
                ),
                Container(
                  width: 250,
                  height: 40,
                  margin: const EdgeInsets.only(bottom: 50),
                  child: ElevatedButton(
                    onPressed: () {
                      RoutesManager.instances.RoutePush(context, WorkPlayScreen(list_practice, widget.plansModel, "${widget.splasModel.name} - $days",widget.splasModel));
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink.shade400,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),

                    child: Text(
                      LocaleKeys.t_go.tr(),
                      style: GoogleFonts.robotoFlex(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16),
                    ),
                  ),
                ),
              ],
            )),
        onWillPop: () async {
          RoutesManager.instances.routesNewPage(context, DetailsPracticeScreen(widget.splasModel));
          return true;
        });
  }

  itemPlanDay(PracticeModel excersieModel) {
    return InkWell(
      onTap: () {
        RoutesManager.instances.routesNewPage(context, DescriptionExerciseScreen(excersieModel, widget.splasModel, widget.plansModel));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
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
                        SizedBox(
                          width: 150,
                          height: 25,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5, right: 5),
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
                    margin: EdgeInsets.only(right: 15,left: 15),
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

  @override
  void dispose() {
   if(ads<1){
     if(_appOpenAd !=null )_appOpenAd!.dispose();
   }
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state== AppLifecycleState.inactive){
      count_inactive=1;
    }
    if(state==AppLifecycleState.paused){
      count_pause=1;
    }
    if(state==AppLifecycleState.resumed){
      if(count_inactive==1 && count_pause==1 && ads<1){
        _appOpenAd!.show();
        count_inactive=0;
        count_inactive=0;
      }
    }
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





}
