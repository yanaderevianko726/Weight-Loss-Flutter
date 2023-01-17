class ModelStretches {
  Data? data;

  ModelStretches({this.data});

  ModelStretches.fromJson(Map<String, dynamic> json) {
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
  List<Stretches>? stretches;
  String? error;

  Data({this.success, this.stretches, this.error});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['stretches'] != null) {
      stretches = [];
      json['stretches'].forEach((v) {
        stretches!.add(new Stretches.fromJson(v));
      });
    }
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.stretches != null) {
      data['stretches'] = this.stretches!.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    return data;
  }
}

class Stretches {
  String? stretchesId;
  String? stretches;
  String? image;
  int? totalExercise;
  String? description;
  String? isActive;

  Stretches({this.stretchesId, this.stretches, this.image,this.isActive});

  Stretches.fromJson(Map<String, dynamic> json) {
    stretchesId = json['stretches_id'];
    stretches = json['stretches'];
    image = json['image'];
    totalExercise = json['totalexercise'];
    description = json['description'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stretches_id'] = this.stretchesId;
    data['stretches'] = this.stretches;
    data['image'] = this.image;
    data['totalexercise'] = this.totalExercise;
    data['description'] = this.description;
    data['is_active'] = this.isActive;
    return data;
  }
}
