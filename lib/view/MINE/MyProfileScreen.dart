

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthygympractice/Routes/RoutesManager.dart';
import 'package:healthygympractice/translations/locale_key.g.dart';

import 'package:healthygympractice/view/Home/HomeScreen.dart';
import 'package:intl/intl.dart' as intl;

import '../../Sharepre/SharePrefercens.dart';

class MyProfileScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_MyProfileScreen();
}
class _MyProfileScreen extends State<MyProfileScreen>{
  int current_select = 0;
  int current_page = 0 ;
  int current_type_weight=0;
  double weight = 65;
  double height = 165;
  double const_pound = 0.45;
  double const_inch = 2.54;
  String date ="07/07/1996";
  int hour = 0;
  int minutes = 0;
  int type = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    intProfile();
  }
  intProfile()async{
    final f_height = await SharePrefercens.instances.getHeight();
    final f_weight = await SharePrefercens.instances.getWeight();
    final f_type = await SharePrefercens.instances.getType();
     setState(() {
       if(f_height!=null){
         height = f_height;
       }
       if(f_weight!=null){
         weight = f_weight;
       }
       if(f_type!=null){
         current_type_weight = f_type;
       }

     });

  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.pink.shade400,
        title: Text(LocaleKeys.mine_profile.tr().toUpperCase()),
        leading: IconButton(onPressed: (){
         Navigator.pop(context);
        }, icon: const Icon(Icons.arrow_back,color: Colors.white,)),
      ),
      body:  SingleChildScrollView(
        child:  Column(

          children: [
            Container(
              width: double.infinity,
              height: 64,
              margin: EdgeInsets.only(top: 15),
              alignment: Alignment.center,
              child: Container(
                width: 64,
                height: 64,
                padding: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    borderRadius: BorderRadius.circular(64)
                ),
                child:  Image.asset("assets/icon/person.png",width: 42,height: 64,fit: BoxFit.fitHeight,),
              ),
            ),

            Padding(padding: EdgeInsets.only(left: 5,right: 5,top: 9),child: Text(LocaleKeys.description_profile.tr(),style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.grey.shade700
            ),textAlign: TextAlign.center,),),
            Container(
              width: double.infinity,
              height: 50,
              margin: EdgeInsets.only(left: 20,right: 20,top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(

                    onTap: (){
                      setState(() {
                        if(current_type_weight==1){
                          height*=const_inch;
                          weight*=const_pound;
                        }

                        current_type_weight=0;
                        SharePrefercens.instances.setType(current_type_weight);
                      });
                    },
                    child: Container(
                      width: 150,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: current_type_weight == 0? Colors.pink.shade300 : Colors.white,
                          border:  current_type_weight == 0 ? Border.all(color: Colors.transparent):Border.all(color: Colors.pink.shade300)
                      ),
                      child:  Text("kg,cm",style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color:  current_type_weight == 0 ? Colors.white: Colors.pink.shade300
                      ),),
                    ),

                  ),
                  const SizedBox(width: 10,),
                  InkWell(
                    onTap: (){
                      setState(() {
                        if(current_type_weight==0){
                          height/=const_inch;
                          weight/=const_pound;
                        }
                        current_type_weight=1;
                        SharePrefercens.instances.setType(current_type_weight);
                      });
                    },

                    child: Container(
                      width: 150,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: current_type_weight == 1? Colors.pink.shade300 : Colors.white,
                          border:  current_type_weight == 1 ?   Border.all(color: Colors.transparent):Border.all(color: Colors.pink.shade300)
                      ),
                      child:  Text("lb,ft",style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color:  current_type_weight == 1 ? Colors.white: Colors.pink.shade300
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
                margin: EdgeInsets.only(left: 10,right: 10),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 17),child: Text(LocaleKeys.t_height.tr(),style: GoogleFonts.roboto(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700

                    ),),),
                    Padding(padding: EdgeInsets.only(right: 17),child: Text(current_type_weight == 0? intl.NumberFormat.decimalPattern().format(height)+"cm":intl.NumberFormat.decimalPattern().format(height)+"ft",style: GoogleFonts.roboto(
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
                margin: EdgeInsets.only(left: 10,right: 10),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 17),child: Text(LocaleKeys.t_weight.tr(),style: GoogleFonts.roboto(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700

                    ),),),
                    Padding(padding: EdgeInsets.only(right: 17),child: Text(current_type_weight == 0? intl.NumberFormat.decimalPattern().format(weight)+"kg":intl.NumberFormat.decimalPattern().format(weight)+"lb",style: GoogleFonts.roboto(
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
                margin: EdgeInsets.only(left: 10,right: 10),
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 17),child: Text(LocaleKeys.t_dob.tr(),style: GoogleFonts.roboto(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700

                    ),),),
                    Padding(padding: EdgeInsets.only(right: 17),child: Text(date,style: GoogleFonts.roboto(
                        fontSize: 17,
                        color: Colors.pink.shade300

                    ),),),
                  ],
                ),
              ),
            ),


          ],
        ),
      ),
    ), onWillPop: ()async{
      Navigator.pop(context);
      return true;
    });
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))
        ),
        builder: (context){

          return StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {

            return Padding(padding: MediaQuery.of(context).viewInsets,child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [


                Padding(padding: EdgeInsets.only(left: 15,top: 50),child: Text(LocaleKeys.t_weight.tr(),style: GoogleFonts.robotoFlex(
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
                      ),flex: 1,),
                      InkWell(

                        onTap: (){
                          setState(() {
                            if(curent_weight==1){
                              height*=const_inch;
                              weight*=const_pound;

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
                              height/=const_inch;
                              weight/=const_pound;
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
                Padding(padding: EdgeInsets.only(left:15,top: 10,),child: Text(LocaleKeys.t_height.tr(),style: GoogleFonts.robotoFlex(
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
                      ),flex: 1,),
                      InkWell(

                        onTap: (){
                          setState(() {

                            if(curent_weight==1){
                              height*=const_inch;
                              weight*=const_pound;
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
                              height/=const_inch;
                              weight/=const_pound;
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
                  margin: EdgeInsets.only(top: 15,bottom: 15),
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
                            intProfile();
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
                        margin: EdgeInsets.only(left: 25),
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
    final timer_select  = DateTime.now();

    final dialog_timer =  await showDatePicker(context: context,

      confirmText: "Save",
      cancelText: "Cancel",
      fieldLabelText: "Select DOB",
      initialDate: timer_select,

      firstDate: DateTime(1950), lastDate: DateTime(DateTime.now().year+1),);

    if(dialog_timer!=null && dialog_timer!=timer_select){
      String date_ = intl.DateFormat("dd/MM/yyyy").format(dialog_timer);
      if(dialog_timer.year>= timer_select.year+1){
        ShowToast("Date of birth not valid");
      }else{
        setState(() {
          date = date_;

        });
      }


    }


  }


}