import 'dart:convert';

import 'package:women_lose_weight_flutter/database/table/home_plan_table.dart';

class HistoryTable {
  HistoryTable({
    this.hid,
    this.hPlanName,
    this.hPlanId,
    this.hDayName,
    this.hBurnKcal,
    this.hTotalEx,
    this.hKg,
    this.hFeet,
    this.hInch,
    this.hCompletionTime,
    this.hDateTime,
    this.hDayId,
    this.hFeelRate,
    this.status,
    this.fireStoreId,
  });

  int? hid;
  String? hPlanName;
  String? hPlanId;
  String? hDayName;
  String? hBurnKcal;
  String? hTotalEx;
  String? hKg;
  String? hFeet;
  String? hInch;
  String? hCompletionTime;
  String? hDateTime;
  String? hDayId;
  String? hFeelRate;
  int? status;
  String? fireStoreId;

  HomePlanTable? planDetail;

  factory HistoryTable.fromRawJson(String str) =>
      HistoryTable.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HistoryTable.fromJson(Map<String, dynamic> json) => HistoryTable(
        hid: json["HId"],
        hPlanName: json["HPlanName"],
        hPlanId: json["HPlanId"],
        hDayName: json["HDayName"],
        hBurnKcal: json["HBurnKcal"],
        hTotalEx: json["HTotalEx"],
        hKg: json["HKg"],
        hFeet: json["HFeet"],
        hInch: json["HInch"],
        hCompletionTime: json["HCompletionTime"],
        hDateTime: json["HDateTime"],
        hDayId: json["HDayId"],
        hFeelRate: json["HFeelRate"],
        status: json["Status"],
        fireStoreId: json["FireStoreID"],
      );

  Map<String, dynamic> toJson() => {
        "HId": hid,
        "HPlanName": hPlanName,
        "HPlanId": hPlanId,
        "HDayName": hDayName,
        "HBurnKcal": hBurnKcal,
        "HTotalEx": hTotalEx,
        "HKg": hKg,
        "HFeet": hFeet,
        "HInch": hInch,
        "HCompletionTime": hCompletionTime,
        "HDateTime": hDateTime,
        "HDayId": hDayId,
        "HFeelRate": hFeelRate,
        "Status": status,
        "FireStoreID": fireStoreId,
      };
}
