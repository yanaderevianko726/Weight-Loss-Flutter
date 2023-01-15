import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';

import '../../../database/table/home_plan_table.dart';
import '../../../utils/constant.dart';

class HomeDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  ScrollController? scrollController;
  bool lastStatus = true;

  dynamic arguments = Get.arguments;

  HomePlanTable? bodyFocusItem;
  List<HomePlanTable> bodyFocusSubPlanList = [];
  double offset = 0.0;

  @override
  void onInit() {
    scrollController = ScrollController();
    scrollController!.addListener(() {
      offset =  scrollController!.offset;
      _scrollListener();
    });
    _getArguments();
    _getSubBodyFocusData();
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
      update([Constant.idHomeDetailSliverAppBar]);
    }
  }

  _getArguments() {
    if (arguments != null) {
      if (arguments[0] != null) {
        bodyFocusItem = arguments[0];
      }
    }
  }

  _getSubBodyFocusData() async {
    bodyFocusSubPlanList = await DBHelper.dbHelper
        .getBodyFocusSubPlanList(bodyFocusItem!.planId.toString());
    update([Constant.idBodyFocusSubList]);
  }
}
