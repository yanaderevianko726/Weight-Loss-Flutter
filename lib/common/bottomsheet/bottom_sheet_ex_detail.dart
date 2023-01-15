import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/custom_classes/custom_classes.dart';
import 'package:women_lose_weight_flutter/ui/exercise_list/controllers/exercise_list_controller.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../routes/app_routes.dart';
import '../../utils/color.dart';
import '../../utils/debug.dart';
import '../../utils/utils.dart';

class BottomSheetExDetails extends StatefulWidget {
  final int index;
  final List<Animation<int>>? listOfAnimation;
  final List<AnimationController>? listOfAnimationController;
  final List<HomeExTableClass>? exerciseList;
  final bool isFromEdit;
  final bool isFromReplace;
  final bool isFromPerformEx;

  const BottomSheetExDetails({this.index = 0,
    this.listOfAnimation,
    this.listOfAnimationController,
    this.exerciseList,
    this.isFromEdit = false,
    this.isFromReplace = false,
    this.isFromPerformEx = false,
    Key? key})
      : super(key: key);

  @override
  State<BottomSheetExDetails> createState() => _BottomSheetExDetailsState();
}

class _BottomSheetExDetailsState extends State<BottomSheetExDetails> {
  final ExerciseListController _exerciseListController =
  Get.find<ExerciseListController>();

  List<int> duration = [];

