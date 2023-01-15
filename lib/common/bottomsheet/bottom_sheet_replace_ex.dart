import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/custom_classes/custom_classes.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/database/table/exercise_table.dart';
import 'package:women_lose_weight_flutter/ui/edit_plan/controllers/edit_plan_controller.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

import '../../utils/color.dart';
import '../../utils/constant.dart';
import '../../utils/utils.dart';
import 'bottom_sheet_ex_detail.dart';

class BottomSheetReplaceEx extends StatefulWidget {
  final HomeExTableClass? currentEx;
  final int? index;

  const BottomSheetReplaceEx({Key? key, this.currentEx, this.index})
      : super(key: key);

  @override
  State<BottomSheetReplaceEx> createState() => _BottomSheetReplaceExState();
}

class _BottomSheetReplaceExState extends State<BottomSheetReplaceEx>
    with TickerProviderStateMixin {
  final EditPlanController _editPlanController = Get.find<EditPlanController>();

  List<ExerciseTable> listOfExercise = [];
  List<HomeExTableClass> listOfExerciseHomeExTableClass = [];
  List<Animation<int>> animationForListInt = [];
  List<AnimationController> animationForListController = [];
  List<int> countOfImagesForList = [];


  Animation<int>? animationForCurrentInt;
  AnimationController? animationForCurrentController;
  int countOfImagesForCurrent = 0;

  @override
  void initState() {
    _getExerciseDataFromDatabase();
    super.initState();
  }

  @override
  void dispose() {
    for (int i = 0; i < animationForListController.length; i++) {
      animationForListController[i].dispose();
    }
    animationForCurrentController!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.fullHeight / 1.14,
      padding: EdgeInsets.only(left: AppSizes.width_3_5,
          right: AppSizes.height_3_5,
          top: AppSizes.height_2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "txtCurrent".tr + ":",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: AppColor.black,
              fontSize: AppFontSize.size_15,
              fontWeight: FontWeight.w700,
            ),
          ),
          _itemCurrentEx(),
          Text(
            "txtReplaceWith".tr,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: AppColor.black,
              fontSize: AppFontSize.size_15,
              fontWeight: FontWeight.w700,
            ),
          ),
          _replaceWithExList(),
        ],
      ),
    );
  }

  _itemCurrentEx() {
    return GetBuilder<EditPlanController>(
        id: Constant.idReplaceCurrent, builder: (logic) {
      return Row(
        children: [
          SizedBox(
            height: AppSizes.height_12,
            width: AppSizes.height_18,
            child: animationForCurrentInt != null ? AnimatedBuilder(
              animation: animationForCurrentInt!,
              builder: (BuildContext context, Widget? child) {
                String frame = animationForCurrentInt!.value
                    .toString();
                return Image.asset(
                  'assets/${widget.currentEx!.exPath}/$frame.webp',
                  gaplessPlayback: true,
                  height: AppSizes.height_12,
                  width: AppSizes.height_14,
                );
              },
            ) : const SizedBox(),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.width_2_5),
              child: Text(
                Utils.getMultiLanguageString(widget.currentEx!.exName!),
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: AppFontSize.size_13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  _replaceWithExList() {
    return Expanded(
      child: GetBuilder<EditPlanController>(id: Constant.idReplaceList, builder: (logic) {
        return ListView.builder(
          itemCount: listOfExercise.length,
          shrinkWrap: Constant.boolValueTrue,
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int index) {
            return _itemReplaceWithExList(index, logic);
          },
        );
      }),
    );
  }

  _itemReplaceWithExList(int index, EditPlanController logic) {
    return InkWell(
      onTap: () {
        Get.bottomSheet(
          BottomSheetExDetails(
            exerciseList: listOfExerciseHomeExTableClass,
            listOfAnimation: animationForListInt,
            listOfAnimationController: animationForListController,
            index: index,
            isFromEdit: Constant.boolValueFalse,
            isFromReplace: Constant.boolValueTrue,
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
        ).then((value) => Get.back(result: value));
      },
      child: Row(
        children: [
          SizedBox(
            height: AppSizes.height_12,
            width: AppSizes.height_18,
            child: animationForListInt.isNotEmpty ? AnimatedBuilder(
              animation: animationForListInt[index],
              builder: (BuildContext context, Widget? child) {
                String frame = animationForListInt[index].value
                    .toString();
                return Image.asset(
                  'assets/${listOfExercise[index].exPath}/$frame.webp',
                  gaplessPlayback: true,
                  height: AppSizes.height_12,
                  width: AppSizes.height_14,
                );
              },
            ) : const SizedBox(),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.width_2_5),
              child: Text(
                listOfExercise.isNotEmpty ? Utils.getMultiLanguageString(
                    listOfExercise[index].exName!) : "",
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: AppFontSize.size_13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
                border: Border.all(
                  color: AppColor.black,
                ),
                shape: BoxShape.circle),
          )
        ],
      ),
    );
  }

  _getExerciseDataFromDatabase() async {
    listOfExercise = await DBHelper.dbHelper.getAllExerciseList();
    for (int i = 0; i < listOfExercise.length; i++) {
      await _setImageRotationForList(i);
      listOfExerciseHomeExTableClass.add(HomeExTableClass(
        exId: listOfExercise[i].exId.toString(),
        exDescription: listOfExercise[i].exDescription,
        exName: listOfExercise[i].exName,
        exPath: listOfExercise[i].exPath,
        exTime: listOfExercise[i].exTime,
        exUnit: listOfExercise[i].exUnit,
        exVideo: listOfExercise[i].exVideo,
      ));
    }
    _setImageRotationForCurrent();
    _editPlanController.update([Constant.idReplaceCurrent]);
  }

  _setImageRotationForList(int pos) async {
    await _getImageFromAssetsForList(pos);

    int duration = 0;
    if (countOfImagesForList[pos] > 2 && countOfImagesForList[pos] <= 4) {
      duration = 3000;
    } else
    if (countOfImagesForList[pos] > 4 && countOfImagesForList[pos] <= 6) {
      duration = 4500;
    } else
    if (countOfImagesForList[pos] > 6 && countOfImagesForList[pos] <= 8) {
      duration = 6000;
    } else
    if (countOfImagesForList[pos] > 8 && countOfImagesForList[pos] <= 10) {
      duration = 8500;
    } else
    if (countOfImagesForList[pos] > 10 && countOfImagesForList[pos] <= 12) {
      duration = 9000;
    } else
    if (countOfImagesForList[pos] > 12 && countOfImagesForList[pos] <= 14) {
      duration = 14000;
    } else {
      duration = 1500;
    }


    animationForListController.add(AnimationController(
        vsync: this, duration: Duration(milliseconds: duration))
      ..repeat());

    animationForListInt.add(IntTween(begin: 1, end: countOfImagesForList[pos])
        .animate(animationForListController[pos]));
  }

  _getImageFromAssetsForList(int index) async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) =>
        key.contains(listOfExercise[index].exPath.toString() + "/"))
        .where((String key) => key.contains('.webp'))
        .toList();

    countOfImagesForList.add(imagePaths.length);
  }

  _setImageRotationForCurrent() async {
    await _getImageFromAssetsForCurrent();


    int duration = 0;
    if (countOfImagesForCurrent > 2 && countOfImagesForCurrent <= 4) {
      duration = 3000;
    } else if (countOfImagesForCurrent > 4 && countOfImagesForCurrent <= 6) {
      duration = 4500;
    } else if (countOfImagesForCurrent > 6 && countOfImagesForCurrent <= 8) {
      duration = 6000;
    } else if (countOfImagesForCurrent > 8 && countOfImagesForCurrent <= 10) {
      duration = 8500;
    } else if (countOfImagesForCurrent > 10 && countOfImagesForCurrent <= 12) {
      duration = 9000;
    } else if (countOfImagesForCurrent > 12 && countOfImagesForCurrent <= 14) {
      duration = 14000;
    } else {
      duration = 1500;
    }

    animationForCurrentController = AnimationController(
        vsync: this, duration: Duration(milliseconds: duration))
      ..repeat();

    animationForCurrentInt = IntTween(begin: 1, end: countOfImagesForCurrent)
        .animate(animationForCurrentController!);
    _editPlanController.update([Constant.idReplaceList]);
  }

  _getImageFromAssetsForCurrent() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) =>
        key.contains(widget.currentEx!.exPath.toString() + "/"))
        .where((String key) => key.contains('.webp'))
        .toList();

    countOfImagesForCurrent = imagePaths.length;
  }
}
