import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/DayModel.dart';
import '../../util/service_provider.dart';

class DietDayListController extends GetxController {

  DayModel? dietDayList;
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    isLoading = false;
  }


  loadDietDayList(BuildContext context,String catId) async {
    isLoading = true;
    DayModel? day = await getDietDayList(context,catId);
    if (day != null) {
      dietDayList = day;
      isLoading = false;
    }
    else {
      isLoading = false;
    }
    update();
  }
}