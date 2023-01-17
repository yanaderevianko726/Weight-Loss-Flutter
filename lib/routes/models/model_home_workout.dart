class HomeWorkout {
  Data? data;

  HomeWorkout({this.data});

  HomeWorkout.fromJson(Map<String, dynamic> json) {
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
  Homeworkout? homeworkout;
  String? error;

  Data({this.success, this.homeworkout, this.error});

  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    homeworkout = json['homeworkout'] != null
        ? new Homeworkout.fromJson(json['homeworkout'])
        : null;
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.homeworkout != null) {
      data['homeworkout'] = this.homeworkout!.toJson();
    }
    data['error'] = this.error;
    return data;
  }
}

class Homeworkout {
  String? homeWorkoutId;
  String? userId;
  String? workouts;
  String? kcal;
  String? duration;

  Homeworkout(
      {this.homeWorkoutId,
        this.userId,
        this.workouts,
        this.kcal,
        this.duration});

  Homeworkout.fromJson(Map<String, dynamic> json) {
    homeWorkoutId = json['home_workout_id'];
    userId = json['user_id'];
    workouts = json['workouts'];
    kcal = json['kcal'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['home_workout_id'] = this.homeWorkoutId;
    data['user_id'] = this.userId;
    data['workouts'] = this.workouts;
    data['kcal'] = this.kcal;
    data['duration'] = this.duration;
    return data;
  }
}
