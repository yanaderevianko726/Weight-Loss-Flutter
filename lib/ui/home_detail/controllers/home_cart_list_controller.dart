import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:women_lose_weight_flutter/ui/home_detail/controllers/home_diet_controller.dart';
import 'package:women_lose_weight_flutter/ui/home_detail/controllers/home_diet_detail_dashboard_controller.dart';
import 'package:women_lose_weight_flutter/ui/report/controllers/report_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constant.dart';
import '../../../utils/preference.dart';
import 'home_diet_detail_controller.dart';

class HomeCartListController extends GetxController {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  bool lastStatus = true;

  List<CartClass> cartsList = [];
  bool isLoading = true;
  String myId = '';

  final ReportController _reportController = Get.find<ReportController>();

  @override
  void onInit() {
    _getDietDetailsData();
    super.onInit();
  }

  _getDietDetailsData() async {
    myId = Preference.shared.getString(Preference.firebaseAuthUid)!;
    cartsList = [];
    isLoading = true;
    update([Constant.idCartsList]);

    if(myId != ''){      
      final snapshot = await dbRef.child('carts').orderByChild('day').get();
      if (snapshot.exists) {
        for (final child in snapshot.children) {
          Map<String, dynamic> map = Map<String, dynamic>.from(child.value as Map); 
          if(map['dietId'] == myId){
            CartClass cart = CartClass();
            cart.fromMap(map);
            cartsList.add(cart);
          }
        }
        isLoading = false;      
      } else {
        isLoading = false;
      }    
      update([Constant.idCartsList]);
    }
  }

  refreshCarts(){
    _getDietDetailsData();
  }

  onCartItemClick(String _detailId) {
    List<DietDetail> details = Get.find<HomeDietDetailController>().getDietDetails().cast<DietDetail>();
    DietDetail dietDetail = DietDetail();
    DietPlan dietPlan = DietPlan();
    for (var element in details) {
      if(element.detailId == _detailId){
        dietDetail = element;
      }
    }
    if(dietDetail.dietId != ''){
      List<DietPlan> diets = Get.find<HomeDietController>().getDietPlans().cast<DietPlan>();
      for (var diet in diets) {
        if(diet.dietId == dietDetail.dietId){
          dietPlan = diet;
        }
      }
    }
    if(dietDetail.detailId != '' && dietPlan.dietId != ''){
      Get.toNamed(AppRoutes.dietDetailDashboard, arguments: [dietPlan, dietDetail])!.then((value) => refreshData());
    }    
  }

  refreshData() {
    _reportController.refreshData();
  }
}

class DietDetail {
  String detailId;
  String dietId;
  String detailTitle;
  String detailDesc;
  String detailImage;
  String day;
  String calories;

  DietDetail({
    this.detailId = '',
    this.dietId = '',
    this.detailTitle = '',
    this.detailDesc = '',
    this.detailImage = '',
    this.day = '',
    this.calories = '0',
  });

  fromMap(Map<String, dynamic> map){
    if (kDebugMode) {
        print('$map');
      }
      detailId = map['detailId'];
      dietId = map['dietId'] ?? '';
      detailTitle = map['detailTitle'] ?? '';
      detailDesc = map['detailDesc'] ?? '';
      detailImage = map['detailImage'] ?? '';
      day = map['day'] ?? '';
      calories = '${map['calories']}';
  }
}
