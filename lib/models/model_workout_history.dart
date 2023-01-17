

import 'dart:convert';

WorkoutHistoryModel workoutHistoryModelFromJson(String str) => WorkoutHistoryModel.fromJson(json.decode(str));

String workoutHistoryModelToJson(WorkoutHistoryModel data) => json.encode(data.toJson());

class WorkoutHistoryModel {
  WorkoutHistoryModel({
    this.data,
  });

  Data? data;

  factory WorkoutHistoryModel.fromJson(Map<String, dynamic> json) => WorkoutHistoryModel(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.success,
    this.completedworkout,
    this.error,
  });

  int? success;
  List<CompletedHistoryworkout>? completedworkout;
  String? error;

  factory Data.fromJson(Map<String, dynamic> json){
    List<CompletedHistoryworkout> list = [];

    if(json["workoutcompleted"] == null){
      list = [];

    }
    else{
      list = List<CompletedHistoryworkout>.from(json["workoutcompleted"].map((x) => CompletedHistoryworkout.fromJson(x)));
    }


    return  Data(
      success: json["success"],
      completedworkout: list ,
      error: json["error"],
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "completedworkout": List<dynamic>.from(completedworkout!.map((x) => x.toJson())),
    "error": error,
  };
}

class CompletedHistoryworkout {
  CompletedHistoryworkout({
    this.workoutHistoryId,
    this.workoutType,
    this.workoutId,
    this.workoutDate,
    this.workoutTime,
    this.kcal,
  });

  String? workoutHistoryId;
  String? workoutType;
  String? workoutId;
  DateTime? workoutDate;
  String? workoutTime;
  String? kcal;

  factory CompletedHistoryworkout.fromJson(Map<String, dynamic> json) => CompletedHistoryworkout(
    workoutHistoryId: json["workouts_completed_id"],
    workoutType: json["workout_type"],
    workoutId: json["workout_id"],
    workoutDate: DateTime.parse(json["completed_date"]),
    workoutTime: json["completed_duration"],
    kcal: json["kcal"],
  );

  Map<String, dynamic> toJson() => {
    "workouts_completed_id": workoutHistoryId,
    "workout_type": workoutType,
    "workout_id": workoutId,
    // "completed_date": workoutDate,
    "completed_date": "${workoutDate!.year.toString().padLeft(4, '0')}-${workoutDate!.month.toString().padLeft(2, '0')}-${workoutDate!.day.toString().padLeft(2, '0')}",
    "completed_duration": workoutTime,
    "kcal": kcal,
  };
}
