// To parse this JSON data, do
//
//     final modelDeleteCustomPlan = modelDeleteCustomPlanFromJson(jsonString);

import 'dart:convert';

ModelDeleteCustomPlan modelDeleteCustomPlanFromJson(String str) => ModelDeleteCustomPlan.fromJson(json.decode(str));

String modelDeleteCustomPlanToJson(ModelDeleteCustomPlan data) => json.encode(data.toJson());

class ModelDeleteCustomPlan {
  ModelDeleteCustomPlan({
    required this.data,
  });

  final Data data;

  factory ModelDeleteCustomPlan.fromJson(Map<String, dynamic> json) => ModelDeleteCustomPlan(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.success,
    required this.deletecustomplan,
    required this.error,
  });

  final int success;
  final List<dynamic> deletecustomplan;
  final String error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    success: json["success"],
    deletecustomplan: List<dynamic>.from(json["deletecustomplan"].map((x) => x)),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "deletecustomplan": List<dynamic>.from(deletecustomplan.map((x) => x)),
    "error": error,
  };
}
