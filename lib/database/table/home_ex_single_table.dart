import 'dart:convert';

class HomeExSingleTable {
  HomeExSingleTable({
    this.id,
    this.planId,
    this.dayId,
    this.exId,
    this.exTime,
    this.isCompleted,
    this.updatedExTime,
    this.replaceExId,
    this.sort,
    this.defaultSort,
    this.exUnit,
    this.isDeleted,
    this.status,
  });

  int? id;
  String? planId;
  String? dayId;
  String? exId;
  String? exTime;
  int? isCompleted;
  String? updatedExTime;
  String? replaceExId;
  int? sort;
  int? defaultSort;
  String? exUnit;
  String? isDeleted;
  int? status;

  factory HomeExSingleTable.fromRawJson(String str) =>
      HomeExSingleTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HomeExSingleTable.fromJson(Map<String, dynamic> json) =>
      HomeExSingleTable(
        id: json["Id"],
        planId: json["PlanId"],
        dayId: json["DayId"],
        exId: json["ExId"],
        exTime: json["ExTime"],
        isCompleted: json["IsCompleted"],
        updatedExTime: json["UpdatedExTime"],
        replaceExId: json["ReplaceExId"],
        sort: json["sort"],
        defaultSort: json["DefaultSort"],
        exUnit: json["ExUnit"],
        isDeleted: json["IsDeleted"],
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "PlanId": planId,
        "DayId": dayId,
        "ExId": exId,
        "ExTime": exTime,
        "IsCompleted": isCompleted,
        "UpdatedExTime": updatedExTime,
        "ReplaceExId": replaceExId,
        "sort": sort,
        "DefaultSort": defaultSort,
        "ExUnit": exUnit,
        "IsDeleted": isDeleted,
        "Status": status,
      };
}
