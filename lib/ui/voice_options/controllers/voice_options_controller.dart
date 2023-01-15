import 'dart:io';

import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/main.dart';
import 'package:women_lose_weight_flutter/utils/utils.dart';
import 'package:open_settings/open_settings.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';



class VoiceOptionsController extends GetxController {
  // bool isSelectedEngine = false;
  //
  // onChooseGuideVoiceEngine(bool? value) {
  //   isSelectedEngine = value!;
  //   update([Constant.idRadioGoogleTTSEngine]);
  // }

  final AndroidIntent intent = const AndroidIntent(
      action: 'com.android.settings.TTS_SETTINGS',
      componentName: "com.android.settings.TextToSpeechSettings"
  );

  Future testVoice() async{
    Utils.textToSpeech("txtHearTestVoice".tr, MyApp.flutterTts);
  }

  openTtsSetting() async{
    if (Platform.isAndroid) {
      await intent.launch();
    } else {
      OpenSettings.openAccessibilitySetting();
    }
  }

  downLoadTTS() {
    if (Platform.isAndroid) {
      try {
        launchUrl(Uri.parse("market://search?q=text to speech&c=apps"));
      } on PlatformException {
        launchUrl(Uri.parse("http://play.google.com/store/search?q=text to speech&c=apps"));
      } finally {
        launchUrl(Uri.parse("http://play.google.com/store/search?q=text to speech&c=apps"));
      }
    } else {
      try {
        launchUrl(Uri.parse("apps://itunes.apple.com/app/apple-store/texttospeech"));
      } on PlatformException {
        launchUrl(Uri.parse("http://appstore.com/texttospeech"));
      } finally {
        launchUrl(Uri.parse("http://appstore.com/texttospeech"));
      }
    }
  }

}
