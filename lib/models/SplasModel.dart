


class SplasModel{
  String? image;
  String? type;
  String? wall_back;

  SplasModel._();

  static SplasModel instances = SplasModel._();

  SplasModel({this.image,this.type,this.wall_back});


  getDataListSplash(){
    List<SplasModel> list = [];
    list.add(new SplasModel(image: "assets/banner/c1.png",type: "0"));
    list.add(new SplasModel(image: "assets/banner/c2.png",type: "0"));
    list.add(new SplasModel(image: "assets/banner/c3.png",type: "0"));
    list.add(new SplasModel(image: "assets/banner/c4.png",type: "0"));
    list.add(new SplasModel(image: "assets/banner/c5.png",type: "0"));
    list.add(new SplasModel(image: "assets/banner/c6.png",type: "0"));


    return list;
  }
  getDataListAbsworkout(){
    List<SplasModel> list = [];
    list.add(new SplasModel(image: "assets/banner/abs_1.png",type: "0"));
    list.add(new SplasModel(image: "assets/banner/abs_2.png",type: "0"));
    list.add(new SplasModel(image: "assets/banner/abs_3.png",type: "0"));
    list.add(new SplasModel(image: "assets/banner/abs_4.png",type: "0"));

    return list;
  }
  getDataListArmworkout(){
    List<SplasModel> list = [];
    list.add(new SplasModel(image: "assets/banner/arm_1.png",type: "0"));
    list.add(new SplasModel(image: "assets/banner/arm_2.png",type: "0"));

    return list;
  }
  getDataListSplitWorkout(){
    List<SplasModel> list = [];
    list.add(new SplasModel(image: "assets/banner/split_1.png",type: "0"));
    list.add(new SplasModel(image: "assets/banner/split_2.png",type: "0"));
    list.add(new SplasModel(image: "assets/banner/split_3.png",type: "0"));
    list.add(new SplasModel(image: "assets/banner/split_4.png",type: "0"));

    return list;
  }
  getDataListButtWorkOut(){
    List<SplasModel> list = [];
    list.add(new SplasModel(image: "assets/banner/butt_1.png",type: "0"));
    list.add(new SplasModel(image: "assets/banner/butt_2.png",type: "0"));
    list.add(new SplasModel(image: "assets/banner/butt_3.png",type: "0"));
    list.add(new SplasModel(image: "assets/banner/butt_4.png",type: "0"));

    return list;
  }
  getDataListThingWorkOut(){
    List<SplasModel> list = [];
    list.add(new SplasModel(image: "assets/banner/thing_1.png",type: "0"));
    list.add(new SplasModel(image: "assets/banner/thing_2.png",type: "0"));
    list.add(new SplasModel(image: "assets/banner/thing_3.png",type: "0"));

    return list;
  }

}