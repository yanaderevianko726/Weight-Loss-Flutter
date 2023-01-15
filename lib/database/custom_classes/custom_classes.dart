import 'dart:convert';

import 'package:women_lose_weight_flutter/database/table/history_table.dart';

class PWeeklyDayData {
  dynamic workoutId;
  dynamic dayId;
  dynamic dayName;
  dynamic weekName;
  dynamic isCompleted;
  dynamic categoryName;
  bool flagPrevDay = true;
  List<PWeekDayData>? arrWeekDayData;

  PWeeklyDayData(
      {this.workoutId,
      this.dayId,
      this.dayName,
      this.weekName,
      this.isCompleted,
      this.categoryName,
      this.arrWeekDayData});

  factory PWeeklyDayData.fromRawJson(String str) =>
      PWeeklyDayData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PWeeklyDayData.fromJson(Map<String, dynamic> json) => PWeeklyDayData(
        workoutId: json["PlanId"],
        dayId: json["DayId"],
        dayName: json["DayName"],
        weekName: json["WeekName"],
        isCompleted: json["IsCompleted"],
        categoryName: json["CategoryName"],
        arrWeekDayData: json["ArrWeekDayData"] == null
            ? null
            : List<PWeekDayData>.from(
                json["ArrWeekDayData"].map((x) => PWeekDayData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "PlanId": workoutId,
        "DayId": dayId,
        "DayName": dayName,
        "WeekName": weekName,
        "IsCompleted": isCompleted,
        "CategoryName": categoryName,
        "ArrWeekDayData": arrWeekDayData == null
            ? null
            : List<dynamic>.from(arrWeekDayData!.map((x) => x.toJson())),
      };
}

class PWeekDayData {
  dynamic dayId;
  dynamic dayName;
  String? workouts;
  String? minutes;
  dynamic isCompleted;

  PWeekDayData(
      {this.dayId,
      this.dayName,
      this.workouts,
      this.minutes,
      this.isCompleted});

  factory PWeekDayData.fromJson(Map<String, dynamic> json) => PWeekDayData(
        dayId: json["DayId"],
        dayName: json["DayName"],
        workouts: json["PlanWorkouts"],
        minutes: json["PlanMinutes"],
        isCompleted: json["IsCompleted"],
      );

  Map<String, dynamic> toJson() => {
        "DayId": dayId,
        "DayName": dayName,
        "PlanWorkouts": workouts,
        "PlanMinutes": minutes,
        "IsCompleted": isCompleted,
      };
}

class HomeExTableClass {
  int? dayExId;
  String? planId;
  String? dayId;
  String? exId;
  String? exTime;
  String? isCompleted;
  String? isDeleted;
  String? updatedExTime;
  String? replaceExId;
  String? exName;
  String? exUnit;
  String? exPath;
  String? exDescription;
  String? exVideo;
  int? planSort;
  int? defaultPlanSort;

  HomeExTableClass({
    this.dayExId,
    this.planId,
    this.dayId,
    this.exId,
    this.exTime,
    this.isCompleted,
    this.isDeleted,
    this.updatedExTime,
    this.replaceExId,
    this.exName,
    this.exUnit,
    this.exPath,
    this.exDescription,
    this.exVideo,
    this.planSort,
    this.defaultPlanSort,
  });

  factory HomeExTableClass.fromJson(Map<String, dynamic> json) =>
      HomeExTableClass(
        dayExId: json["Id"],
        planId: json["PlanId"],
        dayId: json["DayId"],
        exId: json["ExId"],
        exTime: json["ExTime"],
        isCompleted: json["IsCompleted"].toString(),
        isDeleted: json["IsDeleted"],
        updatedExTime: json["UpdatedExTime"],
        replaceExId: json["ReplaceExId"],
        exName: json["ExName"],
        exUnit: json["ExUnit"],
        exPath: json["ExPath"],
        exDescription: json["ExDescription"],
        exVideo: json["ExVideo"],
        planSort: json["sort"],
        defaultPlanSort: json["DefaultSort"],
      );

  Map<String, dynamic> toJson() => {
        "dayExId": dayExId,
        "planId": planId,
        "dayId": dayId,
        "exId": exId,
        "exTime": exTime,
        "isCompleted": isCompleted,
        "isDeleted": isDeleted,
        "updatedExTime": updatedExTime,
        "replaceExId": replaceExId,
        "exName": exName,
        "exUnit": exUnit,
        "exPath": exPath,
        "exDescription": exDescription,
        "exVideo": exVideo,
        "planSort": planSort,
        "defaultPlanSort": defaultPlanSort,
      };
}


class HistoryWeekData {
  HistoryWeekData({
    this.weekNumber,
    this.weekStart,
    this.weekEnd,
    this.totTime,
    this.totKcal,
    this.totWorkout,
    this.arrHistoryDetail,
  });

  String? weekNumber;
  String? weekStart;
  String? weekEnd;
  double? totTime;
  double? totKcal;
  int? totWorkout;

  List<HistoryTable>? arrHistoryDetail;

  factory HistoryWeekData.fromRawJson(String str) =>
      HistoryWeekData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HistoryWeekData.fromJson(Map<String, dynamic> json) =>
      HistoryWeekData(
        weekNumber: json["weekNumber"],
        weekStart: json["weekStart"],
        weekEnd: json["weekEnd"],
        totTime: json["totTime"],
        totKcal: json["totKcal"],
        totWorkout: json["totWorkout"],
        arrHistoryDetail: json["arrHistoryDetail"],
      );

  Map<String, dynamic> toJson() => {
    "weekNumber": weekNumber,
    "weekStart": weekStart,
    "weekEnd": weekEnd,
    "totTime": totTime,
    "totKcal": totKcal,
    "totWorkout": totWorkout,
    "arrHistoryDetail": arrHistoryDetail,
  };
}

