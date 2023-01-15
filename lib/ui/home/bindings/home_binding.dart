import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/ui/report/controllers/report_controller.dart';

import '../../me/controllers/me_controller.dart';
import '../../plan/controllers/plan_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );

    Get.lazyPut<PlanController>(
      () => PlanController(),
    );

    Get.lazyPut<ReportController>(
          () => ReportController(),
    );

    Get.lazyPut<MeController>(
      () => MeController(),
    );
  }
}
