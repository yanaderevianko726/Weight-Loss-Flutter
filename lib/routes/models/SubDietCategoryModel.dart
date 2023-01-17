
import 'dart:convert';

SubDietCategoryModel SubDietCategoryModelFromJson(String str) => SubDietCategoryModel.fromJson(json.decode(str));

String SubDietCategoryModelToJson(SubDietCategoryModel data) => json.encode(data.toJson());

class SubDietCategoryModel {
  SubDietCategoryModel({
    this.data,
  });

  Data? data;

  factory SubDietCategoryModel.fromJson(Map<String, dynamic> json) => SubDietCategoryModel(
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
  List<SubDietcategory>? dietcategory;
  String? error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    success: json["success"],
    dietcategory: List<SubDietcategory>.from(json["dietcategorydetails"].map((x) => SubDietcategory.fromJson(x))),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "dietcategorydetails": List<dynamic>.from(dietcategory!.map((x) => x.toJson())),
    "error": error,
  };
}

class SubDietcategory {
  SubDietcategory({
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

  factory SubDietcategory.fromJson(Map<String, dynamic> json) => SubDietcategory(
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
