import 'package:get/get.dart';

import '../controllers/recent_controller.dart';

class RecentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecentController>(
      () => RecentController(),
    );
  }
}
