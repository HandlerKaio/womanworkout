import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:healthygympractice/Routes/ad_mob.dart';
import 'package:healthygympractice/Routes/events_ga.dart';
import 'package:healthygympractice/remote/remote_config.dart';
import 'package:healthygympractice/translations/locale_key.g.dart';
import 'package:healthygympractice/view/Home/TapHomeScreen.dart';
import 'package:healthygympractice/view/Home/TapMineScreen.dart';
import 'package:healthygympractice/view/Report/TapReportScreen.dart';

import '../../Sharepre/SharePrefercens.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> with WidgetsBindingObserver {
  int current_page_tap = 0;
  AppOpenAd? _appOpenAd;
  BannerAd? bannerAd;
  bool isBannerLoaded = false;
  int current_bg = 0;
  bool open_config = false;
  bool bannerHome = false;
  bool openResumed = false;
  double size = 0;
  double height = 0;
  int width = 360;
  int count_inactive = 0;
  int count_pause = 0;
  int ads = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    initads();
  }

  initads() async {
    final fads = await SharePrefercens.instances.getAds();
    ads = fads;
    init();

    if (ads < 1) {
      Future.delayed(const Duration(milliseconds: 350), () {
        createBannerNative();
      });
      loadAd();
    }
  }

  init() async {
    final fBannerHome = await RemoteConfigAd.instances.getBanner_home();
    final fopenResumes = await RemoteConfigAd.instances.getOpen_resume();
    final fWidth = await SharePrefercens.instances.getWidth();
    setState(() {
      width = fWidth;
      bannerHome = fBannerHome;
      openResumed = fopenResumes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: SizedBox(
                child: current_page_tap == 0
                    ? TapHomeScreen()
                    : current_page_tap == 1
                        ? TapReportScreen()
                        : TapMineScreen(),
              ),
            ),
            Container(
              width: double.infinity,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  bottomBar(LocaleKeys.home_bottom.tr(), () {
                    setState(() {
                      current_page_tap = 0;
                    });
                  }, "assets/icon/fire_unselect.png", 0,
                      "assets/icon/fire_select.png"),
                  bottomBar(LocaleKeys.home_bottom_report.tr(), () {
                    setState(() {
                      current_page_tap = 1;
                    });
                  }, "assets/icon/report_unselect.png", 1,
                      "assets/icon/report_select.png"),
                  bottomBar(LocaleKeys.home_bottom_mine.tr(), () {
                    setState(() {
                      current_page_tap = 2;
                    });
                  }, "assets/icon/mine_unselect.png", 2,
                      "assets/icon/mine_select.png"),
                ],
              ),
            ),
            isBannerLoaded && bannerHome
                ? Container(
                    width: double.infinity,
                    height: width > 400 && width < 729
                        ? 70
                        : width > 729
                            ? 90
                            : 65,
                    child: AdWidget(ad: bannerAd!),
                  )
                : Container()
          ],
        )),
        onWillPop: () async => false);
  }

  void createBannerNative() {
    int create_Banner = 0;
    bannerAd = BannerAd(
      adUnitId: AdMobManager.bannerHome,
      size: AdSize(
          width: width,
          height: width > 400 && width < 729
              ? 80
              : width > 729
                  ? 90
                  : 65),
      request: const AdRequest(),
      listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (create_Banner == 0) {
              setState(() {
                isBannerLoaded = true;
              });
              create_Banner = 1;
            }
          },
          onAdImpression: (ad) {},
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
              name: "Banner_home",
              parameters: map,
            );
          }

          // onAdClicked: (ad)=> EventsGA.instances.adClickBannerHome(AdMobManager.bannerHome)

          ),
    )..load();
  }

  bottomBar(String title, VoidCallback press, String unActive, int currentTap,
      String acTive) {
    return InkWell(
      onTap: press,
      child: Column(
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(bottom: 1, top: 9),
            child: current_page_tap == currentTap
                ? Image.asset(acTive)
                : Image.asset(unActive),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 2,
            ),
            child: Text(
              title,
              style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: currentTap == current_page_tap
                      ? Colors.pink.shade400
                      : Colors.grey),
            ),
          )
        ],
      ),
    );
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
    if (state == AppLifecycleState.resumed && openResumed && ads < 1) {
      if (count_inactive == 1 && count_pause == 1) {
        _appOpenAd!.show();
        count_inactive = 0;
        count_inactive = 0;
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
        onAdFailedToLoad: (error) {},
      ),
    );
  }

  @override
  void dispose() {
    if (ads < 1 && _appOpenAd != null) {
      _appOpenAd!.dispose();
      bannerAd!.dispose();
    }
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
