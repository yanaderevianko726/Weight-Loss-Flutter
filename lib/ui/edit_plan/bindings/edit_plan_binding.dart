import 'package:get/get.dart';

import '../controllers/edit_plan_controller.dart';

class EditPlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditPlanController>(
          () => EditPlanController(),
    );
  }
}
