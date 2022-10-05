


class Languagemodel{
  String? icon;
  String? name;
  String? language;
  bool? is_check;

  Languagemodel._();

  static Languagemodel instances = Languagemodel._();
  Languagemodel({this.icon,this.name,this.is_check,this.language}) ;
  getDataListLanguage(){
    List<Languagemodel> list = [];

    list.add(new Languagemodel( icon: "assets/icon/flag_us.png",name: "English",is_check: true,language: "en"));
    list.add(new Languagemodel( icon: "assets/icon/flag_spnaish.png",name: "Spanish",is_check: false,language: "es"));
    list.add(new Languagemodel( icon: "assets/icon/flag_pos.png",name: "Portuguese",is_check: false,language: "pt"));
    list.add(new Languagemodel( icon: "assets/icon/flag_china.png",name: "Chinese",is_check: false,language: "zh"));
    list.add(new Languagemodel( icon: "assets/icon/flag_indian.png",name: "India",is_check: false,language: "hi"));
    list.add(new Languagemodel( icon: "assets/icon/flag_vn.png",name: "Vietnamese",is_check: false,language: "vi"));

    return list;
  }

}