import 'dart:convert';

class DayExTable {
  DayExTable({
    this.id,
    this.planId,
    this.dayId,
    this.exId,
    this.exTime,
    this.exUnit,
    this.isCompleted,
    this.updatedExTime,
    this.replaceExId,
    this.isDeleted,
    this.sort,
    this.defaultSort,
    this.status,
  });

  int? id;
  String? planId;
  String? dayId;
  String? exId;
  String? exTime;
  String? exUnit;
  String? isCompleted;
  String? updatedExTime;
  String? replaceExId;
  String? isDeleted;
  int? sort;
  int? defaultSort;
  int? status;

  factory DayExTable.fromRawJson(String str) =>
      DayExTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DayExTable.fromJson(Map<String, dynamic> json) => DayExTable(
        id: json["Id"],
        planId: json["PlanId"],
        dayId: json["DayId"],
        exId: json["ExId"],
        exTime: json["ExTime"],
        exUnit: json["ExUnit"],
        isCompleted: json["IsCompleted"],
        updatedExTime: json["UpdatedExTime"],
        replaceExId: json["ReplaceExId"],
        isDeleted: json["IsDeleted"],
        sort: json["sort"],
        defaultSort: json["DefaultSort"],
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "PlanId": planId,
        "DayId": dayId,
        "ExId": exId,
        "ExTime": exTime,
        "ExUnit": exUnit,
        "IsCompleted": isCompleted,
        "UpdatedExTime": updatedExTime,
        "ReplaceExId": replaceExId,
        "IsDeleted": isDeleted,
        "sort": sort,
        "DefaultSort": defaultSort,
        "Status": status,
      };
}
