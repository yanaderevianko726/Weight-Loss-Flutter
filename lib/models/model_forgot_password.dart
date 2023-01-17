class ForgotPasswordModel {
  Data? data;

  ForgotPasswordModel({this.data});

  ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
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
  Forgotpassword? forgotpassword;

  Data({this.success, this.forgotpassword});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    forgotpassword = json['forgotpassword'] != null
        ? new Forgotpassword.fromJson(json['forgotpassword'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.forgotpassword != null) {
      data['forgotpassword'] = this.forgotpassword!.toJson();
    }
    return data;
  }
}

class Forgotpassword {
  String? error;

  Forgotpassword({this.error});

  Forgotpassword.fromJson(Map<String, dynamic> json) {
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    return data;
  }
}
