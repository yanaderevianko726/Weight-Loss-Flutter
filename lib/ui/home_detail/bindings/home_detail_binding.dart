import 'package:get/get.dart';

import '../controllers/home_detail_controller.dart';

class HomeDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeDetailController>(
      () => HomeDetailController(),
    );
  }
}
