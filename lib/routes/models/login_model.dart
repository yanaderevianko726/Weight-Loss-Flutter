

import 'dart:convert';

import 'package:women_workout/models/userdetail_model.dart';

ModelLogin modelLoginFromJson(String str) =>
    ModelLogin.fromJson(json.decode(str));

String modelLoginToJson(ModelLogin data) => json.encode(data.toJson());

class ModelLogin {
  ModelLogin({
    required this.data,
  });

  final Data data;

  factory ModelLogin.fromJson(Map<String, dynamic> json) => ModelLogin(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.success,
    required this.login,
  });

  final int success;
  final Login login;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        success: json["success"],
        login: Login.fromJson(json["login"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "login": login.toJson(),
      };
}

class Login {
  Login({
    this.userdetail,
    this.session,
    this.error,
  });

  UserDetail? userdetail;
  String? session;
  String? error;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        userdetail: UserDetail.fromJson(json["userdetail"]),
        session: json["session"],
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "userdetail": userdetail!.toJson(),
        "session": session,
        "error": error,
      };
}

// class Userdetail {
//   Userdetail({
//     @required this.userId,
//     @required this.image,
//     @required this.firstName,
//     @required this.lastName,
//     @required this.email,
//     @required this.phone,
//     @required this.password,
//     @required this.gender,
//     @required this.yourWeight,
//     @required this.height,
//     @required this.age,
//     @required this.intensively,
//     @required this.otherFactor,
//     @required this.weatherCondition,
//     @required this.drinkGoal,
//     @required this.wakeupTime,
//     @required this.bedTime,
//     @required this.intervalTime,
//     @required this.motivate,
//     @required this.weightGoal,
//     @required this.currentlyFollowDiet,
//     @required this.dontEat,
//     @required this.mealUsuallyHave,
//     @required this.varietyDiet,
//     @required this.createdAt,
//     @required this.updatedAt,
//     @required this.isActive,
//   });
//
//   final String userId;
//   final String image;
//   final String firstName;
//   final String lastName;
//   final String email;
//   final String phone;
//   final String password;
//   final String gender;
//   final String yourWeight;
//   final String height;
//   final String age;
//   final String intensively;
//   final String otherFactor;
//   final String weatherCondition;
//   final String drinkGoal;
//   final String wakeupTime;
//   final String bedTime;
//   final String intervalTime;
//   final String motivate;
//   final String weightGoal;
//   final String currentlyFollowDiet;
//   final String dontEat;
//   final String mealUsuallyHave;
//   final String varietyDiet;
//   final String createdAt;
//   final String updatedAt;
//   final String isActive;
//
//   factory Userdetail.fromJson(Map<String, dynamic> json) => Userdetail(
//     userId: json["user_id"],
//     image: json["image"],
//     firstName: json["first_name"],
//     lastName: json["last_name"],
//     email: json["email"],
//     phone: json["phone"],
//     password: json["password"],
//     gender: json["gender"],
//     yourWeight: json["your_weight"],
//     height: json["height"],
//     age: json["age"],
//     intensively: json["intensively"],
//     otherFactor: json["other_factor"],
//     weatherCondition: json["weather_condition"],
//     drinkGoal: json["drink_goal"],
//     wakeupTime: json["wakeup_time"],
//     bedTime: json["bed_time"],
//     intervalTime: json["interval_time"],
//     motivate: json["motivate"],
//     weightGoal: json["weight_goal"],
//     currentlyFollowDiet: json["currently_follow_diet"],
//     dontEat: json["dont_eat"],
//     mealUsuallyHave: json["meal_usually_have"],
//     varietyDiet: json["variety_diet"],
//     createdAt: json["created_at"],
//     updatedAt: json["updated_at"],
//     isActive: json["is_active"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "user_id": userId,
//     "image": image,
//     "first_name": firstName,
//     "last_name": lastName,
//     "email": email,
//     "phone": phone,
//     "password": password,
//     "gender": gender,
//     "your_weight": yourWeight,
//     "height": height,
//     "age": age,
//     "intensively": intensively,
//     "other_factor": otherFactor,
//     "weather_condition": weatherCondition,
//     "drink_goal": drinkGoal,
//     "wakeup_time": wakeupTime,
//     "bed_time": bedTime,
//     "interval_time": intervalTime,
//     "motivate": motivate,
//     "weight_goal": weightGoal,
//     "currently_follow_diet": currentlyFollowDiet,
//     "dont_eat": dontEat,
//     "meal_usually_have": mealUsuallyHave,
//     "variety_diet": varietyDiet,
//     "created_at": createdAt,
//     "updated_at": updatedAt,
//     "is_active": isActive,
//   };
// }
