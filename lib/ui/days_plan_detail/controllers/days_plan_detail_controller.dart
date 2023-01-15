import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';

import '../../../common/bottomsheet/bottom_sheet_reset_confirmation.dart';
import '../../../database/custom_classes/custom_classes.dart';
import '../../../database/table/home_plan_table.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/color.dart';
import '../../../utils/constant.dart';
import '../../../utils/preference.dart';
import '../../../utils/utils.dart';

class DaysPlanDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  ScrollController? scrollController;
  bool lastStatus = true;

  int currentPlanIndex = 0;

  List? dayProgressData;
  String txtDayLeft = "0";
  double pbDay = 0.0;

  List<PWeeklyDayData> pWeeklyDayList = [];

  bool boolFlagWeekComplete = false;

  HomePlanTable? homePlanTable;
  double offset = 0.0;

  @override
  void onInit() {
    scrollController = ScrollController();
    scrollController!.addListener(() {
      offset = scrollController!.offset;
      _scrollListener();
    });
    _fillMainGoalData();
    _fillWeekDaysData();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController!.removeListener(_scrollListener);
    super.onClose();
  }

  @override
  void dispose() {
    scrollController!.removeListener(_scrollListener);
    super.dispose();
  }

  bool get isShrink {
    return scrollController!.hasClients && offset > (100 - kToolbarHeight);
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      lastStatus = isShrink;
      update([Constant.idDaysPlanDetailSliverAppBar]);
    }
  }

  _fillMainGoalData() async {
    currentPlanIndex =
        Preference.shared.getInt(Preference.selectedPlanIndex) ?? 0;

    dayProgressData = await Utils.setDayProgressData();

    if (dayProgressData != []) {
      txtDayLeft = dayProgressData![1];
      pbDay = dayProgressData![3];
    }
    update([Constant.idDaysPlanDetailSliverAppBar]);
  }

  _fillWeekDaysData() async {
    pWeeklyDayList = await DBHelper.dbHelper.getWorkoutWeeklyData(
        Utils.getSelectedPlanName(currentPlanIndex),
        Utils.getPlanId().toString());
    update([Constant.idWeeksDaysList]);
  }

  getTotalCompletedDaysInWeek(PWeeklyDayData pWeeklyDayList) {
    var count = 0;
    for (int i = 0; i < pWeeklyDayList.arrWeekDayData!.length; i++) {
      if (pWeeklyDayList.arrWeekDayData![i].isCompleted == "1") {
        count++;
      }
    }

    return count.toString();
  }

  isWorkoutCompleted(PWeekDayData currentItem) {
    return currentItem.isCompleted == "1";
  }

  isWorkoutCompletedNextItem(int parentIndex, int childIndex) {

    return int.parse(pWeeklyDayList[parentIndex]
                .arrWeekDayData![childIndex]
                .dayName) ==
            _nextDayName(Utils.getPlanId()) &&
        pWeeklyDayList[parentIndex].arrWeekDayData![childIndex].isCompleted ==
            "0";
  }

  isRestDay(PWeekDayData currentItem) {
    if (currentItem.workouts == "0") {
      return true;
    }
    return false;
  }

  Future<double> getCompletedExercise(String dayId) async {
    int progress = 0;

    progress = await DBHelper.dbHelper.getCompleteDayExList(dayId);

    return progress.toDouble();
  }

  int _nextDayName(int strPlanId) {
    return Utils.getLastCompletedDay(strPlanId);
  }

  refreshData() {
    _fillMainGoalData();
    _fillWeekDaysData();
  }

  onRestartButtonClick() {
    Get.bottomSheet(
      const BottomSheetResetConfirmation(),
      backgroundColor: AppColor.white,
      isDismissible: Constant.boolValueFalse,
      isScrollControlled: Constant.boolValueFalse,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
    ).then((value) {
      if (value != null) {
        if (value) {
         Future.delayed(const Duration(milliseconds: 20), () {
           refreshData();
         });

        }
      }
    });
  }

  onChangePlanButtonClick() {
    Get.toNamed(AppRoutes.whatsYourGoal)!.then((value) {
      if (value != null && value) {
        refreshData();
      }
    });
  }

  onItemWeeksDaysClick(
      PWeeklyDayData pWeeklyDayData, PWeekDayData pWeekDayData) async {
    homePlanTable = await DBHelper.dbHelper.getPlanByPlanId(Utils.getPlanId());

    homePlanTable!.planMinutes = pWeekDayData.minutes;
    homePlanTable!.planWorkouts = pWeekDayData.workouts;
    if (isRestDay(pWeekDayData)) {
      Get.toNamed(AppRoutes.restDay, arguments: [homePlanTable, pWeekDayData])!
          .then((value) {
        refreshData();
      });
    } else {
      Get.toNamed(AppRoutes.exerciseList,
              arguments: [homePlanTable, null, pWeekDayData])!
          .then((value) {
        refreshData();
      });
    }
  }
}
