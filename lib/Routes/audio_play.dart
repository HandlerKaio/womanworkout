import 'package:just_audio/just_audio.dart';


class AudioPlayManager {

  AudioPlayManager.init();
  static AudioPlayManager instances= AudioPlayManager.init();
  final player = AudioPlayer();
  final player1 = AudioPlayer();
  final player2 = AudioPlayer();

  Future<void> audioPlayStart(int type) async{

    if(type==1){
      player.play();
    }else{
      player.stop();
    }



  }
  Future<void> init() async{
    player1.setAsset("assets/sound/clock.mp3");
    player.setAsset("assets/sound/start.mp3");
  }
  Future<void> audioClockStart(int type) async{

   if(type==1){
     player1.play();
   }else{
     player1.stop();
     print("stop");
   }
  }
  Future<void> audioFinish(int type) async{
    player2.setAsset("assets/sound/finish.wav");
    if(type==1){
      player2.play();
    }else{
      player2.stop();

    }
  }
}