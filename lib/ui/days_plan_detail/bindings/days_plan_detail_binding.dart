import 'package:get/get.dart';

import '../controllers/days_plan_detail_controller.dart';

class DaysPlanDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DaysPlanDetailController>(
      () => DaysPlanDetailController(),
    );
  }
}
