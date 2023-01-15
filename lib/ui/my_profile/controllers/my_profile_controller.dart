import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/database/table/weight_table.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/preference.dart';

import '../../../utils/utils.dart';

class MyProfileController extends GetxController {
  bool isKgCmLbsFt = Constant.boolValueTrue;

  int heightUnitValue = Constant.valueZero;
  int weightUnitValue = Constant.valueZero;
  int targetWeightUnitValue = Constant.valueZero;

  List<String> heightUnitList = ["txtCM".tr];
  List<String> weightUnitList = ["txtKG".tr];
  List<String> targetWeightUnitList = ["txtKG".tr];

  String? heightInCM;
  String? weightInKG;
  String? targetWeightInKG;

  int heightCM = Constant.heightCm;
  int weightKG = Constant.weightKg;
  int targetWeightKG = Constant.weightKg;

  FixedExtentScrollController? fixedExtentScrollControllerCm;
  FixedExtentScrollController? fixedExtentScrollControllerWeight;
  FixedExtentScrollController? fixedExtentScrollControllerTargetWeight;

  List<WeightTable>? weightDataList;

  @override
  void onInit() {
    fixedExtentScrollControllerCm =
        FixedExtentScrollController(initialItem: 80);
    fixedExtentScrollControllerWeight =
        FixedExtentScrollController(initialItem: 40);
    fixedExtentScrollControllerTargetWeight =
        FixedExtentScrollController(initialItem: 40);
    _fillData();
    super.onInit();
  }

  _fillData() {
    isKgCmLbsFt = ((Preference.shared.getString(Preference.currentWeightUnit) ==
            Constant.weightUnitKg) &&
        (Preference.shared.getString(Preference.targetWeightUnit) ==
            Constant.weightUnitKg) &&
        (Preference.shared.getString(Preference.currentHeightUnit) ==
            Constant.heightUnitCm));

    if (isKgCmLbsFt) {
      heightInCM = (Preference.shared.getInt(Preference.currentHeightInCm) ??
                  Constant.heightCm)
              .toString() +
          " CM";
      weightInKG = (Preference.shared.getInt(Preference.currentWeightInKg) ??
                  Constant.weightKg)
              .toString() +
          " KG";
      targetWeightInKG =
          (Preference.shared.getInt(Preference.targetWeightInKg) ??
                      Constant.weightKg)
                  .toString() +
              " KG";
    }

    update([Constant.idKgCmLbsFtSelection]);
  }

  onSelectKgCm() {
    isKgCmLbsFt = Constant.boolValueTrue;
    Preference.shared
        .setString(Preference.currentWeightUnit, Constant.weightUnitKg);
    Preference.shared
        .setString(Preference.targetWeightUnit, Constant.weightUnitKg);
    Preference.shared
        .setString(Preference.currentHeightUnit, Constant.heightUnitCm);
    _fillData();
    update([Constant.idKgCmLbsFtSelection]);
  }

  /// Height

  getHeightPreferenceData() {
    heightCM = Preference.shared.getInt(Preference.currentHeightInCm) ??
        Constant.heightCm;
    String prefHeightUnit =
        Preference.shared.getString(Preference.currentHeightUnit) ??
            Constant.heightUnitCm;

    if (prefHeightUnit == Constant.heightUnitCm) {
      heightUnitValue = Constant.valueZero;
      Future.delayed(const Duration(milliseconds: 50), () async {
        await fixedExtentScrollControllerCm!.animateToItem(heightCM - 20,
            duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
      });
    }
  }

  onChangeCMValue(int value) {
    heightCM = value;
  }

  onHeightSaveButtonClick() {
    if (heightUnitValue == Constant.valueZero) {
      Preference.shared.setInt(Preference.currentHeightInCm, heightCM);
    }

    Preference.shared.setString(
        Preference.currentHeightUnit,Constant.heightUnitCm);
    Get.back();
    _fillData();
  }

  /// Weight

  getWeightPreferenceData() {
    weightKG = Preference.shared.getInt(Preference.currentWeightInKg) ??
        Constant.weightKg;

    String prefWeightUnit =
        Preference.shared.getString(Preference.currentWeightUnit) ??
            Constant.weightUnitKg;

    if (prefWeightUnit == Constant.weightUnitKg) {
      weightUnitValue = Constant.valueZero;
      Future.delayed(const Duration(milliseconds: 50), () {
        fixedExtentScrollControllerWeight!.animateToItem(weightKG - 20,
            duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
      });
    }
  }

  onChangeKgValue(int value) {
    weightKG = value;
  }

  onWeightSaveButtonClick() async {
    Preference.shared.setInt(Preference.currentWeightInKg, weightKG);
    Get.back();
    _fillData();
    await _addWeightToDatabase();
  }

  _addWeightToDatabase() async {
    weightDataList = await DBHelper.dbHelper.getWeightData();
    if (weightDataList!.isNotEmpty) {
      var res = weightDataList!.where((element) =>
          element.weightId ==
          DateTime(DateTime.now().year, DateTime.now().month,
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
      weightKG: weightKG.toString(),
      weightLBS: "0",
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
      weightKg: weightKG.toString(),
      weightLb: "0",
      weightDate: Utils.getDate(DateTime.now()).toString(),
      currentTimeStamp: DateTime.now().toString(),
      status: Constant.statusSyncPending,
    ));
  }

  /// Target Weight

  getTargetWeightPreferenceData() {
    targetWeightKG = Preference.shared.getInt(Preference.targetWeightInKg) ??
        Constant.weightKg;

    String prefWeightUnit =
        Preference.shared.getString(Preference.targetWeightUnit) ??
            Constant.weightUnitKg;

    if (prefWeightUnit == Constant.weightUnitKg) {
      targetWeightUnitValue = Constant.valueZero;
      Future.delayed(const Duration(milliseconds: 50), () {
        fixedExtentScrollControllerTargetWeight!.animateToItem(
            targetWeightKG - 20,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn);
      });
    }
  }

  onChangeKgTargetValue(int value) {
    targetWeightKG = value;
  }

  onTargetWeightSaveButtonClick() {
    Preference.shared.setInt(Preference.targetWeightInKg, targetWeightKG);
    Preference.shared.setString(Preference.targetWeightUnit, Constant.weightUnitKg);
    Get.back();
    _fillData();
  }
}
