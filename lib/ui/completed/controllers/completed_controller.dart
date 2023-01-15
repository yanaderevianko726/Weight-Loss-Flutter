import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/database/table/weight_table.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/preference.dart';
import 'package:intl/intl.dart';
import '../../../database/custom_classes/custom_classes.dart';
import '../../../database/table/history_table.dart';
import '../../../database/table/home_plan_table.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/debug.dart';
import '../../../utils/utils.dart';

class CompletedController extends GetxController {
  TextEditingController weightController = TextEditingController();

  bool isSelectedWeightKg = true;
  double? bmi;
  int currentSelectedRadioButtonValue = -1;
  int feelRate = 0;

  String reminderTimers = "";

  HomePlanTable? workoutPlanData;
  List<HomeExTableClass> exerciseList = [];
  int totalExTime = 0;
  List<Animation<int>> listOfAnimation = [];
  List<AnimationController> listOfAnimationController = [];

  String? currentHeightUnit;
  String? height;
  String? bmiCategory;
  Color? bmiColor;

  List<WeightTable>? weightDataList;
  PWeekDayData? weeklyDaysData;

  dynamic arguments = Get.arguments;

  _getArgumentsData() {
    if (arguments != null) {
      if (arguments[0] != null) {
        workoutPlanData = arguments[0];
      }
      if (arguments[1] != null) {
        exerciseList = arguments[1];
      }
      if (arguments[2] != null) {
        totalExTime = arguments[2];
        Debug.printLog("totalExTime -->> $totalExTime");
      }
      if (arguments[3] != null) {
        listOfAnimation = arguments[3];
      }
      if (arguments[4] != null) {
        listOfAnimationController = arguments[4];
      }
      if (arguments[5] != null) {
        weeklyDaysData = arguments[5];
      }
    }
  }

  changeWeightKgLsb(bool value) {
    isSelectedWeightKg = value;
    if (isSelectedWeightKg) {
      Preference.shared
          .setString(Preference.currentWeightUnit, Constant.weightUnitKg);
    }
    update([Constant.idWeightCompleted]);
    setWeightValues();
  }

  double? bmiValuePosition(double fullWidth) {
    if (bmi! <= 15) {
      return fullWidth * -0.45;
    } else if (bmi! > 15 && bmi! < 16) {
      return _setBmiCalculationInLoop(fullWidth, 10, 0.09, -0.45, 0);
    } else if (bmi! >= 16 && bmi! <= 18.5) {
      return _setBmiCalculationInLoop(fullWidth, 25, 16.00, -0.36, 16.00);
    } else if (bmi! >= 18.5 && bmi! < 25) {
      return _setBmiCalculationInLoop(fullWidth, 65, 18.00, -0.20, 24.00);
    } else if (bmi! >= 25 && bmi! < 30) {
      return _setBmiCalculationInLoop(fullWidth, 50, 25.00, 0.04, 17.00);
    } else if (bmi! >= 30 && bmi! < 35) {
      return _setBmiCalculationInLoop(fullWidth, 50, 30.00, 0.21, 11.00);
    } else if (bmi! >= 35 && bmi! < 40) {
      return _setBmiCalculationInLoop(fullWidth, 50, 35.00, 0.32, 12.00);
    } else if (bmi! >= 40) {
      return fullWidth * 0.44;
    }
    return null;
  }

  _setBmiCalculationInLoop(double fullWidth, int totalDiffInLoop,
      double startingPoint, double totalWidth, double totalDiffForTwoPoint) {
    var pos = 0;

    for (int i = 0; i < totalDiffInLoop; i++) {
      if (bmi == startingPoint ||
          (bmi! > startingPoint &&
              bmi! <= (startingPoint + (0.10 * (i + 1))))) {
        break;
      } else {
        pos++;
      }
    }
    if (pos == 0) {
      pos = 1;
    }
    double bmiVal = 0;
    bmiVal = ((pos * totalDiffForTwoPoint) / totalDiffInLoop) / 100;
    Debug.printLog("bmiVal===>>  " + bmiVal.toString() + "  " + pos.toString());
    return fullWidth * (totalWidth + bmiVal);
  }

  changeIFeelRadioValue(int? value) {
    currentSelectedRadioButtonValue = value!;
    feelRate = currentSelectedRadioButtonValue + 1;
    update([Constant.idIFeelListCompleted]);
  }

