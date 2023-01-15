import 'package:get/get.dart';

import '../controllers/choose_target_weight_controller.dart';

class ChooseTargetWeightBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChooseTargetWeightController>(
          () => ChooseTargetWeightController(),
    );
  }
}
