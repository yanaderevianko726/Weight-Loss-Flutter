import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../database/helper/db_helper.dart';
import '../../../database/table/home_plan_table.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constant.dart';

class FastWorkOutController extends GetxController
    with GetSingleTickerProviderStateMixin {
  ScrollController? scrollController;
  bool lastStatus = true;

  List<HomePlanTable> randomWorkoutList = [];
  List<HomePlanTable> trainingGoalList = [];
  double offset = 0.0;

  @override
  void onInit() {
    scrollController = ScrollController();
    scrollController!.addListener(() {
      offset = scrollController!.offset;
      _scrollListener();
    });
    _getRandomWorkoutAndTrainingGoalData();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController!.removeListener(_scrollListener);
    super.onClose();
  }

  bool get isShrink {
    return scrollController!.hasClients &&
        offset > (100 - kToolbarHeight);
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      lastStatus = isShrink;
      update([Constant.idFastWorkOutSliverAppBar]);
    }
  }

  _getRandomWorkoutAndTrainingGoalData() async {
    randomWorkoutList = await DBHelper.dbHelper
        .getHomePlanList(Constant.planTypeFastWorkoutRandom);
    trainingGoalList = await DBHelper.dbHelper
        .getHomePlanList(Constant.planTypeFastWorkoutTrainingGoal);
    update([Constant.idRandomWorkoutList, Constant.idTrainingGoalList]);
  }

  onRandomWorkoutItemClick(HomePlanTable randomWorkoutItem) {
    Get.toNamed(AppRoutes.fastWorkOutDetail, arguments: [randomWorkoutItem]);
  }

  onTrainingGoalItemClick(HomePlanTable trainingGoalItem) {
    Get.toNamed(AppRoutes.fastWorkOutDetail, arguments: [trainingGoalItem]);
  }

  onFatBurningHIITClick() async {
    List<HomePlanTable> fatBurningHIITItem = await DBHelper.dbHelper.getHomePlanList(Constant.planTypeFastWorkoutFatBurning);
    Get.toNamed(AppRoutes.fastWorkOutDetail, arguments: [fatBurningHIITItem[0]]);
  }
}
