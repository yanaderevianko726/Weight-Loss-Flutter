import 'package:get/get.dart';

import '../controllers/your_plan_controller.dart';

class YourPlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<YourPlanController>(
          () => YourPlanController(),
    );
  }
}
