
import 'dart:convert';

ModelExerciseWeek modelExerciseWeekFromJson(String str) =>
    ModelExerciseWeek.fromJson(json.decode(str));

String modelExerciseWeekToJson(ModelExerciseWeek data) =>
    json.encode(data.toJson());

class ModelExerciseWeek {
  ModelExerciseWeek({
    required this.data,
  });

  final Data data;

  factory ModelExerciseWeek.fromJson(Map<String, dynamic> json) =>
      ModelExerciseWeek(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.success,
    required this.week,
    required this.error,
  });

  final int success;
  final List<Week> week;
  final String error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        success: json["success"],
        week: List<Week>.from(json["week"].map((x) => Week.fromJson(x))),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "week": List<dynamic>.from(week.map((x) => x.toJson())),
        "error": error,
      };
}

class Week {
  Week({
    required this.weekId,
    required this.challengesId,
    required this.weekName,
    required this.totaldays,
    required this.isCompleted,
  });

  final String weekId;
  final String challengesId;
  final String weekName;
  final int totaldays;
  final int isCompleted;

  factory Week.fromJson(Map<String, dynamic> json) => Week(
        weekId: json["week_id"],
        challengesId: json["challenges_id"],
        weekName: json["week_name"],
        totaldays: json["totaldays"],
        isCompleted: json["is_completed"],
      );

  Map<String, dynamic> toJson() => {
        "week_id": weekId,
        "challenges_id": challengesId,
        "week_name": weekName,
        "totaldays": totaldays,
        "is_completed": isCompleted,
      };
}
