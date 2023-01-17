import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/DietCategoryModel.dart';
import '../models/SubDietCategoryModel.dart';
import '../../../util/service_provider.dart';

class CategoryController extends GetxController {

  DietCategoryModel? dietCategory;
  SubDietCategoryModel? subDietCategory;
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    isLoading = false;

  }


  loadDietCategory(BuildContext context) async {
    isLoading = true;
    DietCategoryModel? cat = await getDietCategoryList(context);
    if (cat != null) {
      dietCategory = cat;
      isLoading = false;
    }
    else {
      isLoading = false;
    }
    update();
  }



}


