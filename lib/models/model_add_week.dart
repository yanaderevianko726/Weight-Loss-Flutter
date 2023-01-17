class AddWeekModel {
  Data? data;

  AddWeekModel({this.data});

  AddWeekModel.fromJson(Map<String, dynamic> json) {
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

  String? error;

  Data({this.success, this.error});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];

    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;

    data['error'] = this.error;
    return data;
  }
}