import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/utils/preference.dart';

import '../../../utils/constant.dart';

class WhatsYourGoalController extends GetxController {
  List<String> whatsYourGoalList = [];
  int selectedWhatsYourGoalIndex = 0;

  @override
  void onInit() {
    _whatsYourGoalListData();
    _getPreferenceData();
    super.onInit();
  }

  _whatsYourGoalListData() {
    whatsYourGoalList = [
      "txtLoseWeightAndKeepFit".tr,
      "txtButtLiftTone".tr,
      "txtLoseBellyFat".tr,
      "txtBuildMuscleStrength".tr
    ];
  }

  _getPreferenceData() {
    selectedWhatsYourGoalIndex =
        Preference.shared.getInt(Preference.selectedPlanIndex) ?? 0;
  }

  void onWhatsYourGoalClick(int index) {
    selectedWhatsYourGoalIndex = index;
    Preference.shared
        .setInt(Preference.selectedPlanIndex, selectedWhatsYourGoalIndex);
    Preference.shared
        .setInt(Preference.selectedPlanId, (selectedWhatsYourGoalIndex + 1));
    update([Constant.idWhatsYourGoalList]);
  }
}
