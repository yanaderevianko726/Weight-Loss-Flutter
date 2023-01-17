
import 'dart:convert';

DietCategoryModel dietCategoryModelFromJson(String str) => DietCategoryModel.fromJson(json.decode(str));

String dietCategoryModelToJson(DietCategoryModel data) => json.encode(data.toJson());

class DietCategoryModel {
  DietCategoryModel({
    this.data,
  });

  Data? data;

  factory DietCategoryModel.fromJson(Map<String, dynamic> json) => DietCategoryModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.success,
    this.dietcategory,
    this.error,
  });

  int? success;
  List<Dietcategory>? dietcategory;
  String? error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    success: json["success"],
    dietcategory: List<Dietcategory>.from(json["dietcategory"].map((x) => Dietcategory.fromJson(x))),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "dietcategory": List<dynamic>.from(dietcategory!.map((x) => x.toJson())),
    "error": error,
  };
}

class Dietcategory {
  Dietcategory({
    this.dietCategoryId,
    this.category,
    this.image,
    this.promotionBanner,
    this.isActive,
  });

  String? dietCategoryId;
  String? category;
  String? image;
  String? promotionBanner;
  String? isActive;

  factory Dietcategory.fromJson(Map<String, dynamic> json) => Dietcategory(
    dietCategoryId: json["diet_category_id"],
    category: json["category"],
    image: json["image"],
    promotionBanner: json["promotion_banner"],
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "diet_category_id": dietCategoryId,
    "category": category,
    "image": image,
    "is_active": isActive,
    "promotion_banner": promotionBanner,
  };
}
