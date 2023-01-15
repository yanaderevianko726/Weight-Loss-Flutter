import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
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
      if (kDebugMode) {
        print('No data available.');
      }
      isLoading = false;
    }    
    update([Constant.idDietAdjustList]);
  }

  onDietItemClick(DietPlan dietPlan) {
    Get.toNamed(AppRoutes.dietDetail, arguments: [dietPlan])!.then((value) => refreshData());
  }

  onCreateDietPlanPage() {
    Get.toNamed(AppRoutes.dietCreatePage)!.then((value) => refreshData());
  }

  createDietPlan(DietPlan plan) async {
    String? key = dbRef.child('diets').push().key;
    plan.dietId = key!;

    await dbRef.child('diets').child(key).set(<String, String>{
      "dietId": plan.dietId,
      "dietTitle": plan.dietTitle,
      "dietImage": plan.dietImage,
      "dietDescription": plan.dietDescription,
      "dietCategory": plan.dietCategory,
      "dietCalories": plan.dietCalories,
    });
    dietList.add(plan);
    update([Constant.idDietAdjustList]);

    isLoading = false;
    update([Constant.idDietAdjustCreate]);
    Get.back();
  }

  Future<String?> uploadImage(String fileUri, String uploadPath) async {
    isLoading = true;
    update([Constant.idDietAdjustCreate]);

    File file = File(fileUri);
    final fname = fileUri.split('/');
    
    final storageRef = FirebaseStorage.instance.ref().child(uploadPath);
    final mountainsRef = storageRef.child(fname.last);
    try {
      await mountainsRef.putFile(file);
      return await mountainsRef.getDownloadURL();
    } on FirebaseException {      
      isLoading = false;
      update([Constant.idDietAdjustCreate]);
      return null;
    } catch (e) {    
      isLoading = false;
      update([Constant.idDietAdjustCreate]);
      return null;
    }
  }

  refreshData() {
    _reportController.refreshData();
  }
}
