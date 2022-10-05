import 'dart:collection';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:healthygympractice/Routes/RoutesManager.dart';
import 'package:healthygympractice/Routes/ad_mob.dart';
import 'package:healthygympractice/Routes/audio_play.dart';
import 'package:healthygympractice/Sharepre/SharePrefercens.dart';
import 'package:healthygympractice/extensions/color.dart';
import 'package:healthygympractice/models/history_model.dart';
import 'package:healthygympractice/remote/remote_config.dart';
import 'package:healthygympractice/translations/locale_key.g.dart';
import 'package:healthygympractice/view/Home/HomeScreen.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart' as intl;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class WinnerScreen extends StatefulWidget {
  final int length;
  final double second;
  final String name;

  const WinnerScreen(
      {Key? key, required this.length, required this.second, required this.name})
      : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _WinnerScreen();
  }
}

class _WinnerScreen extends State<WinnerScreen>
 with WidgetsBindingObserver{
  int curent_weight = 0;
  TextEditingController txtweight = TextEditingController();
  final _controller = ScreenshotController();
  double weight = 1;
  double height = 1;
  double const_pound = 0.45;
  double const_inch = 2.54;
  List<double> itemsNumber = [15, 16, 18.5, 25, 30, 35, 40];
  int current_index = 1;
  double bmi_value = 15;
  bool b_show = true;
  double bMR = 0;
  int age = 0;
  bool isBannerLoaded = false;
  NativeAd ? bannerAd;
  bool isNativeCompleted = false;
  AppOpenAd ? _appOpenAd;
  int count_inactive=0;
  int count_pause=0;
  bool isOpenApp = false;
  int ads = 0;


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
      interAdsInterbanner();
      AppOpenAd.load(
        adUnitId: AdMobManager.openResumed,
        orientation: AppOpenAd.orientationPortrait,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {

            _appOpenAd = ad;
          },
          onAdFailedToLoad: (error) {

            count_inactive=0;
            count_pause=0;
          },
        ),
      );
    }
  }
  void interAdsInterbanner() async{

    final port = ReceivePort();
    final isolate =  await  Isolate.spawn(interAdsIsolateBanner, port.sendPort);
    port.listen((message) {
      createBannerNative();
    });
    isolate.kill(priority: Isolate.immediate);
  }
  static void interAdsIsolateBanner(SendPort sendPort) {
    sendPort.send(1);
  }

  void createBannerNative() {
    bannerAd = NativeAd(
      adUnitId: AdMobManager.nativeCompleted,
      factoryId: "NativeCompleted",
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad){
          setState(() {
            isBannerLoaded=true;
          });
        },
          onPaidEvent: (ad,eMicros,  preciscyCode,currencyCode){
            FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
            Map<String,dynamic> map = HashMap();
            map.putIfAbsent("currency", () => currencyCode);
            map.putIfAbsent("precision", () => preciscyCode.toString());
            map.putIfAbsent("adUnit", () => ad.adUnitId);
            map.putIfAbsent("value", () => eMicros/1000000);
            map.putIfAbsent("network", () => ad.responseInfo!.mediationAdapterClassName.toString());
            firebaseAnalytics.logEvent(
              name: "paid_ad_impression",
              parameters: map,

            );

          },
        onAdFailedToLoad: (ad,error){

        }
      ),
      
    )..load();
  }

  init() async {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    SharePrefercens.instances.setHistoryTick(dateFormat.format(DateTime.now()), 1);
    AudioPlayManager.init();
    AudioPlayManager.instances.audioFinish(1);
    //Lượng Calo đốt cháy mỗi phút = (0,035 x trọng lượng cơ thể) + ((vận tốc ^ 2) / chiều cao) x 0,029 x trọng lượng cơ thể
    final myWeight = await SharePrefercens.instances.getWeight();
    final myheight = await SharePrefercens.instances.getHeight();
    final myAge = await SharePrefercens.instances.getAge();
    final fOpenApp =  await RemoteConfigAd.instances.getOpen_resume();
    final fNativeCompleted = await  RemoteConfigAd.instances.getNative_complete();
    if (myWeight != null) {
      age = DateTime
          .now()
          .year - int.parse(myAge.toString().split("/")[2]);
      setState(() {
        isOpenApp= fOpenApp;
        isNativeCompleted = fNativeCompleted;
        weight = myWeight;
        txtweight.text = weight.toString();
        height = myheight;
        height /= 100;
        bmi_value = myWeight / (height * height);
        print(bmi_value);
        if (bmi_value > 0 && bmi_value < 15) {
          current_index = 0;
        } else if (bmi_value > 15 && bmi_value < 17) {
          current_index = 1;
        }
        else if (bmi_value > 18 && bmi_value <= 25) {
          current_index = 2;
        }
        else if (bmi_value > 25 && bmi_value <= 30) {
          current_index = 3;
        }
        else if (bmi_value > 30 && bmi_value <= 35) {
          current_index = 4;
        }
        else if (bmi_value > 35 && bmi_value <= 40) {
          current_index = 5;
        } else {
          current_index = 40;
        }
        //bMR = 655 + 9.6 * weight + 1.8 * height - (4.7 * age);
        bMR = 0.035 *weight +(5/height) *0.029 * weight * (widget.second/60);
      });
    } else {
      txtweight.text = "0";
    }
    DateFormat d = DateFormat("d MMM,hh:mm");
    DateFormat d1 = DateFormat("yyyy-MM-dd");
   HistoryModel.inStances.insertHistory(widget.name, bMR.toStringAsFixed(2), (widget.second/60).toStringAsFixed(1), d.format(DateTime.now()),d1.format(DateTime.now()));

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                      width: double.infinity,
                      height: 460,

                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                "assets/banner_fnish.png",
                              ))),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
                        child: Container(
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/shadow.png"))),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          "assets/shadow_1.png"))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    margin: EdgeInsets.only(top: 25, left: 10),
                                    child: IconButton(
                                        onPressed: () {
                                          RoutesManager.instances
                                              .RoutesGotoPage(
                                              context, HomeScreen());
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        )),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(top: 30),
                                    child: Image.asset("assets/rock.png"),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(top: 30),
                                    height: 120,
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/icon/excersise.png",
                                              color: Colors.white,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Text(
                                                widget.length.toString(),
                                                style: GoogleFonts.robotoFlex(
                                                    fontSize: 28,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight
                                                        .bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Text(
                                               LocaleKeys.t_excercises.tr(),
                                                style: GoogleFonts.robotoFlex(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 45,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/icon/calories.png",
                                              color: Colors.white,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Text(
                                                bMR.toStringAsFixed(2),
                                                style: GoogleFonts.robotoFlex(
                                                    fontSize: 28,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight
                                                        .bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Text(
                                               LocaleKeys.t_calories.tr(),
                                                style: GoogleFonts.robotoFlex(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 45,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/icon/minutes.png",
                                              color: Colors.white,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Text(
                                                (widget.second / 60)
                                                    .toStringAsFixed(2),
                                                style: GoogleFonts.robotoFlex(
                                                    fontSize: 28,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight
                                                        .bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 5),
                                              child: Text(
                                               LocaleKeys.t_minutes.tr(),
                                                style: GoogleFonts.robotoFlex(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 42,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              RoutesManager.instances
                                                  .RoutesGotoPage(
                                                  context, HomeScreen());
                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary:
                                                Colors.white.withOpacity(0.1),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(30))),
                                            child:  Text(LocaleKeys.t_do_it_again.tr().toUpperCase()),
                                          ),
                                        ),
                                        Container(
                                          width: 120,
                                          margin: EdgeInsets.only(left: 25),
                                          height: 42,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              sharePractice();

                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.white,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(30))),
                                            child: Text(
                                             LocaleKeys.t_share.tr().toUpperCase(),
                                              style: GoogleFonts.robotoFlex(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: "#7098FF".toColor()),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                  Container(
                      width: double.infinity,
                      height: isBannerLoaded? 735: 410,
                      margin: EdgeInsets.only(top: 355),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: getBMI()),
                ],
              ),
            )),
        onWillPop: () async => false);
  }

  getBMI() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(5), topLeft: Radius.circular(5))),
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isBannerLoaded && isNativeCompleted ? Container(
            height: 305,
            width: 330,
            margin: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
            padding: const EdgeInsets.only(top: 5,bottom: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(15)
            ),


            child: AdWidget(ad: bannerAd!),

          ):Container(),
          Padding(
            padding: EdgeInsets.only(left: 0, top: 50),
            child: Text(
              LocaleKeys.t_weight.tr().toUpperCase(),
              style: GoogleFonts.robotoFlex(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 30,
            margin: EdgeInsets.only(top: 15, bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: txtweight,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.robotoFlex(
                        fontSize: 16, color: Colors.black),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (curent_weight == 1) {
                        weight *= const_pound;
                      } else {
                        weight = double.parse(txtweight.text.toString());
                      }

                      curent_weight = 0;
                      txtweight.text =
                          intl.NumberFormat.decimalPattern().format(weight);
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.only(left: 5, right: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: curent_weight == 0
                            ? Colors.pink.shade300
                            : Colors.white,
                        border: curent_weight == 0
                            ? Border.all(color: Colors.transparent)
                            : Border.all(color: Colors.pink.shade300)),
                    child: Text(
                      "KG",
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: curent_weight == 0
                              ? Colors.white
                              : Colors.pink.shade300),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      weight = double.parse(txtweight.text.toString());
                      if (curent_weight == 0) {
                        weight /= const_pound;
                      }

                      txtweight.text =
                          intl.NumberFormat.decimalPattern().format(weight);
                      curent_weight = 1;
                    });
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: curent_weight == 1
                            ? Colors.pink.shade300
                            : Colors.white,
                        border: curent_weight == 1
                            ? Border.all(color: Colors.transparent)
                            : Border.all(color: Colors.pink.shade300)),
                    child: Text(
                      "LB",
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: curent_weight == 1
                              ? Colors.white
                              : Colors.pink.shade300),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 30,
            margin: EdgeInsets.only(top: 15, bottom: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 1,
                  ),
                  child: Text(
                    "BMI(km/m2)",
                    style: GoogleFonts.robotoFlex(
                        fontSize: 16, color: "#3E3E3E".toColor()),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              if (curent_weight == 1) {
                                weight *= const_pound;
                              } else {
                                weight =
                                    double.parse(txtweight.text.toString());
                              }

                              curent_weight = 0;
                              txtweight.text =
                                  intl.NumberFormat.decimalPattern()
                                      .format(weight);
                            });
                          },
                          child: Container(
                            width: 120,
                            height: 30,
                            margin: EdgeInsets.only(
                              left: 5,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              LocaleKeys.button_edit.tr().toUpperCase(),
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: "#FF7936".toColor()),
                            ),
                          )),
                      InkWell(
                          onTap: () {
                            setState(() {
                              if (b_show) {
                                b_show = false;
                              } else {
                                b_show = true;
                              }
                            });
                          },
                          child: Container(
                            width: 60,
                            height: 30,
                            margin: EdgeInsets.only(
                              left: 5,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              b_show == true ?  LocaleKeys.t_hide.tr().toUpperCase() : LocaleKeys.t_show.tr().toUpperCase(),
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: "#73B8E6".toColor()),
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
          b_show ? Container(
              margin: const EdgeInsets.only(top: 30.0,),
              height: 60,
              child: ListView.builder(
                  itemCount: itemsNumber.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      ItemsRuler(

                          itemsNumber[index], index))
          ) : Container()

        ],
      ),
    );
  }

  ItemsRuler(double value, int index) {
    return Container(
      height: 60,

      child: Stack(
        children: [
          current_index == index ? Container(
            height: 20,
            margin: EdgeInsets.only(left: value / 4),
            child: Text(
              bmi_value.toStringAsFixed(2), style: GoogleFonts.robotoFlex(
                fontSize: 15,
                color: "#3E3E3E".toColor()
            ),),
          ) : Container(
            height: 20,

          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 25, bottom: 4, left: 2),
                width: index == 0 ? 25 : index == 1 ? 35 : index == 2
                    ? 90
                    : index == 3 ? 50 : index == 4 ? 50 : 50,
                height: 5,
                decoration: BoxDecoration(
                  color: index == 0 ? Colors.green.shade200 : index > 0 &&
                      index <= 4 ? Colors.blue.shade200 : index == 5 ? Colors
                      .orange : Colors.red,
                ),
              ),
              Text(value.toStringAsFixed(1), style: GoogleFonts.robotoFlex(
                fontSize: 10,
              ),)
            ],
          ),

        ],
      ),

    );
  }

  void ShowInputHeight() async {
    final f_height = await SharePrefercens.instances.getHeight();
    final f_weight = await SharePrefercens.instances.getWeight();
    if (f_height != null) {
      height = f_height;
    }
    if (f_weight != null) {
      weight = f_weight;
    }
    int curent_weight = 0;

    TextEditingController txtheight = TextEditingController();
    TextEditingController txtweight = TextEditingController();
    txtheight.text = height.toString();
    txtweight.text = weight.toString();

    showModalBottomSheet(context: context,

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))
        ),
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              void Function(void Function()) setState) {
            return Container(
              width: 320,
              height: 360,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30),
                      topLeft: Radius.circular(30))
              ),
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Padding(padding: EdgeInsets.only(left: 0, top: 50),
                    child: Text(LocaleKeys.t_weight.tr().toUpperCase(), style: GoogleFonts.robotoFlex(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),),),
                  Container(
                    width: double.infinity,
                    height: 30,
                    margin: EdgeInsets.only(top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),

                    ),
                    child: Row(
                      children: [
                        Expanded(child: TextFormField(
                          controller: txtweight,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.robotoFlex(
                              fontSize: 16,
                              color: Colors.black
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],


                          decoration: InputDecoration(
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
                        ), flex: 1,),
                        InkWell(

                          onTap: () {
                            setState(() {
                              if (curent_weight == 1) {
                                height *= const_inch;
                                weight *= const_pound;
                              } else {
                                height =
                                    double.parse(txtheight.text.toString());
                                weight =
                                    double.parse(txtweight.text.toString());
                              }

                              curent_weight = 0;
                              txtweight.text =
                                  intl.NumberFormat.decimalPattern().format(
                                      weight);
                              txtheight.text =
                                  intl.NumberFormat.decimalPattern().format(
                                      height);
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            margin: EdgeInsets.only(left: 5, right: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: curent_weight == 0
                                    ? Colors.pink.shade300
                                    : Colors.white,
                                border: curent_weight == 0 ? Border.all(
                                    color: Colors.transparent) : Border.all(
                                    color: Colors.pink.shade300)
                            ),
                            child: Text("KG", style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: curent_weight == 0
                                    ? Colors.white
                                    : Colors.pink.shade300
                            ),),
                          ),

                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              height = double.parse(txtheight.text.toString());
                              weight = double.parse(txtweight.text.toString());
                              if (curent_weight == 0) {
                                height /= const_inch;
                                weight /= const_pound;
                              }

                              txtweight.text =
                                  intl.NumberFormat.decimalPattern().format(
                                      weight);
                              txtheight.text =
                                  intl.NumberFormat.decimalPattern().format(
                                      height);
                              curent_weight = 1;
                            });
                          },

                          child: Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: curent_weight == 1
                                    ? Colors.pink.shade300
                                    : Colors.white,
                                border: curent_weight == 1 ? Border.all(
                                    color: Colors.transparent) : Border.all(
                                    color: Colors.pink.shade300)
                            ),
                            child: Text("LB", style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: curent_weight == 1
                                    ? Colors.white
                                    : Colors.pink.shade300
                            ),),
                          ),
                        )

                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 0, top: 10),
                    child: Text(LocaleKeys.t_height.tr().toUpperCase(), style: GoogleFonts.robotoFlex(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),),),
                  Container(
                    width: double.infinity,
                    height: 30,
                    margin: EdgeInsets.only(top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),

                    ),
                    child: Row(
                      children: [
                        Expanded(child: TextFormField(
                          controller: txtheight,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.robotoFlex(
                              fontSize: 16,
                              color: Colors.black
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],


                          decoration: InputDecoration(


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
                        ), flex: 1,),
                        InkWell(

                          onTap: () {
                            setState(() {
                              if (curent_weight == 1) {
                                height *= const_inch;
                                weight *= const_pound;
                              } else {
                                height =
                                    double.parse(txtheight.text.toString());
                                weight =
                                    double.parse(txtweight.text.toString());
                              }

                              curent_weight = 0;
                              txtweight.text =
                                  intl.NumberFormat.decimalPattern().format(
                                      weight);
                              txtheight.text =
                                  intl.NumberFormat.decimalPattern().format(
                                      height);
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            margin: EdgeInsets.only(left: 5, right: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: curent_weight == 0
                                    ? Colors.pink.shade300
                                    : Colors.white,
                                border: curent_weight == 0 ? Border.all(
                                    color: Colors.transparent) : Border.all(
                                    color: Colors.pink.shade300)
                            ),
                            child: Text("CM", style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: curent_weight == 0
                                    ? Colors.white
                                    : Colors.pink.shade300
                            ),),
                          ),

                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              height = double.parse(txtheight.text.toString());
                              weight = double.parse(txtweight.text.toString());
                              if (curent_weight == 0) {
                                height /= const_inch;
                                weight /= const_pound;
                              }

                              txtweight.text =
                                  intl.NumberFormat.decimalPattern().format(
                                      weight);
                              txtheight.text =
                                  intl.NumberFormat.decimalPattern().format(
                                      height);
                              curent_weight = 1;
                            });
                          },

                          child: Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: curent_weight == 1
                                    ? Colors.pink.shade300
                                    : Colors.white,
                                border: curent_weight == 1 ? Border.all(
                                    color: Colors.transparent) : Border.all(
                                    color: Colors.pink.shade300)
                            ),
                            child: Text("FT", style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: curent_weight == 1
                                    ? Colors.white
                                    : Colors.pink.shade300
                            ),),
                          ),
                        )

                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 40,
                    margin: EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 40,
                          child: RaisedButton(onPressed: () {
                            setState(() {
                              if (weight > 0) {
                                SharePrefercens.instances.setWeight(
                                    double.parse(
                                        txtweight.text.toString().trim()));
                              } else {
                                ShowToast("Please input weight > 0");
                              }
                              if (height > 0) {
                                SharePrefercens.instances.setHeight(
                                    double.parse(
                                        txtheight.text.toString().trim()));
                              } else {
                                ShowToast("Please input height >  0");
                              }

                              SharePrefercens.instances.setType(curent_weight);
                              Navigator.pop(context);
                            });
                          },

                            color: Colors.pink.shade400,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Text(LocaleKeys.button_save.tr().toUpperCase(), style: GoogleFonts.robotoFlex(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),),),
                        ),
                        Container(
                          width: 120,
                          height: 50,
                          margin: EdgeInsets.only(left: 25),
                          child: RaisedButton(onPressed: () {
                            Navigator.pop(context);
                          },

                            color: Colors.grey.shade400,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Text(LocaleKeys.button_quit.tr().toUpperCase(), style: GoogleFonts.robotoFlex(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                            ),),),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },

          );
        });
  }

  void ShowToast(String s) {
    Fluttertoast.showToast(msg: s,
        fontSize: 16,
        textColor: Colors.black,
        backgroundColor: Colors.white);
  }
  @override
  void dispose() {
    if(ads<1){
      bannerAd!.dispose();
      _appOpenAd!.dispose();
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
      if(count_inactive==1 && count_pause==1 && isOpenApp  && ads<1){
        _appOpenAd!.show();
        count_inactive=0;
        count_inactive=0;
      }
    }
  }


  void sharePractice() async {

    ScreenshotController controller = ScreenshotController();
    controller.captureFromWidget(Container(
        width: double.infinity,
        height: 460,

        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  "assets/banner_fnish.png",
                ))),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/shadow.png"))),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                            "assets/shadow_1.png"))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 30),
                      child: Image.asset("assets/rock.png"),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 30),
                      height: 120,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icon/excersise.png",
                                color: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  widget.length.toString(),
                                  style: GoogleFonts.robotoFlex(
                                      fontSize: 28,
                                      color: Colors.white,
                                      fontWeight: FontWeight
                                          .bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  "Exercises",
                                  style: GoogleFonts.robotoFlex(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 45,
                          ),
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icon/calories.png",
                                color: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  bMR.toStringAsFixed(2),
                                  style: GoogleFonts.robotoFlex(
                                      fontSize: 28,
                                      color: Colors.white,
                                      fontWeight: FontWeight
                                          .bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  "Calories",
                                  style: GoogleFonts.robotoFlex(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 45,
                          ),
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icon/minutes.png",
                                color: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  (widget.second / 60)
                                      .toStringAsFixed(2),
                                  style: GoogleFonts.robotoFlex(
                                      fontSize: 28,
                                      color: Colors.white,
                                      fontWeight: FontWeight
                                          .bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  "Minutes",
                                  style: GoogleFonts.robotoFlex(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 2,
                          )
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        )),).then((image) async{
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = await File('${directory.path}/image.png').create();
        await imagePath.writeAsBytes(image);

        /// Share Plugin
        await Share.shareFiles([imagePath.path]);
      }else{

      }
    });


  }



}
