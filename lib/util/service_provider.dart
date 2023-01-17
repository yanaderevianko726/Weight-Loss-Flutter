import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:women_workout/util/pref_data.dart';

import '../models/DayModel.dart';
import '../models/DietCategoryModel.dart';
import '../models/home_workout.dart';
import '../models/model_add_day_complete.dart';
import '../models/model_add_week.dart';
import '../models/model_all_challenges.dart';
import '../models/model_all_workout_category.dart';
import '../models/model_detail_exercise_list.dart';
import '../models/model_discover.dart';
import '../models/model_dummy_send.dart';
import '../models/model_exercise_week.dart';
import '../models/model_exrecise_days.dart';
import '../models/model_get_custom_plan.dart';
import '../models/model_get_custom_plan_exercise.dart';
import '../models/model_quick_workout.dart';
import '../models/model_stretches.dart';
import '../models/model_workout_history.dart';
import '../models/setting_model.dart';
import '../models/userdetail_model.dart';
import '../routes/app_routes.dart';
import 'constant_url.dart';
import 'package:http/http.dart' as http;

Future<ModelAllChallenge?> getAllChallenge(BuildContext context) async {
  var response = await ConstantUrl.getCallService(context,
      serviceName: ConstantUrl.urlGetAllChallenge, function: (data) {});

  ConstantUrl.checkNullResponse(response);

  return ModelAllChallenge.fromJson(jsonDecode(response));
}

Future<ModelGetCustomPlan?> getCustomPlan(BuildContext context) async {
  var response = await ConstantUrl.getCallService(context,
      serviceName: ConstantUrl.urlGetCustomPlan, function: (data) {});

  ConstantUrl.checkNullResponse(response);

  return ModelGetCustomPlan.fromJson(jsonDecode(response));
}

Future<ModelGetCustomPlanExercise?> getCustomPlanExercise(
  BuildContext context,
) async {
  String customPlanId = await PrefData.getCustomPlanId();
  var response = await ConstantUrl.getCallService(context,
      serviceName: ConstantUrl.urlGetCustomPlanExercise,
      function: (data) {},
      data: {ConstantUrl.paramCustomPlanId: customPlanId});

  ConstantUrl.checkNullResponse(response);

  return ModelGetCustomPlanExercise.fromJson(jsonDecode(response));
}

Future<ModelSetting?> getSetting(BuildContext context) async {
  var response = await ConstantUrl.getCallService(context,
      serviceName: ConstantUrl.urlSetting, function: (data) {});

  ConstantUrl.checkNullResponse(response);

  return ModelSetting.fromJson(jsonDecode(response));
}

Future<ModelAllWorkout?> getYogaWorkout(BuildContext context) async {
  var response = await ConstantUrl.getCallService(context,
      serviceName: ConstantUrl.urlGetAllWorkout, function: (data) {});

  ConstantUrl.checkNullResponse(response);

  return ModelAllWorkout.fromJson(jsonDecode(response));
}

Future<ModelExerciseWeek?> getChallengeWeek(
    BuildContext context, String challengeId) async {
  var response = await ConstantUrl.getCallService(context,
      serviceName: ConstantUrl.urlGetChallengeWeek,
      function: (data) {},
      data: {ConstantUrl.paramChallengeId: challengeId});

  ConstantUrl.checkNullResponse(response);

  return ModelExerciseWeek.fromJson(jsonDecode(response));
}

Future<ModelExerciseDays?> getChallengeDay(
    BuildContext context, String weekId) async {
  var response = await ConstantUrl.getCallService(context,
      serviceName: ConstantUrl.urlGetChallengeDays,
      function: (data) {},
      data: {ConstantUrl.paramChallengeWeekId: weekId});

  ConstantUrl.checkNullResponse(response);

  return ModelExerciseDays.fromJson(jsonDecode(response));
}

Future<ModelDetailExerciseList?> getChallengeDetailExerciseList(
    BuildContext context, String daysIdGet) async {
  var response = await ConstantUrl.getCallService(context,
      serviceName: ConstantUrl.urlGetChallengeExercise,
      function: (data) {},
      data: {ConstantUrl.paramDaysId: daysIdGet});

  ConstantUrl.checkNullResponse(response);

  return ModelDetailExerciseList.fromJson(jsonDecode(response));
}

Future<AddWeekModel?> addComplete(BuildContext context, String weekId) async {
  var response = await ConstantUrl.getCallService(context,
      serviceName: ConstantUrl.urlAddCompleteWeek,
      function: (data) {},
      data: {ConstantUrl.paramChallengeWeekId: weekId});

  ConstantUrl.checkNullResponse(response);

  return AddWeekModel.fromJson(jsonDecode(response));
}

Future<AddDayComplete?> addDayComplete(
    BuildContext context, String dayId, String weekID) async {
  var response = await ConstantUrl.getCallService(context,
      serviceName: ConstantUrl.urlAddCompleteDay,
      function: (data) {},
      data: {ConstantUrl.varDaysId: dayId, ConstantUrl.varWeekId: weekID});

  ConstantUrl.checkNullResponse(response);

  return AddDayComplete.fromJson(jsonDecode(response));
}

DateFormat addDateFormat = DateFormat("yyyy-MM-dd", "en-US");

Future<bool?> addWholeHistory(BuildContext context, double cal, int second,
    String workoutType, String id) async {
  Map data = await ConstantUrl.getCommonParams();
  data[ConstantUrl.paramKcal] = cal.toString();
  data[ConstantUrl.paramCompleteDuration] = second.toString();
  data[ConstantUrl.paramCompleteDate] = addDateFormat.format(DateTime.now());
  data[ConstantUrl.paramWorkoutType] = workoutType;
  data[ConstantUrl.paramWorkoutId] = id;

  print("addWholeHistory---id--$id");

  final response =
      await http.post(Uri.parse(ConstantUrl.urlAddHistory), body: data);

  print(
      "addWholeHistory---12--${response.body}===${response.statusCode}----${addDateFormat.format(DateTime.now())}");

  return true;
}

