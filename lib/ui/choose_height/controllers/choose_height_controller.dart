import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/constant.dart';
import '../../../utils/preference.dart';

class ChooseHeightController extends GetxController {
  int heightUnitValue = Constant.valueZero;
  int heightCM = Constant.heightCm;

  List<String> heightUnitList = ["txtCM".tr];

  FixedExtentScrollController? fixedExtentScrollControllerCm;

  @override
  void onInit() {
    fixedExtentScrollControllerCm = FixedExtentScrollController(initialItem: 0);
    _setPreferenceData();
    super.onInit();
  }

  _setPreferenceData() {
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

  onNextButtonClick() {
    Preference.shared.setInt(Preference.currentHeightInCm, heightCM);
    Preference.shared.setString(
        Preference.currentHeightUnit, Constant.heightUnitCm);
    Get.back();
    Get.toNamed(AppRoutes.yourPlan);
  }
}
