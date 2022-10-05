


import 'package:healthygympractice/DB/DBExcerise.dart';

class PlansModel{
  int? PlanID;
  int? DayID;
  int?DayName;
  int? Iscompleted;
  String? dayprogress;
  int?ID;

  PlansModel._();
  static PlansModel instances = PlansModel._();

  PlansModel({this.PlanID,this.DayID,this.DayName,this.Iscompleted,this.dayprogress,this.ID});

  factory PlansModel.fromJson(Map<String,dynamic> map){
     return PlansModel(
       PlanID: map['PLANID'],
       DayID: map['DAYID'],
       DayName: map['DAYNAME'],
       Iscompleted: map['ISCOMPLETED'],
       dayprogress: map['DAYPROGRESS'],
       ID: map['ID']
     );
  }

  Future<List<PlansModel>> getDataList(int id) async {
    return await DBExcerise.instances.getDataListPlan(id);
  }

  void UpdatDayProGress(int i, int parse)  async{

  }

  void UpdateAllProgess(int i)async {
    DBExcerise.instances.UpdateAllprogress(i);
  }


}