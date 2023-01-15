import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/preference.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/utils.dart';

class YourPlanController extends GetxController {
  int? selectedPlanIndex;

  String txtDayLeft = "0";
  double pbDay = 0.0;

  List? dayProgressData;

  @override
  void onInit() {
    _getPreferenceData();
    _getDatabaseData();
    super.onInit();
  }

  _getPreferenceData() {
    selectedPlanIndex =
        Preference.shared.getInt(Preference.selectedPlanIndex) ?? 0;
  }

  _getDatabaseData() async {
    dayProgressData = await Utils.setDayProgressData();

    if (dayProgressData != []) {
      txtDayLeft = dayProgressData![1];
      pbDay = dayProgressData![3];
    }

    update([Constant.idYourPlanProgress]);
  }

  onGoButtonAndGoToHomePageClick() {
    Preference.shared.setBool(Preference.isFirstTimeOpenApp, Constant.boolValueFalse);
    Get.offAllNamed(AppRoutes.home);
  }
}
