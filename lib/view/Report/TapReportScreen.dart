import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthygympractice/DB/DBExcerise.dart';
import 'package:healthygympractice/Sharepre/SharePrefercens.dart';
import 'package:healthygympractice/extensions/color.dart';
import 'package:healthygympractice/models/history_model.dart';
import 'package:healthygympractice/models/weight_model.dart';
import 'package:healthygympractice/translations/locale_key.g.dart';
import 'package:healthygympractice/view/Report/history_screen.dart';
import 'package:intl/intl.dart' as intl;
import 'package:syncfusion_flutter_charts/charts.dart';

class TapReportScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TapReportScreen();
}

class _TapReportScreen extends State<TapReportScreen> {
  List<int> list = [
    15,
    16,
    18,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33,
    34,
    35,
    36,
    37,
    38,
    39,
    40
  ];
  int allExcersie = 0;
  int allWorkout1 = 0;
  int allWorkout2 = 0;
  int allWorkout3 = 0;
  int allWorkout4 = 0;
  int allWorkout5 = 0;
  int allWorkout6 = 0;
  int allWorkout7 = 0;

  int numberDay1 = 1;
  int numberDay2 = 2;
  int numberDay3 = 3;
  int numberDay4 = 4;
  int numberDay5 = 5;
  int numberDay6 = 6;
  int numberDay7 = 7;
  int curent_weight = 0;
  TextEditingController txtweight = TextEditingController();
  TextEditingController txtHeight = TextEditingController();
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
  double allCategories = 0;
  double allTime = 0;
  List<ChartData> data = [];
  List<ChartData> dataCalories = [];
  List<WorkOutData> dataWorkout = [];
  List<HistoryModel> listHistory = [];
  List<WeightModel> listWeight = [];
  String d = "";
  String d1 = "";
  String d2 = "";
  String d3 = "";
  String d4 = "";
  String d5 = "";
  String d6 = "";
  String d7 = "";
  String reportBMI = LocaleKeys.t_Overweight.tr();
  @override
  void initState() {
    super.initState();
    initBMI();
    init();
  }

  initListChart() async {
    final fListWeight = await DBExcerise.instances.getDataListWeight(DateTime.now().month, DateTime.now().year);
    double weightFrom1to7 = 0;
    double weightFrom7to14 = 0;
    double weightFrom14to21 = 0;
    double weightFrom21to28 = 0;

    setState(() {
      if (fListWeight.isNotEmpty) {
        for (final i in fListWeight) {
          int date = int.parse(i.dateNow.toString().split("-")[2].trim());
          if (date > 0 && date <= 7) {
            weightFrom1to7 = double.parse(i.indexweight.toString());
          } else if (date > 7 && date <= 14) {
            weightFrom7to14 = double.parse(i.indexweight.toString());
          } else if (date > 14 && date <= 21) {
            weightFrom14to21 = double.parse(i.indexweight.toString());
          } else if (date > 21 && date <= 31) {
            weightFrom21to28 = double.parse(i.indexweight.toString());
          }
        }
      }

      data = [
        ChartData(DateTime.now().day, weight),
        ChartData(7, weightFrom1to7),
        ChartData(15, weightFrom7to14),
        ChartData(21, weightFrom14to21),
        ChartData(28, weightFrom21to28),
      ];
    });
  }

