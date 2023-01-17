

import 'dart:convert';

EditProfileModel editProfileModelFromJson(String str) => EditProfileModel.fromJson(json.decode(str));

String editProfileModelToJson(EditProfileModel data) => json.encode(data.toJson());

class EditProfileModel {
  EditProfileModel({
    this.data,
  });

  Data? data;

  factory EditProfileModel.fromJson(Map<String, dynamic> json) => EditProfileModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.success,
    this.editProfile,
    this.error,
  });

  int? success;
  EditProfile? editProfile;
  String? error;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    success: json["success"],
    editProfile: EditProfile.fromJson(json["editprofile"]),
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "editprofile": editProfile!.toJson(),
    "error": error,
  };
}

class EditProfile {
  EditProfile({
    this.userId,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.password,
    this.mobile,
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.image,
    this.address,
    this.city,
    this.country,
    this.state,
    this.intensively,
    this.timeinweek,
    this.createdAt,
    this.updatedAt,
    this.isActive,
  });

  String? userId;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? password;
  String? mobile;
  String? age;
  String? gender;
  String? height;
  String? weight;
  String? image;
  String? address;
  String? city;
  String? state;
  String? country;
  String? intensively;
  String? timeinweek;
  String? createdAt;
  String? updatedAt;
  String? isActive;

  factory EditProfile.fromJson(Map<String, dynamic> json) => EditProfile(
    userId: json["user_id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    username: json["username"],
    email: json["email"],
    password: json["password"],
    mobile: json["mobile"],
    age: json["age"],
    gender: json["gender"],
    height: json["height"],
    weight: json["weight"],
    image: json["image"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    intensively: json["intensively"],
    timeinweek: json["timeinweek"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "first_name": firstName,
    "last_name": lastName,
    "username": username,
    "email": email,
    "password": password,
    "mobile": mobile,
    "age": age,
    "gender": gender,
    "height": height,
    "weight": weight,
    "image": image,
    "address": address,
    "city": city,
    "state": state,
    "country": country,
    "intensively": intensively,
    "timeinweek": timeinweek,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "is_active": isActive,
  };
}