  onShareButtonClick() {
    var link = Constant.shareLink;
    var strSubject = "txtShare".tr + " " + "txtAppName".tr + "txtWithYou".tr;
    var strText = "txtIHaveFinish".tr +
        " " +
        exerciseList.length.toString() +
        " " +
        "txtOf".tr +
        " " +
        "txtAppName".tr +
        " " +
        "txtExerciseDot".tr +
        "\n" +
        "txtYouShould".tr +
        " " +
        link;

    Share.share(strText, subject: strSubject);
  }

  onDoItAgainButtonClick() {
    Get.back();
    Get.toNamed(AppRoutes.performExercise, arguments: [
      workoutPlanData,
      exerciseList,
      listOfAnimation,
      listOfAnimationController,
      null,
      weeklyDaysData,
    ]);
  }

  onEditReminderClick() {
    Get.toNamed(AppRoutes.reminder)!.then((value) => _getDataBaseData());
  }

  onNextButtonClick() async {
    var calValue = Constant.secDurationCal * totalExTime;

    DBHelper.dbHelper.addHistory(
      HistoryTable(
        hid: DateTime.now().millisecondsSinceEpoch,
        hPlanId: exerciseList[0].planId.toString(),
        hPlanName: await DBHelper.dbHelper
            .getPlanNameByPlanId(exerciseList[0].planId!),
        hDateTime:
            (DateFormat(Constant.dateTime24Format).format(DateTime.now())),
        hCompletionTime: totalExTime.toString(),
        hBurnKcal: calValue.toString(),
        hTotalEx: exerciseList.length.toString(),
        hKg: (Preference.shared.getInt(Preference.currentWeightInKg) ??
                Constant.weightKg)
            .toString(),
        hFeet: '5',
        hInch: '5',
        hFeelRate: feelRate.toString(),
        hDayName: await DBHelper.dbHelper
            .getPlanDayNameByDayId(exerciseList[0].dayId!),
        hDayId: exerciseList[0].dayId,
        status: Constant.statusSyncPending,
      ),
    );

    if (workoutPlanData!.planDays! == Constant.planDaysYes) {
      DBHelper.dbHelper
          .updatePlanDayCompleteByDayId(exerciseList[0].dayId.toString());
    }

    Get.back();
    Get.toNamed(AppRoutes.history, arguments: workoutPlanData!.planDays! == Constant.planDaysYes ? Constant.boolValueFalse : Constant.boolValueTrue);
  }

  onWeightFieldSubmitted(String value) async {
    Focus.of(Get.context!).unfocus();
    Debug.printLog("onWeightFieldSubmitted -->> $value");

    String weightUnit =
        Preference.shared.getString(Preference.currentWeightUnit) ??
            Constant.weightUnitKg;
    var boolKg = weightUnit == Constant.weightUnitKg;

    if (value.isEmpty) {
      Utils.showToast(Get.context!, "txtPleaseFillTheField".tr);
    } else if (boolKg &&
        (double.parse(value) < Constant.minKG ||
            double.parse(value) > Constant.maxKG)) {
      Utils.showToast(Get.context!, "txtWarningForKg".tr);
    } else {
      await _addWeightToDatabase();
      if (weightUnit != Constant.weightUnitKg) {
        Preference.shared.setInt(Preference.currentWeightInKg,
            Utils.convertWeightLbsToKg((double.parse(value))));
      }
    }
  }

  setWeightValues() {
    int lastWeightKg = Preference.shared.getInt(Preference.currentWeightInKg) ??
        Constant.weightKg;
    String weightUnit =
        Preference.shared.getString(Preference.currentWeightUnit) ??
            Constant.weightUnitKg;

    if (weightUnit == Constant.weightUnitKg && lastWeightKg != 0) {
      isSelectedWeightKg = true;
      weightController.text = lastWeightKg.toString();
    } else if (lastWeightKg != 0) {
      isSelectedWeightKg = false;
      weightController.text =
          Utils.convertWeightKgToLbs(lastWeightKg).toString();
    }
    update([Constant.idWeightCompleted]);
  }

  _getDataBaseData() async {
    reminderTimers = await DBHelper.dbHelper.getRemindersListString();
    update([Constant.idReminderTimes]);
  }