Future<HomeWorkout?> getHomeWorkoutData(BuildContext context) async {
  var response = await ConstantUrl.getCallService(context,
      serviceName: ConstantUrl.urlGetHomeWorkout, function: (data) {});

  ConstantUrl.checkNullResponse(response);

  return HomeWorkout.fromJson(jsonDecode(response));
}

addHistoryData(BuildContext context, String title, String startTime,
    int totalDuration, double cal, String id, String date) async {
  getHomeWorkoutData(context).then((value) {
    int second = 0;
    double kcal = 0;
    int workout = 0;
    if (value != null && value.data!.success == 1) {
      Homeworkout homeWorkout = value.data!.homeworkout!;
      second = int.parse(homeWorkout.duration!);
      kcal = double.parse(homeWorkout.kcal!);
      workout = int.parse(homeWorkout.workouts!);
    }

    second = second + totalDuration;
    kcal = kcal + cal;
    workout = workout + 1;

    addHomeWorkoutData(context, workout, kcal, second);
  });
}

Future<HomeWorkout?> addHomeWorkoutData(
    BuildContext context, int workout, double cal, int second) async {
  var response = await ConstantUrl.getCallService(context,
      serviceName: ConstantUrl.urlAddHomeWorkout,
      function: (data) {},
      data: {
        ConstantUrl.paramWorkout: workout.toString(),
        ConstantUrl.paramKcal: cal.toString(),
        ConstantUrl.paramDuration: second.toString()
      });

  ConstantUrl.checkNullResponse(response);

  return HomeWorkout.fromJson(jsonDecode(response));
}

Future<ModelDetailExerciseList?> getExerciseList(
    BuildContext context, String categoryId) async {
  var response = await ConstantUrl.getCallService(context,
      serviceName: ConstantUrl.urlGetWorkoutExercise,
      function: (data) {},
      data: {ConstantUrl.varCatId: categoryId});

  ConstantUrl.checkNullResponse(response);

  return ModelDetailExerciseList.fromJson(jsonDecode(response));
}

Future<ModelDiscover?> getAllDiscover(BuildContext context) async {
  var response = await ConstantUrl.getCallService(context,
      serviceName: ConstantUrl.urlGetAllDiscover, function: (data) {});

  ConstantUrl.checkNullResponse(response);

  return ModelDiscover.fromJson(jsonDecode(response));
}

Future<ModelQuickWorkout?> getAllYogaStyleWorkout(BuildContext context) async {
  var response = await ConstantUrl.getCallService(context,
      serviceName: ConstantUrl.urlGetAllQuickWorkout, function: (data) {});

  ConstantUrl.checkNullResponse(response);

  return ModelQuickWorkout.fromJson(jsonDecode(response));
}

Future<ModelStretches?> getAllStretch(BuildContext context) async {
  var response = await ConstantUrl.getCallService(context,
      serviceName: ConstantUrl.urlGetAllStretches, function: (data) {});

  ConstantUrl.checkNullResponse(response);

  return ModelStretches.fromJson(jsonDecode(response));
}

Future<WorkoutHistoryModel?> getAllWorkoutHistory(
    BuildContext context, String date) async {
  String deviceId = await ConstantUrl.getDeviceId();
  String s = await PrefData.getUserDetail();

  if (s.isNotEmpty) {
    UserDetail userDetail = await ConstantUrl.getUserDetail();
    String session = await PrefData.getSession();

    Map data = {
      ConstantUrl.paramSession: session,
      ConstantUrl.paramUserId: userDetail.userId,
      ConstantUrl.paramDeviceId: deviceId,
      ConstantUrl.paramCompleteDate: date,
    };

    final response = await http
        .post(Uri.parse(ConstantUrl.urlGetWorkoutCompleted), body: data);

    if (response.body.isEmpty) {
      return null;
    }
    var value = WorkoutHistoryModel.fromJson(jsonDecode(response.body));
    checkLoginError(context, value.data!.error!);

    return value;
  } else {
    return null;
  }
}

Future<ModelDetailExerciseList> getDetailExerciseList(
    BuildContext context, ModelDummySend dummySend) async {
  var response = await ConstantUrl.getCallService(context,
      serviceName: dummySend.serviceName,
      function: (data) {},
      data: {dummySend.sendParam: dummySend.id});

  ConstantUrl.checkNullResponse(response);

  return ModelDetailExerciseList.fromJson(jsonDecode(response));
}

Future<DietCategoryModel?> getDietCategoryList(BuildContext context) async {
  var response = await ConstantUrl.getCallService(context,
      serviceName: ConstantUrl.urlDietCategoryPlan, function: (data) {});

  ConstantUrl.checkNullResponse(response);

  return DietCategoryModel.fromJson(jsonDecode(response));
}

Future<DayModel?> getDietDayList(BuildContext context, String id) async {
  var response = await ConstantUrl.getCallService(context,
      serviceName: ConstantUrl.urlDietCategoryDay,
      function: (data) {},
      data: {ConstantUrl.paramDietCategoryId: id});

  ConstantUrl.checkNullResponse(response);

  return DayModel.fromJson(jsonDecode(response));
}

checkLoginError(BuildContext context, String s) {
  if (s == "Please login first") {
    PrefData.setSession("");
    PrefData.setIsSignIn(false);
    Get.toNamed(Routes.signInRoute);
  }
}
