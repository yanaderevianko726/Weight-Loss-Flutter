
import 'dart:convert';

ModelDeleteCustomPlanExercise modelDeleteCustomPlanExerciseFromJson(String str) => ModelDeleteCustomPlanExercise.fromJson(json.decode(str));

String modelDeleteCustomPlanExerciseToJson(ModelDeleteCustomPlanExercise data) => json.encode(data.toJson());

class ModelDeleteCustomPlanExercise {
  ModelDeleteCustomPlanExercise({
    required this.data,
  });

  final Data data;

  factory ModelDeleteCustomPlanExercise.fromJson(Map<String, dynamic> json) => ModelDeleteCustomPlanExercise(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.success,
    required this.deletecustomplanexercise,
    required this.error,
  });

  final int success;
  final List<dynamic> deletecustomplanexercise;
  final String error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    success: json["success"],
    deletecustomplanexercise: List<dynamic>.from(json["deletecustomplanexercise"].map((x) => x)),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "deletecustomplanexercise": List<dynamic>.from(deletecustomplanexercise.map((x) => x)),
    "error": error,
  };
}
