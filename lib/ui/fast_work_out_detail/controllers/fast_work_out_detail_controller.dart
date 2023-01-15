import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../database/helper/db_helper.dart';
import '../../../database/table/home_plan_table.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constant.dart';

class FastWorkOutDetailController extends GetxController with GetSingleTickerProviderStateMixin {
  ScrollController? scrollController;
  bool lastStatus = true;

  dynamic arguments = Get.arguments;

  HomePlanTable? fastWorkoutItem;
  List<HomePlanTable> fastWorkoutSubPlanList = [];
  double offset = 0.0;

  @override
  void onInit() {
    scrollController = ScrollController();
    scrollController!.addListener(() {
      offset = scrollController!.offset;
      _scrollListener();
    });
    _getArguments();
    _getSubFastWorkoutData();
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
      update([Constant.idFastWorkOutDetailSliverAppBar]);
    }
  }

  _getArguments() {
    if (arguments != null) {
      if (arguments[0] != null) {
        fastWorkoutItem = arguments[0];
      }
    }
  }

  _getSubFastWorkoutData() async {
    fastWorkoutSubPlanList = await DBHelper.dbHelper
        .getHomeSubPlanList(fastWorkoutItem!.planId.toString());
    update([Constant.idSubFastWorkoutList]);
  }

  onItemFastWorkOutDetailsExerciseClick(HomePlanTable fastWorkoutSubPlanList) {
    Get.toNamed(AppRoutes.exerciseList, arguments: [fastWorkoutSubPlanList, Constant.fromFastWorkout, null]);
  }
}
