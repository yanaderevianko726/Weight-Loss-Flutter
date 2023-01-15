import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/custom_classes/custom_classes.dart';
import 'package:women_lose_weight_flutter/routes/app_routes.dart';
import 'package:women_lose_weight_flutter/ui/exercise_list/controllers/exercise_list_controller.dart';

import '../../../google_ads/custom_ad.dart';
import '../../../utils/color.dart';
import '../../../utils/constant.dart';
import '../../../utils/sizer_utils.dart';
import '../../../utils/utils.dart';

class ExerciseListScreen extends StatelessWidget {
  ExerciseListScreen({Key? key}) : super(key: key);

  final ExerciseListController _exerciseListController =
      Get.find<ExerciseListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        top: Constant.boolValueFalse,
        bottom:
            (Platform.isIOS) ? Constant.boolValueFalse : Constant.boolValueTrue,
        child: NestedScrollView(
          controller: _exerciseListController.scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              _sliverAppBarWidget(),
            ];
          },
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (_exerciseListController
                              .getIntroductionDescription() !=
                          "") ...{
                        _expandedTitleTile(),
                        const Divider(color: AppColor.grayDivider),
                      },
                      _timeAndCountOfExerciseWidget(),
                      _exerciseList(),
                    ],
                  ),
                ),
              ),
              GetBuilder<ExerciseListController>(
                id: Constant.idExerciseButtons,
                builder: (logic) {
                  if (logic.isAllCompleted) {
                    return _doItAgainButton();
                  } else if (logic.isAnyCompleted) {
                    return _buttonRestartAndContinue();
                  } else {
                    return _goButton();
                  }
                },
              ),
              const BannerAdClass(),
            ],
          ),
        ),
      ),
    );
  }

  _sliverAppBarWidget() {
    return GetBuilder<ExerciseListController>(
      id: Constant.idExerciseSliverAppBar,
      builder: (logic) {
        return SliverAppBar(
          elevation: 0.8,
          expandedHeight: AppSizes.height_30,
          floating: Constant.boolValueFalse,
          pinned: Constant.boolValueTrue,
          backgroundColor: AppColor.white,
          centerTitle: Constant.boolValueFalse,
          automaticallyImplyLeading: Constant.boolValueFalse,
          titleSpacing: AppSizes.width_1_5,
          title: (logic.isShrink)
              ? Text(
                  Utils.getMultiLanguageString(
                          _exerciseListController.getPlanName())
                      .toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.w700,
                    fontSize: AppFontSize.size_15,
                  ),
                )
              : Container(),
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Icon(
                Icons.arrow_back_sharp,
                color: (logic.isShrink) ? AppColor.black : AppColor.white,
                size: AppSizes.height_3,
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: Constant.boolValueFalse,
            background: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.width_6, vertical: 0.0),
              decoration: BoxDecoration(
                color: AppColor.transparent,
                image: DecorationImage(
                  image: AssetImage(Constant.getAssetImage() +
                      _exerciseListController.getPlanImage()),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (logic.getShowAboutOption()) ...{
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: AppSizes.height_0_8,
                              bottom: AppSizes.height_1_2),
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.width_1_2,
                              vertical: AppSizes.height_0_7),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColor.backgroundTint,
                            border: Border.all(color: AppColor.white),
                          ),
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(AppRoutes.about, arguments: [
                                _exerciseListController.workoutPlanData
                              ]);
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: AppSizes.height_3,
                                  width: AppSizes.height_3,
                                  margin: EdgeInsets.only(
                                      right: AppSizes.width_2,
                                      left: AppSizes.width_1_3),
                                  child: Image.asset(
                                    Constant.getAssetIcons() + "ic_bulb.webp",
                                    color: AppColor.white,
                                  ),
                                ),
                                Text(
                                  "txtAbout".tr.toUpperCase(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: AppFontSize.size_11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  },
                  Text(
                    Utils.getMultiLanguageString(logic.getPlanName()),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.white,
                      fontWeight: FontWeight.w700,
                      fontSize: AppFontSize.size_17,
                    ),
                  ),
                  if (logic.getPlanDescription() != "") ...{
                    Container(
                      margin: EdgeInsets.only(
                          top: AppSizes.height_0_8, right: AppSizes.width_12),
                      child: Text(
                        Utils.getMultiLanguageString(
                            logic.getPlanDescription()),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: AppColor.white,
                          fontSize: AppFontSize.size_10_5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  },
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.commonQuestions);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              top: AppSizes.height_0_8,
                              bottom: AppSizes.height_4),
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.width_3,
                              vertical: AppSizes.height_1_2),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppColor.backgroundTint,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: AppSizes.height_3,
                                width: AppSizes.height_3,
                                margin:
                                    EdgeInsets.only(right: AppSizes.width_2),
                                child: Image.asset(
                                  Constant.getAssetIcons() + "ic_bulb.webp",
                                  color: AppColor.white,
                                ),
                              ),
                              Text(
                                "txtCommonQuestions".tr,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: AppFontSize.size_11,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _expandedTitleTile() {
    return Container(
      margin: EdgeInsets.only(
          right: AppSizes.width_4,
          left: AppSizes.width_4,
          top: AppSizes.height_1_2),
      child: Theme(
        data:
            Theme.of(Get.context!).copyWith(dividerColor: AppColor.transparent),
        child: ExpansionTile(
          initiallyExpanded: Constant.boolValueTrue,
          title: Text(
            "txtInstruction".tr,
            style: TextStyle(
              color: AppColor.black,
              fontSize: AppFontSize.size_13,
              fontWeight: FontWeight.w700,
            ),
          ),
          collapsedIconColor: AppColor.black,
          iconColor: AppColor.black,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          backgroundColor: AppColor.transparent,
          childrenPadding: EdgeInsets.only(
              left: AppSizes.width_3_5,
              bottom: AppSizes.width_3_5,
              right: AppSizes.height_1),
          children: [
            Text(
              Utils.getMultiLanguageString(
                  _exerciseListController.getIntroductionDescription()),
              style: TextStyle(
                fontSize: AppFontSize.size_11,
                color: AppColor.txtColor666,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _timeAndCountOfExerciseWidget() {
    return Container(
      margin: EdgeInsets.only(
          right: AppSizes.width_4,
          left: AppSizes.width_5,
          top: AppSizes.height_2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _exerciseListController.getWorkoutTime() +
                  " • " +
                  _exerciseListController.getWorkoutLevel(),
              style: TextStyle(
                color: AppColor.black,
                fontSize: AppFontSize.size_11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Visibility(
            visible: _exerciseListController.isFrom != Constant.fromFastWorkout,
            child: InkWell(
              onTap: () {
                _exerciseListController.onEditClick();
              },
              child: Row(
                children: [
                  Text(
                    "txtEdit".tr.toUpperCase(),
                    style: TextStyle(
                      color: AppColor.txtColor666,
                      fontSize: AppFontSize.size_12_5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: AppSizes.width_2),
                  const Icon(
                    Icons.edit_outlined,
                    color: AppColor.txtColor666,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _exerciseList() {
    return GetBuilder<ExerciseListController>(
      id: Constant.idExerciseList,
      builder: (logic) {
        return ListView.builder(
          itemCount: logic.exerciseList.length,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(
              horizontal: AppSizes.width_4, vertical: AppSizes.height_2),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return _itemExerciseList(index, logic.exerciseList[index]);
          },
        );
      },
    );
  }

  _itemExerciseList(int index, HomeExTableClass exerciseList) {
    return InkWell(
      onTap: () {
        _exerciseListController.onExerciseItemClick(index);
      },
      child: Row(
        children: [
          SizedBox(
            height: AppSizes.height_12,
            width: AppSizes.height_14,
            child: AnimatedBuilder(
              animation: _exerciseListController.listOfAnimation[index],
              builder: (BuildContext context, Widget? child) {
                String frame = _exerciseListController
                    .listOfAnimation[index].value
                    .toString();
                return Image.asset(
                  'assets/${exerciseList.exPath}/$frame.webp',
                  gaplessPlayback: true,
                  height: AppSizes.height_12,
                  width: AppSizes.height_14,
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.width_2_5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utils.getMultiLanguageString(exerciseList.exName!)
                        .toUpperCase(),
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppFontSize.size_12_5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: AppSizes.height_1),
                  Text(
                    exerciseList.updatedExTime == null ||
                            exerciseList.updatedExTime == ""
                        ? (exerciseList.exUnit == Constant.workoutTypeStep)
                            ? "X " + exerciseList.exTime.toString()
                            : Utils.secToString(int.parse(exerciseList.exTime!))
                        : (exerciseList.exUnit == Constant.workoutTypeStep)
                            ? "X " + exerciseList.updatedExTime.toString()
                            : Utils.secToString(
                                int.parse(exerciseList.updatedExTime!)),
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: AppFontSize.size_11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (exerciseList.isCompleted == "1") ...{
            Container(
              margin: EdgeInsets.only(right: AppSizes.width_3),
              child: Image.asset(
                Constant.getAssetIcons() + "ic_action_check.webp",
                height: AppSizes.height_2_8,
                width: AppSizes.height_2_8,
              ),
            ),
          },
        ],
      ),
    );
  }

  _goButton() {
    return Container(
      width: AppSizes.fullWidth,
      margin: EdgeInsets.only(
          right: AppSizes.width_4,
          left: AppSizes.width_4,
          bottom: AppSizes.height_1_5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        gradient: const LinearGradient(
          begin: Alignment.center,
          end: Alignment.center,
          colors: [
            AppColor.primary,
            AppColor.primary,
          ],
        ),
      ),
      child: TextButton(
        onPressed: () {
          _exerciseListController.onGoButtonClick();
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
              side: const BorderSide(
                color: AppColor.transparent,
                width: 0.7,
              ),
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSizes.height_1),
          child: Text(
            "txtGo".tr.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.white,
              fontSize: AppFontSize.size_14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  _doItAgainButton() {
    return Container(
      width: AppSizes.fullWidth,
      margin: EdgeInsets.only(
          right: AppSizes.width_4,
          left: AppSizes.width_4,
          bottom: AppSizes.height_1_5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        gradient: const LinearGradient(
          begin: Alignment.center,
          end: Alignment.center,
          colors: [
            AppColor.primary,
            AppColor.primary,
          ],
        ),
      ),
      child: TextButton(
        onPressed: () {
          _exerciseListController.onGoButtonClick();
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
              side: const BorderSide(
                color: AppColor.transparent,
                width: 0.7,
              ),
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSizes.height_1),
          child: Text(
            "txtDoItAgain".tr.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.white,
              fontSize: AppFontSize.size_14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  _buttonRestartAndContinue() {
    return Container(
      margin: EdgeInsets.only(
          right: AppSizes.width_4,
          left: AppSizes.width_4,
          bottom: AppSizes.height_1_5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                border: Border.all(color: AppColor.primary),
                gradient: const LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.center,
                  colors: [
                    AppColor.white,
                    AppColor.white,
                  ],
                ),
              ),
              child: TextButton(
                onPressed: () {
                  _exerciseListController.onRestartButtonClick();
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      side: const BorderSide(
                        color: AppColor.transparent,
                        width: 0.7,
                      ),
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSizes.height_0_8),
                  child: Text(
                    "txtRestart".tr.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: AppFontSize.size_15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSizes.width_5),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColor.primary,
                    AppColor.primary,
                  ],
                ),
              ),
              child: TextButton(
                onPressed: () {
                  _exerciseListController.onContinueButtonClick();
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      side: const BorderSide(
                        color: AppColor.transparent,
                        width: 0.7,
                      ),
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSizes.height_0_8),
                  child: Text(
                    "txtContinue".tr.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: AppFontSize.size_15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
