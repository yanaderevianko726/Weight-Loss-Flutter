

import 'dart:convert';

ModelExerciseDays modelExerciseDaysFromJson(String str) =>
    ModelExerciseDays.fromJson(json.decode(str));

String modelExerciseDaysToJson(ModelExerciseDays data) =>
    json.encode(data.toJson());

class ModelExerciseDays {
  ModelExerciseDays({
    required this.data,
  });

  final Data data;

  factory ModelExerciseDays.fromJson(Map<String, dynamic> json) =>
      ModelExerciseDays(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.success,
    required this.days,
    required this.error,
  });

  final int success;
  final List<Day> days;
  final String error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        success: json["success"],
        days: List<Day>.from(json["days"].map((x) => Day.fromJson(x))),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "days": List<dynamic>.from(days.map((x) => x.toJson())),
        "error": error,
      };
}

class Day {
  Day({
    required this.daysId,
    required this.weekId,
    required this.daysName,
    required this.isCompleted,
  });

  final String daysId;
  final String weekId;
  final String daysName;
  final int isCompleted;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        daysId: json["days_id"],
        weekId: json["week_id"],
        daysName: json["days_name"],
        isCompleted: json["is_completed"],
      );

  Map<String, dynamic> toJson() => {
        "days_id": daysId,
        "week_id": weekId,
        "days_name": daysName,
        "is_completed": isCompleted,
      };
}