  _getPreferenceData() {
    isSelectedWeightKg = (Constant.weightUnitKg ==
        (Preference.shared.getString(Preference.currentWeightUnit) ??
            Constant.weightUnitKg));
  }

  getBmiData() {
    bmi = Preference.shared.getDouble(Preference.prefCurrentBMI) ?? 0;
    bmiTextCategory();
    update([Constant.idReportBmiChart]);
  }

  bmiTextCategory() {
    if (bmi! < 15) {
      bmiCategory = "txtSeverelyUnderweight".tr;
      bmiColor = AppColor.black;
      Preference.shared.setString(Preference.prefBMItext, bmiCategory!);
    } else if (bmi! >= 15 && bmi! < 16) {
      bmiCategory = "txtVeryUnderweight".tr;
      bmiColor = AppColor.bmiFirstColor;
      Preference.shared.setString(Preference.prefBMItext, bmiCategory!);
    } else if (bmi! >= 16 && bmi! < 18.5) {
      bmiCategory = "txtUnderweight".tr;
      bmiColor = AppColor.bmiSecondColor;
      Preference.shared.setString(Preference.prefBMItext, bmiCategory!);
    } else if (bmi! >= 18.5 && bmi! <= 25) {
      bmiCategory = "txtHealthyWeight".tr;
      bmiColor = AppColor.bmiThirdColor;
      Preference.shared.setString(Preference.prefBMItext, bmiCategory!);
    } else if (bmi! > 25 && bmi! < 30) {
      bmiCategory = "txtOverWeight".tr;
      bmiColor = AppColor.bmiFourColor;
      Preference.shared.setString(Preference.prefBMItext, bmiCategory!);
    } else if (bmi! >= 30 && bmi! < 35) {
      bmiCategory = "txtModeratelyObese".tr;
      bmiColor = AppColor.bmiFiveColor;
      Preference.shared.setString(Preference.prefBMItext, bmiCategory!);
    } else if (bmi! >= 35 && bmi! < 40) {
      bmiCategory = "txtObese".tr;
      bmiColor = AppColor.bmiSixColor;
      Preference.shared.setString(Preference.prefBMItext, bmiCategory!);
    } else if (bmi! >= 40) {
      bmiCategory = "txtSeverelyObese".tr;
      bmiColor = AppColor.black;
      Preference.shared.setString(Preference.prefBMItext, bmiCategory!);
    }
  }

  _addWeightToDatabase() async {
    weightDataList = await DBHelper.dbHelper.getWeightData();
    if (weightDataList!.isNotEmpty) {
      var res = weightDataList!.where((element) =>
      element.weightId == DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 0, 0, 0, 0)
          .millisecondsSinceEpoch);
      if (res.isNotEmpty) {
        updateWeightDatabase();
      } else {
        insertWeightToDatabase();
      }
    } else {
      insertWeightToDatabase();
    }
  }

  void updateWeightDatabase() {
    DBHelper.dbHelper.updateWeight(
      weightKG: isSelectedWeightKg
          ? double.parse(weightController.text).round().toString()
          : Utils.convertWeightLbsToKg(double.parse(weightController.text))
              .toString(),
      weightLBS: !isSelectedWeightKg
          ? double.parse(weightController.text).round().toString()
          : Utils.convertWeightKgToLbs(double.parse(weightController.text))
              .toString(),
      id: DateTime(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, 0, 0, 0, 0, 0)
          .millisecondsSinceEpoch,
    );
  }

  void insertWeightToDatabase() {
    DBHelper.dbHelper.insertWeightData(WeightTable(
      weightId: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 0, 0, 0, 0, 0)
          .millisecondsSinceEpoch,
      weightKg: isSelectedWeightKg
          ? double.parse(weightController.text).round().toString()
          : Utils.convertWeightLbsToKg(double.parse(weightController.text))
              .toString(),
      weightLb: !isSelectedWeightKg
          ? double.parse(weightController.text).round().toString()
          : Utils.convertWeightKgToLbs(double.parse(weightController.text))
              .toString(),
      weightDate: Utils.getDate(DateTime.now()).toString(),
      currentTimeStamp: DateTime.now().toString(),
      status: Constant.statusSyncPending,
    ));
  }

  @override
  void onInit() {
    super.onInit();
    _getArgumentsData();
    _getPreferenceData();
    _getDataBaseData();
    setWeightValues();
    getBmiData();
  }
}
