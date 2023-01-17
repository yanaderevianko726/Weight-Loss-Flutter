import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ModelHistory {
  int? id;
  String? title;
  String? startTime;
  String? date;
  int? totalDuration;
  String? kCal;

  ModelHistory.fromMap(dynamic objects) {
    title = objects['title'];
    startTime = objects['start_time'];
    date = objects['date'];
    totalDuration = objects['total_duration'];
    kCal = objects['kcal'];
    id = objects['id'];
  }

  Map<String, dynamic> toMap() {
    var map = new HashMap<String, dynamic>();
    map['title'] = title;
    map['start_time'] = startTime;
    map['date'] = date;
    map['total_duration'] = totalDuration;
    map['kcal'] = kCal;
    map['id'] = id;
    return map;
  }
}