import 'package:get/get.dart';
import '../controllers/home_cart_list_controller.dart';

class HomeCartListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeCartListController>(
      () => HomeCartListController(),
    );
  }
}
