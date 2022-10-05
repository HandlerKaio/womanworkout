


import 'package:healthygympractice/DB/DBExcerise.dart';

class PracticeModel{
  int? ExID;
  int? DayExID;
  int? DayID;
  String? ExUnit;
  String? ExPath;
  String? ExName;
  String? ExDescription;
  String? replaceTime;
  int? IsCompleted;

  PracticeModel._();
  static PracticeModel instances = PracticeModel._();

  PracticeModel({this.DayID,this.ExID,this.DayExID,this.ExUnit,this.ExPath,this.ExName,this.ExDescription,this.replaceTime,this.IsCompleted});


  factory PracticeModel.fromJson(Map<String,dynamic> map){
    return PracticeModel(

      DayID: map['DayID'],
      ExID: map['ExId'],
      DayExID: map['DayExID'],
      ExUnit: map['ExUnit'],
      ExName: map['ExName'],
      ExPath: map['ExPath'],
      ExDescription: map['ExDescription'],
      replaceTime: map['ReplaceTime'],
      IsCompleted: map['IsCompleted']
    );
  }
  Future<List<PracticeModel>> getDataListPractice(int planID,int DayID)async{
    final f_list = await DBExcerise.instances.getDataListPractice(planID, DayID) ;
    return f_list;

  }
  Future<void> setSaveTime(String timer,int ExId) async{
    DBExcerise.instances.SetUpdateTimer(timer, ExId);
  }

  void UpdateDayProgress(String i, String idday) async {
    DBExcerise.instances.UpdateDayProgress(i,idday);
  }

  void updateIsCompleted(int i, int? dayExID)  async{
    DBExcerise.instances.updateIsCompleted(i,dayExID);
  }

}