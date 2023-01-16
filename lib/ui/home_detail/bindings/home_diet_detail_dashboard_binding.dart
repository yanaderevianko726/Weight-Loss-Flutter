import 'package:get/get.dart';

import '../controllers/home_diet_detail_dashboard_controller.dart';

class HomeDietDetailDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeDietDetailDashboardController>(
      () => HomeDietDetailDashboardController(),
    );
  }
}
