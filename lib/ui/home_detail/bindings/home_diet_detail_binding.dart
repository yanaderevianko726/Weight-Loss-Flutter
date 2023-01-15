import 'package:get/get.dart';
import '../controllers/home_diet_detail_controller.dart';

class HomeDietDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeDietDetailController>(
      () => HomeDietDetailController(),
    );
  }
}
