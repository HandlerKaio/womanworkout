

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthygympractice/Routes/RoutesManager.dart';
import 'package:healthygympractice/view/Home/HomeScreen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _PrivacyScreen();
}
class _PrivacyScreen extends State<PrivacyScreen>{
  int percentPrivacy = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink.shade400,
        elevation: 0,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        title: Text("Privacy policy",style: GoogleFonts.robotoFlex(
          fontSize: 17,
          color: Colors.white,
          fontWeight: FontWeight.bold
        ),),
      ),
      body:  Column(
crossAxisAlignment: CrossAxisAlignment.center,

        children:  [
          percentPrivacy>99 ? Container():Container(
            margin: EdgeInsets.only(top: 150),
            width: 42,
            height: 42,
            child: CircularProgressIndicator(color: Colors.pink.shade400,),
          ),
          Expanded(child:  WebView(
            initialUrl: "https://pas-technology.com/privacy-policy/womens-home-workout-fat-burn/",
            javascriptMode: JavascriptMode.unrestricted,
            onProgress: (percent){
              setState(() {
                percentPrivacy = percent;
              });
            },
          ))

        ],
      ),
    ), onWillPop: ()async{
      Navigator.pop(context);
      return true;
    });
  }

}