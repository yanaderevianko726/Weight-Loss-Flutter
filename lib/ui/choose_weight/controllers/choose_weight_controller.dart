import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/utils/preference.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/constant.dart';

class ChooseWeightController extends GetxController {
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
    weightKG = Preference.shared.getInt(Preference.currentWeightInKg) ??
        Constant.weightKg;

    String prefWeightUnit =
        Preference.shared.getString(Preference.currentWeightUnit) ??
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
    Preference.shared.setInt(Preference.currentWeightInKg, weightKG);
    Preference.shared.setString(Preference.currentWeightUnit, Constant.weightUnitKg);
    Get.toNamed(AppRoutes.chooseTargetWeight);
  }
}
