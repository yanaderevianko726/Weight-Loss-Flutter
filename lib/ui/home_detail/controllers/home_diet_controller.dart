import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/routes/app_routes.dart';
import 'package:women_lose_weight_flutter/ui/home_detail/controllers/home_diet_detail_dashboard_controller.dart';
import 'package:women_lose_weight_flutter/ui/report/controllers/report_controller.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../../database/table/home_plan_table.dart';
import '../../../utils/constant.dart';
import '../../../utils/preference.dart';

class HomeDietController extends GetxController {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  List<DietPlan> dietList = [];
  List<CartClass> carrtsList = [];
  bool isLoading = true;

  dynamic arguments = Get.arguments;
  HomePlanTable? homePlanItem;

  final ReportController _reportController = Get.find<ReportController>();

  @override
  void onInit() {
    _getArguments();
    _getDietsData();
    _getCartsData();
    super.onInit();
  }

  _getArguments() {
    if (arguments != null) {
      if (arguments[0] != null) {
        homePlanItem = arguments[0];
      }
    }
  }

  _getDietsData() async {
    dietList = [];
    isLoading = true;
    update([Constant.idDietPlanList]);
    
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
      if (kDebugMode) {
        print('No data available.');
      }
      isLoading = false;
    }    
    update([Constant.idDietPlanList]);
  }

  _getCartsData() async {
    final myId = Preference.shared.getString(Preference.firebaseAuthUid);   
    if(myId != null && myId != ''){
      final snapshot = await dbRef.child('carts').orderByChild('day').get();
      if (snapshot.exists) {
        for (final child in snapshot.children) {
          Map<String, dynamic> map = Map<String, dynamic>.from(child.value as Map);
          if(myId  == map['userId']){
            CartClass cart = CartClass();
            cart.fromMap(map);
            carrtsList.add(cart);
          }
        }
      }   
      update([Constant.idCartsList]);
    } 
  }

  onDietItemClick(DietPlan dietPlan) {
    Get.toNamed(AppRoutes.dietDetail, arguments: [dietPlan])!.then((value) => refreshData());
  }

  refreshData() {
    _reportController.refreshData();
  }
}

class DietPlan {
  String dietId;
  String dietTitle;
  String dietImage;
  String dietDescription;
  String dietCategory;
  String dietCalories;

  DietPlan({
    this.dietId = '',
    this.dietTitle = '',
    this.dietImage = '',
    this.dietDescription = '',
    this.dietCategory = '',
    this.dietCalories = '',
  });

  fromMap(Map<String, dynamic> map){
      dietId = map['dietId'];
      dietTitle = map['dietTitle'] ?? '';
      dietImage = map['dietImage'] ?? '';
      dietDescription = map['dietDescription'] ?? '';
      dietCategory = map['dietCategory'] ?? '';
      dietCalories = map['dietCalories'] ?? '';
  }
}
