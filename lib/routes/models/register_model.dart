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
