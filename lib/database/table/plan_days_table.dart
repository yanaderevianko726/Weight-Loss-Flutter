import 'dart:convert';

class PlanDaysTable {
  PlanDaysTable({
    this.dayId,
    this.planId,
    this.dayName,
    this.isCompleted,
    this.dayProgress,
    this.weekName,
    this.planWorkouts,
    this.planMinutes,
    this.status,
  });

  int? dayId;
  String? planId;
  String? dayName;
  String? isCompleted;
  String? dayProgress;
  String? weekName;
  String? planWorkouts;
  String? planMinutes;
  int? status;

  factory PlanDaysTable.fromRawJson(String str) =>
      PlanDaysTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlanDaysTable.fromJson(Map<String, dynamic> json) => PlanDaysTable(
        dayId: json["DayId"],
        planId: json["PlanId"],
        dayName: json["DayName"],
        isCompleted: json["IsCompleted"],
        dayProgress: json["DayProgress"],
        weekName: json["WeekName"],
        planWorkouts: json["PlanWorkouts"],
        planMinutes: json["PlanMinutes"],
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "DayId": dayId,
        "PlanId": planId,
        "DayName": dayName,
        "IsCompleted": isCompleted,
        "DayProgress": dayProgress,
        "WeekName": weekName,
        "PlanWorkouts": planWorkouts,
        "PlanMinutes": planMinutes,
        "Status": status,
      };
}
