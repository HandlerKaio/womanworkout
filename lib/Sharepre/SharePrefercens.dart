import 'package:shared_preferences/shared_preferences.dart';

class SharePrefercens {
  static SharedPreferences? _sharedPreferences;
  static SharePrefercens instances = SharePrefercens._();

  String KEY_LANGUAGE = "LANGUAGE";
  String KEY_WEIGHT = "WEIGHT";
  String KEY_HEIGHT = "HEIGHT";
  String KEY_AGE = "AGE";
  String KEY_SKIPTUTORIAL = "SKIPTUTORIAL";
  String KEY_TYPE = "TYPE";
  String KEY_ADS = "ADS";
  String KEY_CALORIES = "CALORIES";
  String KEY_MINUTES = "MINUTES";
  String KEY_RESTSET = "KEY_RESTSET";
  String KEY_COUNTDOWN = "KEY_COUNTDOWN";
  String KEY_DAYS = "KEY_DAYS";
  String KEY_DAYS_FIRST = "KEY_DAYS_FIRST";
  String KEY_HOURS = "HOUR";

  SharePrefercens._();

  Future<SharedPreferences> get shareprefer async {
    if (_sharedPreferences != null) return _sharedPreferences!;

    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences!;
  }

  Future<void> setLanguage(String name) async {
    final sharef = await instances.shareprefer;
    sharef.setString(KEY_LANGUAGE, name);
  }
  Future<void> setRestSet(int restSet) async {
    final sharef = await instances.shareprefer;
    sharef.setInt(KEY_RESTSET, restSet);
  }

  Future<void> setWeight(double weight) async {
    final sharef = await instances.shareprefer;
    sharef.setDouble(KEY_WEIGHT, weight);
  }
  Future<void> setCountDown(int countdown) async {
    final sharef = await instances.shareprefer;
    sharef.setInt(KEY_COUNTDOWN, countdown);
  }
  Future<void> setMinutes(double minutes) async {
    final sharef = await instances.shareprefer;
    sharef.setDouble(KEY_MINUTES, minutes);
  }

  Future<void> setHeight(double height) async {
    final sharef = await instances.shareprefer;
    sharef.setDouble(KEY_HEIGHT, height);
  }

  Future<void> setAge(String age) async {
    final sharef = await instances.shareprefer;
    sharef.setString(KEY_AGE, age);
  }
  Future<void> setCalories(double calories) async {
    final sharef = await instances.shareprefer;
    sharef.setDouble(KEY_CALORIES, calories);
  }


  Future<void> setSkipTutorial(int skip) async {
    final sharef = await instances.shareprefer;
    sharef.setInt(KEY_SKIPTUTORIAL, skip);
  }

  Future<void> setType(int type) async {
    final sharef = await instances.shareprefer;
    sharef.setInt(KEY_TYPE, type);
  }
  Future<void> setHistoryTick(String key,int value) async {
    final sharef = await instances.shareprefer;
    sharef.setInt(key, value);
  }
  Future<void> setDayFirst(int type) async {
    final sharef = await instances.shareprefer;
    sharef.setInt(KEY_DAYS_FIRST, type);
  }

  Future<void> setRemoveADS(int ads) async {
    final sharef = await instances.shareprefer;
    sharef.setInt(KEY_ADS, ads);
  }

  Future<void> setWidth(int width) async {
    final sharef = await instances.shareprefer;
    sharef.setInt("WIDTH", width);
  }
  Future<dynamic> getWidth() async {
    final sharef = await instances.shareprefer;
    return sharef.getInt("WIDTH");
  }
  void setTimer(int hour, int minutes) async {
    final sharef = await instances.shareprefer;
    sharef.setInt("HOUR", hour);
    sharef.setInt("MINUTES", minutes);
  }

  Future<dynamic> getHeight() async {
    final sharef = await instances.shareprefer;
    return sharef.getDouble(KEY_HEIGHT);
  }
  Future<dynamic> getTickGoal(String key) async {
    final sharef = await instances.shareprefer;
    if(sharef.containsKey(key)) return sharef.getInt(key)!;
    return 0;
  }

  Future<dynamic> getWeight() async {
    final sharef = await instances.shareprefer;
    return sharef.getDouble(KEY_WEIGHT);
  }
  Future<void> setTrainingDays(int days) async{
    final sharef = await instances.shareprefer;
    sharef.setInt(KEY_DAYS, days);
  }
  Future<dynamic> getDays() async {
    final sharef = await instances.shareprefer;
    if(sharef.containsKey(KEY_DAYS)) return sharef.getInt(KEY_DAYS)!;
    return 3;
  }
  Future<dynamic> getDaysFist() async {
    final sharef = await instances.shareprefer;
    if(sharef.containsKey(KEY_DAYS_FIRST)) return sharef.getString(KEY_DAYS_FIRST)!;
    return "MonDay";
  }

  Future<dynamic> getType() async {
    final sharef = await instances.shareprefer;
    return sharef.getInt(KEY_TYPE);
  }
  Future<dynamic> getRestSet() async {
    final sharef = await instances.shareprefer;
    if(sharef.containsKey(KEY_RESTSET)) return sharef.getInt(KEY_RESTSET)!;
    return 20;
  }
  Future<dynamic> getCountdown() async {
    final sharef = await instances.shareprefer;
    if(sharef.containsKey(KEY_COUNTDOWN)) return sharef.getString(KEY_COUNTDOWN)!;
    return 5;
  }
  Future<String> getAge() async {
    final sharef = await instances.shareprefer;
    if(sharef.containsKey(KEY_AGE)) return sharef.getString(KEY_AGE)!;
    return "01/02/1990";
  }
  Future<String> getLanguage() async{
    final sharef = await instances.shareprefer;
    if(sharef.containsKey(KEY_LANGUAGE)) return sharef.getString(KEY_LANGUAGE)!;
    return "en";
  }
  Future<int> getSkipTutorial() async{
    final sharef = await instances.shareprefer;
      if(sharef.containsKey(KEY_SKIPTUTORIAL)) return sharef.getInt(KEY_SKIPTUTORIAL)!;
    return 0;
  }
  Future<int> getAds() async{
    final sharef = await instances.shareprefer;
    if(sharef.containsKey(KEY_ADS)) return sharef.getInt(KEY_ADS)!;
    return 0;
  }
  Future<double> getCalories() async{
    final sharef = await instances.shareprefer;
    if(sharef.containsKey(KEY_CALORIES)) return sharef.getDouble(KEY_CALORIES)!;
    return 0.0;
  }
  Future<int> getMinutes() async{
    final sharef = await instances.shareprefer;
    if(sharef.containsKey(KEY_MINUTES)) return sharef.getInt(KEY_MINUTES)!;
    return 0;
  }
  Future<int> getHour() async{
    final sharef = await instances.shareprefer;
    if(sharef.containsKey(KEY_HOURS)) return sharef.getInt(KEY_HOURS)!;
    return 0;
  }

}
