import 'package:get/get.dart';

import '../controllers/whats_your_goal_controller.dart';

class WhatsYourGoalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WhatsYourGoalController>(
      () => WhatsYourGoalController(),
    );
  }
}
