import 'package:shared_preferences/shared_preferences.dart';

class PrefData {
  // static String pkgName = "yoga_workout_ui";
  static String prefName = "com.screensizer.screen_sizer";
  static String remindTime = prefName + "ttsSetRemindTime";
  static String remindDays = prefName + "ttsSetRemindDays";
  static String remindAmPm = prefName + "ttsSetRemindAmPm";
  static String trainingRest = prefName + "ttsTrainingRest";
  static String reminderOn = prefName + "ttsIsReminderOn";
  static String calorieBurn = prefName + "ttsCalorieBurn";
  static String getDailyGoal = prefName + "ttsCalorieBurnDailyGoal";
  static String isFirst = prefName + "ttsIsFirstIntro";
  static String keyHeight = prefName + "ttsHeightKeys";
  static String keyWeight = prefName + "ttsWeightKeys";
  static String keyIsMale = prefName + "ttsGenderKeys";
  static String isKg = prefName + "ttsIsKgUNit";
  static String isSoundOn = prefName + "soundIsMutes";
  static String isTtsOn = prefName + "ttsIsMutes";
  static String isVolume = prefName + "isVolume";
  static String userDetail = prefName + "userDetail";
  static String isIntro = prefName + "isIntro";
  static String signIn = prefName + "signIn";
  static String session = prefName + "session";

  // static String isCode = pkgName + "isCode";
  // static String isImage = pkgName + "isImage";
  static String isCode = "${prefName}isCode";
  static String isImage = "${prefName}isImage";
  static String isCustomPlanId = "${prefName}isCustomPlanId";
  static String isCustomPlanDescription = "${prefName}isCustomPlanDescription";
  static String isCustomPlanName = "${prefName}isCustomPlanName";
  static String progressIndex = "${prefName}pregressIndex";
  static String userAccess = "${prefName}userAccess";
  static String isFirstSignUp = "${prefName}isFirstSignUp";
  static String isSetting = "${prefName}isSetting";

  static setUserAccess(int i) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt(userAccess, (i - 1));
  }

  static getUserAccess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userAccess) ?? 4;
  }

  checkUserAccess() async {
    int i = await PrefData.getUserAccess();
    if (i > 0) {
      setUserAccess(i);
      return true;
    } else {
      return false;
    }
  }

  static Future<SharedPreferences> getPrefInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences;
  }

  static setPrgressIndex(int index) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setInt(progressIndex, index);
  }

  static Future<int> getProgressIndex() async {
    SharedPreferences preferences = await getPrefInstance();
    int isProgressIndex = preferences.getInt(progressIndex) ?? 0;
    return isProgressIndex;
  }

  static setCode(String code) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setString(isCode, code);
  }

  static Future<String> getCode() async {
    SharedPreferences preferences = await getPrefInstance();
    String isCodeAvailable = preferences.getString(isCode) ?? "";
    return isCodeAvailable;
  }

  static setImage(String image) async {
    SharedPreferences preferences = await getPrefInstance();
    preferences.setString(isImage, image);
  }

  static Future<String> getImage() async {
    SharedPreferences preferences = await getPrefInstance();
    String isImageAvailable = preferences.getString(isImage) ?? "";
    return isImageAvailable;
  }

  static setSession(String s) async {
    print("session----$s");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(session, s);
  }

  static getSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(session) ?? "";
  }

  static setCustomPlanId(String s) async {
    print("session----$s");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(isCustomPlanId, s);
  }

  static getCustomPlanId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(isCustomPlanId) ?? "";
  }

  static setCustomPlanName(String s) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(isCustomPlanName, s);
  }

  static getCustomPlanName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(isCustomPlanName) ?? "";
  }

  static setCustomPlanDescription(String s) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(isCustomPlanDescription, s);
  }

  static getCustomPlanDescription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(isCustomPlanDescription) ?? "";
  }

  static setIsSignIn(bool isFav) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(signIn, isFav);
  }

  static getIsSignIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(signIn) ?? false;
  }

  static setIsSetting(bool setting) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isSetting, setting);
  }

  static getIsSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isSetting) ?? false;
  }

  static setFirstSignUp(bool firstSignup) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isFirstSignUp, firstSignup);
  }

  static getFirstSignUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isFirstSignUp) ?? true;
  }

  static setUserDetail(String s) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userDetail, s);
  }

  static getUserDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userDetail) ?? '';
  }

  addRestTime(int sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(trainingRest, sizes);
  }

  addReminderTime(String sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(remindTime, sizes);
  }

  static setIsIntro(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isIntro, sizes);
  }

  static getIsIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool intValue = prefs.getBool(isIntro) ?? true;
    return intValue;
  }

  addReminderDays(String sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(remindDays, sizes);
  }

  addReminderAmPm(String sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(remindAmPm, sizes);
  }

  addHeight(double sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyHeight, sizes);
  }

  addWeight(double sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(keyWeight, sizes);
  }

  addDailyCalGoal(int sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(getDailyGoal, sizes);
  }

  setIsFirst(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isFirst, sizes);
  }

  setIsKgUnit(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isKg, sizes);
  }

  setIsReminderOn(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(reminderOn, sizes);
  }

  setIsMale(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsMale, sizes);
  }

  addBurnCalorie(int sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(calorieBurn, sizes);
  }

  getRestTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int intValue = prefs.getInt(trainingRest) ?? 10;
    return intValue;
  }

  getHeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double intValue = prefs.getDouble(keyHeight) ?? 100;
    return intValue;
  }

  getRemindTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String intValue = prefs.getString(remindTime) ?? "5:30";
    return intValue;
  }

  getRemindDays() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String intValue = prefs.getString(remindDays) ?? "";
    return intValue;
  }

  getRemindAmPm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String intValue = prefs.getString(remindAmPm) ?? "AM";
    return intValue;
  }

  getWeight() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double intValue = prefs.getDouble(keyWeight) ?? 50;
    return intValue;
  }

  getDailyCalGoal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int intValue = prefs.getInt(getDailyGoal) ?? 200;
    return intValue;
  }

  getIsFirstIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool intValue = prefs.getBool(isFirst) ?? true;
    return intValue;
  }

  getIsReminderOn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool intValue = prefs.getBool(reminderOn) ?? true;
    return intValue;
  }

  getIsMute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool intValue = prefs.getBool(isTtsOn) ?? true;
    return intValue;
  }

  getIsVolume() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double intValue = prefs.getDouble(isVolume) ?? 0.0;
    return intValue;
  }

  getIsSoundOn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool intValue = prefs.getBool(isSoundOn) ?? true;
    return intValue;
  }

  setIsMute(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isTtsOn, sizes);
  }

  setIsVolume(double volume) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(isVolume, volume);
  }

  setIsSoundOn(bool sizes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isSoundOn, sizes);
  }

  getIsKgUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool intValue = prefs.getBool(isKg) ?? true;
    return intValue;
  }

  getIsMale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool intValue = prefs.getBool(keyIsMale) ?? true;
    return intValue;
  }

  getBurnCalorie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int intValue = prefs.getInt(calorieBurn) ?? 0;
    return intValue;
  }
}
