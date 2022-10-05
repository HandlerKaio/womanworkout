

import 'package:healthygympractice/DB/DBExcerise.dart';

class HistoryModel {
  int ? id;
  String? name;
  String? allCalories;
  String? allTime;
  String? dateCreate;
  String? dateNow;

  HistoryModel({this.id,this.name,this.allCalories,this.allTime,this.dateCreate,this.dateNow});
  HistoryModel.init();

  static HistoryModel inStances = HistoryModel.init();

  factory HistoryModel.fromJson(Map<String,dynamic> map) {
    return HistoryModel(
      id: map['ID'],
      name: map['NAME'],
      allCalories: map['ALLCALORIES'],
      allTime: map['ALLTIMER'],
      dateCreate: map['DATE_CREATE'],
      dateNow: map['DATE_NOW'],
    );
  }
  Future<List<HistoryModel>> getDataListHistory(int month,String dayFrom,String dayTo,int year) async{
    String monthChange = "";
    if(month>10){
      monthChange= month.toString();
    }else{
      monthChange="0$month";
    }
    return await DBExcerise.instances.getDataListHistory(monthChange, dayFrom, dayTo,year);
  }
  Future<void> insertHistory(String name,String allCategories,String allTime,String date,String dateNow) async{
    DBExcerise.instances.insertHistory(name,allCategories,allTime,date,dateNow);
  }




}