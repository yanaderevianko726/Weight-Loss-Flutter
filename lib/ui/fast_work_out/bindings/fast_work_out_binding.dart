import 'package:get/get.dart';

import '../controllers/fast_work_out_controller.dart';

class FastWorkOutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FastWorkOutController>(
      () => FastWorkOutController(),
    );
  }
}
