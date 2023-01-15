import 'dart:convert';

class ReminderTable {
  ReminderTable({
    this.rid,
    this.remindTime,
    this.days,
    this.isActive,
    this.repeatNo,
  });

  int? rid;
  String? remindTime;
  String? days;
  int? isActive;
  String? repeatNo;

  factory ReminderTable.fromRawJson(String str) =>
      ReminderTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ReminderTable.fromJson(Map<String, dynamic> json) => ReminderTable(
        rid: json["RId"],
        remindTime: json["RemindTime"],
        days: json["Days"],
        isActive: json["IsActive"],
        repeatNo: json["RepeatNo"],
      );

  Map<String, dynamic> toJson() => {
        "RId": rid,
        "RemindTime": remindTime,
        "Days": days,
        "IsActive": isActive,
        "RepeatNo": repeatNo,
      };
}
