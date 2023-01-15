import 'package:get/get.dart';

import '../controllers/completed_controller.dart';


class CompletedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompletedController>(
      () => CompletedController(),
    );
  }
}
