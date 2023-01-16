import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/ui/home_detail/controllers/home_diet_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:women_lose_weight_flutter/ui/report/controllers/report_controller.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constant.dart';

class HomeDietDetailController extends GetxController {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  ScrollController? scrollController;
  double offset = 0.0;
  bool lastStatus = true;

  List<DietDetail> dietDetailsList = [];
  bool isLoading = true;

  dynamic arguments = Get.arguments;
  DietPlan? dietPlan;

  final ReportController _reportController = Get.find<ReportController>();

  @override
  void onInit() {
    scrollController = ScrollController();
    scrollController!.addListener(() {
      offset =  scrollController!.offset;
      _scrollListener();
    });
    _getArguments();
    _getDietDetailsData();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController!.removeListener(_scrollListener);
    super.onClose();
  }

  bool get isShrink {
    return scrollController!.hasClients &&
        offset > (100 - kToolbarHeight);
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      lastStatus = isShrink;
      update([Constant.idDietDetailSliverAppBar]);
    }
  }

  _getArguments() {
    if (arguments != null) {
      if (arguments[0] != null) {
        dietPlan = arguments[0];
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
      isLoading = false;
    }    
    update([Constant.idDietDetailsList]);
  }

  onDietDetailClick(DietDetail dietDetail) {
    Get.toNamed(AppRoutes.dietDetailDashboard, arguments: [dietPlan, dietDetail])!.then((value) => refreshData());
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
