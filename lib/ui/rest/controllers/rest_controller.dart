import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/main.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/utils.dart';

import '../../../common/bottomsheet/bottom_sheet_ex_detail.dart';
import '../../../common/count_down_timer/circular_count_down_timer.dart';
import '../../../database/custom_classes/custom_classes.dart';
import '../../../database/table/home_plan_table.dart';
import '../../../utils/color.dart';
import '../../../utils/debug.dart';

class RestController extends GetxController with WidgetsBindingObserver {
  CountDownController countDownController = CountDownController();

  Timer? _timer;
  int timerCount = 15;
  int stopExTimerCount = 15;
  int progressCount = 0;
  int completedCount = 15;

  dynamic arguments = Get.arguments;

  int currentPos = 0;
  List<Animation<int>> listOfAnimation = [];
  List<AnimationController> listOfAnimationController = [];
  List<HomeExTableClass> exerciseList = [];
  List<int> listOfImagesCount = [];
  HomePlanTable? workoutPlanData;

  onAdd20SecondsClick() {
    timerCount = timerCount + 20;
    completedCount = completedCount + 20;
    update([Constant.idRestCountDownTimer]);
  }

  _startTimer() {
    timerCount = stopExTimerCount;
    stopExTimerCount = 15;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerCount == 4) {
        Utils.textToSpeech((timerCount - 1).toString(), MyApp.flutterTts);
      }

      if (timerCount == 3) {
        Utils.textToSpeech((timerCount - 1).toString(), MyApp.flutterTts);
      }

      if (timerCount == 2) {
        Utils.textToSpeech((timerCount - 1).toString(), MyApp.flutterTts);
      }

      if (timerCount > 0) {
        timerCount = timerCount - 1;
        progressCount = progressCount + 1;
        update([Constant.idRestCountDownTimer]);
      } else {
        if (_timer != null) _timer!.cancel();
        onRestTimeComplete();
      }
    });
  }

  _argumentData() {
    if (arguments != null) {
      if (arguments[0] != null) {
        currentPos = arguments[0];
        Debug.printLog("currentPos -->>" + currentPos.toString());
      }

      if (arguments[1] != null) {
        exerciseList = arguments[1];
        Debug.printLog("exerciseList -->>" + exerciseList.toList().toString());
      }

      if (arguments[2] != null) {
        listOfAnimation = arguments[2];
        Debug.printLog(
            "listOfAnimation -->>" + listOfAnimation.toList().toString());
      }

      if (arguments[3] != null) {
        listOfAnimationController = arguments[3];
        Debug.printLog("listOfAnimationController -->>" +
            listOfAnimationController.toList().toString());
      }

      if (arguments[4] != null) {
        workoutPlanData = arguments[4];
        Debug.printLog(
            "listOfAnimationController -->>" + workoutPlanData.toString());
      }
    }
  }

  onRestTimeComplete() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timer != null) _timer!.cancel();
    Get.back(result: [
      workoutPlanData,
      exerciseList,
      listOfAnimation,
      listOfAnimationController,
      currentPos + 1,
    ]);
  }

  pauseTimers() {
    if (_timer != null) {
      _timer!.cancel();
      stopExTimerCount = timerCount;
    }
  }

  resumeTimers() {
    _startTimer();
  }

  onNextExClick(int index) {
    pauseTimers();
    WidgetsBinding.instance.removeObserver(this);
    Get.bottomSheet(
      BottomSheetExDetails(
        exerciseList: exerciseList,
        listOfAnimation: listOfAnimation,
        listOfAnimationController: listOfAnimationController,
        index: index,
        isFromEdit: Constant.boolValueFalse,
        isFromReplace: Constant.boolValueFalse,
        isFromPerformEx: Constant.boolValueTrue,
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
      resumeTimers();
    });
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    Utils.playSound("raw/ding.mp3");
    _argumentData();
    _startTimer();
    if (exerciseList[currentPos + 1].exUnit == Constant.workoutTypeStep) {
      Utils.textToSpeech("tts6".tr, MyApp.flutterTts).then((value) {
        Utils.textToSpeech(
            "tts7".tr +
                " ${exerciseList[currentPos + 1].exTime} " +
                "tts8".tr +
                " ${Utils.getMultiLanguageString(exerciseList[currentPos + 1].exName!)}",
            MyApp.flutterTts);
      });
    } else {
      Utils.textToSpeech("tts6".tr, MyApp.flutterTts).then((value) {
        Utils.textToSpeech(
            "tts7".tr +
                " ${exerciseList[currentPos + 1].exTime} " +
                "tts4".tr +
                " ${Utils.getMultiLanguageString(exerciseList[currentPos + 1].exName!)}",
            MyApp.flutterTts);
      });
    }
    super.onInit();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timer != null) _timer!.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      resumeTimers();
    } else if (state == AppLifecycleState.paused) {
      pauseTimers();
    }
    super.didChangeAppLifecycleState(state);
  }
}
