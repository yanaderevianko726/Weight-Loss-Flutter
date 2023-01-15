import 'dart:async';

import 'package:get_storage/get_storage.dart';


class Preference {
  static const String authorization = "AUTHORIZATION";

  static const String selectedLanguage = "LANGUAGE";
  static const String selectedCountryCode = "SELECTED_COUNTRY_CODE";

  static const String isFirstTimeOpenApp = "IS_FIRST_TIME_OPEN_APP";

  static const String selectedPlanId = "SELECTED_PLAN_ID";
  static const String selectedPlanIndex = "SELECTED_PLAN_INDEX";
  static const String selectedDietIndex = "SELECTED_DIET_INDEX";

  static const String currentWeightInKg = "CURRENT_WEIGHT_IN_KG";
  static const String currentWeightUnit = "CURRENT_WEIGHT_UNIT";

  static const String targetWeightInKg = "TARGET_WEIGHT_IN_KG";
  static const String targetWeightUnit = "TARGET_WEIGHT_UNIT";

  static const String currentHeightInCm = "CURRENT_HEIGHT_IN_CM";
  static const String currentHeightUnit = "CURRENT_HEIGHT_UNIT";

  static const String soundOptionMute = "SOUND_OPTION_MUTE";
  static const String soundOptionVoiceGuide = "SOUND_OPTION_VOICE_GUIDE";
  static const String soundOptionCoachTips = "SOUND_OPTION_COACH_TIPS";

  static const String turnOnWaterTracker = "TURN_ON_WATER_TRACKER";

  static const String prefLastDayCompleteLoseWeight = "PREF_LAST_DAY_COMPLETE_LOSE_WEIGHT";
  static const String prefLastDayCompleteButtLift = "PREF_LAST_DAY_COMPLETE_BUTT_LIFT";
  static const String prefLastDayCompleteLoseBelly = "PREF_LAST_DAY_COMPLETE_LOSE_BELLY";
  static const String prefLastDayCompleteBuildMuscle = "PREF_LAST_DAY_COMPLETE_BUILD_MUSCLE";

  static const String resetCompleteLoseWeight = "RESET_COMPLETE_LOSE_WEIGHT";
  static const String resetCompleteButtLift = "RESET_COMPLETE_BUTT_LIFT";
  static const String resetCompleteLoseBelly = "RESET_COMPLETE_LOSE_BELLY";
  static const String resetCompleteBuildMuscle = "RESET_COMPLETE_BUILD_MUSCLE";
  static const String resetCompleteAllEx = "RESET_COMPLETE_ALL_EX";

  static const String prefWaterTrackerDate = "PREF_WATER_TRACKER_DATE";
  static const String prefCurrentWaterGlass = "PREF_CURRENT_WATER_GLASS";

  static const String prefCurrentBMI = "PREF_CURRENT_BMI";
  static const String prefBMItext = "PREF_BMI_TEXT";
  static const String prefGender = "PREF_GENDER";
  static const String prefDOB = "PREF_DOB";

  static const String firebaseAuthUid = "FIREBASE_AUTH_UID";
  static const String firebaseAuthEmail = "FIREBASE_AUTH_EMAIL";
  static const String trackStatus = "TRACK_STATUS";
  static const String isPurchased = "IS_PURCHASED";

  static const String interstitialAdCount = "INTERSTITIAL_AD_COUNT";

  static const String lastSyncDate = "LAST_SYNC_DATE";

  /// ------------------ SINGLETON -----------------------
  static final Preference _preference = Preference._internal();

  factory Preference() {
    return _preference;
  }

  Preference._internal();

  static Preference get shared => _preference;

  static GetStorage? _pref;


  Future<GetStorage?> instance() async {
    if (_pref != null) return _pref;
    await GetStorage.init().then((value) {
      if (value) {
        _pref = GetStorage();
      }
    }).catchError((onError) {
      _pref = null;
    });
    return _pref;
  }

  String? getString(String key) {
    return _pref!.read(key);
  }

  Future<void> setString(String key, String value) {
    return _pref!.write(key, value);
  }

  int? getInt(String key) {
    return _pref!.read(key);
  }

  Future<void> setInt(String key, int value) {
    return _pref!.write(key, value);
  }

  bool? getBool(String key) {
    return _pref!.read(key);
  }

  Future<void> setBool(String key, bool value) {
    return _pref!.write(key, value);
  }

  double? getDouble(String key) {
    return _pref!.read(key);
  }

  Future<void> setDouble(String key, double value) {
    return _pref!.write(key, value);
  }

  List<String>? getStringList(String key) {
    return _pref!.read(key);
  }

  Future<void> setStringList(String key, List<String> value) {
    return _pref!.write(key, value);
  }


  Future<void> remove(key, [multi = false]) async {
    GetStorage? pref = await instance();
    if (multi) {
      key.forEach((f) async {
        return await pref!.remove(f);
      });
    } else {
      return await pref!.remove(key);
    }
  }


  static Future<bool> clear() async {
    _pref!.getKeys().forEach((key) async {
      await _pref!.remove(key);
    });

    return Future.value(true);
  }

  static Future<bool> clearLogout() async {
    return Future.value(true);
  }

  Future<bool> firebaseLogout() async {
    await _pref!.remove(firebaseAuthUid);
    return Future.value(true);
  }

  Future<bool> resetLastSelectedDay() async {
    await _pref!.remove(prefLastDayCompleteLoseWeight);
    await _pref!.remove(prefLastDayCompleteButtLift);
    await _pref!.remove(prefLastDayCompleteLoseBelly);
    await _pref!.remove(prefLastDayCompleteBuildMuscle);
    return Future.value(true);
  }

  Future<bool> clearResetCompletedDay() async {
    await _pref!.remove(resetCompleteLoseWeight);
    await _pref!.remove(resetCompleteButtLift);
    await _pref!.remove(resetCompleteLoseBelly);
    await _pref!.remove(resetCompleteBuildMuscle);
    await _pref!.remove(resetCompleteAllEx);
    return Future.value(true);
  }
}
