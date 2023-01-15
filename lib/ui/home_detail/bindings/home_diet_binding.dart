import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/ui/home_detail/controllers/home_diet_controller.dart';

class HomeDietsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeDietController>(
      () => HomeDietController(),
    );
  }
}
