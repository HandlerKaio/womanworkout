import 'dart:io';


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:healthygympractice/Routes/RoutesManager.dart';
import 'package:healthygympractice/models/CategoryModel.dart';
import 'package:healthygympractice/translations/locale_key.g.dart';

import '../models/PlansModel.dart';
import '../models/PracticeModel.dart';
import '../view/Practice/ExcersieScreen.dart';
import '../view/Practice/WorkPlayPlanLevelScreen.dart';

class AdMobManager {

  AdMobManager.init();


  static String interSplash ="ca-app-pub-9145585496357863/9275621885";
  static String nativeLanguage ="ca-app-pub-9145585496357863/1397131862";
  static String bannerHome ="ca-app-pub-9145585496357863/8154111906";
  static String bannerRestPage ="ca-app-pub-9145585496357863/2901785229";
  static String nativeCompleted ="ca-app-pub-9145585496357863/7770968521";
  static String interCompleted ="ca-app-pub-9145585496357863/8863438782";
  static String interExitExercise ="ca-app-pub-9145585496357863/9299672615";
  static String rewardExcercise ="ca-app-pub-9145585496357863/6535320585";
  static String openResumed ="ca-app-pub-9145585496357863/5500028402";
  static String bannerExcercise ="ca-app-pub-9145585496357863/5794765191";
  static String rewardInterExcercise ="ca-app-pub-9145585496357863/1819170202";

  static AdMobManager instances = AdMobManager.init();
  late RewardedAd rewardedAd;

  Future<void> showvideoAds(BuildContext context,CategoryModel categoryModel,PlansModel plansModel) async {
    RewardedAd.load(
        adUnitId: rewardExcercise,
        request: AdRequest(),
    rewardedAdLoadCallback: RewardedAdLoadCallback(
    onAdLoaded: (RewardedAd ad) {

      loadRewardAd(ad,context,categoryModel,plansModel);

    },
    onAdFailedToLoad: (LoadAdError error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(LocaleKeys.ads_description_no_network.tr()),duration: const Duration(seconds: 2),),);

    },
    ));



  }
  Future<void> showvideoAdsPlanLevel(BuildContext context,List<PracticeModel> list_practice,String name,CategoryModel categoryModel) async {
    RewardedAd.load(
        adUnitId: rewardInterExcercise,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {

            loadRewardAdLevel(ad,context,list_practice,name,categoryModel);

          },
          onAdFailedToLoad: (LoadAdError error) {

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(LocaleKeys.ads_description_no_network.tr()),duration: const Duration(seconds: 2),),);

          },
        ));



  }

  void loadRewardAd(RewardedAd ad,BuildContext context,CategoryModel categoryModel,PlansModel plansModel) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad){
        RoutesManager.instances.RoutePush(context, ExcersieScreen(categoryModel, plansModel));
      },
      onAdWillDismissFullScreenContent: (ad){
    }
    );

    ad.show(onUserEarnedReward: (ad,item){
             print("show: "+item.amount.toString());
    });
  }
  void loadRewardAdLevel(RewardedAd ad,BuildContext context,List<PracticeModel> list_practice,String name,CategoryModel categoryModel) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad){
          RoutesManager.instances.RoutesGotoPage(context, WorkPlayPlanLevelScreen(list_practice,name,categoryModel));
        },
        onAdWillDismissFullScreenContent: (ad){
        }
    );

    ad.show(onUserEarnedReward: (ad,item){
      print("show: "+item.amount.toString());
    });
  }


}
