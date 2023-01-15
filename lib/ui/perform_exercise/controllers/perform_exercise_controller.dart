import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/database/table/history_table.dart';
import 'package:women_lose_weight_flutter/main.dart';
import 'package:women_lose_weight_flutter/routes/app_routes.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/debug.dart';
import 'package:women_lose_weight_flutter/utils/preference.dart';
import 'package:women_lose_weight_flutter/utils/utils.dart';
import '../../../common/bottomsheet/bottom_sheet_ex_detail.dart';
import '../../../common/count_down_timer/circular_count_down_timer.dart';
import '../../../common/dialog/quite_workout/quite_workout.dart';
import '../../../database/custom_classes/custom_classes.dart';
import '../../../database/table/home_plan_table.dart';
import '../../../google_ads/ad_helper.dart';
import '../../../utils/color.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PerformExerciseController extends FullLifeCycleController
    with
        GetSingleTickerProviderStateMixin,
        GetTickerProviderStateMixin,
        WidgetsBindingObserver {
  CountDownController countDownController = CountDownController();

  bool isCompletedCountDown = false;
  int currentPos = 0;
  HomeExTableClass? currentExe;
  List<Animation<int>> listOfAnimation = [];
  List<AnimationController> listOfAnimationController = [];

  double buttonProgressValue = 0;
  double buttonProgressTime = 0;

  int exTime = 0;
  int stopExTime = 0;

  dynamic arguments = Get.arguments;

  HomePlanTable? workoutPlanData;
  List<HomeExTableClass> exerciseList = [];

  Timer? _timer;

  bool isMute = Constant.boolValueFalse;

  Timer? totalExTimer;
  int totalExTime = 0;
  int lastTotalExTime = 0;

   PWeekDayData? weeklyDaysData;

  InterstitialAd? _interstitialAd;

  int getCountShowAd = 0;
  bool isFromCompleted = true;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              if (isFromCompleted) {
                _moveToCompetedScreen();
              } else {
                _moveToQuite();
              }
            },
          );
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (err) {
          Debug.printLog('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void onInit() {
    addBindingObserver();
    _loadInterstitialAd();
    _argumentData();
    getPreferenceData();
    super.onInit();
  }

  addBindingObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  removeBindingObserver() {
    WidgetsBinding.instance.removeObserver(this);
  }

  _startTotalExTimer() {
    totalExTime = lastTotalExTime;
    totalExTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      totalExTime = totalExTime + 1;
      Debug.printLog("totalExTime -->> " + totalExTime.toString());
    });
  }

  getPreferenceData() {
    isMute = Preference.shared.getBool(Preference.soundOptionMute) ??
        Constant.boolValueFalse;
    update([Constant.idPerformSoundOptionMute]);
  }

  String formatDDHHMMSS(int seconds, {String returnType = ""}) {
    int days = ((seconds / 3600) / 24).truncate();
    int hours = ((seconds / 3600) % 24).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String daysStr = (days).toString().padLeft(2, '0');
    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (returnType == Constant.days) {
      return daysStr;
    } else if (returnType == Constant.hours) {
      return hoursStr;
    } else if (returnType == Constant.minute) {
      return minutesStr;
    } else if (returnType == Constant.seconds) {
      return secondsStr;
    } else {
      return "00";
    }
  }

  _argumentData() {
    if (arguments != null) {
      if (arguments[4] != null) {
        currentPos = arguments[4];
        Debug.printLog("currentPos -->>" + currentPos.toString());
      }

      if (arguments[0] != null) {
        workoutPlanData = arguments[0];
        Debug.printLog(
            "workoutPlanData -->>" + workoutPlanData!.toJson().toString());
      }

      if (arguments[1] != null) {
        exerciseList = arguments[1];
        Debug.printLog("exerciseList -->>" + exerciseList.toList().toString());
        setCurrentExe(currentPos);
      }

      if (arguments[2] != null) {
        listOfAnimation = arguments[2];
        Debug.printLog(
            "listOfAnimation -->>" + listOfAnimation.toList().toString());
        setCurrentExe(currentPos);
      }

      if (arguments[3] != null) {
        listOfAnimationController = arguments[3];
        Debug.printLog("listOfAnimationController -->>" +
            listOfAnimationController.toList().toString());
        setCurrentExe(currentPos);
      }

      if (arguments[5] != null) {
        weeklyDaysData = arguments[5];
        Debug.printLog("weeklyDaysData -->>" + weeklyDaysData.toString());
        setCurrentExe(currentPos);
      }
    }
  }

  countDownTimerFinish() {
    isCompletedCountDown = Constant.boolValueTrue;
    update([Constant.idCountDownTimerExercise]);
    startPerformExercise();
  }

  int lastChangeCountDownTimerValue = 0;

  countDownTimerChange(String value) {
    if (int.parse(value) == Constant.countDownTimeSeconds ~/ 2) {
      Utils.textToSpeech("tts2".tr, MyApp.flutterTts);
    }

    if (int.parse(value) == 3 &&
        lastChangeCountDownTimerValue != int.parse(value)) {
      lastChangeCountDownTimerValue = int.parse(value);
      Utils.textToSpeech(value, MyApp.flutterTts);
    }

    if (int.parse(value) == 2 &&
        lastChangeCountDownTimerValue != int.parse(value)) {
      lastChangeCountDownTimerValue = int.parse(value);
      Utils.textToSpeech(value, MyApp.flutterTts);
    }

    if (int.parse(value) == 1 &&
        lastChangeCountDownTimerValue != int.parse(value)) {
      lastChangeCountDownTimerValue = int.parse(value);
      Utils.textToSpeech(value, MyApp.flutterTts);
    }
  }

  setCurrentExe(int pos) {
    currentExe = exerciseList[pos];

    if (pos == 0) {
      Utils.textToSpeech(
          "tts1".tr + Utils.getMultiLanguageString(currentExe!.exName!),
          MyApp.flutterTts);
    }
  }

  getExeName() {
    return Utils.getMultiLanguageString(currentExe!.exName!).toUpperCase();
  }

  startPerformExercise() {
    Utils.playSound("raw/whistle.wav");
    if (!(currentExe!.exUnit == Constant.workoutTypeStep)) {
      _startTotalExTimer();
      changeButtonProgressValue();
      Utils.textToSpeech(
          "tts3".tr +
              " ${currentExe!.exTime} " +
              "tts4".tr +
              " ${Utils.getMultiLanguageString(currentExe!.exName!)}",
          MyApp.flutterTts);
    }
  }

  changeButtonProgressValue() {
    var increaseButtonValue = 1 / int.parse(currentExe!.exTime!);
    buttonProgressValue = buttonProgressTime;
    buttonProgressTime = 0;

    if (stopExTime != 0) {
      exTime = stopExTime;
    } else {
      exTime = int.parse(exerciseList[currentPos].exTime!);
    }
    stopExTime = 0;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (exTime == ((int.parse(exerciseList[currentPos].exTime!) ~/ 2) + 1)) {
        Utils.textToSpeech("tts5".tr, MyApp.flutterTts);
      }

      if (exTime == 4) {
        Utils.textToSpeech((exTime - 1).toString(), MyApp.flutterTts);
      }

      if (exTime == 3) {
        Utils.textToSpeech((exTime - 1).toString(), MyApp.flutterTts);
      }

      if (exTime == 2) {
        Utils.textToSpeech((exTime - 1).toString(), MyApp.flutterTts);
      }

      if (buttonProgressValue <= 1) {
        buttonProgressValue = buttonProgressValue + increaseButtonValue;
        exTime = exTime - 1;

        Debug.printLog("buttonProgressValue -->> $buttonProgressValue");
        update([Constant.idButtonProgressValue, Constant.idPerformExTime]);
      } else {
        _timer!.cancel();
        onSkipButtonClick();
      }
    });
  }

  pauseTimers() {
    if (!isCompletedCountDown) {
      countDownController.pause();
    }
    if (_timer != null) {
      _timer!.cancel();
      buttonProgressTime = buttonProgressValue;
      stopExTime = exTime;
    }
    if (totalExTimer != null) {
      totalExTimer!.cancel();
      lastTotalExTime = totalExTime;
    }
  }

  resumeTimers() {
    if (!isCompletedCountDown) {
      countDownController.resume();
    } else {
      _startTotalExTimer();
      changeButtonProgressValue();
    }
  }

  onSkipButtonClick() {
    if (_timer != null) _timer!.cancel();
    if (workoutPlanData!.planDays == Constant.planDaysYes) {
      DBHelper.dbHelper
          .updateCompleteExByDayExId(currentExe!.dayExId!.toString());
    } else {
      DBHelper.dbHelper
          .updateCompleteHomeExByDayExId(currentExe!.dayExId!.toString());
    }
    if (currentPos != exerciseList.length - 1) {
      removeBindingObserver();
      Get.toNamed(AppRoutes.rest, arguments: [
        currentPos,
        exerciseList,
        listOfAnimation,
        listOfAnimationController,
        workoutPlanData,
      ])!
          .then((value) {
        if (value != null) {
          addBindingObserver();
          workoutPlanData = value[0];
          exerciseList = value[1];
          listOfAnimation = value[2];
          listOfAnimationController = value[3];
          currentPos = value[4];

          setCurrentExe(currentPos);

          buttonProgressValue = 0.0;
          buttonProgressTime = 0.0;

          exTime = 0;
          stopExTime = 0;

          if (totalExTimer != null) {
            totalExTimer!.cancel();
            lastTotalExTime = totalExTime;
          }
          startPerformExercise();

          update([
            Constant.idTimerAndProgress,
            Constant.idPerformExName,
            Constant.idPerformExProgress
          ]);
        }
      });
    } else {
      removeBindingObserver();
      if (totalExTimer != null) {
        totalExTimer!.cancel();
      }
      Get.back();
      Utils.textToSpeech("tts9".tr, MyApp.flutterTts);

      isFromCompleted = true;
      if (_interstitialAd != null && Debug.googleAd && !Utils.isPurchased()) {
        _interstitialAd?.show();
      } else {
        _moveToCompetedScreen();
      }

      if (workoutPlanData!.planDays == Constant.planDaysYes) {
        Utils.setLastCompletedDay(
            Utils.getPlanId(), int.parse(weeklyDaysData!.dayName));
      }
    }
  }

  _moveToCompetedScreen() {
    Get.toNamed(AppRoutes.completed, arguments: [
      workoutPlanData,
      exerciseList,
      totalExTime,
      listOfAnimation,
      listOfAnimationController,
      weeklyDaysData,
    ]);
  }

  onPreviousButtonClick() {
    if (currentPos != 0) {
      if (_timer != null) _timer!.cancel();
      removeBindingObserver();
      Get.toNamed(AppRoutes.rest, arguments: [
        currentPos - 2,
        exerciseList,
        listOfAnimation,
        listOfAnimationController,
        workoutPlanData,
      ])!
          .then((value) {
        if (value != null) {
          addBindingObserver();
          workoutPlanData = value[0];
          exerciseList = value[1];
          listOfAnimation = value[2];
          listOfAnimationController = value[3];
          currentPos = value[4];

          setCurrentExe(currentPos);

          buttonProgressValue = 0.0;
          buttonProgressTime = 0.0;

          exTime = 0;
          stopExTime = 0;

          if (totalExTimer != null) {
            totalExTimer!.cancel();
            lastTotalExTime = totalExTime;
          }
          startPerformExercise();

          update([
            Constant.idTimerAndProgress,
            Constant.idPerformExName,
            Constant.idPerformExProgress
          ]);
        }
      });
    }
  }

  onBackButtonClick() {
    removeBindingObserver();
    pauseTimers();
    Utils.textToSpeech("txtQuitExMsg".tr, MyApp.flutterTts);
    showDialog(
      context: Get.context!,
      builder: (context) => QuiteWorkout(),
    ).then((value) {
      if (value != null) {
        if (value[0]) {
          resumeTimers();
        } else {
          pauseTimers();
        }
      }
    });
  }

  onPauseButtonClick(int index) {
    pauseTimers();
    removeBindingObserver();
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

  onWorkOutInfoClick(int index) {
    pauseTimers();
    removeBindingObserver();
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

  onVideoClick(int index) {
    pauseTimers();
    removeBindingObserver();
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

  onCommonQuestionClick() {
    pauseTimers();
    removeBindingObserver();
    Get.toNamed(AppRoutes.commonQuestions)!.then((value) {
      resumeTimers();
    });
  }

  onQuiteButtonClick() async {
    var calValue = Constant.secDurationCal * totalExTime;

    DBHelper.dbHelper.addHistory(
      HistoryTable(
        hid: DateTime.now().millisecondsSinceEpoch,
        hPlanId: exerciseList[0].planId.toString(),
        hPlanName: await DBHelper.dbHelper
            .getPlanNameByPlanId(exerciseList[0].planId!),
        hDateTime:
            (DateFormat(Constant.dateTime24Format).format(DateTime.now())),
        hCompletionTime: totalExTime.toString(),
        hBurnKcal: calValue.toString(),
        hTotalEx: exerciseList.length.toString(),
        hKg: (Preference.shared.getInt(Preference.currentWeightInKg) ??
                Constant.weightKg)
            .toString(),
        hFeet: '5',
        hInch: '5',
        hFeelRate: "0",
        hDayName: await DBHelper.dbHelper
            .getPlanDayNameByDayId(exerciseList[0].dayId!),
        hDayId: exerciseList[0].dayId,
        status: Constant.statusSyncPending,
      ),
    );

    getCountShowAd =
        Preference.shared.getInt(Preference.interstitialAdCount) ??
            1;
    isFromCompleted = false;
    if (getCountShowAd.isEven) {
      if (_interstitialAd != null && Debug.googleAd && !Utils.isPurchased()) {
        _interstitialAd?.show();
      } else {
        _moveToQuite();
      }
    } else {
      _moveToQuite();
    }
  }

  _moveToQuite() {
    Preference.shared
        .setInt(Preference.interstitialAdCount, getCountShowAd + 1);
    Get.back();
    Get.back();
  }

  @override
  void dispose() {
    for (int i = 0; i < listOfAnimationController.length; i++) {
      listOfAnimationController[i].dispose();
    }
    if (_timer != null) _timer!.cancel();
    if (totalExTimer != null) totalExTimer!.cancel();
    removeBindingObserver();
    _interstitialAd?.dispose();
    super.dispose();
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
