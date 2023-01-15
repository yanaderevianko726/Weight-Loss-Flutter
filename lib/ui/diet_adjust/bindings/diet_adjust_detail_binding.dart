import 'package:get/get.dart';
import '../controllers/diet_adjust_detail_controller.dart';

class DietAdjustDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DietAdjustDetailController>(
      () => DietAdjustDetailController(),
    );
  }
}
