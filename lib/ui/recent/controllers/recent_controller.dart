import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/database/table/history_table.dart';
import 'package:women_lose_weight_flutter/database/table/home_plan_table.dart';
import 'package:women_lose_weight_flutter/routes/app_routes.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';

class RecentController extends GetxController {

  dynamic args = Get.arguments;
  List<HistoryTable> recentHistoryList = [];
  List<HomePlanTable> homePlanTableList = [];

  @override
  void onInit() {
    recentHistoryList = args[0];
    createRecentList();
    super.onInit();
  }

  HomePlanTable? homePlanTable;

  onRecentItemClick(int index, HistoryTable arrHistoryDetail) async {
    homePlanTable = await DBHelper.dbHelper
        .getPlanByPlanId(int.parse(arrHistoryDetail.hPlanId.toString()));

    if (arrHistoryDetail.planDetail!.hasSubPlan!) {
      Get.toNamed(AppRoutes.fastWorkOutDetail);
    } else if (arrHistoryDetail.planDetail!.planDays == Constant.planDaysYes) {
      Get.toNamed(AppRoutes.daysPlanDetail);
    } else {
      Get.toNamed(
          AppRoutes.exerciseList, arguments: [homePlanTable, null, null]);
    }
  }

  getRecentItemTime(int index) async {
    int compDay = await DBHelper.dbHelper.getCompleteDayCountByPlanId(
        recentHistoryList[index].planDetail!.planId!.toString());
    if (recentHistoryList[index].planDetail!.planDays == Constant.planDaysYes) {
      return (recentHistoryList[index].planDetail!.days! - compDay).toString() +
          " " + "txtDaysLeft".tr;
    } else {
      return recentHistoryList[index].planDetail!.planMinutes! + " " +
          "txtMins".tr;
    }
  }

  final Map<String, HistoryTable> recentMap =  {};

  createRecentList() {
    for (var item in recentHistoryList) {
      recentMap[item.hPlanName!] = item;
    }
    recentHistoryList = recentMap.values.toList();

  }

}
