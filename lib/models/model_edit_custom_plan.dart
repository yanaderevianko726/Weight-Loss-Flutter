import 'dart:convert';

ModelEditCustomPlan modelEditCustomPlanFromJson(String str) =>
    ModelEditCustomPlan.fromJson(json.decode(str));

String modelEditCustomPlanToJson(ModelEditCustomPlan data) =>
    json.encode(data.toJson());

class ModelEditCustomPlan {
  ModelEditCustomPlan({
    required this.data,
  });

  final Data data;

  factory ModelEditCustomPlan.fromJson(Map<String, dynamic> json) =>
      ModelEditCustomPlan(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.success,
    required this.editcustomplan,
    required this.error,
  });

  final int success;
  final List<dynamic> editcustomplan;
  final String error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        success: json["success"],
        editcustomplan:
            List<dynamic>.from(json["editcustomplan"].map((x) => x)),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "editcustomplan": List<dynamic>.from(editcustomplan.map((x) => x)),
        "error": error,
      };
}
