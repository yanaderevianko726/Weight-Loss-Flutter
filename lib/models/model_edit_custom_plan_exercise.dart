import 'dart:convert';

ModelEditCustomPlanExercise ModelEditCustomPlanExerciseFromJson(String str) =>
    ModelEditCustomPlanExercise.fromJson(json.decode(str));

String ModelEditCustomPlanExerciseToJson(ModelEditCustomPlanExercise data) =>
    json.encode(data.toJson());

class ModelEditCustomPlanExercise {
  ModelEditCustomPlanExercise({
    required this.data,
  });

  final Data data;

  factory ModelEditCustomPlanExercise.fromJson(Map<String, dynamic> json) =>
      ModelEditCustomPlanExercise(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.success,

  });

  final int success;


  factory Data.fromJson(Map<String, dynamic> json) => Data(
        success: json["success"],

      );

  Map<String, dynamic> toJson() => {
        "success": success,

      };
}
