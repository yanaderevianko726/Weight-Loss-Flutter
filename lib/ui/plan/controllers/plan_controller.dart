import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/database/table/history_table.dart';
import 'package:women_lose_weight_flutter/ui/report/controllers/report_controller.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/preference.dart';

import '../../../database/table/home_plan_table.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/utils.dart';

class PlanController extends GetxController {
  List<HomePlanTable> homePlansList = [];
  int currentPlanIndex = 0;

  List? dayProgressData;
  double pbDay = 0.0;
  String txtDayLeft = "0";
  String btnDays = " 0";

  List<HistoryTable> recentHistoryList = [];
  List<HomePlanTable> homePlanTableList = [];

  final ReportController _reportController = Get.find<ReportController>();

  @override
  void onInit() {
    _fillMainGoalData();
    _getHomePlansData();
    super.onInit();
  }

  _fillMainGoalData() async {
    currentPlanIndex =
        Preference.shared.getInt(Preference.selectedPlanIndex) ?? 0;

    dayProgressData = await Utils.setDayProgressData();

    if (dayProgressData != []) {
      txtDayLeft = dayProgressData![1];
      pbDay = dayProgressData![3];
      btnDays = dayProgressData![4];
    }
    update([Constant.idYourPlanProgressDetails]);
  }

  _getHomePlansData() async {
    homePlansList =
        await DBHelper.dbHelper.getHomePlanList(Constant.planTypeHomePlans);
    update([Constant.idHomePlansList]);
  }

  onDietItemClick(HomePlanTable bodyFocusItem) {
    Get.toNamed(AppRoutes.dietsPage, arguments: [bodyFocusItem])!.then((value) => refreshData());
  }

  onExerciseItemClick(HomePlanTable homePlanItem) {
    Get.toNamed(AppRoutes.exercisesPage, arguments: [homePlanItem])!.then((value) => refreshData());
  }

  onBodyFocusItemClick(HomePlanTable bodyFocusItem) {
    Get.toNamed(AppRoutes.homeDetail, arguments: [bodyFocusItem])!.then((value) => refreshData());
  }

  refreshData() {
    _fillMainGoalData();
    _reportController.refreshData();
  }

  HomePlanTable? homePlanTable;
  onRecentItemClick() async{
    homePlanTable = await DBHelper.dbHelper
        .getPlanByPlanId(int.parse(recentHistoryList[0].hPlanId.toString()));

    if (recentHistoryList[0].planDetail!.hasSubPlan!) {
      Get.toNamed(AppRoutes.fastWorkOutDetail)!.then((value) => refreshData());
    } else if (recentHistoryList[0].planDetail!.planDays == Constant.planDaysYes) {
      Get.toNamed(AppRoutes.daysPlanDetail)!.then((value) => refreshData());
    } else {
      Get.toNamed(AppRoutes.exerciseList, arguments: [homePlanTable, null, null])!.then((value) => refreshData());
    }
  }

  getRecentItemTime() async {
    int compDay = await DBHelper.dbHelper.getCompleteDayCountByPlanId(
        recentHistoryList[0].planDetail!.planId!.toString());
    if (recentHistoryList[0].planDetail!.planDays == Constant.planDaysYes) {
      return (recentHistoryList[0].planDetail!.days! - compDay).toString() +
          " " + "txtDaysLeft".tr;
    } else {
      return recentHistoryList[0].planDetail!.planMinutes! + " " +
          "txtMins".tr;
    }
  }
}