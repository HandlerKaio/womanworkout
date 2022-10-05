

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthygympractice/Routes/RoutesManager.dart';
import 'package:healthygympractice/extensions/color.dart';
import 'package:healthygympractice/models/history_model.dart';
import 'package:healthygympractice/translations/locale_key.g.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HistoryScreen();
}
class _HistoryScreen extends State<HistoryScreen>{

  double allCategories = 0;
  double allCategories1 = 0;
  double allCategories2 = 0;
  double allCategories3 = 0;

  double allTime =  0;
  double allTime1 = 0;
  double allTime2 = 0;
  double allTime3 = 0;
  List<HistoryModel> listFromOneToSeven =[];
  List<HistoryModel> listFrom7To14=[];
  List<HistoryModel> listFrom14To21=[];
  List<HistoryModel> listFrom21To28=[];
  int thang = DateTime.now().month;
  int nam =DateTime.now().year;
  DateTime focusday = DateTime.now();


  @override
  void initState() {
    super.initState();
    init(thang,nam);
  }
  init(int thang,int nam) async{

    listFrom7To14.clear();
    listFrom14To21.clear();
    listFrom21To28.clear();
    listFromOneToSeven.clear();
    final fListOneToSeven = await HistoryModel.inStances.getDataListHistory(thang, "01", "07",nam);
    final flistFrom7To14 = await HistoryModel.inStances.getDataListHistory(thang, "08", "15",nam);
    final flistFrom14To21 = await HistoryModel.inStances.getDataListHistory(thang, "16", "21",nam);
    final flistFrom21To28 = await HistoryModel.inStances.getDataListHistory(thang, "22", thang==2 ? "28" : thang==1 || thang==3||thang==5
        ||thang==7|| thang==8||thang==10||thang==12  ? "31":"30",nam);

     setState(() {
        if(fListOneToSeven.isNotEmpty){
           listFromOneToSeven = fListOneToSeven;
           for(final i in listFromOneToSeven){
             allCategories+= double.parse(i.allCalories.toString());
             allTime+= double.parse(i.allTime.toString().trim());
           }
        }
        if(flistFrom7To14.isNotEmpty){
          listFrom7To14 = flistFrom7To14;
          for(final i in listFrom7To14){
            allCategories1+= double.parse(i.allCalories.toString());
            allTime1+= double.parse(i.allTime.toString().trim());
          }
        }
        if(flistFrom14To21.isNotEmpty){
          listFrom14To21 = flistFrom14To21;
          for(final i in listFrom14To21){
            allCategories2+= double.parse(i.allCalories.toString());
            allTime2+= double.parse(i.allTime.toString().trim());
          }
        }
        if(flistFrom21To28.isNotEmpty){
          listFrom21To28 = flistFrom21To28;
          for(final i in listFrom21To28){
            allCategories3+= double.parse(i.allCalories.toString());
            allTime3+= double.parse(i.allTime.toString().trim());
          }
        }
     });



  }
  @override
  Widget build(BuildContext context) {
     return WillPopScope(child: Scaffold(
       appBar: AppBar(
         leading: IconButton(onPressed: (){
           Navigator.pop(context);
         }, icon: const Icon(Icons.arrow_back,color: Colors.black,)),
         title: Text(LocaleKeys.t_history.tr(),style: GoogleFonts.oswald(
           fontSize: 16,
           color: "#3E3E3E".toColor()
             
         ),),
         elevation: 0.2,
         backgroundColor: Colors.white,
       ),
        body:  SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 420,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(4,4),
                      blurRadius: 15
                    )
                  ]
                ),
                child: TableCalendar(
                  calendarFormat: CalendarFormat.month,
                  currentDay: focusday,
                  headerVisible: true,
                  onPageChanged: (datetime){
                   setState(() {
                        thang = datetime.month;
                        nam = datetime.year;
                        focusday = datetime;
                        init(thang,nam);

                   });
                  },

                  calendarStyle:  CalendarStyle(


                    selectedTextStyle:  GoogleFonts.oswald(
                      fontSize: 23,
                      color: "#676767".toColor(),
                      fontWeight: FontWeight.w500
                    ),
                    isTodayHighlighted: true,
                    defaultTextStyle: GoogleFonts.nunito(
                        fontSize: 15,
                        color: "#3E3E3E".toColor(),
                        fontWeight: FontWeight.w300
                    ) ,
                      todayDecoration: BoxDecoration(
                          color: Colors.pink.withOpacity(0.4),
                          shape:  BoxShape.circle
                      )

                  ),
                  daysOfWeekHeight: 40,
                  daysOfWeekStyle:  DaysOfWeekStyle(
                    weekdayStyle:  GoogleFonts.oswald(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500
                    ),
                    weekendStyle: GoogleFonts.oswald(
                        fontSize: 16,
                        color: "#FF4275".toColor(),
                        fontWeight: FontWeight.w500
                    ),
                  ),

                  headerStyle: HeaderStyle(
                    headerMargin: const EdgeInsets.only(left: 35,right: 35),
                    titleCentered: true,
                    formatButtonVisible: false,

                    formatButtonShowsNext: true,

                    titleTextStyle: GoogleFonts.oswald(
                        fontSize: 23,
                        color: "#676767".toColor(),
                        fontWeight: FontWeight.w500
                    ),

                  ),
                  firstDay: DateTime.utc(2015, 10, 16),
                  lastDay: DateTime.utc(2023, 3, 14),
                  focusedDay: focusday,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      thang  =selectedDay.month;
                      nam = selectedDay.year;
                      focusday = selectedDay;



                    });
                  },

                ),
              ),
              ConstrainedBox(constraints: BoxConstraints(
                minHeight: 500,
              ),child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      offset: Offset(1,1),
                      blurRadius: 3
                    )
                  ]
                ),
                child: Column(
                  children: [
                    listFromOneToSeven.isNotEmpty ?   getWidgetFromOnetoSeven("1 Th$thang - 7Th$thang",listFromOneToSeven.length,allTime,allCategories,listFromOneToSeven) :Container(),
                    listFrom7To14.isNotEmpty ?   getWidgetFromOnetoSeven("8 Th$thang - 14Th$thang",listFrom7To14.length,allTime1,allCategories1,listFrom7To14):Container(),
                    listFrom14To21.isNotEmpty ?  getWidgetFromOnetoSeven("15 Th$thang - 21Th$thang",listFrom14To21.length,allTime2,allCategories2,listFrom14To21):Container(),
                    listFrom21To28.isNotEmpty ?   getWidgetFromOnetoSeven("22 Th$thang - ${thang==2 ? "28" : thang==1 || thang==3||thang==5||thang==7 || thang==8 ||thang==10||thang==12 ? "31":"30"} Th$thang",listFrom21To28.length,allTime3,allCategories3,listFrom21To28):Container()


                  ],
                ),
              ),)
              

            ],
          ),
        ),
     ), onWillPop: ()async=>false);

  }
  ItemsWorkout(HistoryModel historyModel){
    return   Container(
      width: double.infinity,
      height: 95,
      padding: EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color:  "#FF4275".toColor().withOpacity(0.4),
              borderRadius: BorderRadius.circular(64)
            ),
            child: Image.asset("assets/icon/ic_history.png"),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(historyModel.dateCreate.toString(),style: GoogleFonts.quicksand(
                    fontSize: 12,
                    color: Colors.grey.shade600
                ),),
                margin: EdgeInsets.only(left: 12,top: 2),
              ),
              Container(
                child: Text(historyModel.name.toString(),style: GoogleFonts.oswald(
                    fontSize: 23,
                    fontWeight: FontWeight.w500
                ),),
                margin: EdgeInsets.only(left: 12,bottom: 1,top: 1),
              ),
              Container(
                padding: EdgeInsets.only(left: 10,right: 10),
                height: 35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(Icons.timer_sharp,color: Colors.blue,size: 12,),
                              Padding(padding: EdgeInsets.only(left: 5),child: Text(historyModel.allTime.toString(),style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: Colors.grey
                              ),),),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 15,left: 10),
                          child: Row(
                            children: [
                              Icon(Icons.local_fire_department_outlined,color: Colors.red,size: 12,),
                              Padding(padding: EdgeInsets.only(left: 5,),child: Text(historyModel.allCalories.toString()+" Calories",style: GoogleFonts.nunito(
                                  fontSize: 12,
                                  color: Colors.grey
                              ),),),
                            ],
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ),

            ],
          )
        ],
      ),
    );
  }
  getWidgetFromOnetoSeven(String ngaythang,int allWorkout,double timer,double allCalories,List<HistoryModel> list) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 10,right: 10),
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(

                children: [
                  Padding(padding: EdgeInsets.only(top: 0),child: Text(ngaythang,style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey.shade600
                  ),),),
                  Padding(padding: EdgeInsets.only(top: 5),child: Text("$allWorkout Workout",style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey
                  ),),),

                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Icon(Icons.timer_sharp,color: Colors.blue,size: 12,),
                        Padding(padding: EdgeInsets.only(left: 5),child: Text(timer.toStringAsFixed(1)+" minutes",style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.grey
                        ),),),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5,right: 15),
                    child: Row(
                      children: [
                        Icon(Icons.local_fire_department_outlined,color: Colors.red,size: 12,),
                        Padding(padding: EdgeInsets.only(left: 5,),child: Text("$allCalories Calories",style: GoogleFonts.roboto(
                            fontSize: 12,
                            color: Colors.grey
                        ),),),
                      ],
                    ),
                  ),

                ],
              )
            ],
          ),
        ),
        Divider(
            color: Colors.grey.shade300
        ),
        ConstrainedBox(constraints: BoxConstraints(
            minHeight: 150
        ),child: Container(
          child: ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              itemBuilder: (context,index)=>ItemsWorkout(list[index])),
        ),),

      ],
    );
  }

}