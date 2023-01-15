import 'package:get/get.dart';

import '../controllers/fast_work_out_detail_controller.dart';

class FastWorkOutDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FastWorkOutDetailController>(
      () => FastWorkOutDetailController(),
    );
  }
}
