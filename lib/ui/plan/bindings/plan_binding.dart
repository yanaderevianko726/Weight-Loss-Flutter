import 'package:get/get.dart';

import '../controllers/plan_controller.dart';

class PlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlanController>(
      () => PlanController(),
    );
  }
}
