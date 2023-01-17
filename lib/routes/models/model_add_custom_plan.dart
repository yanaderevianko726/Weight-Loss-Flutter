
import 'dart:convert';

ModelAddCustomPlan modelAddCustomPlanFromJson(String str) => ModelAddCustomPlan.fromJson(json.decode(str));

String modelAddCustomPlanToJson(ModelAddCustomPlan data) => json.encode(data.toJson());

class ModelAddCustomPlan {
  ModelAddCustomPlan({
    required this.data,
  });

  final Data data;

  factory ModelAddCustomPlan.fromJson(Map<String, dynamic> json) => ModelAddCustomPlan(
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
  final List<dynamic> customplan;
  final String error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    success: json["success"],
    customplan: List<dynamic>.from(json["customplan"].map((x) => x)),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "customplan": List<dynamic>.from(customplan.map((x) => x)),
    "error": error,
  };
}
