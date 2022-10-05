


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthygympractice/Routes/RoutesManager.dart';
import 'package:healthygympractice/models/PracticeModel.dart';
import 'package:healthygympractice/view/Practice/ExcersieScreen.dart';
import 'package:healthygympractice/view/Practice/PlansLevelScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/CategoryModel.dart';
import '../../models/PlansModel.dart';

class DescriptionLevelScreen extends StatefulWidget{
  PracticeModel exerciseModel;
  CategoryModel splasModel;
  DescriptionLevelScreen(this.exerciseModel,this.splasModel);
  @override
  State<StatefulWidget> createState() {


    return _DescriptionLevelScreen();
  }

}
class  _DescriptionLevelScreen extends State<DescriptionLevelScreen>{

  int timer = 0 ;
  bool dark_mode = false;
  String unit ="";
  int reset = 0;

  Init() async{
    if(widget.exerciseModel.replaceTime.toString().contains("s")){
      timer = int.parse(widget.exerciseModel.replaceTime.toString().replaceAll("s", "").trim());
      unit ="s";
    }else{
      timer = int.parse(widget.exerciseModel.replaceTime.toString().replaceAll("x", "").trim());
      unit="x";
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Init();
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(child: Scaffold(
      backgroundColor:  dark_mode? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor:  dark_mode? Colors.black : Colors.white,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Colors.pink.shade400,)),
        elevation: 0,
        title: Text(widget.exerciseModel.ExName.toString(),style: GoogleFonts.robotoFlex(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.pink.shade400
        ),),
        iconTheme: IconThemeData(
            color: Colors.pink.shade400
        ),

      ),
      body:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 180,
            child:  Image.asset(widget.exerciseModel.ExPath.toString(),height: 180),
          ),
          Padding(padding: const EdgeInsets.only(left: 15,top: 15),child: Text(widget.exerciseModel.ExName.toString(),
            style: TextStyle(color: Colors.pink.shade400,fontWeight: FontWeight.bold,fontSize: 20),),),
          Padding(padding: const EdgeInsets.only(left: 15,top: 10),child: Text(widget.exerciseModel.ExDescription.toString().tr(),
            style: TextStyle(fontSize: 15,color: dark_mode? Colors.white : Colors.black,),),),
          const Spacer(flex: 1,),
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 25,right: 25,bottom: 10),
            height: 60,
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Expanded(child: IconButton(onPressed: (){
                  if(timer> 0 ){
                    setState(() {
                      reset=1;
                      timer--;
                    });
                  }

                },icon: Icon(Icons.remove_circle,color: Colors.pink.shade400,),),flex: 1,),
                Padding(padding: EdgeInsets.only(left: 15),child: Text(timer.toString(),style: TextStyle(color: dark_mode? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),),),
                Expanded(child: IconButton(onPressed: (){
                  setState(() {
                    reset=1;
                    timer++;
                  });
                },icon: Icon(Icons.add_circle_outlined,color: Colors.pink.shade400,),),flex: 1,),

              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 25,right: 25,bottom: 50),
            height: 60,

            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                reset>0 ? Expanded(child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color:  reset>0 ? Colors.pink.shade400 : Colors.grey,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: RaisedButton(onPressed: (){
                    setState(() {
                      reset=0;
                      if(widget.exerciseModel.replaceTime.toString().contains("x")){
                        timer =  int.parse(widget.exerciseModel.replaceTime.toString().replaceAll("x", "").trim());
                      }else{
                        timer =  int.parse(widget.exerciseModel.replaceTime.toString().replaceAll("s", "").trim());
                      }

                    });
                  },


                    highlightColor:  reset>0 ? Colors.grey: Colors.transparent,
                    splashColor:  reset>0 ? Colors.grey: Colors.transparent,
                    focusColor:  reset>0 ? Colors.grey: Colors.transparent,
                    hoverColor: reset>0 ? Colors.grey: Colors.transparent,
                    elevation:  reset>0 ? 5 : 0,



                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                    ),color: reset>0 ? Colors.pink.shade400 : Colors.grey,child: const Text("RESET",style: TextStyle(color: Colors.white),),),
                )) :Container(),
                reset>0 ? SizedBox(width: 30,):Container(),
                Expanded(child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color:  Colors.pink.shade400,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: RaisedButton(onPressed: (){
                    if(unit=="s"){
                      PracticeModel.instances.setSaveTime("${timer}s", widget.exerciseModel.ExID!.toInt());
                    }else{
                      PracticeModel.instances.setSaveTime("x$timer", widget.exerciseModel.ExID!.toInt());
                    }
                    RoutesManager.instances.RoutesGotoPage(context, PlanLevelScreen(widget.splasModel));

                  },shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),color: Colors.pink.shade400,child: Text("SAVE",style: TextStyle(color: Colors.white),),),
                )),
              ],
            ),
          ),


        ],
      ),
    ), onWillPop: ()async{

      return true;
    });
  }

}