import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/constant.dart';
import '../../../utils/preference.dart';

class ChooseTargetWeightController extends GetxController {
  int weightUnitValue = Constant.valueZero;
  int weightKG = Constant.weightKg;

  List<String> weightUnitList = ["txtKG".tr];

  FixedExtentScrollController? fixedExtentScrollController;

  @override
  void onInit() {
    fixedExtentScrollController = FixedExtentScrollController(initialItem: 0);
    _setPreferenceData();
    super.onInit();
  }

  _setPreferenceData() {
    weightKG = Preference.shared.getInt(Preference.targetWeightInKg) ??
        Constant.weightKg;

    String prefWeightUnit =
        Preference.shared.getString(Preference.targetWeightUnit) ??
            Constant.weightUnitKg;

    if (prefWeightUnit == Constant.weightUnitKg) {
      weightUnitValue = Constant.valueZero;
      Future.delayed(const Duration(milliseconds: 50), () {
        fixedExtentScrollController!.animateToItem(weightKG - 20,
            duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
      });
    }
  }

  onChangeKgValue(int value) {
    weightKG = value;
  }

  onNextButtonClick() {
    Preference.shared.setInt(Preference.targetWeightInKg, weightKG);
    Preference.shared.setString(Preference.targetWeightUnit, Constant.weightUnitKg);
    Get.toNamed(AppRoutes.chooseHeight);
  }
}
