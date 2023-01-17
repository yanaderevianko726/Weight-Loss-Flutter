// ignore_for_file: unnecessary_null_comparison

import 'package:shared_preferences/shared_preferences.dart';

var title = "Preferences";

Preferences preferences = Preferences();

class Preferences {
  Preferences._();

  static final Preferences preferences = Preferences._();

  factory Preferences() {
    return preferences;
  }

  late SharedPreferences _prefs;

  Future<SharedPreferences> get prefs async {
    if (_prefs != null) return _prefs;

    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  Future<bool> saveString({String? key, String? value}) async {
    print("savestr===$key===$value");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key!, value!);
  }

  Future<String?> getString({String? key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key!);
  }

  Future<bool> saveBool({String? key, bool? value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(key!, value!);
  }

  Future<bool> getBool({required String key,required bool defValue}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defValue;
  }

  Future clearPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
  Future clearPrefValue(String keyVal) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(keyVal);

  }
}

mixin PrefernceKey {
  static String isUserLogin = "isUserLogin";
  static String loginToken = "loginToken";
  static String userData = "userData";
  static String userName = "username";
  static String userId = "userId";
  static String isfirstTimeInfo = "isfirstTimeInfo";
  static String isProUser = "isProUser";
  static String currentProPlan= "proUserCurrentSelectedPlan";

}
