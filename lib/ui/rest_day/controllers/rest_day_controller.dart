import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/utils/utils.dart';

import '../../../database/custom_classes/custom_classes.dart';
import '../../../database/table/home_plan_table.dart';

class RestDayController extends GetxController {
  dynamic arguments = Get.arguments;

  HomePlanTable? workoutPlanData;
  PWeekDayData? pWeekDayData;

  _getArgumentData() {
    if (arguments != null) {
      if (arguments[0] != null) {
        workoutPlanData = arguments[0];
      }

      if (arguments[1] != null) {
        pWeekDayData = arguments[1];
      }
    }
  }

  onFinishedButtonClick() {
    if (pWeekDayData != null) {
      if (pWeekDayData!.dayId != null) {
        DBHelper.dbHelper.updatePlanDayCompleteByDayId(pWeekDayData!.dayId.toString());
      }
      Utils.setLastCompletedDay(Utils.getPlanId(), int.parse(pWeekDayData!.dayName));
    }
    Get.back();
  }

  @override
  void onInit() {
    _getArgumentData();
    super.onInit();
  }
}