  @override
  void initState() {
    _exerciseListController.onChangeSubPageViewPage(0);
    for (var element in widget.exerciseList!) {
      duration.add(int.parse(element.exTime!));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _exerciseListController.mainPageController =
        PageController(initialPage: widget.index);
    return SizedBox(
      height: AppSizes.fullHeight / 1.14,
      child: PageView.builder(
        itemCount: widget.exerciseList!.length,
        controller: _exerciseListController.mainPageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (int currentPage) {},
        itemBuilder: (context, mainPageIndex) {
          return _widgetAnimationAndVideoPageView(mainPageIndex);
        },
      ),
    );
  }

  _widgetAnimationAndVideoPageView(int mainPageIndex) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppSizes.width_4, vertical: AppSizes.height_2),
      child: Column(
        children: [
          GetBuilder<ExerciseListController>(
              id: Constant.idTabViewOfExerciseDialog,
              builder: (logic) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.width_5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                _exerciseListController.subPageController
                                    .previousPage(
                                    duration:
                                    const Duration(milliseconds: 100),
                                    curve: Curves.bounceIn);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: AppSizes.height_1_5),
                                child: Text(
                                  "txtAnimation".tr,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color:
                                    (logic.subPageControllerCurrentPage ==
                                        0)
                                        ? AppColor.black
                                        : AppColor.txtColor666,
                                    fontSize: AppFontSize.size_14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: AppSizes.height_0_7,
                              decoration: BoxDecoration(
                                color: (logic.subPageControllerCurrentPage == 0)
                                    ? AppColor.primary
                                    : AppColor.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: AppSizes.width_3),
                      Expanded(
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                _exerciseListController.subPageController
                                    .nextPage(
                                    duration:
                                    const Duration(milliseconds: 100),
                                    curve: Curves.bounceIn);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: AppSizes.height_1_5),
                                child: Text(
                                  "txtVideo".tr,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color:
                                    (logic.subPageControllerCurrentPage ==
                                        1)
                                        ? AppColor.black
                                        : AppColor.txtColor666,
                                    fontSize: AppFontSize.size_14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: AppSizes.height_0_7,
                              decoration: BoxDecoration(
                                color: (logic.subPageControllerCurrentPage == 1)
                                    ? AppColor.primary
                                    : AppColor.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
          Container(
            margin: EdgeInsets.only(top: AppSizes.height_2_5),
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: AppColor.shadow,
                  blurRadius: 3.0,
                  spreadRadius: 0.15,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 210,
                  minHeight: 210,
                ),
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  controller: _exerciseListController.subPageController,
                  onPageChanged: (value) {
                    _exerciseListController.onChangeSubPageViewPage(value);
                  },
                  children: [
                    AnimatedBuilder(
                      animation: widget.listOfAnimation![mainPageIndex],
                      builder: (BuildContext context, Widget? child) {
                        String frame = widget
                            .listOfAnimation![mainPageIndex].value
                            .toString();
                        return Image.asset(
                          'assets/${widget.exerciseList![mainPageIndex]
                              .exPath}/$frame.webp',
                          gaplessPlayback: true,
                          width: AppSizes.fullWidth,
                        );
                      },
                    ),
                    Container(
                      color: AppColor.primary,
                      child: YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: widget
                              .exerciseList![mainPageIndex].exVideo!
                              .split("=")[1]
                              .toString(),
                          flags: const YoutubePlayerFlags(
                            autoPlay: true,
                            mute: true,
                          ),
                        ),
                        showVideoProgressIndicator: true,
                        width: AppSizes.fullWidth,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: AppSizes.height_3),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utils.getMultiLanguageString(
                        widget.exerciseList![mainPageIndex].exName!)
                        .toUpperCase(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppFontSize.size_14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GetBuilder<ExerciseListController>(
                      id: Constant.idEditTimeInPlan, builder: (logic) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: AppSizes.height_2),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              (widget.exerciseList![mainPageIndex].exUnit ==
                                  Constant.workoutTypeStep)
                                  ? "txtRepeat".tr
                                  : "txtDuration".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: AppFontSize.size_12_5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          if (widget.isFromEdit || widget.isFromReplace) ...{
                            InkWell(
                              onTap: () {
                                if (widget.exerciseList![mainPageIndex]
                                    .exUnit ==
                                    Constant.workoutTypeStep) {
                                  if (duration[mainPageIndex] > 5) {
                                    duration[mainPageIndex] =
                                        duration[mainPageIndex] - 1;
                                  }
                                } else {
                                  if (duration[mainPageIndex] > 10) {
                                    duration[mainPageIndex] =
                                        duration[mainPageIndex] - 5;
                                  }
                                }
                                logic.isShowResetWidget(
                                    widget.exerciseList![mainPageIndex].exTime!,
                                    duration[mainPageIndex]);
                                logic.update([Constant.idEditTimeInPlan]);
                              },
                              child: Container(
                                width: AppSizes.height_4,
                                height: AppSizes.height_4,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColor.grayDivider),
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                child: const Icon(
                                  Icons.remove_rounded,
                                  color: AppColor.pink,
                                ),
                              ),
                            ),
                          },
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: AppSizes.width_3),
                            child: Text(
                              (widget.exerciseList![mainPageIndex].exUnit ==
                                  Constant.workoutTypeStep)
                                  ? duration[mainPageIndex]
                                  .toString()
                                  : Utils.secToString(duration[
                              mainPageIndex] ),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: AppFontSize.size_12_5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (widget.isFromEdit || widget.isFromReplace) ...{
                            InkWell(
                              onTap: () {
                                if (widget.exerciseList![mainPageIndex]
                                    .exUnit ==
                                    Constant.workoutTypeStep) {
                                  duration[mainPageIndex] =
                                      duration[mainPageIndex] + 1;
                                } else {
                                  duration[mainPageIndex] =
                                      duration[mainPageIndex] + 5;
                                }
                                logic.isShowResetWidget(
                                    widget.exerciseList![mainPageIndex].exTime!,
                                    duration[mainPageIndex]);
                                logic.update([Constant.idEditTimeInPlan]);
                              },
                              child: Container(
                                width: AppSizes.height_4,
                                height: AppSizes.height_4,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColor.grayDivider),
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                child: const Icon(
                                  Icons.add_rounded,
                                  color: AppColor.pink,
                                ),
                              ),
                            ),
                          },
                        ],
                      ),
                    );
                  }),
                  Text(
                    Utils.getMultiLanguageString(
                        widget.exerciseList![mainPageIndex].exDescription!),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppColor.txtColor666,
                      fontSize: AppFontSize.size_11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.toNamed(AppRoutes.commonQuestions);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: AppSizes.height_2,
                          horizontal: AppSizes.width_3),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: AppSizes.height_3_2,
                            width: AppSizes.height_3_2,
                            margin: EdgeInsets.only(right: AppSizes.width_2),
                            child: Image.asset(
                              Constant.getAssetIcons() + "ic_bulb.webp",
                              color: AppColor.primary,
                            ),
                          ),
                          Text(
                            "txtCommonQuestions".tr,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColor.primary,
                              fontSize: AppFontSize.size_11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GetBuilder<ExerciseListController>(id: Constant.idEditTimeInPlan, builder: (logic) {
            if (!widget.isFromReplace &&
                !_exerciseListController.isShowResetWidget(
                    widget.exerciseList![mainPageIndex].exTime!,
                    duration[mainPageIndex]) &&
                !widget.isFromPerformEx) {
            return _buttonNextPrevAndClose(mainPageIndex);
            } return const SizedBox();
          }),

          if (widget.isFromReplace) ...{_buttonCancelAndReplace()},

            GetBuilder<ExerciseListController>(id: Constant.idEditTimeInPlan, builder: (logic) {
              if (_exerciseListController.isShowResetWidget(
                  widget.exerciseList![mainPageIndex].exTime!,
                  duration[mainPageIndex]) && !widget.isFromReplace) {
              return _buttonResetAndSave(mainPageIndex, logic);
    } return const SizedBox();
            }),

          if (!widget.isFromReplace &&
              !widget.isFromEdit &&
              widget.isFromPerformEx) ...{
            _buttonContinue(),
          },
        ],
      ),
    );
  }

  _buttonNextPrevAndClose(int mainPageIndex) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  _exerciseListController.onChangeSubPageViewPage(0);
                  _exerciseListController.mainPageController.previousPage(
                      duration: const Duration(microseconds: 100),
                      curve: Curves.bounceIn);
                },
                child: Image.asset(
                  Constant.getAssetIcons() +
                      ((mainPageIndex == 0)
                          ? "ic_previous.webp"
                          : "ic_previous_highlight.png"),
                  height: AppSizes.height_5,
                  width: AppSizes.height_5,
                ),
              ),
              Expanded(
                child: Text(
                  "${mainPageIndex + 1}/${widget.exerciseList!.length}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: AppFontSize.size_15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _exerciseListController.onChangeSubPageViewPage(0);
                  _exerciseListController.mainPageController.nextPage(
                      duration: const Duration(microseconds: 100),
                      curve: Curves.bounceIn);
                },
                child: Image.asset(
                  Constant.getAssetIcons() +
                      ((mainPageIndex == widget.exerciseList!.length - 1)
                          ? "ic_next.webp"
                          : "ic_next_highlight.png"),
                  height: AppSizes.height_5,
                  width: AppSizes.height_5,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: AppSizes.width_6),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColor.greenGradualStartColor,
                  AppColor.greenGradualEndColor,
                ],
              ),
            ),
            child: TextButton(
              onPressed: () {
                Get.back();
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
                  "txtClose".tr.toUpperCase(),
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
    );
  }

  _buttonCancelAndReplace() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              border: Border.all(color: AppColor.txtColor999),
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
                Get.back();
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
                  "txtCancel".tr.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.black,
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
                  AppColor.greenGradualStartColor,
                  AppColor.greenGradualEndColor,
                ],
              ),
            ),
            child: TextButton(
              onPressed: () {
                Debug.printLog("value: " + duration.toString());

                Map<String, dynamic> map = {
                  "index": widget.index,
                  "exerciseReplaceId": widget.exerciseList![widget.index].exId,
                  "duration": duration,
                };
                Get.back(result: map);
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
                  "txtReplace".tr.toUpperCase(),
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
    );
  }

  _buttonResetAndSave(int index, ExerciseListController logic) {
     return Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                border: Border.all(color: AppColor.txtColor999),
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
                  duration[index] = logic.exTime!;
                  logic.update([Constant.idEditTimeInPlan]);
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
                    "txtReset".tr.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.black,
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
                    AppColor.greenGradualStartColor,
                    AppColor.greenGradualEndColor,
                  ],
                ),
              ),
              child: TextButton(
                onPressed: () {
                  Get.back(result: duration);
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
                    "txtSave".tr.toUpperCase(),
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
      );
  }

  _buttonContinue() {
    return Container(
      width: AppSizes.fullWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColor.greenGradualStartColor,
            AppColor.greenGradualEndColor,
          ],
        ),
      ),
      child: TextButton(
        onPressed: () {
          Get.back();
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
    );
  }
}
