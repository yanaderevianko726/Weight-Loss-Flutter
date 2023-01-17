class UpdatePasswordModel {
  Data? data;

  UpdatePasswordModel({this.data});

  UpdatePasswordModel.fromJson(Map<String, dynamic> json) {
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
  List<Updatepassword>? updatepassword;

  Data({this.success, this.updatepassword});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['updatepassword'] != null) {
      updatepassword =  [];
      json['updatepassword'].forEach((v) {
        updatepassword!.add(new Updatepassword.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.updatepassword != null) {
      data['updatepassword'] =
          this.updatepassword!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Updatepassword {
  String? error;

  Updatepassword({this.error});

  Updatepassword.fromJson(Map<String, dynamic> json) {
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    return data;
  }
}
