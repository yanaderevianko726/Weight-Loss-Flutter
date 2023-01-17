class ModelQuickWorkout {
  Data? data;

  ModelQuickWorkout({this.data});

  ModelQuickWorkout.fromJson(Map<String, dynamic> json) {
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
  List<Quickworkout>? quickworkout;
  String? error;

  Data({this.success, this.quickworkout, this.error});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['quickworkout'] != null) {
      quickworkout =[];
      json['quickworkout'].forEach((v) {
        quickworkout!.add(new Quickworkout.fromJson(v));
      });
    }
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.quickworkout != null) {
      data['quickworkout'] = this.quickworkout!.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    return data;
  }
}

class Quickworkout {
  String? quickworkoutId;
  String? quickworkout;
  String? image;
  String? desc;
  String? isActive;

  Quickworkout({this.quickworkoutId, this.quickworkout, this.image,this.isActive});

  Quickworkout.fromJson(Map<String, dynamic> json) {
    quickworkoutId = json['quickworkout_id'];
    quickworkout = json['quickworkout'];
    image = json['image'];
    desc = json['description'];
    isActive = json['is_active']??'0';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quickworkout_id'] = this.quickworkoutId;
    data['quickworkout'] = this.quickworkout;
    data['image'] = this.image;
    data['description'] = this.desc;
    data['is_active'] = this.isActive;
    return data;
  }
}
