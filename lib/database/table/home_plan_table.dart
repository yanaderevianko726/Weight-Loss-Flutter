import 'dart:convert';

import 'package:women_lose_weight_flutter/utils/constant.dart';

class  HomePlanTable {
  HomePlanTable({
    this.planId,
    this.planName,
    this.planNameEn,
    this.planNameEs,
    this.planProgress,
    this.planText,
    this.planLvl,
    this.planLvlEn,
    this.planLvlEs,
    this.planImage,
    this.planDays,
    this.days,
    this.planType,
    this.sort,
    this.planWorkouts,
    this.planMinutes,
    this.shortDes,
    this.shortDesEn,
    this.shortDesEs,
    this.introduction,
    this.introductionEn,
    this.introductionEs,
    this.isPro,
    this.hasSubPlan,
    this.testDes,
    this.testDesEn,
    this.testDesEs,
    this.planThumbnail,
    this.parentPlanId,
    this.planTypeImage,
  });

  int? planId;
  String? planName;
  String? planNameEn;
  String? planNameEs;
  String? planProgress;
  String? planText;
  String? planLvl;
  String? planLvlEn;
  String? planLvlEs;
  String? planImage;
  String? planDays;
  int? days;
  String? planType;
  int? sort;
  String? planWorkouts;
  String? planMinutes;
  String? shortDes;
  String? shortDesEn;
  String? shortDesEs;
  String? introduction;
  String? introductionEn;
  String? introductionEs;
  bool? isPro;
  bool? hasSubPlan;
  String? testDes;
  String? testDesEn;
  String? testDesEs;
  String? planThumbnail;
  String? parentPlanId;
  String? planTypeImage;

  factory HomePlanTable.fromRawJson(String str) =>
      HomePlanTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HomePlanTable.fromJson(Map<String, dynamic> json) => HomePlanTable(
        planId: json["PlanId"],
        planName: json["PlanName"],
        planNameEn: json["PlanName_en"],
        planNameEs: json["PlanName_es"],
        planProgress: json["PlanProgress"],
        planText: json["PlanText"],
        planLvl: json["PlanLvl"],
        planLvlEn: json["PlanLvl_en"],
        planLvlEs: json["PlanLvl_es"],
        planImage: json["PlanImage"],
        planDays: json["PlanDays"],
        days: json["Days"],
        planType: json["PlanType"],
        sort: json["sort"],
        planWorkouts: json["PlanWorkouts"],
        planMinutes: json["PlanMinutes"],
        shortDes: json["ShortDes"],
        shortDesEn: json["ShortDes_en"],
        shortDesEs: json["ShortDes_es"],
        introduction: json["Introduction"],
        introductionEn: json["Introduction_en"],
        introductionEs: json["Introduction_es"],
        isPro: json["IsPro"] == Constant.boolValueTrue.toString(),
        hasSubPlan: json["HasSubPlan"] == Constant.boolValueTrue.toString(),
        testDes: json["TestDes"],
        testDesEn: json["TestDes_en"],
        testDesEs: json["TestDes_es"],
        planThumbnail: json["PlanThumbnail"],
        parentPlanId: json["ParentPlanId"],
        planTypeImage: json["PlanTypeImage"],
      );

  Map<String, dynamic> toJson() => {
        "PlanId": planId,
        "PlanName": planName,
        "PlanName_en": planNameEn,
        "PlanName_es": planNameEs,
        "PlanProgress": planProgress,
        "PlanText": planText,
        "PlanLvl": planLvl,
        "PlanLvl_en": planLvlEn,
        "PlanLvl_es": planLvlEs,
        "PlanImage": planImage,
        "PlanDays": planDays,
        "Days": days,
        "PlanType": planType,
        "sort": sort,
        "PlanWorkouts": planWorkouts,
        "PlanMinutes": planMinutes,
        "ShortDes": shortDes,
        "ShortDes_en": shortDesEn,
        "ShortDes_es": shortDesEs,
        "Introduction": introduction,
        "Introduction_en": introductionEn,
        "Introduction_es": introductionEs,
        "IsPro": isPro,
        "HasSubPlan": hasSubPlan,
        "TestDes": testDes,
        "TestDes_en": testDesEn,
        "TestDes_es": testDesEs,
        "PlanThumbnail": planThumbnail,
        "ParentPlanId": parentPlanId,
        "PlanTypeImage": planTypeImage,
      };
}
