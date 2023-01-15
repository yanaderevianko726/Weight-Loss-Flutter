import 'package:get/get.dart';

import '../controllers/well_done_controller.dart';

class WellDoneBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WellDoneController>(
      () => WellDoneController(),
    );
  }
}
