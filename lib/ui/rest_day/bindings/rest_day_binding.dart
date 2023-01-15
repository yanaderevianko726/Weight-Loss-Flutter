import 'package:get/get.dart';

import '../controllers/rest_day_controller.dart';

class RestDayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestDayController>(
      () => RestDayController(),
    );
  }
}
