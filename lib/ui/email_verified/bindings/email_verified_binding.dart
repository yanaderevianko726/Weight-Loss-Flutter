import 'package:get/get.dart';

import '../controllers/email_verified_controller.dart';

class EmailVerifiedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailVerifiedController>(
      () => EmailVerifiedController(),
    );
  }
}
