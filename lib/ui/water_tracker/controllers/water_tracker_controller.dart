import 'dart:async';

import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/routes/app_routes.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';

import '../../../utils/sizer_utils.dart';

class WaterTrackerController extends GetxController with GetTickerProviderStateMixin{
 dynamic args = Get.arguments;
  bool animate = false;
  int? currentGlass;
  int? percentCounter;
  Timer? timerValue;
  double? viewCenter;
  Timer? timer;

  @override
  void onClose() {
    timer!.cancel();
    timerValue!.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    _getDataFromArgs();
    _increasePercentage();
    _navigateToWellDone();
    super.onInit();
  }

  _getDataFromArgs() {
    currentGlass = args[0];
  }

  _increasePercentage() {
    percentCounter = (currentGlass! * 100)~/8;
    if (currentGlass! < 7) {
      viewCenter = (AppSizes.fullHeight*(currentGlass!))/8;
    } else {
      viewCenter = (AppSizes.fullHeight*7)/8;
    }
    timerValue = Timer.periodic(const Duration(milliseconds: 75), (timer) {
      if(percentCounter! < ((currentGlass!+1) * 100)~/8) {
        percentCounter = percentCounter! +1;
        update([Constant.idWaterTrackerPercent]);
      }
      if (currentGlass! < 7) {
        if(viewCenter! < (AppSizes.fullHeight*(currentGlass!+1))/8) {
          viewCenter = viewCenter! + 6;
          update([Constant.idWaterTrackerAnim]);
        }
      } else {
        if(viewCenter! < AppSizes.fullHeight) {
          viewCenter = viewCenter! + 6;
          update([Constant.idWaterTrackerAnim]);
        }
      }

    });

  }

  _navigateToWellDone() {
    timer = Timer(const Duration(seconds: 2), () {
      Get.back();
      Get.toNamed(AppRoutes.wellDoneDone);
    });
  }

}
