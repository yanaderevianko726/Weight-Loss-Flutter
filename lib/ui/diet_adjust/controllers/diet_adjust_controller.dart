import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/routes/app_routes.dart';
import 'package:women_lose_weight_flutter/ui/report/controllers/report_controller.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../utils/constant.dart';
import '../../home_detail/controllers/home_diet_controller.dart';

class DietAdjustController extends GetxController {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  List<DietPlan> dietList = [];
  bool isLoading = true;

  final ReportController _reportController = Get.find<ReportController>();

  @override
  void onInit() {
    _getDietsData();
    super.onInit();
  }

  _getDietsData() async {
    dietList = [];
    isLoading = true;
    update([Constant.idDietAdjustList]);
    
    final snapshot = await dbRef.child('diets').orderByChild('dietId').get();
    if (snapshot.exists) {
      for (final child in snapshot.children) {
        Map<String, dynamic> map = Map<String, dynamic>.from(child.value as Map);
        DietPlan dietPlan = DietPlan();
        dietPlan.fromMap(map);
        dietList.add(dietPlan);
      }
      isLoading = false;
    } else {
      isLoading = false;
    }    
    update([Constant.idDietAdjustList]);
  }

  onDietItemClick(DietPlan dietPlan) {
    Get.toNamed(AppRoutes.dietAdjustDetail, arguments: [dietPlan])!.then((value) => refreshData());
  }

  refreshData() {
    _reportController.refreshData();
  }
}
