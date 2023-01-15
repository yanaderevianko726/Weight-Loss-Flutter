import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/database/table/history_table.dart';
import 'package:women_lose_weight_flutter/routes/app_routes.dart';
import 'package:women_lose_weight_flutter/ui/report/controllers/report_controller.dart';
import 'package:women_lose_weight_flutter/utils/preference.dart';
import 'package:women_lose_weight_flutter/utils/utils.dart';

import '../../../database/table/home_plan_table.dart';
import '../../../utils/constant.dart';

class HomeExerciseController extends GetxController {
  List<HomePlanTable> homeSubPlanList = [];
  dynamic arguments = Get.arguments;
  HomePlanTable? homePlanSubItem;

  int currentPlanIndex = 0;

  List? dayProgressData;
  String txtDayLeft = "0";
  double pbDay = 0.0;
  String btnDays = " 0";

  List<HistoryTable> recentHistoryList = [];
  List<HomePlanTable> homePlanTableList = [];

  final ReportController _reportController = Get.find<ReportController>();

  @override
  void onInit() {
    _getArguments();
    _fillMainGoalData();
    _getHomePlansData();
    getRecentHistoryData();
    super.onInit();
  }

  _getArguments() {
    if (arguments != null) {
      if (arguments[0] != null) {
        homePlanSubItem = arguments[0];
      }
    }
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
    homeSubPlanList =
        await DBHelper.dbHelper.getHomeSubPlanList(homePlanSubItem!.planId.toString());
    update([Constant.idBodyFocusList]);
  }

  onBodyFocusItemClick(HomePlanTable bodyFocusItem) {
    Get.toNamed(AppRoutes.homeDetail, arguments: [bodyFocusItem])!.then((value) => refreshData());
  }

  getRecentHistoryData() async{
    recentHistoryList.clear();
    recentHistoryList = await DBHelper.dbHelper.getRecentHistoryData();
    update([Constant.idPlanRecentHistory]);
  }

  refreshData() {
    _fillMainGoalData();
    getRecentHistoryData();
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
