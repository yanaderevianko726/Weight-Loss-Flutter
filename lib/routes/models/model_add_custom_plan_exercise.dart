import 'dart:convert';

ModelAddCustomPlanExercise modelAddCustomPlanExerciseFromJson(String str) =>
    ModelAddCustomPlanExercise.fromJson(json.decode(str));

String modelAddCustomPlanExerciseToJson(ModelAddCustomPlanExercise data) =>
    json.encode(data.toJson());

class ModelAddCustomPlanExercise {
  ModelAddCustomPlanExercise({
    required this.data,
  });

  final Data data;

  factory ModelAddCustomPlanExercise.fromJson(Map<String, dynamic> json) =>
      ModelAddCustomPlanExercise(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.success,
    required this.addcustomplanexercise,
    required this.error,
  });

  final int success;
  final List<dynamic> addcustomplanexercise;
  final String error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        success: json["success"],
        addcustomplanexercise:
            List<dynamic>.from(json["addcustomplanexercise"].map((x) => x)),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "addcustomplanexercise":
            List<dynamic>.from(addcustomplanexercise.map((x) => x)),
        "error": error,
      };
}
