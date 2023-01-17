class HomeSuccess {
  Data? data;

  HomeSuccess({this.data});

  HomeSuccess.fromJson(Map<String, dynamic> json) {
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

  Data({this.success});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;

    return data;
  }
}
