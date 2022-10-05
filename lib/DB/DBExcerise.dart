import 'dart:io';

import 'package:flutter/services.dart';
import 'package:healthygympractice/models/CategoryModel.dart';
import 'package:healthygympractice/models/PlansModel.dart';
import 'package:healthygympractice/models/PracticeModel.dart';
import 'package:healthygympractice/models/history_model.dart';
import 'package:healthygympractice/models/weight_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class DBExcerise {
  Database? _database;

  static DBExcerise instances = DBExcerise._();

  DBExcerise._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await inItDB("excersise.db");
    return _database!;
  }

  Future<Database> inItDB(String name) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, name);
    var exists = await databaseExists(path);
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", "wowenfitness.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    Database database = await openDatabase(path,readOnly: false);

    return database;
  }

  Future<List<CategoryModel>> getDataList(int id_cate) async {
    final db = await instances.database;
    String SQL = "SELECT * FROM  PRACTICE WHERE ID_CATEGORY ='${id_cate}'";
    List<Map<String, dynamic>> list = await db.rawQuery(SQL);
    List<CategoryModel> list_category = [];
    for (var i in list) {
      CategoryModel categoryModel = CategoryModel.fromJson(i);
      list_category.add(categoryModel);
    }
    return list_category;
  }

  Future<List<PlansModel>> getDataListPlan(int planid) async {
    final db = await instances.database;
    String SQL = "SELECT * FROM PLanDaysTable WHERE PLANID = '${planid}'";
    List<Map<String, dynamic>> list = await db.rawQuery(SQL);
    List<PlansModel> list_plans = [];
    for (var i in list) {
      list_plans.add(PlansModel.fromJson(i));
    }
    return list_plans;
  }
  Future<List<PracticeModel>> getDataListPractice(int planID,int DayID) async{
     final db = await instances.database;
     String SQL="SELECT ExcerciseTable.ExId,DayExTable.DayID,DayExTable.DayExID,ExcerciseTable.ExUnit,ExcerciseTable.ExPath, ExcerciseTable.ExName,"
     "ExcerciseTable.ExDescription,ExcerciseTable.ReplaceTime,DayExTable.IsCompleted"
    " FROM  ExcerciseTable,DayExTable  WHERE DayExTable.ExDescription = ExcerciseTable.ExDescription AND DayExTable.DayID= '${DayID}' AND DayExTable.PlanID ='${planID}'";
     List<Map<String,dynamic>> list = await db.rawQuery(SQL);
     List<PracticeModel> list_practice= [];
     for(var i in list){
       PracticeModel practiceModel = PracticeModel.fromJson(i);
       list_practice.add(practiceModel);
     }
     return list_practice;
  }
  Future<List<HistoryModel>> getDataListHistory(String month,String dayfrom, String dayto,int year) async{
    final db = await instances.database;
    String SQL = "SELECT * FROM HISTORY WHERE  strftime('%m',DATE_NOW) = '$month'  AND strftime('%d',DATE_NOW) >= '$dayfrom'"
        " AND strftime('%d',DATE_NOW) <= '$dayto' AND  strftime('%Y',DATE_NOW) = '$year' ";
    List<Map<String,dynamic>> list_history_map =  await db.rawQuery(SQL);
    List<HistoryModel> list_history= [];
    for(var i in list_history_map){
      HistoryModel historyModel = HistoryModel.fromJson(i);
      list_history.add(historyModel);
    }
    return list_history;
  }

  Future<void> SetUpdateTimer(String timer,int ExId) async{
    final db = await instances.database;
    String SQL="UPDATE  ExcerciseTable SET Replacetime = '${timer}' WHERE ExId = '${ExId}' ";
    db.rawUpdate(SQL);
  }

  void UpdateDayProgress(String i, String idday) async {
    final db = await instances.database;
    String SQL="UPDATE PlanDaysTable SET  DAYPROGRESS = '${i}' WHERE  ID = '${idday}'";
    db.rawUpdate(SQL);
  }

  void UpdateAllprogress(int i)  async{
    final db = await instances.database;
    String SQL="UPDATE PlanDaysTable SET  DAYPROGRESS = '${0}' WHERE  ID>0";
    db.rawUpdate(SQL);
  }

  void updateIsCompleted(int i, int? dayExID) async {
    final db = await instances.database;
    String SQL="UPDATE DayExTable SET  IsCompleted = '$i' WHERE  DayExID = '$dayExID'";
    db.rawUpdate(SQL);
  }

  void insertHistory(String name, String allcategories, String allTimer,String date,String dateNow)  async{
    final db = await instances.database;
    String SQL="INSERT INTO HISTORY(NAME,ALLCALORIES,ALLTIMER,DATE_CREATE,DATE_NOW) VALUES('$name','$allcategories','$allTimer','$date','$dateNow')";
    db.rawInsert(SQL);
  }
  void insertWeight(String indexweight,String dateNow) async{
    final db = await instances.database;
    String SQL="INSERT INTO WEIGTHTABLE(INDEXWEIGHT,DATE_NOW) VALUES('$indexweight','$dateNow')";
    db.rawInsert(SQL);
  }
  Future<List<WeightModel>> getDataListWeight(int moth,int year) async {
    final db = await instances.database;
    String moth_change  = moth<10 ? "0"+moth.toString(): moth.toString();
    String SQL = "SELECT * FROM  WEIGTHTABLE WHERE strftime('%m',DATE_NOW) = '$moth_change' ";
    List<Map<String, dynamic>> list = await db.rawQuery(SQL);
    List<WeightModel> listWeight = [];
    for (var i in list) {
      listWeight.add(WeightModel.fromJson(i));
    }
    return listWeight;
  }


}
