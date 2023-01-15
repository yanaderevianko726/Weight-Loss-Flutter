import 'package:date_format/date_format.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/ui/exercise_list/controllers/exercise_list_controller.dart';
import 'package:women_lose_weight_flutter/ui/fast_work_out_detail/controllers/fast_work_out_detail_controller.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';

import '../../../database/custom_classes/custom_classes.dart';
import '../../../database/table/history_table.dart';
import '../../../database/table/home_plan_table.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/utils.dart';

class HistoryController extends GetxController {
  bool isFromReport = false;
  dynamic arguments = Get.arguments;
  List calendarDates = [];

  DateTime currentDate = DateTime.now();

  List<HistoryTable> historyDataList = [];
  List<HistoryWeekData> historyWeekDataList = [];

  List<DateTime> dates = [];

  getDataFromDatabase() async {
    historyDataList = await DBHelper.dbHelper.getHistoryData();

    for (var element in historyDataList) {
      dates.add(DateTime.parse(element.hDateTime!));
    }

    historyWeekDataList = await DBHelper.dbHelper.getHistoryWeekData();

    for (var element in historyWeekDataList) {
      for (var element1 in element.arrHistoryDetail!) {
        calendarDates.add(DateTime.parse(
            DateTime.parse(element1.hDateTime!.split(" ")[0]).toString() +
                "Z"));
      }
    }

    update([Constant.idHistoryList, Constant.idCalender]);
  }

  DateFormat dateFormat = DateFormat();

  convertStringFromDate(String date) {
    final todayDate = DateTime.parse(date);
    return formatDate(todayDate, [MM.substring(1), ' ', dd]);
  }

  convertStringFromDateWithTime(String date) {
    final todayDate = DateTime.parse(date);
    return formatDate(
        todayDate, [MM.substring(1), ' ', dd, ', ', hh, ':', nn, ' ', am]);
  }

  getExName(HistoryTable arrHistoryDetail) {
    if (arrHistoryDetail.planDetail!.planDays == Constant.planDaysYes) {
      return (Utils.getMultiLanguageString(arrHistoryDetail.hPlanName!) +
              " - " +
              "txtDay".tr +
              " " +
              arrHistoryDetail.hDayName!.replaceAll(RegExp(r'^0+(?=.)'), ''))
          .toUpperCase();
    } else {
      return Utils.getMultiLanguageString(arrHistoryDetail.hPlanName!)
          .toUpperCase();
    }
  }

  @override
  void onInit() {
    if(arguments != null){
      isFromReport = arguments;
    }
    getDataFromDatabase();
    super.onInit();
  }

  HomePlanTable? homePlanTable;

  onCompletedExItemClick(int index, HistoryTable arrHistoryDetail) async {
    homePlanTable = await DBHelper.dbHelper
        .getPlanByPlanId(int.parse(arrHistoryDetail.hPlanId.toString()));

    if (arrHistoryDetail.planDetail!.hasSubPlan!) {
      Get.lazyReplace(() => FastWorkOutDetailController());
      Get.toNamed(AppRoutes.fastWorkOutDetail);
    } else if (arrHistoryDetail.planDetail!.planDays == Constant.planDaysYes) {
      if (isFromReport) {
        Get.toNamed(AppRoutes.daysPlanDetail);
      } else {
        Get.back();
        Get.back();
      }
    } else {
      Get.lazyReplace(() => ExerciseListController());
      Get.toNamed(AppRoutes.exerciseList,
          arguments: [homePlanTable, null, null]);
    }
  }
}
