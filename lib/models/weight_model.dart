


class WeightModel{
  int? id;
  String? indexweight;
  String? dateNow;

  WeightModel({this.id,this.indexweight,this.dateNow});
  WeightModel.init();
  static WeightModel weightModel = WeightModel.init();

  factory WeightModel.fromJson(Map<String,dynamic> map) {
    return WeightModel(
      id: map['ID'],
      indexweight: map['INDEXWEIGHT'],
      dateNow: map['DATE_NOW']

    );
  }
}