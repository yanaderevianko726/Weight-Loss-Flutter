import 'package:get/get.dart';

import '../controllers/perform_exercise_controller.dart';

class PerformExerciseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PerformExerciseController>(
      () => PerformExerciseController(),
    );
  }
}
