import 'dart:convert';
import 'dart:math';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/routes/app_routes.dart';
import 'package:women_lose_weight_flutter/utils/preference.dart';
import 'package:women_lose_weight_flutter/utils/utils.dart';

import '../../../common/bottomsheet/bottom_sheet_ex_detail.dart';
import '../../../database/custom_classes/custom_classes.dart';
import '../../../database/table/home_plan_table.dart';
import '../../../google_ads/ad_helper.dart';
import '../../../utils/color.dart';
import '../../../utils/constant.dart';
import '../../../utils/debug.dart';

class ExerciseListController extends GetxController
    with GetSingleTickerProviderStateMixin, GetTickerProviderStateMixin {
  ScrollController? scrollController;
  bool lastStatus = true;

  dynamic arguments = Get.arguments;

  HomePlanTable? workoutPlanData;
  int currentPlanIndex = 0;

  List<Animation<int>> listOfAnimation = [];
  List<AnimationController> listOfAnimationController = [];
  List<HomeExTableClass> exerciseList = [];
  List<HomeExTableClass> exerciseListOriginal = [];
  List<int> listOfImagesCount = [];

  String? isFrom;

  PWeekDayData? weeklyDaysData;

  bool isAnyCompleted = false;
  bool isAllCompleted = false;
  double offset = 0.0;

  RewardedAd? _rewardedAd;

  void _loadRewardedAd() {
    if (Debug.googleAd && !Utils.isPurchased()) {
      RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                _rewardedAd = null;
                _loadRewardedAd();
              },
            );

            _rewardedAd = ad;
          },
          onAdFailedToLoad: (err) {
            Debug.printLog('Failed to load a rewarded ad: ${err.message}');
          },
        ),
      );
    }
  }

  onClickUnlockOnce() {
    if (_rewardedAd != null && Debug.googleAd && !Utils.isPurchased()) {
      _rewardedAd?.show(
        onUserEarnedReward: (adWithoutView, reward) {
          Get.back();
        },
      );
    } else {
      Get.back();
    }
  }

  @override
  void onInit() {
    _loadRewardedAd();
    // Future.delayed(const Duration(milliseconds: 1), () {
    //   if (!Utils.isPurchased()) {
    //     showDialog(
    //       useSafeArea: false,
    //       context: Get.context!,
    //       builder: (BuildContext context) {
    //         return WatchAdDialog();
    //       },
    //     );
    //   }
    // });
    scrollController = ScrollController();
    scrollController!.addListener(() {
      offset = scrollController!.offset;
      _scrollListener();
    });
    _getArgumentData();
    _getPreferenceData();
    _getDataFromDataBase();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController!.removeListener(_scrollListener);
    for (int i = 0; i < listOfAnimationController.length; i++) {
      listOfAnimationController[i].dispose();
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      super.onClose();
    });
  }

  @override
  void dispose() {
    scrollController!.removeListener(_scrollListener);
    _rewardedAd?.dispose();
    for (int i = 0; i < listOfAnimationController.length; i++) {
      listOfAnimationController[i].dispose();
    }
    Future.delayed(const Duration(milliseconds: 200), () {
      super.dispose();
    });
  }

  bool get isShrink {
    return scrollController!.hasClients && offset > (100 - kToolbarHeight);
  }

  _scrollListener() {
    if (isShrink != lastStatus) {
      lastStatus = isShrink;
      update([Constant.idExerciseSliverAppBar]);
    }
  }

  _getArgumentData() {
    if (arguments != null) {
      if (arguments[0] != null) {
        workoutPlanData = arguments[0];
      }

      if (arguments[1] != null) {
        isFrom = arguments[1];
      }

      if (arguments[2] != null) {
        weeklyDaysData = arguments[2];
      }
    }
  }

  _getPreferenceData() {
    currentPlanIndex =
        Preference.shared.getInt(Preference.selectedPlanIndex) ?? 0;
  }

  _getDataFromDataBase() async {
    for (var element in listOfAnimationController) {
      element.dispose();
    }
    listOfImagesCount.clear();
    listOfAnimation.clear();
    listOfAnimationController.clear();
    if (workoutPlanData != null) {
      if (workoutPlanData!.planDays == Constant.planDaysYes) {
        if (weeklyDaysData != null) {
          exerciseList = await DBHelper.dbHelper
              .getDayExList(weeklyDaysData!.dayId.toString());
          exerciseListOriginal.addAll(exerciseList);
        }
      } else if (isFrom != null && isFrom == Constant.fromFastWorkout) {
        exerciseList = await DBHelper.dbHelper
            .getHomeDetailExList(workoutPlanData!.planId.toString());

        Map<String, HomeExTableClass> newExerciseList = {};
        int i = 0;
        while (i <
            (int.parse((workoutPlanData!.planMinutes ?? "2").toString())) * 2) {
          int randomIndex = Random().nextInt(exerciseList.length);
          // Debug.printLog("random -->>" + randomIndex.toString());
          var item = exerciseList[randomIndex];
          if (!(newExerciseList.containsKey(item.dayExId.toString()))) {
            i++;
            // Debug.printLog("add $i -->> " + randomIndex.toString());
            newExerciseList.putIfAbsent(item.dayExId.toString(), () => item);
          }
        }
        exerciseList.clear();
        exerciseList.addAll(newExerciseList.values.toList());
      } else {
        exerciseList = await DBHelper.dbHelper
            .getHomeDetailExList(workoutPlanData!.planId.toString());
        exerciseListOriginal.addAll(exerciseList);
      }

      exerciseList.removeWhere((element) => element.isDeleted == "1");

      isAnyCompletedEx();
      isAllCompletedEx();

      exerciseList.sort((a, b) => a.planSort!.compareTo(b.planSort!));

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
      update([Constant.idExerciseList]);
    }
  }

  isAnyCompletedEx() {
    for (var item in exerciseList) {
      if (item.isCompleted != null) {
        if (item.isCompleted == "1") {
          isAnyCompleted = true;
        }
      }
    }
    update([Constant.idExerciseButtons]);
  }

  isAllCompletedEx() {
    for (var item in exerciseList) {
      if (item.isCompleted != null) {
        if (!(item.isCompleted == "1")) {
          isAllCompleted = false;
        } else {
          isAllCompleted = true;
        }
      }
    }
    update([Constant.idExerciseButtons]);
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

  getPlanImage() {
    return (workoutPlanData!.planImage ?? "butt_lift_tone") + ".webp";
  }

  getPlanName() {
    if (workoutPlanData != null) {
      if (workoutPlanData!.planDays == Constant.planDaysYes) {
        return "txtDay".tr + " " + weeklyDaysData!.dayName.toString();
      } else {
        return workoutPlanData!.planName ?? "";
      }
    }
  }

  getPlanDescription() {
    if (workoutPlanData != null) {
      if (workoutPlanData!.planDays == Constant.planDaysYes) {
        return workoutPlanData!.planName;
      } else {
        return workoutPlanData!.shortDes ?? "";
      }
    }
  }

  getShowAboutOption() {
    if (workoutPlanData!.introduction != null &&
        workoutPlanData!.introduction!.isNotEmpty) {
      if (workoutPlanData!.testDes != null &&
          workoutPlanData!.testDes!.isNotEmpty) {
        return Constant.boolValueTrue;
      }
    }
    return Constant.boolValueFalse;
  }

  getIntroductionDescription() {
    if (workoutPlanData!.introduction != null &&
        workoutPlanData!.introduction!.isNotEmpty) {
      return workoutPlanData!.introduction;
    }
    return "";
  }

  getWorkoutTime() {
    return (workoutPlanData!.planMinutes ?? "0") +
        " " +
        "txtMins".tr.toUpperCase();
  }

  getWorkoutLevel() {
    if (workoutPlanData!.planWorkouts == "0" &&
        workoutPlanData!.planLvl != null) {
      return Utils.getExerciseLevelString(workoutPlanData!.planLvl!)
          .toUpperCase();
    } else {
      return workoutPlanData!.planWorkouts! +
          " " +
          "txtWorkouts".tr.toUpperCase();
    }
  }

  onExerciseItemClick(int index) {
    onChangeSubPageViewPage(0);
    Get.bottomSheet(
      BottomSheetExDetails(
        exerciseList: exerciseList,
        listOfAnimation: listOfAnimation,
        listOfAnimationController: listOfAnimationController,
        index: index,
        isFromEdit: Constant.boolValueFalse,
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
    );
  }

  onGoButtonClick() {
    Get.toNamed(AppRoutes.performExercise, arguments: [
      workoutPlanData,
      exerciseList,
      listOfAnimation,
      listOfAnimationController,
      null,
      workoutPlanData!.planDays == Constant.planDaysYes ? weeklyDaysData : null,
    ])!
        .then((value) => _getDataFromDataBase());
  }

  onRestartButtonClick() async {
    if (workoutPlanData!.planDays == Constant.planDaysYes) {
      await DBHelper.dbHelper
          .restartPlanDayEx(weeklyDaysData!.dayId, Constant.boolValueTrue);
    } else {
      await DBHelper.dbHelper
          .restartPlanDayEx(workoutPlanData!.planId!, Constant.boolValueFalse);
    }
    onGoButtonClick();
  }

  onContinueButtonClick() {
    int? continuePos;
    for (int i = 0; i < exerciseList.length; i++) {
      if (!(exerciseList[i].isCompleted == "1")) {
        continuePos ??= i;
        break;
      }
    }

    Get.toNamed(AppRoutes.performExercise, arguments: [
      workoutPlanData,
      exerciseList,
      listOfAnimation,
      listOfAnimationController,
      continuePos,
      workoutPlanData!.planDays == Constant.planDaysYes ? weeklyDaysData : null,
    ])!
        .then((value) => _getDataFromDataBase());
  }

  /// BottomSheetExDetails Dialog Methods

  int subPageControllerCurrentPage = 0;

  PageController mainPageController = PageController();
  PageController subPageController = PageController();

  onChangeSubPageViewPage(value) {
    subPageControllerCurrentPage = value;
    update([Constant.idTabViewOfExerciseDialog]);
  }

  onEditClick() {
    Get.toNamed(AppRoutes.editPlan,
            arguments: [exerciseList, workoutPlanData, exerciseListOriginal])!
        .then((value) {
      _getDataFromDataBase();
    });
  }

  int? exTime;

  bool isShowResetWidget(String time, int dur) {
    exTime = int.parse(time);

    if (exTime == dur) {
      return false;
    } else {
      return true;
    }
  }
}
