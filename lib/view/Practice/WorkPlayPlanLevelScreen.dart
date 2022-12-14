import 'dart:collection';
import 'dart:isolate';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:healthygympractice/Routes/RoutesManager.dart';
import 'package:healthygympractice/Sharepre/SharePrefercens.dart';
import 'package:healthygympractice/extensions/color.dart';
import 'package:healthygympractice/models/CategoryModel.dart';
import 'package:healthygympractice/models/PracticeModel.dart';
import 'package:healthygympractice/view/Practice/DescriptionLevelScreen.dart';
import 'package:healthygympractice/view/Practice/PlansLevelScreen.dart';
import 'package:healthygympractice/view/Practice/WinnerScreen.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../Routes/ad_mob.dart';
import '../../Routes/audio_play.dart';
import '../../Routes/events_ga.dart';
import '../../remote/remote_config.dart';
import '../../translations/locale_key.g.dart';

class WorkPlayPlanLevelScreen extends StatefulWidget {
  List<PracticeModel> list = [];
  String name;
  CategoryModel categoryModel;

  WorkPlayPlanLevelScreen(this.list, this.name, this.categoryModel, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WorkPlayPlanLevelScreen();
  }
}

class _WorkPlayPlanLevelScreen extends State<WorkPlayPlanLevelScreen>
    with WidgetsBindingObserver {
  int index = 0;
  int percent = 0;
  bool state_start = true;
  String time_history = "0";
  int pause = 0;
  int currentTap = 0;

  int plusTime = 0;
  double allTime = 0;
  bool isPlayClock = false;
  bool isBannerLoaded = false;
  bool isBannerLoaded2 = false;
  BannerAd? bannerAd;
  BannerAd? bannerAd1;
  InterstitialAd? interstitialAd;
  InterstitialAd? interstitialAd1;
  AppOpenAd? _appOpenAd;
  bool isBannerRestPage = false;
  bool isBannerExcersise = false;
  bool isInterCompleted = false;
  bool isInterExit = false;
  bool isOpenApp = false;
  int resetSet = 20;
  int countDown = 5;
  int width = 360;
  int countDownOpen = 0;
  int showSucess = 0;
  int count_inactive = 0;
  int count_pause = 0;
  int ads = 0;
  int tapQuit = 0;
  int tapExit = 0;
  bool isAdsExit  = false;


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    initAds();
    AudioPlayManager.instances.init();
    AudioPlayManager.instances.audioPlayStart(1);
  }

  initAds() async{
    final fads = await SharePrefercens.instances.getAds();
    ads = fads;
    if(ads<1){
      loadAd();
      interAdsInterbanner();
      interAdsInter();
    }else{
      setState(() {
        tapExit=1;
      });
    }
  }

  void interAdsInter() async{

    final port = ReceivePort();
    final isolate =  await  Isolate.spawn(interAdsIsolate, port.sendPort);
    port.listen((message) {
      _createInterstitialAd();
      _createInterstitialAdExitPractice();
    });
    isolate.kill(priority: Isolate.immediate);
  }
  static void interAdsIsolate(SendPort sendPort) {
    sendPort.send(0);
  }
  void interAdsInterbanner() async{

    final port = ReceivePort();
    final isolate =  await  Isolate.spawn(interAdsIsolateBanner, port.sendPort);
    port.listen((message) {
      createBannerNative();
      createBannerNative2();

    });
    isolate.kill(priority: Isolate.immediate);
  }
  static void interAdsIsolateBanner(SendPort sendPort) {
    sendPort.send(1);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor:  Colors.white,
          body: currentTap == 0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 15, left: 10),
                      height: 50,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                ShowQuit();
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.pink.shade400,
                              )),
                        ],
                      ),
                    ),
                    isBannerLoaded && isBannerExcersise
                        ? Container(
                            width: double.infinity,
                            height: width > 400 && width < 729
                                ? 70
                                : width > 729
                                    ? 90
                                    : width < 360
                                        ? 60
                                        : 65,
                            child: AdWidget(
                              ad: bannerAd!,
                            ),
                          )
                        : Container(),
                    Container(
                      width: double.infinity,
                      height: 300,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 5),
                      child:
                          widget.list[index].ExPath.toString().contains("gif")
                              ? Image.asset(
                                  widget.list[index].ExPath.toString(),
                                  fit: BoxFit.fill,
                                  width: 300,
                                  height: 300,
                                )
                              : Image.asset(
                                  widget.list[index].ExPath.toString(),
                                  width: 320,
                                  height: 220,
                                ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          state_start &&
                              widget.list[index].replaceTime
                                  .toString()
                                  .contains("s")
                              ? Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                  bottom: 15, left: 5, right: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5)),
                              child: pause == 0 ? TweenAnimationBuilder<Duration>(
                                tween: Tween<Duration>(
                                    begin: Duration(seconds: int.parse(time_history.trim())),
                                    end:  Duration(
                                        seconds: int.parse(widget
                                            .list[index].replaceTime
                                            .toString()
                                            .replaceAll("s", "")
                                            .trim())+countDown)),
                                duration: Duration(
                                    seconds: int.parse(widget
                                        .list[index].replaceTime
                                        .toString()
                                        .replaceAll("s", "")
                                        .trim())+countDown) ,

                                onEnd: () {
                                  setState(() {
                                    currentTap = 1;
                                    pause =1;
                                    if (index < widget.list.length - 1) {
                                      index = index + 1;
                                      state_start = true;
                                    } else if (index ==
                                        widget.list.length - 1) {
                                      RoutesManager.instances
                                          .RoutesGotoPage(
                                          context,
                                          WinnerScreen(
                                            length: widget.list.length,
                                            second: allTime,
                                            name: widget.name,
                                          ));
                                    }
                                  });
                                },
                                builder: (context, value, _) {
                                  time_history = value.inSeconds.toString();

                                  return Column(
                                    children: [

                                      Container(
                                          width: double.infinity,
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.only(left: 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(20)),
                                          child: RichText(
                                              text: TextSpan(children: [
                                                TextSpan(
                                                    text: time_history,
                                                    style: GoogleFonts.robotoFlex(
                                                        color: "#FF7D75".toColor(),
                                                        fontSize: 27,
                                                        fontStyle: FontStyle.italic,
                                                        fontWeight: FontWeight.bold)),
                                                TextSpan(
                                                    text: '???',
                                                    style: TextStyle(
                                                        color: Colors.orange.shade600,
                                                        fontSize: 27,
                                                        fontStyle: FontStyle.italic,
                                                        fontWeight: FontWeight.bold)),
                                                TextSpan(
                                                    text: "/${ int.parse(widget.list[index].replaceTime.toString().replaceAll("s","").trim())+countDown}",
                                                    style: GoogleFonts.robotoFlex(
                                                        color: "#000000".toColor(),
                                                        fontSize: 22,
                                                        fontWeight: FontWeight.bold)),
                                                TextSpan(
                                                    text: '???\n',
                                                    style: GoogleFonts.robotoFlex(
                                                        color: Colors.black,
                                                        fontSize: 22,
                                                        fontStyle: FontStyle.italic,
                                                        fontWeight: FontWeight.bold)),
                                                TextSpan(
                                                    text: widget.list[index].ExName
                                                        .toString(),
                                                    style: GoogleFonts.robotoFlex(
                                                        color: Colors.black,
                                                        fontSize: 22,
                                                        fontWeight: FontWeight.bold)),
                                              ]))),
                                      Container(
                                          margin: const EdgeInsets.only(bottom: 5),
                                          width: double.infinity,
                                          height: 5,
                                          child:ListView.builder(

                                              scrollDirection: Axis.horizontal,

                                              itemCount: widget.list.length,
                                              itemBuilder: (context, index) => itemWork(widget.list[index], index))),
                                      Container(
                                          width: double.infinity,
                                          height: 80,
                                          margin: const EdgeInsets.only(
                                            bottom: 1,
                                          ),
                                          child: pause == 0 ? SizedBox(
                                            width: double.infinity,
                                            height: 80,
                                            child: Stack(
                                              children: [
                                                FAProgressBar(
                                                  currentValue: double.parse(time_history.trim()),
                                                  progressColor: "#FF7936".toColor(),
                                                  direction: Axis.horizontal,
                                                  borderRadius:
                                                  BorderRadius.circular(0),
                                                  size: 80,
                                                  maxValue: double.parse(widget.list[index].replaceTime.toString().replaceAll("s","").trim())+countDown,
                                                  backgroundColor: Colors.grey.shade100,
                                                  animatedDuration: const Duration(milliseconds: 1),
                                                ) ,
                                                Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  left: 0,
                                                  child: Container(
                                                    width: 42,
                                                    margin: const EdgeInsets.only(top: 10),
                                                    height: 42,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          pause=1;
                                                        });
                                                      },
                                                      icon: Icon(Icons.pause,
                                                          size: 42,
                                                          color: Colors.grey.shade600),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  child: Container(
                                                    width: 42,
                                                    margin: const EdgeInsets.only(top: 10),
                                                    height: 42,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          currentTap = 1;
                                                          updatePractice();
                                                        });

                                                      },
                                                      icon: Icon(
                                                        Icons.navigate_next,
                                                        size: 36,
                                                        color: Colors.grey.shade600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ) :SizedBox(
                                            width: double.infinity,
                                            height: 80,
                                            child: Stack(
                                              children: [
                                                FAProgressBar(
                                                  currentValue: double.parse(time_history.trim()),
                                                  progressColor: "#FF7936".toColor(),
                                                  direction: Axis.horizontal,
                                                  borderRadius:
                                                  BorderRadius.circular(0),
                                                  size: 80,
                                                  maxValue: double.parse(widget.list[index].replaceTime.toString().replaceAll("s","").trim())+countDown,
                                                  backgroundColor: Colors.grey.shade100,
                                                  animatedDuration:
                                                  const Duration(milliseconds: 1),
                                                ),
                                                pause == 0 ? Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  left: 0,
                                                  child: Container(
                                                    width: 42,
                                                    margin: const EdgeInsets.only(top: 10),
                                                    height: 42,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          pause=1;
                                                        });
                                                      },
                                                      icon: Icon(Icons.pause,
                                                          size: 42,
                                                          color: Colors.grey.shade600),
                                                    ),
                                                  ),
                                                ): Positioned(
                                                  right: 0,
                                                  top: 0,
                                                  left: 0,
                                                  child: Container(
                                                    width: 42,
                                                    margin: const EdgeInsets.only(top: 10),
                                                    height: 42,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          pause=0;
                                                        });
                                                      },
                                                      icon: Icon(Icons.play_arrow,
                                                          size: 42,
                                                          color: Colors.grey.shade600),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  child: Container(
                                                    width: 42,
                                                    margin: const EdgeInsets.only(top: 10),
                                                    height: 42,
                                                    child: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          currentTap = 1;
                                                          updatePractice();
                                                        });

                                                      },
                                                      icon: Icon(
                                                        Icons.navigate_next,
                                                        size: 36,
                                                        color: Colors.grey.shade600,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))

                                    ],
                                  );
                                },
                              ) : Column(
                                children: [

                                  Container(
                                      width: double.infinity,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(20)),
                                      child: RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: time_history,
                                                style: GoogleFonts.robotoFlex(
                                                    color: "#FF7D75".toColor(),
                                                    fontSize: 27,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.bold)),
                                            TextSpan(
                                                text: '???',
                                                style: TextStyle(
                                                    color: Colors.orange.shade600,
                                                    fontSize: 27,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.bold)),
                                            TextSpan(
                                                text: "/${ int.parse(widget.list[index].replaceTime.toString().replaceAll("s","").trim())+countDown}",
                                                style: GoogleFonts.robotoFlex(
                                                    color: "#000000".toColor(),
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold)),
                                            TextSpan(
                                                text: '???\n',
                                                style: GoogleFonts.robotoFlex(
                                                    color: Colors.black,
                                                    fontSize: 22,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.bold)),
                                            TextSpan(
                                                text: widget.list[index].ExName
                                                    .toString(),
                                                style: GoogleFonts.robotoFlex(
                                                    color: Colors.black,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold)),
                                          ]))),
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      width: double.infinity,
                                      height: 5,
                                      child:ListView.builder(
                                          scrollDirection: Axis.horizontal,

                                          itemCount: widget.list.length,
                                          itemBuilder: (context, index) => itemWork(widget.list[index], index))),
                                  Container(
                                      width: double.infinity,
                                      height: 80,
                                      margin: const EdgeInsets.only(
                                        bottom: 1,
                                      ),
                                      child: pause == 0 ? SizedBox(
                                        width: double.infinity,
                                        height: 80,
                                        child: Stack(
                                          children: [
                                            FAProgressBar(
                                              currentValue: double.parse(time_history.trim()),
                                              progressColor: "#FF7936".toColor(),
                                              direction: Axis.horizontal,
                                              borderRadius:
                                              BorderRadius.circular(0),
                                              size: 80,
                                              maxValue: double.parse(widget.list[index].replaceTime.toString().replaceAll("s","").trim())+countDown,
                                              backgroundColor: Colors.grey.shade100,
                                              animatedDuration: const Duration(milliseconds: 1),
                                            ) ,
                                            pause == 0 ? Positioned(
                                              right: 0,
                                              top: 0,
                                              left: 0,
                                              child: Container(
                                                width: 42,
                                                margin: const EdgeInsets.only(top: 10),
                                                height: 42,
                                                child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      pause=1;
                                                    });
                                                  },
                                                  icon: Icon(Icons.pause,
                                                      size: 42,
                                                      color: Colors.grey.shade600),
                                                ),
                                              ),
                                            ): Positioned(
                                              right: 0,
                                              top: 0,
                                              left: 0,
                                              child: Container(
                                                width: 42,
                                                margin: const EdgeInsets.only(top: 10),
                                                height: 42,
                                                child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      pause=0;
                                                    });
                                                  },
                                                  icon: Icon(Icons.play_arrow,
                                                      size: 42,
                                                      color: Colors.grey.shade600),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              child: Container(
                                                width: 42,
                                                margin: const EdgeInsets.only(top: 10),
                                                height: 42,
                                                child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      currentTap = 1;
                                                      updatePractice();
                                                    });

                                                  },
                                                  icon: Icon(
                                                    Icons.navigate_next,
                                                    size: 36,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ) :SizedBox(
                                        width: double.infinity,
                                        height: 80,
                                        child: Stack(
                                          children: [
                                            FAProgressBar(
                                              currentValue: double.parse(time_history.trim()),
                                              progressColor: "#FF7936".toColor(),
                                              direction: Axis.horizontal,
                                              borderRadius:
                                              BorderRadius.circular(0),
                                              size: 80,
                                              maxValue: double.parse(widget.list[index].replaceTime.toString().replaceAll("s","").trim())+countDown,
                                              backgroundColor: Colors.grey.shade100,
                                              animatedDuration:
                                              const Duration(milliseconds: 1),
                                            ),
                                            pause == 0 ? Positioned(
                                              right: 0,
                                              top: 0,
                                              left: 0,
                                              child: Container(
                                                width: 42,
                                                margin: const EdgeInsets.only(top: 10),
                                                height: 42,
                                                child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      pause=1;
                                                    });
                                                  },
                                                  icon: Icon(Icons.pause,
                                                      size: 42,
                                                      color: Colors.grey.shade600),
                                                ),
                                              ),
                                            ): Positioned(
                                              right: 0,
                                              top: 0,
                                              left: 0,
                                              child: Container(
                                                width: 42,
                                                margin: const EdgeInsets.only(top: 10),
                                                height: 42,
                                                child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      pause=0;
                                                    });
                                                  },
                                                  icon: Icon(Icons.play_arrow,
                                                      size: 42,
                                                      color: Colors.grey.shade600),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              child: Container(
                                                width: 42,
                                                margin: const EdgeInsets.only(top: 10),
                                                height: 42,
                                                child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      currentTap = 1;
                                                      updatePractice();
                                                    });

                                                  },
                                                  icon: Icon(
                                                    Icons.navigate_next,
                                                    size: 36,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))

                                ],
                              )
                          )
                              : Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: widget.list[index].ExName
                                              .toString(),
                                          style: GoogleFonts.robotoFlex(
                                              color: Colors.black,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: " x ${widget.list[index].replaceTime
                                              .toString()
                                              .replaceAll("x", "")}",
                                          style: GoogleFonts.robotoFlex(
                                              color: Colors.pink.shade400,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold)),
                                    ])),
                                Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    width: double.infinity,
                                    height: 5,
                                    child:ListView.builder(

                                        scrollDirection: Axis.horizontal,

                                        itemCount: widget.list.length,
                                        itemBuilder: (context, index) => itemWork(widget.list[index], index))),
                                Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(bottom: 35),
                                    height: 80,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 64,
                                          width: 64,
                                          child: index > 0
                                              ? IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  currentTap = 1;
                                                  if (index > 0) {
                                                    index = index - 1;
                                                    state_start = true;
                                                  }
                                                });
                                              },
                                              icon: Icon(
                                                Icons.navigate_before,
                                                color: "#9E9E9E".toColor(),
                                                size: 64,
                                              ))
                                              : Container(),
                                        ),
                                        Container(
                                            width: 64,
                                            margin: EdgeInsets.only(top: 16, left: 16),
                                            height: 64,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(64),
                                                color: Colors.pink.shade400),
                                            child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    setState(() {
                                                      currentTap = 1;
                                                      updatePractice();
                                                    });
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                ))),
                                        Container(
                                          height: 64,
                                          width: 64,
                                          margin: EdgeInsets.only(
                                            right: 16,
                                          ),
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  currentTap = 1;
                                                  updatePractice();
                                                });
                                              },
                                              icon: Icon(
                                                Icons.navigate_next_sharp,
                                                color: "#9E9E9E".toColor(),
                                                size: 64,
                                              )),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),


                  ],
                )
              : getTakeArest(),
        ),
        onWillPop: () async {
          ShowQuit();
          return true;
        });
  }

  itemWork(PracticeModel exerciseModel, int indexs) {
    return Container(
      margin: const EdgeInsets.only(
        left: 1,
        right: 1,
      ),
      width: 25,
      height: 5,
      decoration: BoxDecoration(
          color: index >= indexs ? Colors.pink.shade400 : Colors.grey,
          borderRadius: BorderRadius.circular(1)),
    );
  }

  void ShowQuit() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Don't quit! Feeling tired means it's working",
              style: GoogleFonts.robotoFlex(color: Colors.black, fontSize: 14),
            ),
            actions: [
              RaisedButton(
                onPressed: () {
                  if(ads>0){
                    Navigator.pop(context);
                    RoutesManager.instances.RoutePush(context, PlanLevelScreen(widget.categoryModel));
                  }else{
                    if(isAdsExit){
                      showSucess=1;
                      count_pause=0;
                      count_inactive=0;
                      interstitialAd1!.show();
                      interstitialAd1!.fullScreenContentCallback = FullScreenContentCallback(
                          onAdShowedFullScreenContent: (InterstitialAd ad){
                            RoutesManager.instances.RoutePush(context, PlanLevelScreen(widget.categoryModel));
                          },
                          onAdDismissedFullScreenContent: (ad){
                            ad.dispose();
                          },
                          onAdFailedToShowFullScreenContent: (ad,_){
                             ad.dispose();
                          },
                          onAdImpression: (InterstitialAd ad) {
                            EventsGA.instances.adImpressioInter_exit_exercise(ad);
                          }
                      );

                    }else{
                      Navigator.pop(context);
                      RoutesManager.instances.RoutePush(context, PlanLevelScreen(widget.categoryModel));
                    }
                  }


                  try {
                    AudioPlayManager.instances.audioClockStart(0);
                    AudioPlayManager.instances.audioPlayStart(0);
                  } catch (_) {}
                  ;
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.pink.shade400,
                child: Text(
                  LocaleKeys.button_quit.tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Continue",
                  style: TextStyle(color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.grey.withOpacity(0.6),
              )
            ],
          );
        });
  }

  getTakeArest() {
    AudioPlayManager.instances.audioClockStart(0);
    return Stack(
      children: [
        Container(
            width: double.infinity,
            height: 420,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      "assets/banner/banner_rest.png",
                    ))),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
              child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          "assets/banner/shadow.png",
                        ))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                        top: 15,
                      ),
                      height: 50,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                interstitialAd1!.show();
                                setState(() {
                                  currentTap = 0;
                                  plusTime = 0;
                                });
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Text(
                        LocaleKeys.t_take_a_rest.tr(),
                        style: GoogleFonts.robotoFlex(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: "#FF7D75".toColor()),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          plusTime > 0
                              ? InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  child: Container(
                                    width: 75,
                                    height: 25,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "",
                                      style: GoogleFonts.robotoFlex(
                                          color: Colors.white),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  onTap: () {
                                    setState(() {
                                      plusTime = 20;
                                    });
                                  },
                                  child: Container(
                                    width: 75,
                                    height: 25,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(70)),
                                    child: Text(
                                      "+ $resetSet s",
                                      style: GoogleFonts.robotoFlex(
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                          SizedBox(
                              width: 90,
                              height: 90,
                              child: TweenAnimationBuilder<Duration>(
                                tween: Tween<Duration>(
                                    begin: Duration.zero,
                                    end:
                                        Duration(seconds: plusTime + resetSet)),
                                duration:
                                    Duration(seconds: plusTime + resetSet),
                                onEnd: () {
                                  setState(() {
                                    pause=0;
                                    time_history ="0";
                                    currentTap = 0;
                                    plusTime = 0;
                                  });
                                },
                                builder: (context, value, _) {
                                  percent = (value.inSeconds % 60);
                                  allTime = allTime + percent;

                                  return CircularPercentIndicator(
                                    radius: 90.0,
                                    lineWidth: 3.7,
                                    percent: percent.toDouble() /
                                        (plusTime + resetSet),
                                    center: Text(
                                      "$percent",
                                      style: GoogleFonts.robotoFlex(
                                          fontSize: 36,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    progressColor: "#FF7D75".toColor(),
                                  );
                                },
                              )),
                          InkWell(
                            onTap: () {
                              setState(() {
                                pause=0;
                                time_history ="0";
                                currentTap = 0;
                                plusTime = 0;
                                isPlayClock = false;
                                if (index < widget.list.length - 1) {
                                  index = index + 1;
                                  state_start = true;
                                } else if (index ==
                                    widget.list.length - 1) {
                                  RoutesManager.instances
                                      .RoutesGotoPage(
                                      context,
                                      WinnerScreen(
                                        length: widget.list.length,
                                        second: allTime,
                                        name: widget.name,
                                      ));
                                }
                                AudioPlayManager.instances.init();
                                AudioPlayManager.instances.audioPlayStart(1);
                              });
                            },
                            child: Container(
                              width: 75,
                              height: 25,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(70)),
                              child: Text(
                                LocaleKeys.t_skip.tr(),
                                style:
                                    GoogleFonts.robotoFlex(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 380),
          padding: const EdgeInsets.only(top: 8, left: 1, right: 1),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(15))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isBannerLoaded2 && isBannerRestPage ? getBanner2() : Container(),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 15),
                child: Text(
                  LocaleKeys.t_next.tr(),
                  style: GoogleFonts.robotoFlex(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: "#797979".toColor()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 15),
                child: Text(
                  widget.list[index].ExName.toString(),
                  style: GoogleFonts.robotoFlex(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 300,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 5),
                  child: widget.list[index].ExPath.toString().contains("gif")
                      ? Image.asset(
                          widget.list[index].ExPath.toString(),
                          fit: BoxFit.fill,
                          width: 300,
                          height: 300,
                        )
                      : Image.asset(
                          widget.list[index].ExPath.toString(),
                          width: 320,
                          height: 220,
                        ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  getBanner2() {
    return Container(
      width: double.infinity,
      height: width > 400 && width < 729
          ? 70
          : width > 729
              ? 90
              : width < 360
                  ? 60
                  : 65,
      color: Colors.white,
      child: AdWidget(
        ad: bannerAd1!,
      ),
    );
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdMobManager.interCompleted,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            setState(() {
              interstitialAd = ad;

            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            interstitialAd=null;

          },
        ));

  }
  void _createInterstitialAdExitPractice() {
    InterstitialAd.load(
        adUnitId: AdMobManager.interExitExercise,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            setState(() {
              interstitialAd1 = ad;
              tapExit = 1;
              isAdsExit=true;

            });


          },
          onAdFailedToLoad: (LoadAdError error) {
            setState(() {
              tapExit = 1;
              isAdsExit=false;
            });

          },
        ));
  }

  void createBannerNative() {
    bannerAd = BannerAd(
      adUnitId: AdMobManager.bannerExcercise,
      size: AdSize(
          width: width,
          height: width > 400 && width < 729
              ? 80
              : width > 729
                  ? 90
                  : 65),
      request: const AdRequest(),
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          isBannerLoaded = true;
        });
      }, onPaidEvent: (ad, eMicros, preciscyCode, currencyCode) {
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
      }),
    )..load();
  }

  void createBannerNative2() {
    bannerAd1 = BannerAd(
      adUnitId: AdMobManager.bannerRestPage,
      size: AdSize(
          width: width,
          height: width > 400 && width < 729
              ? 80
              : width > 729
                  ? 90
                  : 65),
      request: const AdRequest(),
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          isBannerLoaded2 = true;
        });
      }, onPaidEvent: (ad, eMicros, preciscyCode, currencyCode) {
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
      }),
    )..load();
  }

  void Close() {
    Navigator.pop(context);
  }

  void updatePractice() {
    try {
      interAdsInter();
      PracticeModel.instances.updateIsCompleted(1, widget.list[index].DayExID);
      if (index < widget.list.length - 1) {
        index = index + 1;
        state_start = true;
      } else if (index == widget.list.length - 1) {
        if (ads < 1) {
          if (_appOpenAd != null) _appOpenAd!.dispose();
           if(interstitialAd!=null){
             interstitialAd!.show();
             interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
                 onAdShowedFullScreenContent: (InterstitialAd ad){
                   RoutesManager.instances.RoutesGotoPage(
                       context,
                       WinnerScreen(
                         length: widget.list.length,
                         second: allTime,
                         name: widget.name,
                       ));
                 },
                 onAdDismissedFullScreenContent: (ad){
                   ad.dispose();
                 },
                 onAdFailedToShowFullScreenContent: (ad,_){
                   ad.dispose();
                 },
                 onAdImpression: (ad){
                 }
             );
           }
          showSucess = 1;
          countDownOpen = 0;
        } else {
          RoutesManager.instances.RoutesGotoPage(
              context,
              WinnerScreen(
                length: widget.list.length,
                second: allTime,
                name: widget.name,
              ));
        }
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    if (ads < 1) {
      bannerAd1!.dispose();
      bannerAd!.dispose();
      if (_appOpenAd != null) _appOpenAd!.dispose();
    }
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive) {
      count_inactive = 1;
    }
    if (state == AppLifecycleState.paused) {
      count_pause = 1;
    }
    if (state == AppLifecycleState.resumed) {
      if (count_inactive == 1 && count_pause == 1 && isOpenApp && ads < 1) {
        if (showSucess < 1) {
          _appOpenAd!.show();
        }

        count_pause = 0;
        count_inactive = 0;
      }
    }
  }

  void loadAd() async {
    final fBannerRestPage =
        await RemoteConfigAd.instances.getBanner_rest_page();
    final fBannerExcersise =
        await RemoteConfigAd.instances.getBanner_exercise();
    final fOpenApp = await RemoteConfigAd.instances.getOpen_resume();
    final fInterCompleted = await RemoteConfigAd.instances.getInter_complete();
    final fInterExit = await RemoteConfigAd.instances.getInter_exit_exercise();
    final fResetSet = await SharePrefercens.instances.getRestSet();
    final fCountDown = await SharePrefercens.instances.getCountdown();
    final fWidth = await SharePrefercens.instances.getWidth();
    setState(() {
      width = fWidth;
      isBannerRestPage = fBannerRestPage;
      isBannerExcersise = fBannerExcersise;
      isOpenApp = fOpenApp;
      isInterCompleted = fInterCompleted;
      isInterExit = fInterExit;
      resetSet = fResetSet;
      countDown = fCountDown;
    });
    AppOpenAd.load(
      adUnitId: AdMobManager.openResumed,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          isOpenApp= true;
          EventsGA.instances.adImpressioInterOpenApp(ad);
        },
        onAdFailedToLoad: (error) {
          // Handle the error.
        },
      ),
    );
  }
}
