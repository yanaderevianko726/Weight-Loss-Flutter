import 'dart:ui';

import '../utils/constant.dart';
import '../utils/debug.dart';
import '../utils/preference.dart';

Future<Locale> getLocale() async {
  String languageCode =
      Preference.shared.getString(Preference.selectedLanguage) ??
          Constant.languageEn;
  String countryCode =
      Preference.shared.getString(Preference.selectedCountryCode) ??
          Constant.countryCodeEn;
  Debug.printLog("getLocale Updated $languageCode   $countryCode");
  return _locale(languageCode, countryCode);
}

Locale _locale(String languageCode, String countryCode) {
  return languageCode.isNotEmpty
      ? Locale(languageCode, countryCode)
      : const Locale(Constant.languageEn, Constant.countryCodeEn);
}
