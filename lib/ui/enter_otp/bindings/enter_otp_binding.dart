import 'package:get/get.dart';

import '../controllers/enter_otp_controller.dart';

class EnterOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EnterOtpController>(
      () => EnterOtpController(),
    );
  }
}
