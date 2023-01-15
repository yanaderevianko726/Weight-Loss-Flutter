import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart' as time_zone;
import 'package:url_launcher/url_launcher.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/utils/debug.dart';

import '../common/dialog/multi_selection_days/multiselect_dialog.dart';
import '../database/table/reminder_table.dart';
import '../main.dart';
import '../routes/app_routes.dart';
import 'color.dart';
import 'constant.dart';
import 'preference.dart';
import 'sizer_utils.dart';

class Utils {

  static showToast(BuildContext context, String msg) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      textColor: AppColor.white,
      fontSize: AppFontSize.size_13,
    );
  }

  static getFirebaseUid() {
    return Preference.shared.getString(Preference.firebaseAuthUid);
  }

  static isFirstTimeOpenApp() {
    return Preference.shared.getBool(Preference.isFirstTimeOpenApp) ??
        Constant.boolValueTrue;
  }

  static getPlanId() {
    return Preference.shared.getInt(Preference.selectedPlanId) ?? 1;
  }

  static Future showBottomSheetDialog(Widget bottomSheetWidget,
      {bool isDismiss = true}) {
    return Get.bottomSheet(
      bottomSheetWidget,
      backgroundColor: AppColor.white,
      isScrollControlled: true,
      ignoreSafeArea: false,
      elevation: 10,
      isDismissible: isDismiss,
      enableDrag: isDismiss,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
    );
  }

  static backWidget({Color? iconColor}) {
    return Image.asset(
      Constant.getAssetIcons() + "ic_back_gray.png",
      color: iconColor,
      height: AppSizes.height_3,
      width: AppSizes.height_3,
    );
  }

  static decimalNumberFormat(int number) {
    return intl.NumberFormat.decimalPattern().format(number);
  }

  static convertWeightKgToLbs(value) {
    return (value * 2.205).round();
  }

  static convertWeightLbsToKg(value) {
    return (value / 2.205).round();
  }

  static cmToInch(value) {
    return (value / 2.54).round();
  }

  static inchToCm(value) {
    return (value * 2.54).round();
  }

  static ftInToInch(ft, inch) {
    return (ft * 12).toDouble() + inch;
  }

  static calcInchToFeet(value) {
    return (value / 12.0).toInt();
  }

  static calcInFromInch(value) {
    return double.parse((value % 12.0).toStringAsFixed(6)).round();
  }

  static getMeter(inch) {
    return inch * 0.0254;
  }

  static getBmiCalculation(kg, foot, inch) {
    return kg / pow(getMeter(ftInToInch(foot, inch.toDouble())), 2.0);
  }

  static bmiWeightString(point) {
    try {
      if (point < 15) {
        return "Severely underweight";
      } else if (point > 15 && point < 16) {
        return "Very underweight";
      } else if (point > 16 && point < 18.5) {
        return "Underweight";
      } else if (point > 18.5 && point < 25) {
        return "Healthy Weight";
      } else if (point > 25 && point < 30) {
        return "Overweight";
      } else if (point > 30 && point < 35) {
        return "Moderately obese";
      } else if (point > 35 && point < 40) {
        return "Very obese";
      } else if (point > 40) {
        return "Severely obese";
      }
    } catch (e) {
      Debug.printLog(e.toString());
    }
    return "";
  }

  static getSelectedPlanImage(planIndex) {
    if (planIndex == 0) {
      return Constant.getAssetImage() + "lose_weight_keep.webp";
    } else if (planIndex == 1) {
      return Constant.getAssetImage() + "butt_lift_tone.webp";
    } else if (planIndex == 2) {
      return Constant.getAssetImage() + "lose_belly_fat.webp";
    } else if (planIndex == 3) {
      return Constant.getAssetImage() + "build_muscle_strength.webp";
    } else {
      return Constant.getAssetImage() + "lose_weight_keep.webp";
    }
  }

  static getSelectedPlanName(planIndex) {
    if (planIndex == 0) {
      return "txtLoseWeightAndKeepFit".tr;
    } else if (planIndex == 1) {
      return "txtButtLiftTone".tr;
    } else if (planIndex == 2) {
      return "txtLoseBellyFat".tr;
    } else if (planIndex == 3) {
      return "txtBuildMuscleStrength".tr;
    } else {
      return "txtLoseWeightAndKeepFit".tr;
    }
  }

  static setDayProgressData() async {
    try {
      int compDay = await DBHelper.dbHelper
          .getCompleteDayCountByPlanId(Utils.getPlanId().toString());
      int currentExDays = await DBHelper.dbHelper
          .getTotalDayCountOfExByPlanId(Utils.getPlanId().toString());
      String? txtDayLeft;
      String? txtDayPer;
      String? btnDay;
      double? pbDay;

      var proPercentage =
          (((((compDay).toDouble()) * 100) / currentExDays).toDouble())
              .toString()
              .replaceAll(",", ".");

      if ((currentExDays - compDay) > 0) {
        txtDayLeft = (currentExDays - compDay).toString();
      } else {
        txtDayLeft = "txtWellDone".tr;
      }

      txtDayPer ??= double.parse(proPercentage).round().toString() + "%";

      pbDay = ((double.parse(proPercentage) / 1) / 100);

      if (btnDay == null) {
        if ((currentExDays - compDay) > 0) {
          btnDay = " " + (compDay + 1).toString();
        } else {
          btnDay = "Finished";
        }
      }

      Debug.printLog(
          "setDayProgressData -->> $compDay $txtDayLeft $txtDayPer $pbDay $btnDay");
      return [compDay, txtDayLeft, txtDayPer, pbDay, btnDay];
    } catch (e) {
      Debug.printLog(e.toString());
    }

    return null;
  }

  static onIntroductionSkipButtonClick() {
    Preference.shared
        .setBool(Preference.isFirstTimeOpenApp, Constant.boolValueFalse);
    Get.offAllNamed(AppRoutes.home);
  }

  static daysList() {
    List<MultiSelectDialogItem> daysList = [
      MultiSelectDialogItem(
          "1",
          intl.DateFormat.EEEE(Get.locale!.languageCode)
              .dateSymbols
              .WEEKDAYS[1]),
      MultiSelectDialogItem(
          "2",
          intl.DateFormat.EEEE(Get.locale!.languageCode)
              .dateSymbols
              .WEEKDAYS[2]),
      MultiSelectDialogItem(
          "3",
          intl.DateFormat.EEEE(Get.locale!.languageCode)
              .dateSymbols
              .WEEKDAYS[3]),
      MultiSelectDialogItem(
          "4",
          intl.DateFormat.EEEE(Get.locale!.languageCode)
              .dateSymbols
              .WEEKDAYS[4]),
      MultiSelectDialogItem(
          "5",
          intl.DateFormat.EEEE(Get.locale!.languageCode)
              .dateSymbols
              .WEEKDAYS[5]),
      MultiSelectDialogItem(
          "6",
          intl.DateFormat.EEEE(Get.locale!.languageCode)
              .dateSymbols
              .WEEKDAYS[6]),
      MultiSelectDialogItem(
          "7",
          intl.DateFormat.EEEE(Get.locale!.languageCode)
              .dateSymbols
              .WEEKDAYS[0]),
    ];

    return daysList;
  }

  static Future<void> setNotificationReminder(
      {List<ReminderTable>? reminderList}) async {
    int notificationId = 100;
    List selectedDays = [];
    TimeOfDay? selectedTime;

    List<PendingNotificationRequest> pendingNotification =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    for (var element in pendingNotification) {
      if (element.payload == Constant.strExerciseReminder) {
        flutterLocalNotificationsPlugin.cancel(element.id);
      }
    }

    for (var element in reminderList!) {
      selectedDays = element.repeatNo!.split(", ");
      var hr = int.parse(element.remindTime!.split(":")[0]);
      var min = int.parse(element.remindTime!.split(":")[1]);
      selectedTime = TimeOfDay(hour: hr, minute: min);

      final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

      tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
          now.day, selectedTime.hour, selectedTime.minute);

      if (element.isActive == Constant.valueOne) {
        for (var element in selectedDays) {
          notificationId += 1;
          if (int.parse(element as String) == DateTime.now().weekday &&
              DateTime.now().isBefore(scheduledDate)) {
            await scheduledNotification(scheduledDate, notificationId);
          } else {
            var tempTime = scheduledDate.add(const Duration(days: 1));
            while (tempTime.weekday != int.parse(element)) {
              tempTime = tempTime.add(const Duration(days: 1));
            }
            await scheduledNotification(tempTime, notificationId);
          }
        }
      }
    }
  }

  static scheduledNotification(
      tz.TZDateTime scheduledDate, int notificationId) async {
    var titleText = "Lose Weight For Women";
    var msg =
        "Your body needs energy! You haven't exercised in ${intl.DateFormat('EEEE').format(DateTime.now())}!";
    Debug.printLog("scheduledNotification Id --->> $notificationId");
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      titleText,
      msg,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'exercise_reminder',
          titleText,
          channelDescription: msg,
          icon: 'ic_notification',
          styleInformation: const BigTextStyleInformation(''),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: Constant.boolValueTrue,
          presentBadge: Constant.boolValueTrue,
          presentSound: Constant.boolValueTrue,
        ),
      ),
      androidAllowWhileIdle: Constant.boolValueTrue,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: Constant.strExerciseReminder,
    );
  }

  static setWaterReminderNotifications() async {
    var titleText = "It's time to hydrate!";
    var msg = "Drink lots of water for glowing skin!!";
    final time_zone.TZDateTime now = time_zone.TZDateTime.now(time_zone.local);

    List<PendingNotificationRequest> pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    for (var element in pendingNotifications) {
      if (element.payload != Constant.strWaterReminder) {
        Debug.printLog("Cancel Notification ::::::==> ${element.id}");
        flutterLocalNotificationsPlugin.cancel(element.id);
      }
    }

    time_zone.TZDateTime startTime = time_zone.TZDateTime(
        time_zone.local, now.year, now.month, now.day, 08, 00);
    time_zone.TZDateTime endTime = time_zone.TZDateTime(
        time_zone.local, now.year, now.month, now.day, 23, 00);

    scheduledNotification(
        time_zone.TZDateTime scheduledDate, int notificationId) async {
      Debug.printLog(
          "Schedule Notification at ::::::==> ${scheduledDate.toIso8601String()}");
      Debug.printLog(
          "Schedule Notification at scheduledDate.millisecond::::::==> $notificationId");
      await flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId,
          titleText,
          msg,
          scheduledDate,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'drink_water_reminder',
              titleText,
              channelDescription: msg,
              icon: 'ic_notification',
              styleInformation: const BigTextStyleInformation(''),
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: Constant.boolValueTrue,
              presentBadge: Constant.boolValueTrue,
              presentSound: Constant.boolValueTrue,
            ),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: scheduledDate.millisecondsSinceEpoch.toString());
    }

    int interval = 1; /// intervals into the hours
    var notificationId = 1;
    while (startTime.isBefore(endTime)) {
      time_zone.TZDateTime newScheduledDate = startTime;
      if (newScheduledDate.isBefore(now)) {
        newScheduledDate = newScheduledDate.add(const Duration(days: 1));
      }
      await scheduledNotification(newScheduledDate, notificationId);
      notificationId += 1;
      startTime = startTime.add(Duration(hours: interval));
    }
  }

  static cancelWaterReminderNotifications() async {
    List<PendingNotificationRequest> pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    for (var element in pendingNotifications) {
      if (element.payload != Constant.strWaterReminder) {
        Debug.printLog("Cancel Notification ::::::==> ${element.id}");
        flutterLocalNotificationsPlugin.cancel(element.id);
      }
    }
  }

  static String secToString(int seconds) {
    if (seconds != 0) {
      int hours = (seconds / 3600).truncate();
      seconds = (seconds % 3600).truncate();
      int minutes = (seconds / 60).truncate();

      String hoursStr = (hours).toString().padLeft(2, '0');
      String minutesStr = (minutes).toString().padLeft(2, '0');
      String secondsStr = (seconds % 60).toString().padLeft(2, '0');

      if (hours == 0) {
        return "$minutesStr:$secondsStr";
      }
      return "$hoursStr:$minutesStr:$secondsStr";
    } else {
      return "00:00";
    }
  }

  static String secondToMMSSFormat(int value) =>
      '${formatDecimal(value ~/ 60)}:${formatDecimal(value % 60)}';

  static String formatDecimal(num value) => '$value'.padLeft(2, '0');

  static Future textToSpeech(String speakText, FlutterTts flutterTts) async {
    bool isVoiceGuide =
        Preference.shared.getBool(Preference.soundOptionVoiceGuide) ??
            Constant.boolValueTrue;

    String getLocal = Get.locale!.languageCode + "-" + Get.locale!.countryCode!;
    Debug.printLog("getLocal -->> " + getLocal.toString());
    flutterTts.stop();
    if (isVoiceGuide) {
      await flutterTts.awaitSpeakCompletion(true);
      if (Platform.isAndroid) {
        if (await flutterTts.isLanguageAvailable(getLocal) &&
            await flutterTts.isLanguageInstalled(getLocal)) {
          await flutterTts.setLanguage(getLocal);
        } else {
          await flutterTts.setLanguage("en-GB");
        }
      } else {
        if (await flutterTts.isLanguageAvailable(getLocal)) {
          await flutterTts.setLanguage(getLocal);
        } else {
          await flutterTts.setLanguage("en-GB");
        }
      }
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(speakText);
    }
  }

  static playSound(String sound) {
    bool isCoachTips =
        Preference.shared.getBool(Preference.soundOptionCoachTips) ??
            Constant.boolValueTrue;

    if (isCoachTips) {
      AudioPlayer audioPlayer = AudioPlayer();
      AudioCache audioCache = AudioCache(fixedPlayer: audioPlayer);
      audioCache.play(sound);
    }
  }

  static setLastCompletedDay(int strPlanId, int strLastDayName) {
    switch (strPlanId) {
      case 1:
        return Preference.shared.setInt(
            Preference.prefLastDayCompleteLoseWeight, strLastDayName + 1);
      case 2:
        return Preference.shared
            .setInt(Preference.prefLastDayCompleteButtLift, strLastDayName + 1);
      case 3:
        return Preference.shared.setInt(
            Preference.prefLastDayCompleteLoseBelly, strLastDayName + 1);
      case 4:
        return Preference.shared.setInt(
            Preference.prefLastDayCompleteBuildMuscle, strLastDayName + 1);
    }
  }

  static getLastCompletedDay(int strPlanId) {
    switch (strPlanId) {
      case 1:
        return Preference.shared
                .getInt(Preference.prefLastDayCompleteLoseWeight) ??
            1;
      case 2:
        return Preference.shared
                .getInt(Preference.prefLastDayCompleteButtLift) ??
            1;
      case 3:
        return Preference.shared
                .getInt(Preference.prefLastDayCompleteLoseBelly) ??
            1;
      case 4:
        return Preference.shared
                .getInt(Preference.prefLastDayCompleteBuildMuscle) ??
            1;
    }
  }

  static setResetCompletedDay(int strPlanId) {
    switch (strPlanId) {
      case 1:
        return Preference.shared.setBool(
            Preference.resetCompleteLoseWeight, Constant.boolValueTrue);
      case 2:
        return Preference.shared
            .setBool(Preference.resetCompleteButtLift, Constant.boolValueTrue);
      case 3:
        return Preference.shared
            .setBool(Preference.resetCompleteLoseBelly, Constant.boolValueTrue);
      case 4:
        return Preference.shared.setBool(
            Preference.resetCompleteBuildMuscle, Constant.boolValueTrue);
    }
  }

  static getResetCompletedDay(int strPlanId) {
    switch (strPlanId) {
      case 1:
        return Preference.shared.getBool(Preference.resetCompleteLoseWeight) ??
            Constant.boolValueFalse;
      case 2:
        return Preference.shared.getBool(Preference.resetCompleteButtLift) ??
            Constant.boolValueFalse;
      case 3:
        return Preference.shared.getBool(Preference.resetCompleteLoseBelly) ??
            Constant.boolValueFalse;
      case 4:
        return Preference.shared.getBool(Preference.resetCompleteBuildMuscle) ??
            Constant.boolValueFalse;
    }
  }

  static getResetCompletedAllEx() {
    return Preference.shared.getBool(Preference.resetCompleteAllEx) ??
        Constant.boolValueFalse;
  }

  static getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  static isWaterTrackerOn() {
    return Preference.shared.getBool(Preference.turnOnWaterTracker) ??
        Constant.boolValueTrue;
  }

  static getWaterTrackerDate() {
    return Preference.shared.getString(Preference.prefWaterTrackerDate);
  }

  static getCurrentWaterGlass() {
    return getWaterTrackerDate() != getDate(DateTime.now()).toString()
        ? 0
        : Preference.shared.getInt(Preference.prefCurrentWaterGlass) ?? 0;
  }

  static getCalorieFromSec(int second) {
    return second * Constant.secDurationCal;
  }

  void sendFeedback() {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: Constant.emailPath,
      query: encodeQueryParameters(<String, String>{
        'subject': Platform.isAndroid
            ? "txtLoseWeightForWomenFeedbackAndroid".tr
            : "txtLoseWeightForWomenFeedbackiOS".tr,
        'body': " "
      }),
    );
    launchUrl(emailLaunchUri);
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  static List<String> getDaysNameOfWeek() {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 0));
    return List.generate(7, (index) => index)
        .map((value) => intl.DateFormat(intl.DateFormat.WEEKDAY)
            .format(firstDayOfWeek.add(Duration(days: value))))
        .toList();
  }

  static List<String> getDaysDateOfWeek() {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 0));
    return List.generate(7, (index) => index)
        .map((value) => intl.DateFormat(intl.DateFormat.DAY)
            .format(firstDayOfWeek.add(Duration(days: value))))
        .toList();
  }

  static List<String> getDaysDateForHistoryOfWeek() {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday));
    return List.generate(7, (index) => index)
        .map((value) => intl.DateFormat("yyyy-MM-dd")
            .format(firstDayOfWeek.add(Duration(days: value))))
        .toList();
  }

  static String getMultiLanguageString(String str) {
    return str.tr;
  }

  static getCurrentLocale() {
    var lCode = Preference.shared.getString(Preference.selectedLanguage) ??
        Constant.languageEn;
    var cCode = Preference.shared.getString(Preference.selectedCountryCode) ??
        Constant.countryCodeEn;
    return lCode + "_" + cCode;
  }

  static getExerciseLevelString(String str) {
    if (str == "Beginner") {
      return "txtBeginner".tr;
    } else if (str == "Intermediate") {
      return "txtIntermediate".tr;
    } else if (str == "Advanced") {
      return "txtAdvanced".tr;
    } else {
      return null;
    }
  }

  static Future<bool> isInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  static nonPersonalizedAds() {
    if (Platform.isIOS) {
      if (Preference.shared.getString(Preference.trackStatus) !=
          Constant.trackingStatus) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static isPurchased() {
    return Preference.shared.getBool(Preference.isPurchased) ?? Constant.boolValueFalse;
  }
}
