// To parse this JSON data, do
//
//     final modelAllWorkout = modelAllWorkoutFromJson(jsonString);

import 'dart:convert';

ModelAllWorkout modelAllWorkoutFromJson(String str) => ModelAllWorkout.fromJson(json.decode(str));

String modelAllWorkoutToJson(ModelAllWorkout data) => json.encode(data.toJson());

class ModelAllWorkout {
  ModelAllWorkout({
    required this.data,
  });

  final Data data;

  factory ModelAllWorkout.fromJson(Map<String, dynamic> json) => ModelAllWorkout(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.success,
    required this.category,
    required this.error,
  });

  final int success;
  final List<Category> category;
  final String error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    success: json["success"],
    category: List<Category>.from(json["category"].map((x) => Category.fromJson(x))),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "category": List<dynamic>.from(category.map((x) => x.toJson())),
    "error": error,
  };
}

class Category {
  Category({
    required this.categoryId,
    required this.category,
    required this.image,
    required this.description,
    required this.isActive,
  });

  final String categoryId;
  final String category;
  final String image;
  final String description;
  final String isActive;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    categoryId: json["category_id"],
    category: json["category"],
    image: json["image"],
    description: json["description"],
    isActive: (json["is_active"])?? "0",
  );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "category": category,
    "image": image,
    "description": description,
    "is_active": isActive,
  };
}
