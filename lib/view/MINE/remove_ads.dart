

import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:healthygympractice/Routes/RoutesManager.dart';
import 'package:healthygympractice/Sharepre/SharePrefercens.dart';

import 'package:healthygympractice/extensions/color.dart';
import 'package:healthygympractice/main.dart';
import 'package:healthygympractice/translations/locale_key.g.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
class RemoveADS extends StatefulWidget{
  @override
  State<StatefulWidget> createState()  => _RemoveADS();
}
class _RemoveADS extends State<RemoveADS> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  String price = "4.99";
   final Set<String> _kIds = <String>{'com.pas.women.workout.fatburn'};
  List<ProductDetails> products =[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  static final facebookAppEvents = FacebookAppEvents();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            InkWell(
              onTap: ()async {

                if(products.isNotEmpty){
                  PurchaseParam purchaseParam = GooglePlayPurchaseParam(
                    applicationUserName: null,
                    productDetails: products[0],);
                  InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam,autoConsume: true);
                }else{
                  showMessage("Wait a minute !");
                }


              },
              splashColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade200,
              child: Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.only(top: 650, bottom: 50),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/button_go.png')
                    )
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 420,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/bg_remove_ads.png")
                ),

              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/shadow_remove_ads.png")
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        margin: const EdgeInsets.only(top: 35, left: 5),
                        height: 24,
                        child: IconButton(onPressed: () {
                         Navigator.pop(context);
                        },
                            icon: const Icon(
                              Icons.arrow_back, color: Colors.white,)),
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(LocaleKeys.t_remove_ads.tr(), style: GoogleFonts.oswald(
                            fontSize: 22,
                            color: Colors.white,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400

                        ),),
                      ),

                    ],
                  ),
                ),

              ),
            ),
            Container(
              width: double.infinity,
              height: 420,
              margin: EdgeInsets.only(left: 35, right: 35, top: 120),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 9,
                        offset: Offset(4, 4)
                    ),
                    BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 9,
                        offset: Offset(-4, -4)
                    )
                  ]
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 62,
                    margin: EdgeInsets.only(top: 30),
                    child: Image.asset("assets/key_ads.png"),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: 240,
                      height: 60,
                      margin: EdgeInsets.only(top: 30),
                      padding: EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),

                          border: Border.all(color: "#73B8E6".toColor())
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(32),
                                border: Border.all(color: "#73B8E6".toColor())
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(left: 15),
                            child: Text(
                              '$price \$/ALL TIME', style: GoogleFonts.oswald(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: "#73B8E6".toColor()
                            ),),)
                        ],
                      ),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    height: 30,
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.only(left: 35, right: 5),

                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          child: Image.asset("assets/check_ads.png"),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10), child: Text(
                         LocaleKeys.t_remove_ads_description.tr(), style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: "#676767".toColor()

                        ),),)

                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 30,
                    padding: EdgeInsets.only(left: 35, right: 5),

                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          child: Image.asset("assets/check_ads.png"),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10), child: Text(
                          LocaleKeys.t_remove_more_description.tr(), style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: "#676767".toColor()

                        ),),)

                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 30,
                    padding: EdgeInsets.only(left: 35, right: 5),

                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          child: Image.asset("assets/check_ads.png"),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10), child: Text(
                          LocaleKeys.t_remove_const_description.tr(), style: GoogleFonts.nunito(
                            fontSize: 14,
                            color: "#676767".toColor()

                        ),),)

                      ],
                    ),
                  )
                ],
              ),
            ),


          ],
        ),
      ),
    ), onWillPop: () async {
      Navigator.pop(context);
      return true;
    });
  }

  @override
  void initState() {
     init();
    super.initState();
    loadPurchases();


  }
  init()async{
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
      purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {

    }, onError: (error) {
      // handle error here.
    });
  }
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {

      } else {
          if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
            bool valid = await _verifyPurchase(purchaseDetails);

        }
        if (purchaseDetails.pendingCompletePurchase) {
          SharePrefercens.instances.setRemoveADS(1);
          facebookAppEvents.logPurchase(amount: 4.99, currency: "\$");
          RoutesManager.instances.RoutePush(context, MyApp(0));
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {

    return Future<bool>.value(true);
  }
  Future<void> loadPurchases() async {
    final available = await _inAppPurchase.isAvailable();
    final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(_kIds);
    if (available) {
      products = response.productDetails;
      _purchases = <PurchaseDetails>[];
    }
  }
 @override
 void dispose() {

   super.dispose();
 }
 




  void showMessage(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s),duration: Duration(seconds: 3),));
  }




}