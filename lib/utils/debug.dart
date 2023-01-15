import 'dart:developer';

class Debug {
  ///|>==|>==|> Set all debug variable false when you make release build. <|==<|==<|

  static const debug = true;
  static const googleAd = true;
  static const sandboxVerifyRecieptUrl = true;

  static printLog(String str) {
    if (debug) log(str);
  }
}
