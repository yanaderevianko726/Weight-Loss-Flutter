import 'package:get/get.dart';

import '../controllers/common_questions_controller.dart';

class CommonQuestionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommonQuestionsController>(
      () => CommonQuestionsController(),
    );
  }
}
