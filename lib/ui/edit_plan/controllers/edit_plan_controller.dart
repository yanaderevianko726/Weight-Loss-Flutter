import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/common/bottomsheet/bottom_sheet_ex_detail.dart';
import 'package:women_lose_weight_flutter/common/bottomsheet/bottom_sheet_replace_ex.dart';
import 'package:women_lose_weight_flutter/database/custom_classes/custom_classes.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/database/table/exercise_table.dart';
import 'package:women_lose_weight_flutter/database/table/home_plan_table.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/debug.dart';

class EditPlanController extends GetxController with GetSingleTickerProviderStateMixin, GetTickerProviderStateMixin {
dynamic args = Get.arguments;

  List<Animation<int>> listOfAnimation = [];
  List<AnimationController> listOfAnimationController = [];
  List<HomeExTableClass> exerciseList = [];
  List<HomeExTableClass> exerciseListOriginal = [];
  List<int> listOfImagesCount = [];
  List<ExerciseTable> listOfExercise = [];
  HomePlanTable? workoutPlanData;
  List<HomeExTableClass> deleted = [];


  @override
  void onInit() {
    _getArgumentData();
    _getAllExerciseDatabase();
    _animationImages();
    super.onInit();
  }

  void _getArgumentData() {
    exerciseList = args[0];
    workoutPlanData = args[1];
    exerciseListOriginal = args[2];
  }

  @override
  void onClose() {
    for (int i = 0; i < listOfAnimationController.length; i++) {
      listOfAnimationController[i].stop();
      listOfAnimationController[i].dispose();
    }
    Future.delayed(const Duration(milliseconds: 200),(){
      super.onClose();
    });
  }

  @override
  void dispose() {
    for (int i = 0; i < listOfAnimationController.length; i++) {
      listOfAnimationController[i].stop();
      listOfAnimationController[i].dispose();
    }
    Future.delayed(const Duration(milliseconds: 200),(){
      super.dispose();
    });

  }

  _animationImages() async{
    for (int i = 0; i < exerciseList.length; i++) {
      await _getImageFromAssets(i);
      int duration = 0;
      if (listOfImagesCount[i] > 2 && listOfImagesCount[i] <= 4) {
        duration = 3000;
      } else if (listOfImagesCount[i] > 4 && listOfImagesCount[i] <= 6) {
        duration = 4500;
      } else if (listOfImagesCount[i] > 6 && listOfImagesCount[i] <= 8) {
        duration = 6000;
      } else if (listOfImagesCount[i] > 8 && listOfImagesCount[i] <= 10) {
        duration = 7500;
      } else if (listOfImagesCount[i] > 10 && listOfImagesCount[i] <= 12) {
        duration = 9000;
      } else if (listOfImagesCount[i] > 12 && listOfImagesCount[i] <= 14) {
        duration = 10500;
      } else {
        duration = 1500;
      }

      listOfAnimationController.add(AnimationController(
          vsync: this, duration: Duration(milliseconds: duration))
        ..repeat());

      listOfAnimation.add(IntTween(begin: 1, end: listOfImagesCount[i])
          .animate(listOfAnimationController[i]));
    }
    update([Constant.idEditPlanExerciseList]);
  }

  _getImageFromAssets(int index) async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) =>
        key.contains(exerciseList[index].exPath.toString() + "/"))
        .where((String key) => key.contains('.webp'))
        .toList();

    listOfImagesCount.add(imagePaths.length);
  }

  onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final HomeExTableClass item =
    exerciseList
        .removeAt(oldIndex);
    exerciseList
        .insert(newIndex, item);

    var count =
    listOfImagesCount.removeAt(oldIndex);
    listOfImagesCount.insert(newIndex, count);

    var anim = listOfAnimation
        .removeAt(oldIndex);
    listOfAnimation.insert(
        newIndex, anim);

    var animController = listOfAnimationController
        .removeAt(oldIndex);
    listOfAnimationController.insert(
        newIndex, animController);
    update([Constant.idEditPlanExerciseList]);
  }

  onExerciseItemClick(int index) {
    Get.bottomSheet(
      BottomSheetExDetails(
        exerciseList: exerciseList,
        listOfAnimation: listOfAnimation,
        listOfAnimationController: listOfAnimationController,
        index: index,
        isFromEdit: Constant.boolValueTrue,
        isFromReplace: Constant.boolValueFalse,
      ),
      backgroundColor: AppColor.white,
      isDismissible: Constant.boolValueTrue,
      isScrollControlled: Constant.boolValueTrue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
    ).then((value) {
      if (value != null) {
        for (int i = 0; i < exerciseList.length; i++) {
           if(exerciseList[i].exTime !=  value[i].toString()) {
             exerciseList[i].updatedExTime = value[i].toString();
           }
           exerciseList[i].exTime = value[i].toString();
        }
      }
      update([Constant.idEditPlanExerciseList]);
    });
  }

  onDeleteExercise(int index) {
    deleted.add(exerciseList[index]);
    exerciseList.removeAt(index);
    update([Constant.idEditPlanExerciseList]);
    listOfAnimationController[index].stop();
    listOfAnimationController[index].dispose();
    listOfImagesCount.removeAt(index);
    listOfAnimationController.removeAt(index);
    listOfAnimation.removeAt(index);
    update([Constant.idEditPlanExerciseList]);
  }

  onReplaceClick(int index) {
    Get.bottomSheet(
      BottomSheetReplaceEx(currentEx: exerciseList[index], index: index,),
      backgroundColor: AppColor.white,
      isDismissible: Constant.boolValueTrue,
      isScrollControlled: Constant.boolValueTrue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
      ),
    ).then((value) {
      if (value != null) {
        exerciseList[index]
            .exName = listOfExercise[
        value.entries.first.value]
            .exName;
        exerciseList[index]
            .exTime = value["duration"][
        value.entries.first.value].toString();
        exerciseList[index]
            .updatedExTime = value["duration"][
        value.entries.first.value].toString();
        exerciseList[index]
            .exPath = listOfExercise[
        value.entries.first.value]
            .exPath;
        exerciseList[index].replaceExId = listOfExercise[
        value.entries.first.value].exId.toString();
        update([Constant.idEditPlanExerciseList]);
      }
    });
  }

  Future onSave() async {
    if (workoutPlanData!.planDays != Constant.planDaysYes) {
      Debug.printLog("Day plan not");
      for(int i =0; i< deleted.length; i++) {
        await DBHelper.dbHelper.deletePlan(deleted[i]);
      }
      for(int i = 0; i<exerciseList.length; i++) {
        exerciseList[i].planSort = i+1;
        await DBHelper.dbHelper.updatePlan(exerciseList[i]);
      }
    } else {
      Debug.printLog("Day plan yes ==> ${deleted.length}");
      for(int i =0; i< deleted.length; i++) {
        await DBHelper.dbHelper.deletePlanDayEx(deleted[i]);
      }
      for(int i = 0; i<exerciseList.length; i++) {
        exerciseList[i].planSort = i+1;
        await DBHelper.dbHelper.updatePlanDayEx(exerciseList[i]);
      }
    }
    Get.back();
  }

  Future onResetClick() async {
    for (var element in exerciseListOriginal) {
      if (workoutPlanData!.planDays != Constant.planDaysYes) {
        await DBHelper.dbHelper.resetPlan(element);
      } else {
        await DBHelper.dbHelper.resetPlanDayEx(element);
      }
    }
  }

  _getAllExerciseDatabase() async{
    listOfExercise = await DBHelper.dbHelper.getAllExerciseList();
  }
}