  initBMI() async {
    final myWeight = await SharePrefercens.instances.getWeight();
    final myheight = await SharePrefercens.instances.getHeight();
    final myAge = await SharePrefercens.instances.getAge();

    if (myWeight != null) {
      age = DateTime.now().year - int.parse(myAge.toString().split("/")[2]);
      setState(() {
        weight = myWeight;
        txtweight.text = weight.toString();
        height = myheight;
        txtHeight.text = height.toString();
        double height_convert = height / 100;
        bmi_value = myWeight / (height_convert * height_convert);
        if (bmi_value > 0 && bmi_value < 15) {
          current_index = 0;
          reportBMI = LocaleKeys.t_Moderate_Thinness.tr();
        } else if (bmi_value > 15 && bmi_value < 17) {
          current_index = 1;
          reportBMI = LocaleKeys.t_Moderate_Thinness.tr();
        } else if (bmi_value > 18 && bmi_value <= 25) {
          current_index = 2;
          reportBMI = LocaleKeys.t_Normal.tr();
        } else if (bmi_value > 25 && bmi_value <= 30) {
          current_index = 3;
          reportBMI = LocaleKeys.t_Overweight.tr();
        } else if (bmi_value > 30 && bmi_value <= 35) {
          current_index = 4;
          reportBMI = LocaleKeys.t_Obese_Class_I.tr();
        } else if (bmi_value > 35 && bmi_value <= 40) {
          current_index = 5;
          reportBMI = LocaleKeys.t_Obese_Class_II.tr();
        } else {
          current_index = 6;
          reportBMI = LocaleKeys.t_Obese_Class_III.tr();
        }
        bMR = 655 + 9.6 * weight + 1.8 * height - (4.7 * age);
        bMR *= 1.2;
      });
    } else {
      txtweight.text = "0";
    }
  }

  init() async {
    final fallCalories = await SharePrefercens.instances.getCalories();
    final fListOneToSeven = await HistoryModel.inStances.getDataListHistory(DateTime.now().month, "01", "31", DateTime.now().year);

    setState(() {
      // allCalories = fallCalories;
      // minutes = fallMinutes;

      numberDay1 = DateTime.now().day;


      if (numberDay1 > 0 && numberDay1 <= 7) {
        numberDay1 = 1;
        numberDay2 = 2;
        numberDay3 = 3;
        numberDay4 = 4;
        numberDay5 = 5;
        numberDay6 = 6;
        numberDay7 = 7;
      } else if (numberDay1 > 7 && numberDay1 <= 14) {
        numberDay1 = 8;
        numberDay2 = 9;
        numberDay3 = 10;
        numberDay4 = 11;
        numberDay5 = 12;
        numberDay6 = 13;
        numberDay7 = 14;
      } else if (numberDay1 > 14 && numberDay1 <= 21) {
        numberDay1 = 15;
        numberDay2 = 16;
        numberDay3 = 17;
        numberDay4 = 18;
        numberDay5 = 29;
        numberDay6 = 20;
        numberDay7 = 21;
      } else if (numberDay1 > 21) {
        numberDay1 = 22;
        numberDay2 = 23;
        numberDay3 = 24;
        numberDay4 = 25;
        numberDay5 = 26;
        numberDay6 = 27;
        numberDay7 = 28;
      }
      DateFormat dateFormat = DateFormat("EEEE",'en');
      DateTime dateTimeNow1 = DateTime.utc(DateTime.now().year,DateTime.now().month,numberDay1);
      DateTime dateTimeNow2 = DateTime.utc(DateTime.now().year,DateTime.now().month,numberDay2);
      DateTime dateTimeNow3 = DateTime.utc(DateTime.now().year,DateTime.now().month,numberDay3);
      DateTime dateTimeNow4 = DateTime.utc(DateTime.now().year,DateTime.now().month,numberDay4);
      DateTime dateTimeNow5 = DateTime.utc(DateTime.now().year,DateTime.now().month,numberDay5);
      DateTime dateTimeNow6 = DateTime.utc(DateTime.now().year,DateTime.now().month,numberDay6);
      DateTime dateTimeNow7 = DateTime.utc(DateTime.now().year,DateTime.now().month,numberDay7);
       d = dateFormat.format(dateTimeNow1)[0];
       d1 = dateFormat.format(dateTimeNow2)[0];
       d2 = dateFormat.format(dateTimeNow3)[0];
       d3 = dateFormat.format(dateTimeNow4)[0];
       d4 = dateFormat.format(dateTimeNow5)[0];
       d5 = dateFormat.format(dateTimeNow6)[0];
       d6 = dateFormat.format(dateTimeNow7)[0];



      if (fListOneToSeven.isNotEmpty) {
        initCalories(fListOneToSeven);
        for (final i in fListOneToSeven) {
          allCategories += double.parse(i.allCalories.toString());
          allTime += double.parse(i.allTime.toString().trim());
        }
        allTime/=60;
        allExcersie = fListOneToSeven.length;
      }
      initListChart();
    });
  }

