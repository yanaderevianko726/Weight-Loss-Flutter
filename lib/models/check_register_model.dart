import 'dart:convert';

CheckRegisterModel checkRegisterModelFromJson(String str) => CheckRegisterModel.fromJson(json.decode(str));

String checkRegisterModelToJson(CheckRegisterModel data) => json.encode(data.toJson());

class CheckRegisterModel {
  CheckRegisterModel({
    this.data,
  });

  Data? data;

  factory CheckRegisterModel.fromJson(Map<String, dynamic> json) => CheckRegisterModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.success,
    this.login,
  });

  int? success;
  Login? login;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    success: json["success"],
    login: Login.fromJson(json["login"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "login": login!.toJson(),
  };
}

class Login {
  Login({
    this.userdetail,
    this.session,
    this.error,
  });

  Userdetail? userdetail;
  String? session;
  String? error;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    userdetail: Userdetail.fromJson(json["userdetail"]),
    session: json["session"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "userdetail": userdetail!.toJson(),
    "session": session,
    "error": error,
  };
}

class Userdetail {
  Userdetail({
    this.empty,
  });

  String? empty;

  factory Userdetail.fromJson(Map<String, dynamic> json) => Userdetail(
    empty: json[""],
  );

  Map<String, dynamic> toJson() => {
    "": empty,
  };
}
