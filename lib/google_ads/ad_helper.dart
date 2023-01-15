import 'dart:io';

import 'package:women_lose_weight_flutter/utils/debug.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Debug.googleAd) {
      if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/6300978111";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/2934735716";
      } else {
        throw UnsupportedError("Unsupported platform");
      }
    } else {
      return "";
    }
  }

  static String get interstitialAdUnitId {
    if (Debug.googleAd) {
      if (Platform.isAndroid) {
        return "ca-app-pub-3940256099942544/8691691433";
      } else if (Platform.isIOS) {
        return "ca-app-pub-3940256099942544/5135589807";
      } else {
        throw UnsupportedError("Unsupported platform");
      }
    } else {
      return "";
    }
  }

  static String get rewardedAdUnitId {
    if (Debug.googleAd) {
      if (Platform.isAndroid) {
        return 'ca-app-pub-3940256099942544/5224354917';
      } else if (Platform.isIOS) {
        return 'ca-app-pub-3940256099942544/1712485313';
      } else {
        throw UnsupportedError("Unsupported platform");
      }
    } else {
      return "";
    }
  }
}
