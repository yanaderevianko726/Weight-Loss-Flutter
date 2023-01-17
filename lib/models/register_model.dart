import 'package:women_workout/models/userdetail_model.dart';

class RegisterModel {
  final DataModel dataModel;

  RegisterModel({required this.dataModel});

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      dataModel: DataModel.fromJson(json['data']),
    );
  }
}

class DataModel {
  final int? success;
  final Login? login;

  DataModel({this.success, this.login});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      success: json['success'],
      login: Login.fromJson(json['login']),
    );
  }
}

class Login {
  final UserDetail? userDetail;
  final String? session;
  final String? error;

  Login({this.userDetail, this.session, this.error});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      userDetail: UserDetail.fromJson(json['userdetail']),
      session: json['session'],
      error: json['error'],
    );
  }
}

class Userdetail {
  Userdetail({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.password,
    required this.mobile,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.image,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.intensively,
    required this.timeinweek,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  final String userId;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;
  final String mobile;
  final String age;
  final String gender;
  final String height;
  final String weight;
  final String image;
  final String address;
  final String city;
  final String state;
  final String country;
  final String intensively;
  final String timeinweek;
  final String createdAt;
  final String updatedAt;
  final String isActive;

  factory Userdetail.fromJson(Map<String, dynamic> json) => Userdetail(
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
