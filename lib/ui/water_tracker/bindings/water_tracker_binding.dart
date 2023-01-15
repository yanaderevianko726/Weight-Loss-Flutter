import 'package:get/get.dart';

import '../controllers/water_tracker_controller.dart';

class WaterTrackerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WaterTrackerController>(
      () => WaterTrackerController(),
    );
  }
}
