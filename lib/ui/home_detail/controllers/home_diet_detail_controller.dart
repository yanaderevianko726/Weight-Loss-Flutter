import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/routes/app_routes.dart';
import 'package:women_lose_weight_flutter/ui/home_detail/controllers/home_diet_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:women_lose_weight_flutter/ui/report/controllers/report_controller.dart';
import '../../../common/dialog/diet/add_diet_detail_dialog.dart';
import '../../../utils/constant.dart';

class HomeDietDetailController extends GetxController {
  ScrollController? scrollController;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  List<DietDetail> dietDetailsList = [];
  bool isLoading = true;

  dynamic arguments = Get.arguments;
  DietPlan? dietPlan;

  final ReportController _reportController = Get.find<ReportController>();

  @override
  void onInit() {
    _getArguments();
    _getDietDetailsData();
    super.onInit();
  }

  _getArguments() {
    if (arguments != null) {
      if (arguments[0] != null) {
        dietPlan = arguments[0];
        if (kDebugMode) {
          print('dietId: ${dietPlan!.dietId}');
        }
      }
    }
  }

  _getDietDetailsData() async {
    dietDetailsList = [];
    isLoading = true;
    update([Constant.idDietDetailsList]);
    
    final snapshot = await dbRef.child('dietdetails').orderByChild('day').get();
    if (snapshot.exists) {
      for (final child in snapshot.children) {
        Map<String, dynamic> map = Map<String, dynamic>.from(child.value as Map); 
        if(map['dietId'] == dietPlan!.dietId){
          DietDetail dietDetail = DietDetail();
          dietDetail.fromMap(map);
          dietDetailsList.add(dietDetail);
        }
      }
      isLoading = false;      
    } else {
      if (kDebugMode) {
        print('No data available.');
      }
      isLoading = false;
    }    
    update([Constant.idDietDetailsList]);
  }

  onDietItemClick(DietDetail dietPlan) {
    Get.toNamed(AppRoutes.dietDetail, arguments: [dietPlan])!.then((value) => refreshData());
  }

  onCLickAddDetail() {
    Get.toNamed(AppRoutes.dietDetail, arguments: [dietPlan])!.then((value) => refreshData());
  }

  refreshData() {
    _reportController.refreshData();
  }

  onAddNewCalory() {
    showDialog(
      context: Get.context!,
      builder: (context) => AddDietDetailDialog(dietPlan: dietPlan!,),
    ).then((value) {
      _getDietDetailsData();
    });
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
      dietId = map['detailTitle'] ?? '';
      dietId = map['detailDesc'] ?? '';
      dietId = map['detailImage'] ?? '';
      day = map['day'] ?? '';
      calories = '${map['calories']}';
  }
}
