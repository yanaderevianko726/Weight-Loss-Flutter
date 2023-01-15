import 'package:get/get.dart';
import '../controllers/home_exercise_controller.dart';

class HomePlanDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeExerciseController>(
      () => HomeExerciseController(),
    );
  }
}
