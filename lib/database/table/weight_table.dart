import 'dart:convert';

class WeightTable {
  WeightTable({
    this.weightId,
    this.weightKg,
    this.weightLb,
    this.weightDate,
    this.currentTimeStamp,
    this.status,
  });

  int? weightId;
  String? weightKg;
  String? weightLb;
  String? weightDate;
  String? currentTimeStamp;
  int? status;

  factory WeightTable.fromRawJson(String str) =>
      WeightTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeightTable.fromJson(Map<String, dynamic> json) => WeightTable(
        weightId: json["WeightId"],
        weightKg: json["WeightKg"],
        weightLb: json["WeightLb"],
        weightDate: json["WeightDate"],
        currentTimeStamp: json["CurrentTimeStamp"],
        status: json["Status"],
      );

  Map<String, dynamic> toJson() => {
        "WeightId": weightId,
        "WeightKg": weightKg,
        "WeightLb": weightLb,
        "WeightDate": weightDate,
        "CurrentTimeStamp": currentTimeStamp,
        "Status": status,
      };
}
