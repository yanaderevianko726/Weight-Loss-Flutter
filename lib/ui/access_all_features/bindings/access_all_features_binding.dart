import 'package:get/get.dart';

import '../controllers/access_all_features_controller.dart';

class AccessAllFeaturesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AccessAllFeaturesController>(
      () => AccessAllFeaturesController(),
    );
  }
}
