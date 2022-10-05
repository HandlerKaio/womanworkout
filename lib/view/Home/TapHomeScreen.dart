


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthygympractice/Routes/RoutesManager.dart';
import 'package:healthygympractice/Sharepre/SharePrefercens.dart';
import 'package:healthygympractice/models/CategoryModel.dart';
import 'package:healthygympractice/translations/locale_key.g.dart';
import 'package:healthygympractice/view/Home/set_week_goal_screem.dart';
import 'package:healthygympractice/view/Practice/DetailsPracticeScreen.dart';
import 'package:healthygympractice/view/Practice/PlansLevelScreen.dart';

import '../../models/SplasModel.dart';

class TapHomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return _TapHomeScreen();
  }

}
class _TapHomeScreen extends State<TapHomeScreen>{
  List<CategoryModel> list = [];
  List<CategoryModel> list_abs_workout = [];
  List<CategoryModel> list_arm_workout = [];
  List<CategoryModel> list_thing_workout = [];
  List<CategoryModel> list_butt_workout = [];
  List<CategoryModel> list_split_workout = [];

  bool isMonday = false;
  bool isTuesDay = false;
  bool isWed = false;
  bool isThurs = false;
  bool isFri = false;
  bool isSat = false;
  bool isSun = false;
  int weekgoal = 0;
  Init()async {
    DateFormat dateFormat = DateFormat("EEEE");
    DateFormat dateFormat1 = DateFormat("dd/MM/yyyy");
    String dateNow = dateFormat.format(DateTime.now());
    final weekOt = await SharePrefercens.instances.getTickGoal(dateFormat1.format(DateTime.now()));
    weekgoal = weekOt;
    switch(dateNow.toLowerCase()){
      case "monday" :case "thứ hai": isMonday=true;break;
      case "tuesday":case "thứ ba": isTuesDay=true;break;
      case "wednesday":case "thứ tư":isWed=true;break;
      case "thursday":case "thứ năm": isThurs=true;break;
      case "friday":case "thứ sáu": isFri=true;break;
      case "saturday": case "thứ bảy":isSat=true;break;
      case "sunday": case "chủ nhật":isSun=true;break;
    }

  }
  InitBanner() async{
     final f_list = await CategoryModel.instances.getDataListCategoryBanner(1);
     final f_list_abs = await CategoryModel.instances.getDataListCategoryBanner(2);
     final f_list_arm = await CategoryModel.instances.getDataListCategoryBanner(3);
     final f_list_thing = await CategoryModel.instances.getDataListCategoryBanner(4);
     final f_list_butt = await CategoryModel.instances.getDataListCategoryBanner(5);
     setState(() {
       list = f_list;
       list_abs_workout = f_list_abs;
       list_arm_workout = f_list_arm;
       list_thing_workout = f_list_thing;
       list_butt_workout = f_list_butt;
     });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Init();
    InitBanner();
  }
  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(left: 10,top: 10),child: Text("Women Workout",style: GoogleFonts.roboto(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.bold
          ),),),
          Container(
            width: double.infinity,
            height: 30,
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(padding: const EdgeInsets.only(left: 10,top: 10),child: Text(LocaleKeys.t_week_goal.tr().toUpperCase(),style: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,

                ),),),


              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 40,
            margin: EdgeInsets.only(top: 23),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                getWeekGoal("Mon", isMonday),
                getWeekGoal("Tue", isTuesDay),
                getWeekGoal("Wed", isWed),
                getWeekGoal("Thu", isThurs),
                getWeekGoal("Fri", isFri),
                getWeekGoal("Sat", isSat),
                getWeekGoal("Sun", isSun),

              ],
            ),
          ),
          Container(
              width: double.infinity,
              height: 30,
              margin: EdgeInsets.only(top: 15),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(left: 10,top: 10),child: Text(LocaleKeys.home_challenge.tr(),style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,

                  ),),),

                ],
              )
          ),
          Container(
            width: double.infinity,
            height: 250,
            child: ListView.builder(
                itemCount: list.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index)=>ItemsChallenge(list[index])),
          ),
          Container(
              width: double.infinity,
              height: 30,
              margin: EdgeInsets.only(top: 15),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(left: 10,top: 10),child: Text("ABS WORKOUT",style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,

                  ),),),

                ],
              )
          ),
          Container(
            width: double.infinity,
            height: 170,
            child: ListView.builder(
                itemCount: list_abs_workout.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index)=>ItemsAbs(list_abs_workout[index])),
          ),
          Container(
              width: double.infinity,
              height: 30,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(left: 10,top: 10),child: Text("ARM WORKOUT",style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,

                  ),),),

                ],
              )
          ),
          Container(
            width: double.infinity,
            height: 170,
            child: ListView.builder(
                itemCount: list_arm_workout.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index)=>ItemsAbs(list_arm_workout[index])),
          ),
          Container(
              width: double.infinity,
              height: 30,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(left: 10,top: 10),child: Text("THING WORKOUT",style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,

                  ),),),

                ],
              )
          ),
          Container(
            width: double.infinity,
            height: 170,
            child: ListView.builder(
                itemCount: list_thing_workout.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index)=>ItemsAbs(list_thing_workout[index])),
          ),
          Container(
              width: double.infinity,
              height: 30,
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.only(left: 10,top: 10),child: Text("BUTT WORKOUT",style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,

                  ),),),

                ],
              )
          ),
          Container(
            width: double.infinity,
            height: 170,
            child: ListView.builder(
                itemCount: list_butt_workout.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index)=>ItemsAbs(list_butt_workout[index])),
          ),

        ],
      ),
    );
  }
  ItemsChallenge(CategoryModel splasModel){
    return InkWell(
      onTap: (){
        RoutesManager.instances.routesNewPage(context, DetailsPracticeScreen(splasModel));
      },
      child: Container(
        width: 250,
        padding: EdgeInsets.only(left: 15),
        margin: EdgeInsets.only(left: 2,right: 2,top: 15),

        child: Image.asset(splasModel.image.toString()),
      ),
    );
  }
  ItemsAbs(CategoryModel splasModel){
    return InkWell(
      onTap: (){
        RoutesManager.instances.routesNewPage(context, PlanLevelScreen(splasModel));
      },
      child: Container(
        width: 280,
        padding: EdgeInsets.only(left: 25),
        margin: EdgeInsets.only(left: 2,right: 2,top: 5),

        child: Image.asset(splasModel.image.toString()),
      ),
    );
  }
  getWeekGoal(String title,bool bcheck){
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(42),
          color: Colors.grey.shade200
      ),
      child: bcheck && weekgoal==1 ? Icon(Icons.check,color: Colors.pink.shade400,): bcheck ? Text(title,style: GoogleFonts.roboto(
          fontSize: 12,
          color: Colors.pink.shade400,
          fontWeight: FontWeight.bold
      ),)
          :Text(title,style: GoogleFonts.roboto(
          fontSize: 12,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.bold
      ),)

    );
  }

  void ShowEditWeight() async {
    TextEditingController txtweight = TextEditingController();
    final fWeight = await SharePrefercens.instances.getWeight();
    txtweight.text = fWeight;
    showDialog(context: context, builder: (context){

      return  Dialog(
        child:  Container(
          width: 320,
          height: 320,
          child: Column(
            children: [

            ],
          ),
        ),
      );
    });
  }

}