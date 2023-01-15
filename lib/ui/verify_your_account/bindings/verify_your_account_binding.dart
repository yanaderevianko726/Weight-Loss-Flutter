import 'package:get/get.dart';

import '../controllers/verify_your_account_controller.dart';

class VerifyYourAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyYourAccountController>(
      () => VerifyYourAccountController(),
    );
  }
}
