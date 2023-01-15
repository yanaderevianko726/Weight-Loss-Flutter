import 'package:get/get.dart';
import '../controllers/diet_adjust_controller.dart';

class DietAdjustBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DietAdjustController>(
      () => DietAdjustController(),
    );
  }
}
