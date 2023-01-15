import 'package:get/get.dart';

import '../controllers/turn_on_water_controller.dart';

class TurnOnWaterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TurnOnWaterController>(
      () => TurnOnWaterController(),
    );
  }
}
