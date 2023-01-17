// To parse this JSON data, do
//
//     final dayModel = dayModelFromJson(jsonString);

import 'dart:convert';

DayModel dayModelFromJson(String str) => DayModel.fromJson(json.decode(str));

String dayModelToJson(DayModel data) => json.encode(data.toJson());

class DayModel {
  DayModel({
    this.data,
  });

  Data? data;

  factory DayModel.fromJson(Map<String, dynamic> json) => DayModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.success,
    this.dietcategorydetails,
    this.error,
  });

  int? success;
  List<Dietcategorydetail>? dietcategorydetails;
  String? error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    success: json["success"],
    dietcategorydetails: List<Dietcategorydetail>.from(json["dietcategorydetails"].map((x) => Dietcategorydetail.fromJson(x))),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "dietcategorydetails": List<dynamic>.from(dietcategorydetails!.map((x) => x.toJson())),
    "error": error,
  };
}

class Dietcategorydetail {
  Dietcategorydetail({
    this.dietCategoryDetailsId,
    this.dietCategoryId,
    this.dishesName,
    this.image,
    this.description,

  });

  String? dietCategoryDetailsId;
  String? dietCategoryId;
  String? dishesName;
  String? image;

  String? description;

  factory Dietcategorydetail.fromJson(Map<String, dynamic> json) => Dietcategorydetail(
    dietCategoryDetailsId: json["diet_category_details_id"],
    dietCategoryId: json["diet_category_id"],
    dishesName: json["dishes_name"],
    image: json["image"],
    description: json["description"],

  );

  Map<String, dynamic> toJson() => {
    "diet_category_details_id": dietCategoryDetailsId,
    "diet_category_id": dietCategoryId,
    "dishes_name": dishesName,
    "image": image,

    "description": description,
  };
}
