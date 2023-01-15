import 'package:get/get.dart';

import '../controllers/choose_height_controller.dart';

class ChooseHeightBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChooseHeightController>(
          () => ChooseHeightController(),
    );
  }
}
