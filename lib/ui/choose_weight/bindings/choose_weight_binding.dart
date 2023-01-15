import 'package:get/get.dart';

import '../controllers/choose_weight_controller.dart';

class ChooseWeightBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChooseWeightController>(
          () => ChooseWeightController(),
    );
  }
}