  initCalories(List<HistoryModel> list) async {
    double alLCalories1 = 0;
    double alLCalories2 = 0;
    double alLCalories3 = 0;
    double alLCalories4 = 0;
    double alLCalories5 = 0;
    double alLCalories6 = 0;
    double alLCalories7 = 0;

    for (final i in list) {
      int date = int.parse(i.dateNow.toString().split("-")[2].trim());
      if (date == numberDay1) {
        alLCalories1 += double.parse(i.allCalories.toString());
        allWorkout1++;
      } else if (date == numberDay2) {
        alLCalories2 += double.parse(i.allCalories.toString());
        allWorkout2++;
      } else if (date == numberDay3) {
        alLCalories3 += double.parse(i.allCalories.toString());
        allWorkout3++;
      } else if (date == numberDay4) {
        alLCalories4 += double.parse(i.allCalories.toString());
        allWorkout4++;
      } else if (date == numberDay5) {
        alLCalories5 += double.parse(i.allCalories.toString());
        allWorkout5++;
      } else if (date == numberDay6) {
        alLCalories6 += double.parse(i.allCalories.toString());
        allWorkout6++;
      } else if (date >= numberDay7) {
        alLCalories7 += double.parse(i.allCalories.toString());
        allWorkout7++;
      }
    }
    setState(() {
      dataCalories = [
        ChartData(numberDay1, alLCalories1),
        ChartData(numberDay2, alLCalories2),
        ChartData(numberDay3, alLCalories3),
        ChartData(numberDay4, alLCalories4),
        ChartData(numberDay5, alLCalories5),
        ChartData(numberDay6, alLCalories6),
        ChartData(numberDay7, alLCalories7)
      ];
      dataWorkout = [
        WorkOutData(numberDay1, allWorkout1),
        WorkOutData(numberDay2, allWorkout2),
        WorkOutData(numberDay3, allWorkout3),
        WorkOutData(numberDay4, allWorkout4),
        WorkOutData(numberDay5, allWorkout5),
        WorkOutData(numberDay6, allWorkout6),
        WorkOutData(numberDay7, allWorkout7),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            getHeader(),
            Container(
              width: double.infinity,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 15),
                    child: Text(
                      LocaleKeys.t_history.tr().toUpperCase(),
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          color: "#3E3E3E".toColor(),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15, top: 15, right: 15),
                    child: Text(
                      LocaleKeys.t_calendar.tr().toUpperCase(),
                      style: GoogleFonts.nunito(
                          fontSize: 11,
                          color: "#FF7936".toColor(),
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistoryScreen()));
              },
              child: Container(
                width: double.infinity,
                height: 90,
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getHistoryWeek(numberDay1, false,d),
                    getHistoryWeek(numberDay2, false,d1),
                    getHistoryWeek(numberDay3, false,d2),
                    getHistoryWeek(numberDay4, false,d3),
                    getHistoryWeek(numberDay5, false,d4),
                    getHistoryWeek(numberDay6, false,d5),
                    getHistoryWeek(numberDay7, true,d6),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            LocaleKeys.t_weight.tr().toUpperCase(),
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: "#3E3E3E".toColor()),
                          ),
                        ),
                        InkWell(
                          onTap: ShowInputWeight,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5, right: 15),
                            child: Text(
                              LocaleKeys.button_edit.tr().toUpperCase(),
                              style: GoogleFonts.nunito(
                                  color: "#FF7936".toColor(),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 320,
              child: Container(
                  child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      series: <ChartSeries>[
                        StackedLineSeries<ChartData, int>(
                          dataSource: data,
                          opacity: 0.9,
                          color: Colors.blueGrey,
                          width: 0.4,
                          xValueMapper: (ChartData data, _) => data.year,
                          yValueMapper: (ChartData data, _) => data.sales,
                        ),
                      ])),
            ),
            Container(
              width: double.infinity,
              height: 40,
              margin: EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
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
                          onTap: ShowInputHeight,
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
                                  color: "#6EA2E1".toColor()),
                            ),
                          ),
                        ),
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
                              margin: const EdgeInsets.only(
                                left: 5,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                b_show == true ? LocaleKeys.t_hide.tr() : LocaleKeys.t_show.tr(),
                                style: GoogleFonts.roboto(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: "#4C6C93".toColor()),
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            b_show
                ? Container(
                margin: const EdgeInsets.only(
                  top: 5.0,
                ),
                height: 60,
                child: ListView.builder(
                    itemCount: itemsNumber.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) =>
                        ItemsRuler(itemsNumber[index], index)))
                : Container(),
            Container(
              width: double.infinity,
              height: 30,
              alignment: Alignment.center,
              child: Text(
                reportBMI,
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: "#DCE683".toColor()),
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey.shade200,
            ),
            Container(
              width: double.infinity,
              height: 120,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            LocaleKeys.t_height.tr().toUpperCase(),
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: "#3E3E3E".toColor()),
                          ),
                        ),
                        InkWell(
                          onTap: ShowInputHeightCurrent,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5, right: 15),
                            child: Text(
                              LocaleKeys.button_edit.tr(),
                              style: GoogleFonts.nunito(
                                  color: "#FF7936".toColor(),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            LocaleKeys.t_CURRENT.tr().toUpperCase(),
                            style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: "#3E3E3E".toColor()),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 15),
                          child: Text(
                            "${height.toStringAsFixed(1)} cm",
                            style: GoogleFonts.nunito(
                                color: "#FF7936".toColor(),
                                fontSize: 11,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.only(left: 15),
              child: Text(
                LocaleKeys.t_Calories_burned_estimated.tr(),
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 16),
              ),
            ),
            Container(
              width: double.infinity,
              height: 320,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(4, 4),
                    blurRadius: 11)
              ]),
              child: Container(
                  child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.top,
                      ),
                      series: <ChartSeries>[
                        ColumnSeries<ChartData, int>(
                          dataSource: dataCalories,
                          opacity: 0.9,
                          color: Colors.blueGrey,
                          width: 0.4,
                          xValueMapper: (ChartData data, _) => data.year,
                          yValueMapper: (ChartData data, _) => data.sales,
                          name: LocaleKeys.t_calories.tr(),
                          gradient: LinearGradient(
                              colors: [Colors.red.withOpacity(0.3), Colors.orange]),
                        ),
                      ])),
            ),
            Container(
              width: double.infinity,
              height: 30,
              margin: EdgeInsets.only(top: 25),
              padding: EdgeInsets.only(left: 15),
              child: Text(
                LocaleKeys.t_excercises.tr(),
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 16),
              ),
            ),
            Container(
              width: double.infinity,
              height: 320,
              child: Container(
                  child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.top,
                      ),
                      series: <ChartSeries>[
                        ColumnSeries<WorkOutData, int>(
                          dataSource: dataWorkout,
                          opacity: 0.9,
                          color: Colors.blueGrey,
                          width: 0.4,
                          xValueMapper: (WorkOutData data, _) => data.year,
                          yValueMapper: (WorkOutData data, _) => data.sales,
                          name:  LocaleKeys.t_excercises.tr(),
                          gradient: LinearGradient(
                              colors: [Colors.red.withOpacity(0.3), Colors.orange]),
                        ),
                      ])),
            ),
          ],
        ),
      ),
    );
  }

  getHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25, left: 15),
          child: Text(
          LocaleKeys.t_report.tr(),
            style: GoogleFonts.oswald(
                fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 0, right: 0),
          child: Divider(
            thickness: 1,
            color: Colors.grey.shade200,
          ),
        ),
        Container(
          width: double.infinity,
          height: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 120,
                height: 120,
                child: Image.asset("assets/icon/report.png"),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    "assets/icon/excersise.png",
                    color: "#EB1D36".toColor(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      "$allExcersie",
                      style: GoogleFonts.oswald(
                          fontSize: 28,
                          color: "#EB1D36".toColor(),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
    LocaleKeys.t_excercises.tr(),
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: "#9E9E9E".toColor(),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    "assets/icon/calories.png",
                    color: "#EB1D36".toColor(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      allCategories.toStringAsFixed(0),
                      style: GoogleFonts.oswald(
                          fontSize: 28,
                          color: "#EB1D36".toColor(),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
    LocaleKeys.t_calories.tr(),
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: "#9E9E9E".toColor(),
                      ),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Image.asset(
                    "assets/icon/minutes.png",
                    color: "#EB1D36".toColor(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      allTime.toStringAsFixed(0),
                      style: GoogleFonts.oswald(
                          fontSize: 28,
                          color: "#EB1D36".toColor(),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
    LocaleKeys.t_minutes.tr(),
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        color: "#9E9E9E".toColor(),
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
    );
  }

  getHistoryWeek(int number, bool b,String date) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Text(
              date,
              style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: "#D5D5D5".toColor()),
            ),
          ),
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: "#D5D5D5".toColor(), width: 2)),
            child: Text(
              "$number",
              style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: b ? "#EA444E".toColor() : "#D5D5D5".toColor()),
            ),
          ),
        ],
      ),
    );
  }

  ItemsRuler(double value, int index) {
    return Container(
      height: 60,
      child: Stack(
        children: [
          current_index == index
              ? Container(
                  height: 20,
                 margin: EdgeInsets.only(left: bmi_value<40 ? value / 8 : 2),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    bmi_value.toStringAsFixed(2),
                    style: GoogleFonts.roboto(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: "#3E3E3E".toColor()),
                  ),
                )
              : Container(
                  height: 20,
                ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 25, bottom: 4, left: 2),
                width: index == 0
                    ? 25
                    : index == 1
                        ? 35
                        : index == 2
                            ? 90
                            : index == 3
                                ? 50
                                : index == 4
                                    ? 50
                                    : 50,
                height: 5,
                decoration: BoxDecoration(
                  color: index == 0
                      ? Colors.green.shade200
                      : index > 0 && index <= 4
                          ? "#4C6C93".toColor()
                          : index == 5
                              ? Colors.orange
                              : Colors.red,
                ),
              ),
              Text(
                value.toStringAsFixed(1),
                style: GoogleFonts.robotoFlex(
                  fontSize: 10,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void ShowInputHeight() async {
    int curent_weight = 0;
    final fType = await SharePrefercens.instances.getType();
    final fHeight = await SharePrefercens.instances.getHeight();
    final fWeight = await SharePrefercens.instances.getWeight();
     if(fType==1){
        txtHeight.text = "${fHeight/const_inch}";
        txtweight.text = "${fWeight/const_pound}";
     }else{
       txtHeight.text = "$fHeight";
       txtweight.text = "$fWeight";
     }

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Padding(padding: MediaQuery.of(context).viewInsets,child: Container(
                width: 320,
                height: 360,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0, top: 50),
                      child: Text(
                        LocaleKeys.t_weight.tr(),
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
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.black)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.black)),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (curent_weight == 1) {
                                  height *= const_inch;
                                  weight *= const_pound;
                                } else {
                                  height = double.parse(txtHeight.text.toString());
                                  weight = double.parse(txtweight.text.toString());
                                }

                                curent_weight = 0;
                                txtweight.text =weight.toStringAsFixed(1);
                                txtHeight.text = height.toStringAsFixed(1);
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
                                      : Border.all(
                                      color: Colors.pink.shade300)),
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
                                height =
                                    double.parse(txtHeight.text.toString());
                                weight =
                                    double.parse(txtweight.text.toString());
                                if (curent_weight == 0) {
                                  height /= const_inch;
                                  weight /= const_pound;
                                }

                                txtweight.text =weight.toStringAsFixed(1);
                                txtHeight.text = height.toStringAsFixed(1);
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
                                      : Border.all(
                                      color: Colors.pink.shade300)),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 0, top: 10),
                      child: Text(
                        LocaleKeys.t_height.tr(),
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
                              controller: txtHeight,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.robotoFlex(
                                  fontSize: 16, color: Colors.black),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.black)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.black)),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (curent_weight == 1) {
                                  height *= const_inch;
                                  weight *= const_pound;
                                } else {
                                  height =
                                      double.parse(txtHeight.text.toString());
                                  weight =
                                      double.parse(txtweight.text.toString());
                                }

                                curent_weight = 0;
                                txtweight.text = weight.toStringAsFixed(2);
                                txtHeight.text = height.toStringAsFixed(2);
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
                                      : Border.all(
                                      color: Colors.pink.shade300)),
                              child: Text(
                                "CM",
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
                                height =
                                    double.parse(txtHeight.text.toString());
                                weight =
                                    double.parse(txtweight.text.toString());
                                if (curent_weight == 0) {
                                  height /= const_inch;
                                  weight /= const_pound;
                                }

                                txtweight.text = weight.toStringAsFixed(2);
                                txtHeight.text = height.toStringAsFixed(2);
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
                                      : Border.all(
                                      color: Colors.pink.shade300)),
                              child: Text(
                                "FT",
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
                      height: 40,
                      margin: EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 40,
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  if (weight > 0) {
                                     if(curent_weight==1){
                                       SharePrefercens.instances.setWeight(double.parse(txtweight.text.toString().trim().replaceAll(",", "."))*const_pound);
                                     }else{
                                       SharePrefercens.instances.setWeight(double.parse(txtweight.text.toString().trim().replaceAll(",", ".")));
                                     }

                                  } else {
                                    ShowToast(LocaleKeys.t_weight_description.tr());
                                  }
                                  if (height > 0) {
                                    if(curent_weight==1){
                                      SharePrefercens.instances.setHeight(double.parse(txtHeight.text.toString().replaceAll(",", ".").trim())*const_inch);
                                    }else{
                                      SharePrefercens.instances.setHeight(double.parse(txtHeight.text.toString().replaceAll(",", ".").trim()));
                                    }
                                  } else {
                                    ShowToast(LocaleKeys.t_height_description.tr());
                                  }
                                  setState(() {
                                    initBMI();
                                  });


                                  SharePrefercens.instances.setType(curent_weight);
                                  Navigator.pop(context);
                                });
                              },
                              color: Colors.pink.shade400,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                LocaleKeys.button_save.tr(),
                                style: GoogleFonts.robotoFlex(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                            width: 120,
                            height: 50,
                            margin: EdgeInsets.only(left: 25),
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Colors.grey.shade400,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                LocaleKeys.button_quit.tr(),
                                style: GoogleFonts.robotoFlex(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),);
            },
          );
        });
  }

  void ShowInputWeight() async {
    int curentWeight = 0;
    final f_type = await SharePrefercens.instances.getType();
    final fWeight = await SharePrefercens.instances.getWeight();

    if (f_type == 1) {
      txtweight.text = "${fWeight/const_pound}";

    }else{
      txtweight.text = "$fWeight";
    }


    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Padding(padding: MediaQuery.of(context).viewInsets,child: Container(
                width: 320,
                height: 220,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 0, top: 40),
                      child: Text(
                        LocaleKeys.t_weight.tr(),
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
                      margin: const EdgeInsets.only(top: 15, bottom: 15),
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
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.black)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.black)),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {

                                if (curentWeight == 1) {
                                  weight *= const_pound;
                                }else{
                                  weight = double.parse(txtweight.text.toString().replaceAll(",", "."));
                                }
                                curentWeight = 0;
                                txtweight.text = weight.toStringAsFixed(1);
                              });
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              margin: const EdgeInsets.only(left: 5, right: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: curentWeight == 0
                                      ? Colors.pink.shade300
                                      : Colors.white,
                                  border: curentWeight == 0
                                      ? Border.all(color: Colors.transparent)
                                      : Border.all(
                                      color: Colors.pink.shade300)),
                              child: Text(
                                "KG",
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: curentWeight == 0
                                        ? Colors.white
                                        : Colors.pink.shade300),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {

                                if (curentWeight == 0) {
                                  weight /= const_pound;
                                }else{
                                  weight = double.parse(txtweight.text.toString().replaceAll(",", "."));
                                }
                                curentWeight = 1;
                                txtweight.text = weight.toStringAsFixed(1);
                              });
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: curentWeight == 1
                                      ? Colors.pink.shade300
                                      : Colors.white,
                                  border: curentWeight == 1
                                      ? Border.all(color: Colors.transparent)
                                      : Border.all(
                                      color: Colors.pink.shade300)),
                              child: Text(
                                "LB",
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: curentWeight == 1
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
                      height: 40,
                      margin: const EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 40,
                            child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  DateFormat dateformat =
                                  DateFormat("yyyy-MM-dd");
                                  if (curentWeight == 0) {
                                    DBExcerise.instances.insertWeight(
                                        txtweight.text.toString().trim().replaceAll(",", "."),
                                        dateformat.format(DateTime.now()));
                                  } else {
                                    DBExcerise.instances.insertWeight(
                                        (weight * const_pound).toString().replaceAll(",", "."),
                                        dateformat.format(DateTime.now()));
                                  }
                                  if (weight > 0) {

                                    if(curentWeight==1){
                                      SharePrefercens.instances.setWeight(double.parse(txtweight.text.toString().trim().replaceAll(",", "."))*const_pound);
                                    }else{
                                      SharePrefercens.instances.setWeight(double.parse(txtweight.text.toString().trim().replaceAll(",", ".")));
                                    }
                                    initBMI();

                                  } else {
                                    ShowToast(LocaleKeys.t_weight_description.tr());
                                  }


                                  Navigator.pop(context);
                                });
                              },
                              color: Colors.pink.shade400,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                LocaleKeys.button_save.tr(),
                                style: GoogleFonts.robotoFlex(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                            width: 120,
                            height: 50,
                            margin: EdgeInsets.only(left: 25),
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Colors.grey.shade400,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                LocaleKeys.button_quit.tr(),
                                style: GoogleFonts.robotoFlex(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),);
            },
          );
        });
  }

  void ShowInputHeightCurrent() async {

    final f_type = await SharePrefercens.instances.getType();
    final fHeight = await SharePrefercens.instances.getHeight();
    if (f_type == 1) {
      txtHeight.text = "${ fHeight/const_inch}";
    }else{
      txtHeight.text = "${ fHeight}";
    }
    int curent_weight = 0;
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30))),
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  width: 320,
                  height: 220,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30))),
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 0, top: 40),
                        child: Text(
                          LocaleKeys.t_height.tr(),
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
                                controller: txtHeight,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.robotoFlex(
                                    fontSize: 16, color: Colors.black),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (curent_weight == 1) {
                                    height /= const_inch;
                                  } else {
                                    height = double.parse(txtHeight.text.toString());
                                  }

                                  curent_weight = 0;
                                  txtHeight.text = height.toStringAsFixed(2);
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
                                        : Border.all(
                                            color: Colors.pink.shade300)),
                                child: Text(
                                  "CM",
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
                                  height =
                                      double.parse(txtHeight.text.toString());
                                  if (curent_weight == 0) {
                                    height *= const_inch;
                                  }

                                  txtHeight.text = height.toStringAsFixed(2);
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
                                        : Border.all(
                                            color: Colors.pink.shade300)),
                                child: Text(
                                  "FT",
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
                        height: 40,
                        margin: EdgeInsets.only(top: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 40,
                              child: RaisedButton(
                                onPressed: () {
                                  if (curent_weight == 0) {
                                    height = double.parse(
                                        txtHeight.text.toString().trim());
                                    SharePrefercens.instances.setHeight(height);
                                  } else {
                                    height = double.parse(
                                        txtHeight.text.toString().trim());
                                    SharePrefercens.instances
                                        .setHeight(height * const_inch);
                                  }
                                  Update();
                                  Navigator.pop(context);
                                },
                                color: Colors.pink.shade400,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  LocaleKeys.button_save.tr(),
                                  style: GoogleFonts.robotoFlex(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Container(
                              width: 120,
                              height: 50,
                              margin: EdgeInsets.only(left: 25),
                              child: RaisedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: Colors.grey.shade400,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  LocaleKeys.button_quit.tr(),
                                  style: GoogleFonts.robotoFlex(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  void ShowToast(String s) {
    Fluttertoast.showToast(
        msg: s,
        fontSize: 16,
        textColor: Colors.black,
        backgroundColor: Colors.white);
  }

  void Update() {
    setState(() {
      initBMI();
    });
  }
}

class ChartData {
  ChartData(this.year, this.sales);

  final int year;
  final double sales;
}

class WorkOutData {
  WorkOutData(this.year, this.sales);

  final int year;
  final int sales;
}
