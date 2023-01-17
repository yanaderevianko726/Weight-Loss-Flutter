// To parse this JSON data, do
//
//     final modelGetCustomPlan = modelGetCustomPlanFromJson(jsonString);

import 'dart:convert';

ModelGetCustomPlan modelGetCustomPlanFromJson(String str) => ModelGetCustomPlan.fromJson(json.decode(str));

String modelGetCustomPlanToJson(ModelGetCustomPlan data) => json.encode(data.toJson());

class ModelGetCustomPlan {
  ModelGetCustomPlan({
    required this.data,
  });

  final Data data;

  factory ModelGetCustomPlan.fromJson(Map<String, dynamic> json) => ModelGetCustomPlan(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.success,
    required this.customplan,
    required this.error,
  });

  final int success;
  final List<Customplan> customplan;
  final String error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    success: json["success"],
    customplan: json["success"]==0?[]:List<Customplan>.from(json["customplan"].map((x) => Customplan.fromJson(x))),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "customplan": List<dynamic>.from(customplan.map((x) => x.toJson())),
    "error": error,
  };
}

class Customplan {
  Customplan({
    required this.customPlanId,
    required this.userId,
    required this.name,
    required this.description,
    required this.totalexercise,
    required this.createdAt,
    required this.updatedAt,
  });

  final String customPlanId;
  final String userId;
  final String name;
  final String description;
  final int totalexercise;
  final String createdAt;
  final String updatedAt;

  factory Customplan.fromJson(Map<String, dynamic> json) => Customplan(
    customPlanId: json["custom_plan_id"],
    userId: json["user_id"],
    name: json["name"],
    description: json["description"],
    totalexercise: json["totalexercise"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "custom_plan_id": customPlanId,
    "user_id": userId,
    "name": name,
    "description": description,
    "totalexercise": totalexercise,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
