

import 'package:women_workout/models/userdetail_model.dart';

class LogoutModel {
  Data? data;

  LogoutModel({this.data});

  LogoutModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? success;
  Login? login;

  Data({this.success, this.login});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    login = json['login'] != null ? new Login.fromJson(json['login']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.login != null) {
      data['login'] = this.login!.toJson();
    }
    return data;
  }
}

class Login {
  UserDetail? userdetail;
  String? session;
  String? error;

  Login({this.userdetail, this.session, this.error});

  Login.fromJson(Map<String, dynamic> json) {
    userdetail = json['userdetail'] != null
        ? new UserDetail.fromJson(json['userdetail'])
        : null;
    session = json['session'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userdetail != null) {
      data['userdetail'] = this.userdetail!.toJson();
    }
    data['session'] = this.session;
    data['error'] = this.error;
    return data;
  }
}


