import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/routes/app_routes.dart';
import 'package:women_lose_weight_flutter/ui/home_detail/controllers/home_diet_detail_controller.dart';
import 'package:women_lose_weight_flutter/ui/report/controllers/report_controller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:date_format/date_format.dart';

import '../../../utils/constant.dart';
import '../../home_detail/controllers/home_diet_controller.dart';

class DietAdjustDetailController extends GetxController {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  ScrollController? scrollController;
  double offset = 0.0;
  bool lastStatus = true;

  List<DietDetail> dietDetailsList = [];
  bool isLoading = true;

  dynamic arguments = Get.arguments;
  DietPlan? planItem;

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
        planItem = arguments[0];
      }
    }
  }

  _getDietDetailsData() async {
    dietDetailsList = [];
    isLoading = true;
    update([Constant.idDietDetailAdjustList]);
    
    final snapshot = await dbRef.child('dietdetails').orderByChild('day').get();
    if (snapshot.exists) {
      for (final child in snapshot.children) {
        Map<String, dynamic> map = Map<String, dynamic>.from(child.value as Map);
        if(map['dietId'] == planItem!.dietId){
          DietDetail dietDetail = DietDetail();
          dietDetail.fromMap(map);
          dietDetailsList.add(dietDetail);
        }
      }
      isLoading = false;
    } else {
      isLoading = false;
    }    
    update([Constant.idDietDetailAdjustList]);
  }

  onDietDetailItemClick(DietDetail dietDetail) {
    
  }

  onCreateDietDetailPage() {
    Get.toNamed(AppRoutes.dietDetailCreatePage)!.then((value) => refreshData());
  }

  createDietDetail(DietDetail detail) async {
    String? key = dbRef.child('dietdetails').push().key;
    detail.detailId = key!;
    detail.day = convertStringFromDateWithTime(DateTime.now());

    await dbRef.child('dietdetails').child(key).set(<String, String>{
      "detailId": detail.detailId,
      "dietId": planItem!.dietId,
      "detailTitle": detail.detailTitle,
      "detailDesc": detail.detailDesc,
      "detailImage": detail.detailImage,
      "day": detail.day,
      "calories": detail.calories,
    });
    dietDetailsList.add(detail);
    update([Constant.idDietDetailAdjustList]);

    Get.back();
  }

  Future<String?> uploadImage(String fileUri, String uploadPath) async {
    isLoading = true;
    update([Constant.idDietDetailAdjustCreate]);

    File file = File(fileUri);
    final fname = fileUri.split('/');
    
    final storageRef = FirebaseStorage.instance.ref().child(uploadPath);
    final mountainsRef = storageRef.child(fname.last);
    try {
      await mountainsRef.putFile(file);
      return await mountainsRef.getDownloadURL();
    } on FirebaseException {      
      isLoading = false;
      update([Constant.idDietDetailAdjustCreate]);
      return null;
    } catch (e) {    
      isLoading = false;
      update([Constant.idDietDetailAdjustCreate]);
      return null;
    }
  }

  refreshData() {
    _reportController.refreshData();
  }

  convertStringFromDateWithTime(DateTime todayDate) {
    return formatDate(
        todayDate, ['yyyy', ', ', MM.substring(1), ' ', dd, ', ', hh, ':', nn, ' ', am]);
  }
}
