import 'package:get/get.dart';

import '../controllers/choose_your_plan_controller.dart';

class ChooseYourPlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChooseYourPlanController>(
      () => ChooseYourPlanController(),
    );
  }
}
