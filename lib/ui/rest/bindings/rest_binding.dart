import 'package:get/get.dart';

import '../controllers/rest_controller.dart';

class RestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RestController>(
      () => RestController(),
    );
  }
}
