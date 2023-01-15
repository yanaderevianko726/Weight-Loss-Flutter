import 'dart:convert';

class ExerciseTable {
  ExerciseTable({
    this.exId,
    this.exName,
    this.exUnit,
    this.exDescription,
    this.exPath,
    this.exVideo,
    this.replaceTime,
    this.exTime,
    this.isInMyTraining,
  });

  int? exId;
  String? exName;
  String? exUnit;
  String? exDescription;
  String? exPath;
  String? exVideo;
  String? replaceTime;
  String? exTime;
  String? isInMyTraining;

  factory ExerciseTable.fromRawJson(String str) =>
      ExerciseTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExerciseTable.fromJson(Map<String, dynamic> json) => ExerciseTable(
        exId: json["ExId"],
        exName: json["ExName"],
        exUnit: json["ExUnit"],
        exDescription: json["ExDescription"],
        exPath: json["ExPath"],
        exVideo: json["ExVideo"],
        replaceTime: json["ReplaceTime"],
        exTime: json["ExTime"],
        isInMyTraining: json["IsInMyTraining"],
      );

  Map<String, dynamic> toJson() => {
        "ExId": exId,
        "ExName": exName,
        "ExUnit": exUnit,
        "ExDescription": exDescription,
        "ExPath": exPath,
        "ExVideo": exVideo,
        "ReplaceTime": replaceTime,
        "ExTime": exTime,
        "IsInMyTraining": isInMyTraining,
      };
}
