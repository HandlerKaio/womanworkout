


import 'package:healthygympractice/DB/DBExcerise.dart';

class CategoryModel{
  int? id;
  String? name;
  String? image;
  String? icon;
  String?background;

  CategoryModel._();
  static CategoryModel instances = CategoryModel._();

  CategoryModel({this.id,this.name,this.image,this.icon,this.background});

  factory CategoryModel.fromJson(Map<String,dynamic> map){
    return CategoryModel(
      id: map['ID'],
      name: map['NAME'],
      image: map['IMAGE'],
      icon: map['ICON'],
      background: map['BACKGROUND'],
    );
  }
  Future<List<CategoryModel>> getDataListCategoryBanner(int id_cate) async{
    return await DBExcerise.instances.getDataList(id_cate);
  }

}