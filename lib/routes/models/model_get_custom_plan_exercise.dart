// To parse this JSON data, do
//
//     final modelGetCustomPlanExercise = modelGetCustomPlanExerciseFromJson(jsonString);

import 'package:women_workout/data/dummy_data.dart';
import 'dart:convert';


ModelGetCustomPlanExercise modelGetCustomPlanExerciseFromJson(String str) =>
    ModelGetCustomPlanExercise.fromJson(json.decode(str));

String modelGetCustomPlanExerciseToJson(ModelGetCustomPlanExercise data) =>
    json.encode(data.toJson());

class ModelGetCustomPlanExercise {
  ModelGetCustomPlanExercise({
    required this.data,
  });

  final Data data;

  factory ModelGetCustomPlanExercise.fromJson(Map<String, dynamic> json) =>
      ModelGetCustomPlanExercise(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data(
      {required this.success,
      required this.customplanexercise,
      required this.error,
      required this.idList});

  final int success;
  final List<Customplanexercise> customplanexercise;
  final List<String> idList;
  final String error;

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        success: json["success"],
        idList: List<String>.from(json["customplanexercise"].map((x) {
          Customplanexercise customplanexercise =
              Customplanexercise.fromJson(x);

          int exerciseTime = 10;
          if (customplanexercise.exerciseTime != null &&
              customplanexercise.exerciseTime!.isNotEmpty) {
            if (double.tryParse(customplanexercise.exerciseTime!) != null) {
              exerciseTime =
                  double.parse(customplanexercise.exerciseTime!).toInt();
            }
          }

          DummyData.setDuration(
              customplanexercise.exercisedetail.exerciseId, exerciseTime,
              customPlanId: customplanexercise.customPlanExerciseId);

          return Customplanexercise.fromJson(x).exercisedetail.exerciseId;
        })),
        customplanexercise: List<Customplanexercise>.from(
            json["customplanexercise"]
                .map((x) => Customplanexercise.fromJson(x))),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "customplanexercise":
            List<dynamic>.from(customplanexercise.map((x) => x.toJson())),
        "error": error,
      };
}

class Customplanexercise {
  Customplanexercise({
    required this.customPlanExerciseId,
    required this.customPlanId,
    required this.exerciseTime,
    required this.exercisedetail,
  });

  final String customPlanExerciseId;
  final String customPlanId;
  final String? exerciseTime;
  final Exercisedetail exercisedetail;

  factory Customplanexercise.fromJson(Map<String, dynamic> json) =>
      Customplanexercise(
        customPlanExerciseId: json["custom_plan_exercise_id"],
        customPlanId: json["custom_plan_id"],
        exerciseTime: json["exercise_time"],
        exercisedetail: Exercisedetail.fromJson(json["exercisedetail"]),
      );

  Map<String, dynamic> toJson() => {
        "custom_plan_exercise_id": customPlanExerciseId,
        "custom_plan_id": customPlanId,
        "exercise_time": exerciseTime,
        "exercisedetail": exercisedetail.toJson(),
      };
}

class Exercisedetail {
  Exercisedetail({
    required this.exerciseId,
    required this.exerciseName,
    required this.image,
    required this.description,
    required this.exerciseTime,
  });

  final String exerciseId;
  final String exerciseName;
  final String image;
  final String description;
  final String exerciseTime;

  factory Exercisedetail.fromJson(Map<String, dynamic> json) => Exercisedetail(
        exerciseId: json["exercise_id"],
        exerciseName: json["exercise_name"],
        image: json["image"],
        description: json["description"],
        exerciseTime: json["exercise_time"],
      );

  Map<String, dynamic> toJson() => {
        "exercise_id": exerciseId,
        "exercise_name": exerciseName,
        "image": image,
        "description": description,
        "exercise_time": exerciseTime,
      };
}
