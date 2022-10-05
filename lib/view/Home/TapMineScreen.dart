


import 'dart:ffi';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthygympractice/Routes/RoutesManager.dart';
import 'package:healthygympractice/Sharepre/SharePrefercens.dart';
import 'package:healthygympractice/extensions/color.dart';

import 'package:healthygympractice/view/MINE/MyProfileScreen.dart';
import 'package:healthygympractice/view/MINE/PrivacyScreen.dart';
import 'package:healthygympractice/view/MINE/ReminderScreen.dart';
import 'package:healthygympractice/view/MINE/remove_ads.dart';
import 'package:healthygympractice/view/Practice/LanguageScreenSettings.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../models/PlansModel.dart';
import '../../translations/locale_key.g.dart';

class TapMineScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState()=> _TapMineScreen();
}
class _TapMineScreen extends State<TapMineScreen>{
  String language ="en";
  String my_profile = "My profile";
  String Reminder = "Reminder";
  String Restset = "Rest set";
  String CountdownTime = "Countdown Time";
  String Languageoptions = "Language options";
  int adsDonate = 0;
  int restSet = 20;
  TextEditingController txtResetSet =  TextEditingController();
  TextEditingController txtCountDown =  TextEditingController();
  int ads = 0;
  Init() async{

     final f_language   = await SharePrefercens.instances.getLanguage();
     final f_ads  = await SharePrefercens.instances.getAds();
     final f_restSet  = await SharePrefercens.instances.getRestSet();
     final fCountDown  = await SharePrefercens.instances.getCountdown();
     setState(() {
       ads= f_ads;
       language = f_language;
       restSet = f_restSet;
       txtResetSet.text = restSet.toString();
       txtCountDown.text = fCountDown.toString();
     });


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Init();
  }
  @override
  Widget build(BuildContext context)  {

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

           Padding(padding: EdgeInsets.only(top: 25,left: 15),child: Text("MINE",style: GoogleFonts.robotoFlex(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),),),
          ads> 0  ?Container(): DividerCustom(),
         ads> 0  ? Container() :  Container(
           width: double.infinity,
           height: 80,
           margin: const EdgeInsets.only(top: 15),
           child: Column(
             children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Container(

                     margin: const EdgeInsets.only(left: 15),

                     child: Image.asset("assets/fire_ads.png",width: 32,height: 32,),
                   ),
                   Expanded(flex: 1,child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Padding(padding: const EdgeInsets.only(left: 5),child: Text("Donate now",style: GoogleFonts.robotoFlex(
                           fontSize: 15,
                           color: Colors.black
                       ),),),
                       Padding(padding: const EdgeInsets.only(left: 5),child: Text("give us motivation",style: GoogleFonts.robotoFlex(
                           fontSize: 12,
                           color: Colors.grey
                       ),),),

                     ],
                   ),),
                   InkWell(
                     child:  Container(
                         width: 80,
                         height: 35,
                         margin: const EdgeInsets.only(right: 15),
                         alignment: Alignment.center,
                         decoration: const BoxDecoration(
                             image: DecorationImage(
                                 image: AssetImage("assets/button_price_ads.png")
                             )
                         ),
                         child: Text("4.99\$",style: GoogleFonts.robotoFlex(
                             fontSize: 15,
                             color: Colors.white
                         ),)
                     ),
                   ),


                 ],
               ),
               InkWell(
                 onTap: (){
                   RoutesManager.instances.routesNewPage(context, RemoveADS());
                 },
                 child: Container(
                   width: double.infinity,
                   height: 40,
                   alignment: Alignment.center,
                   margin: const EdgeInsets.only(left: 50,right: 15,top: 5),
                   decoration: BoxDecoration(
                       color: "#FF4275".toColor().withOpacity(0.1),
                       borderRadius: BorderRadius.circular(10)
                   ),
                   child: Text("Donate for us",style: GoogleFonts.robotoFlex(
                       fontSize: 15,
                       color: Colors.pink.shade400
                   ),),
                 ),
               )
             ],
           ),
         ),
          DividerCustom(),
           CustomSettings(LocaleKeys.mine_profile.tr(),(){
             RoutesManager.instances.routesNewPage(context, MyProfileScreen());
           },"assets/icon/edit_profile.png"),
          DividerCustom(),
           CustomSettings(LocaleKeys.mine_reminder.tr(),(){
             RoutesManager.instances.routesNewPage(context, ReminderScreen());
           },"assets/icon/reminder.png"),
          DividerCustom(),
          Padding(padding: EdgeInsets.only(left: 15),child: Text("Mine",style: GoogleFonts.robotoFlex(
              fontSize: 14,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.bold
          ),),),
          CustomSettings(LocaleKeys.mine_rest_set.tr(),(){
             showDiaLogRestSet();
          },"assets/icon/reset_mine.png"),
          DividerCustom(),
          CustomSettings(LocaleKeys.mine_countdown_time.tr(),(){
            showDiaLogCountDown();
          },"assets/icon/count_down.png"),
          DividerCustom(),
          Padding(padding: EdgeInsets.only(left: 15),child: Text(LocaleKeys.mine_general_settings.tr(),style: GoogleFonts.robotoFlex(
              fontSize: 14,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.bold
          ),),),
          CustomSettings(LocaleKeys.mine_language_options.tr(),(){
            RoutesManager.instances.RoutesGotoPage(context, LanguageScreenSettings());
          },"assets/icon/ic_language.png"),
          DividerCustom(),
          Padding(padding: EdgeInsets.only(left: 15),child: Text(LocaleKeys.mine_support_us.tr(),style: GoogleFonts.robotoFlex(
              fontSize: 14,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.bold
          ),),),
          CustomSettings(LocaleKeys.mine_rate.tr(),(){
            ShowRatingBar();
          },"assets/icon/ic_rate.png"),
          DividerCustom(),
          CustomSettings(LocaleKeys.mine_feed_back.tr(),(){
            launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.pas.women.workout.fatburn"));
            
          },"assets/icon/ic_feedback.png"),
          DividerCustom(),
          CustomSettings(LocaleKeys.mine_privacy_policy.tr(),(){
            RoutesManager.instances.routesNewPage(context, PrivacyScreen());
          },"assets/icon/privacy.png"),
          DividerCustom(),
          CustomSettings(LocaleKeys.mine_restart_progress.tr(),(){
            ShowDialogReset();
          },"assets/icon/reset_mine.png"),

          
        ],
      ),
    );
  }
  CustomSettings(String title,VoidCallback press, String assets_icon) {
    return InkWell(
      onTap: press,
      child: Container(
        width: double.infinity,
        height: 50,
        margin: EdgeInsets.only(top: 5),
        child: Row(
          children: [
            Padding(padding: EdgeInsets.only(left: 25),child: Image.asset(assets_icon),),
             Padding(padding: EdgeInsets.only(left: 10),child: Text(title,style: GoogleFonts.robotoFlex(
                 fontSize: 16,
                 color: Colors.black
             ),))
          ],
        ),
      ),
    );
  }
  DividerCustom()
  {
    return   Padding(padding: EdgeInsets.only(left: 15,right: 15),child: Divider(
      color: Colors.grey.shade300,
    ),);
  }
  void ShowRatingBar() {
    final _dialog = RatingDialog(
      initialRating: 1.0,
      title: Text("Rating Women's Home Workout: Fat Burn",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color:  Colors.pink),textAlign: TextAlign.center,),
      submitButtonText: 'Submit',
      onSubmitted: (reponsive) {
       Rate_Google();
      },
      onCancelled: (){

      },

      message: Text(
        'Tap a star to set your rating. Add more description here if you want.',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),

      starColor:  Colors.pink.shade400,
      image: Image.asset("assets/icon/logo.jpg",width: 120,height: 120,),
      commentHint: "Enter & Feedback",
    );
    showDialog(context: context, builder: (context)=> _dialog);

  }
  Future<void> Rate_Google() async {
    launchUrl(Uri.parse("https://play.google.com/store/apps/details?id=com.pas.women.workout.fatburn"));
  }
  void ShowDialogReset() {

    showDialog(context: context, builder: (context){

      return AlertDialog(
        title: Text("If you agree, all exercises will return to their original state !",style: GoogleFonts.robotoFlex(
            fontSize: 14,
            color: Colors.grey.shade700
        ),),
        actions: [
          Container(
            width: 90,
            height: 30,
            child: RaisedButton(onPressed: (){

              PlansModel.instances.UpdateAllProgess(0);
              Navigator.pop(context);
              updateSucess();


            },
              color: Colors.pink.shade400,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              child: Text("OK"),),
          ),
          Container(
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
              child: Text("Cancel"),),
          )
        ],
      );
    });
  }

  void showDiaLogRestSet() {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context){
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: 320,
          height: 240,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 30,
                alignment: Alignment.centerLeft,
                child: IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.close,color: Colors.pink.shade400,)),
              ),
              Padding(padding: const EdgeInsets.only(top: 10),child: Text(LocaleKeys.mine_rest_set.tr(),style: GoogleFonts.oswald(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w800
              ),),),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.only(left: 15,right: 15,top: 15),
                child: TextFormField(
                  controller: txtResetSet,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "input ${LocaleKeys.mine_rest_set.tr()} (s)",
                  ),
                ),
              ),
              Container(
                width: 220,
                height: 40,
                margin: const EdgeInsets.only(top: 30,bottom: 15),
                child: ElevatedButton(
                  onPressed: (){
                    if(txtResetSet.text.toString().isNotEmpty){
                      SharePrefercens.instances.setRestSet(int.parse(txtResetSet.text.toString().trim()));

                    }else{
                      SharePrefercens.instances.setRestSet(20);
                    }

                    Navigator.pop(context);
                    
                    
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pink.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    )
                  ),
                  child: Text(LocaleKeys.button_save.tr(),style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w700
                ),),
                ),
              )
              
            ],
          ),
        )
      );
    });
  }
  void showDiaLogCountDown() {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context){
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                width: 320,
                height: 240,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 30,
                      alignment: Alignment.centerLeft,
                      child: IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: Icon(Icons.close,color: Colors.pink.shade400,)),
                    ),
                    Padding(padding: const EdgeInsets.only(top: 10),child: Text(LocaleKeys.mine_countdown_time.tr(),style: GoogleFonts.oswald(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w800
                    ),),),
                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.only(left: 15,right: 15,top: 15),
                      child: TextFormField(
                        controller: txtCountDown,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "input ${LocaleKeys.mine_countdown_time.tr()} (s)",
                        ),
                      ),
                    ),
                    Container(
                      width: 220,
                      height: 40,
                      margin: const EdgeInsets.only(top: 30,bottom: 15),
                      child: ElevatedButton(
                        onPressed: (){
                          if(txtCountDown.text.toString().isNotEmpty){
                            SharePrefercens.instances.setRestSet(int.parse(txtResetSet.text.toString().trim()));
                          }else{
                            SharePrefercens.instances.setCountDown(5);
                          }
                          Navigator.pop(context);


                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.pink.shade400,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)
                            )
                        ),
                        child: Text(LocaleKeys.button_save.tr(),style: GoogleFonts.nunito(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w700
                        ),),
                      ),
                    )

                  ],
                ),
              )
          );
        });
  }

  void updateSucess() {
    Future.delayed(Duration(milliseconds: 150),(){
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Successfully"),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 650),));
    });
  }




}