import 'package:get/get.dart';

import '../controllers/voice_options_controller.dart';


class VoiceOptionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoiceOptionsController>(
      () => VoiceOptionsController(),
    );
  }
}
