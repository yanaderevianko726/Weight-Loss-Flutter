import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/ui/perform_exercise/controllers/perform_exercise_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';
import '../../../common/count_down_timer/circular_count_down_timer.dart';
import '../../../common/dialog/sound_option/dialog_sound_option.dart';
import '../../../utils/utils.dart';

class PerformExerciseScreen extends StatelessWidget {
  PerformExerciseScreen({Key? key}) : super(key: key);

  final PerformExerciseController _performExerciseController =
      Get.find<PerformExerciseController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _performExerciseController.onBackButtonClick();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColor.bgExercise,
        body: SafeArea(
          child: Column(
            children: [
              _exImageWidget(),
              Expanded(
                child: Container(
                  width: AppSizes.fullWidth,
                  color: AppColor.white,
                  child: Column(
                    children: [
                      GetBuilder<PerformExerciseController>(
                        id: Constant.idCountDownTimerExercise,
                        builder: (logic) {
                          if (!logic.isCompletedCountDown) {
                            return _textReadyToGo();
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      _textExerciseName(),
                      GetBuilder<PerformExerciseController>(
                        id: Constant.idCountDownTimerExercise,
                        builder: (logic) {
                          if (logic.isCompletedCountDown) {
                            return _timerAndProgressWidget();
                          } else {
                            return _countDownExercise();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _exImageWidget() {
    return IntrinsicHeight(
      child: Stack(
        children: [
          Column(
            children: [
              AnimatedBuilder(
                animation: _performExerciseController
                    .listOfAnimation[_performExerciseController.currentPos],
                builder: (BuildContext context, Widget? child) {
                  String frame = _performExerciseController
                      .listOfAnimation[_performExerciseController.currentPos]
                      .value
                      .toString();
                  return Image.asset(
                    'assets/${_performExerciseController.exerciseList[_performExerciseController.currentPos].exPath}/$frame.webp',
                    gaplessPlayback: true,
                  );
                },
              ),
              GetBuilder<PerformExerciseController>(
                id: Constant.idPerformExProgress,
                builder: (logic) {
                  return SizedBox(
                    height: AppSizes.height_0_6,
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width /
                              _performExerciseController.exerciseList.length,
                          child: Divider(
                            color:
                                (_performExerciseController.currentPos > index)
                                    ? AppColor.primary
                                    : AppColor.transparent,
                            thickness: AppSizes.height_0_6,
                          ),
                        );
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          _performExerciseController.exerciseList.length - 1,
                    ),
                  );
                },
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: AppSizes.height_2_5, horizontal: AppSizes.width_3_5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _widgetBack(),
                const Spacer(),
                _soundVideoAndHintWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _widgetBack() {
    return InkWell(
      onTap: () {
        _performExerciseController.onBackButtonClick();
      },
      child: Utils.backWidget(),
    );
  }

  _soundVideoAndHintWidget() {
    return Column(
      children: [
        GetBuilder<PerformExerciseController>(
          id: Constant.idPerformSoundOptionMute,
          builder: (logic) {
            return InkWell(
              onTap: () {
                _performExerciseController.removeBindingObserver();
                _performExerciseController.pauseTimers();
                _soundOptionsDialog();
              },
              child: Image.asset(
                (_performExerciseController.isMute)
                    ? Constant.getAssetIcons() + "wp_ic_mute.webp"
                    : Constant.getAssetIcons() + "wp_ic_sound.webp",
                width: AppSizes.height_5,
                height: AppSizes.height_5,
              ),
            );
          },
        ),
        InkWell(
          onTap: () {
            _performExerciseController
                .onVideoClick(_performExerciseController.currentPos);
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: AppSizes.height_1_8),
            child: Image.asset(
              Constant.getAssetIcons() + "wp_ic_video.webp",
              width: AppSizes.height_5,
              height: AppSizes.height_5,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _performExerciseController.onCommonQuestionClick();
          },
          child: Container(
            width: AppSizes.height_5,
            height: AppSizes.height_5,
            decoration: const BoxDecoration(
              color: AppColor.bgIconBulb,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(AppSizes.height_1),
            child: Image.asset(
              Constant.getAssetIcons() + "ic_bulb.webp",
              color: AppColor.white,
            ),
          ),
        ),
      ],
    );
  }


  _textReadyToGo() {
    return Container(
      margin: EdgeInsets.only(top: AppSizes.height_3),
      child: Text(
        "txtReadyToGo".tr + "!",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: AppColor.primary,
          fontSize: AppFontSize.size_19,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _textExerciseName() {
    return GetBuilder<PerformExerciseController>(
      id: Constant.idPerformExName,
      builder: (logic) {
        return Container(
          margin: EdgeInsets.only(
            top: AppSizes.height_4,
            left: AppSizes.width_6,
            right: AppSizes.width_6,
          ),
          child: RichText(
            text: TextSpan(
              text: _performExerciseController.getExeName(),
              style: TextStyle(
                color: AppColor.black,
                fontSize: AppFontSize.size_17,
                fontWeight: FontWeight.w500,
              ),
              children: [
                WidgetSpan(child: SizedBox(width: AppSizes.width_2),),
                WidgetSpan(child: InkWell(
                  onTap: () {
                    _performExerciseController.onWorkOutInfoClick(
                        _performExerciseController.currentPos);
                  },
                  child: Image.asset(
                    Constant.getAssetIcons() + "icon_exe_question.webp",
                    height: AppSizes.height_3_2,
                    width: AppSizes.height_3_2,
                  ),
                ),)
              ]
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        );
      },
    );
  }

  _countDownExercise() {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularCountDownTimer(
            duration: Constant.countDownTimeSeconds,
            initialDuration: 0,
            controller: _performExerciseController.countDownController,
            width: AppSizes.height_15,
            height: AppSizes.height_15,
            ringColor: AppColor.white,
            ringGradient: null,
            fillColor: AppColor.primary,
            fillGradient: null,
            backgroundColor: AppColor.transparent,
            backgroundGradient: null,
            strokeWidth: 5.0,
            strokeCap: StrokeCap.round,
            textStyle: TextStyle(
              fontSize: AppFontSize.size_35,
              color: AppColor.black,
              fontWeight: FontWeight.w600,
            ),
            textFormat: CountdownTextFormat.S,
            isReverse: Constant.boolValueTrue,
            isReverseAnimation: Constant.boolValueFalse,
            isTimerTextShown: Constant.boolValueTrue,
            autoStart: Constant.boolValueTrue,
            onStart: () {},
            onChange: (String value) {
              _performExerciseController.countDownTimerChange(value);
            },
            onComplete: () {
              _performExerciseController.countDownTimerFinish();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  _performExerciseController.countDownTimerFinish();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: AppSizes.width_3_5),
                  child: Image.asset(
                    Constant.getAssetIcons() + "ic_next_exercise.webp",
                    height: AppSizes.height_5,
                    width: AppSizes.height_5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _timerAndProgressWidget() {
    return GetBuilder<PerformExerciseController>(
      id: Constant.idTimerAndProgress,
      builder: (logic) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
                top: AppSizes.height_5, bottom: AppSizes.height_2_5),
            child: Column(
              children: [
                if (_performExerciseController.currentExe!.exUnit ==
                    Constant.workoutTypeStep) ...{
                  Text(
                    "X " +
                        _performExerciseController
                            .exerciseList[_performExerciseController.currentPos]
                            .exTime
                            .toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppFontSize.size_30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                } else ...{
                  GetBuilder<PerformExerciseController>(
                    id: Constant.idPerformExTime,
                    builder: (logic) {
                      return Text(
                        _performExerciseController.formatDDHHMMSS(
                                _performExerciseController.exTime,
                                returnType: Constant.minute) +
                            ":" +
                            _performExerciseController.formatDDHHMMSS(
                                _performExerciseController.exTime,
                                returnType: Constant.seconds),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: AppFontSize.size_30,
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    },
                  ),
                },
                const Spacer(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    GetBuilder<PerformExerciseController>(
                      id: Constant.idButtonProgressValue,
                      builder: (logic) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.width_19),
                          width: AppSizes.fullWidth,
                          height: AppSizes.height_7,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40.0),
                            child: LinearProgressIndicator(
                              value: (_performExerciseController
                                          .currentExe!.exUnit ==
                                      Constant.workoutTypeStep)
                                  ? 1
                                  : _performExerciseController
                                      .buttonProgressValue,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColor.primary),
                              backgroundColor: AppColor.primary.withOpacity(.3),
                            ),
                          ),
                        );
                      },
                    ),
                    InkWell(
                      onTap: () {
                        if (_performExerciseController.currentExe!.exUnit ==
                            Constant.workoutTypeStep) {
                          _performExerciseController.onSkipButtonClick();
                        } else {
                          _performExerciseController.onVideoClick(
                              _performExerciseController.currentPos);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            (_performExerciseController.currentExe!.exUnit ==
                                    Constant.workoutTypeStep)
                                ? Constant.getAssetIcons() +
                                    "icon_exe_done.webp"
                                : Constant.getAssetIcons() +
                                    "icon_exe_pause.webp",
                            height: AppSizes.height_2_6,
                            color: AppColor.white,
                          ),
                          Text(
                            (_performExerciseController.currentExe!.exUnit ==
                                    Constant.workoutTypeStep)
                                ? " " + "txtDone".tr.toUpperCase()
                                : " " + "txtPause".tr.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: AppFontSize.size_14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _performExerciseController.onPreviousButtonClick();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                Constant.getAssetIcons() + "icon_exe_prev.webp",
                                color:
                                    (_performExerciseController.currentPos == 0)
                                        ? AppColor.txtColor999
                                        : AppColor.txtColor666,
                                height: AppSizes.height_3_5,
                                width: AppSizes.height_3_5,
                              ),
                              Text(
                                "txtPrevious".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color:
                                      (_performExerciseController.currentPos ==
                                              0)
                                          ? AppColor.txtColor999
                                          : AppColor.txtColor666,
                                  fontSize: AppFontSize.size_12_5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const VerticalDivider(color: AppColor.txtColor999),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _performExerciseController.onSkipButtonClick();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                Constant.getAssetIcons() + "icon_exe_skip.webp",
                                color: AppColor.txtColor666,
                                height: AppSizes.height_3_5,
                                width: AppSizes.height_3_5,
                              ),
                              Text(
                                "txtSkip".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColor.txtColor666,
                                  fontSize: AppFontSize.size_12_5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _soundOptionsDialog() {
    return showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "txtSoundOptions".tr,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColor.black,
              fontSize: AppFontSize.size_15,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: const DialogSoundOption(),
          buttonPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          actions: [
            Container(
              margin: EdgeInsets.only(
                  right: AppSizes.width_5, bottom: AppSizes.height_1_5),
              child: TextButton(
                child: Text(
                  "txtOk".tr.toUpperCase(),
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: AppFontSize.size_12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ],
        );
      },
    ).then((value) {
      _performExerciseController.getPreferenceData();
      _performExerciseController.resumeTimers();
    });
  }
}
