import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:women_lose_weight_flutter/database/helper/firestore_helper.dart';
import 'package:women_lose_weight_flutter/database/table/home_ex_single_table.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/preference.dart';

import '../../utils/debug.dart';
import '../custom_classes/custom_classes.dart';
import '../table/day_ex_table.dart';
import '../table/exercise_table.dart';
import '../table/history_table.dart';
import '../table/home_plan_table.dart';
import '../table/plan_days_table.dart';
import '../table/reminder_table.dart';
import '../table/weight_table.dart';

class DBHelper {
  static final DBHelper dbHelper = DBHelper.internal();

  /// DayExTable table getting by DayId
  String dayExTable = "DayExTable";
  String homeExSingleTable = "HomeExSingleTable";
  String dayExId = "Id";
  String exId = "ExId";
  String exTime = "ExTime";
  String updatedExTime = "UpdatedExTime";

  String replaceExId = "ReplaceExId";
  String isDeleted = "IsDeleted";

  /// ExerciseTable getting
  String exerciseTable = "ExerciseTable";
  String exName = "ExName";
  String exUnit = "ExUnit";
  String exPath = "ExPath";
  String exDescription = "ExDescription";
  String exVideo = "ExVideo";
  String exReplaceTime = "ReplaceTime";

  /// HistoryTable getting
  String historyTable = "HistoryTable";
  String hId = "HId";
  String hPlanName = "HPlanName";
  String hPlanId = "HPlanId";
  String hDayName = "HDayName";
  String hDayId = "HDayId";
  String hBurnKcal = "HBurnKcal";
  String hTotalEx = "HTotalEx";
  String hKg = "HKg";
  String hFeet = "HFeet";
  String hInch = "HInch";
  String hFeelRate = "HFeelRate";
  String hCompletionTime = "HCompletionTime";
  String hDateTime = "HDateTime";

  /// Home Plan table
  String homePlanTable = "HomePlanTable";
  String planId = "PlanId";
  String planName = "PlanName";
  String planProgress = "PlanProgress";
  String planText = "PlanText";
  String planLvl = "PlanLvl";
  String planImage = "PlanImage";
  String planDays = "PlanDays";
  String dayCount = "Days";
  String planType = "PlanType";
  String shortDes = "ShortDes";
  String introduction = "Introduction";
  String planWorkouts = "PlanWorkouts";
  String planMinutes = "PlanMinutes";
  String isPro = "IsPro";
  String hasSubPlan = "HasSubPlan";
  String testDes = "TestDes";
  String planThumbnail = "PlanThumbnail";
  String planTypeImage = "PlanTypeImage";
  String parentPlanId = "ParentPlanId";
  String planSort = "sort";
  String defaultSort = "DefaultSort";

  /// Plan days table getting by planId
  String planDaysTable = "PlanDaysTable";
  String dayId = "DayId";
  String dayName = "DayName";
  String weekName = "WeekName";
  String isCompleted = "IsCompleted";
  String dayProgress = "DayProgress";

  /// ReminderTable getting
  String reminderTable = "ReminderTable";
  String rId = "RId";
  String remindTime = "RemindTime";
  String days = "Days";
  String isActive = "IsActive";
  String repeatNo = "RepeatNo";

  /// WeightTable getting
  String weightTable = "WeightTable";
  String weightId = "WeightId";
  String weightKg = "WeightKg";
  String weightLb = "WeightLb";
  String weightDate = "WeightDate";
  String currentTimeStamp = "CurrentTimeStamp";
  String status = "Status";
  String createdAt = "CreatedAt";
  String fireStoreID = "FireStoreID";

  factory DBHelper() => dbHelper;

  Database? _db;

  DBHelper.internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await init();
    return _db!;
  }

  init() async {
    var dbPath = await getDatabasesPath();
    Debug.printLog("getDatabasesPath ===>" + dbPath.toString());

    String dbPathEnliven = path.join(dbPath, "LoseWeightFlutter.db");
    Debug.printLog("dbPathEnliven ===>" + dbPathEnliven.toString());

    bool dbExistsEnliven = await io.File(dbPathEnliven).exists();

    if (!dbExistsEnliven) {
      ByteData data = await rootBundle
          .load(path.join("assets/database", "LoseWeightFlutter.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await io.File(dbPathEnliven).writeAsBytes(bytes, flush: true);
    }

    return _db = await openDatabase(dbPathEnliven);
  }

  Future<int> getCompleteDayCountByPlanId(String pId) async {
    int completedCount = 0;
    var dbClient = await db;

    List<Map<String, dynamic>> _query = await dbClient.rawQuery(
        "SELECT $dayId FROM $planDaysTable WHERE $planId = $pId AND $isCompleted = '1'");

    if (_query != [] && _query.isNotEmpty) {
      completedCount = _query.length;
      Debug.printLog(
          "getCompleteDayCountByPlanId -->>" + _query.length.toString());
    }

    return completedCount;
  }

  Future<int> getTotalDayCountOfExByPlanId(String pId) async {
    int totalCount = 0;
    var dbClient = await db;

    List<Map<String, dynamic>> _query = await dbClient
        .rawQuery("SELECT $dayCount FROM $homePlanTable WHERE $planId = $pId");

    if (_query != [] && _query.isNotEmpty) {
      totalCount = _query.first.values.first;
      Debug.printLog(
          "getTotalDayCountOfExByPlanId -->>" + _query.first.values.toString());
    }

    return totalCount;
  }

  Future<List<ReminderTable>> getReminderData() async {
    var dbClient = await db;
    List<ReminderTable> _reminderList = [];

    List<Map<String, dynamic>> _query =
        await dbClient.rawQuery("SELECT * FROM $reminderTable");

    if (_query.isNotEmpty) {
      for (var answer in _query) {
        var reminderTableData = ReminderTable.fromJson(answer);
        Debug.printLog(
            "reminderTableData -->>" + reminderTableData.toJson().toString());
        _reminderList.add(reminderTableData);
      }
    }

    return _reminderList;
  }

  Future<int> insertReminderData(ReminderTable reminderData) async {
    var dbClient = await db;
    var result = await dbClient.insert(reminderTable, reminderData.toJson());

    return result;
  }

  Future<int?> updateReminderStatus(int id, int isActive) async {
    var dbClient = await db;
    var result = await dbClient.rawUpdate(
        "UPDATE $reminderTable SET ${this.isActive} = '$isActive' where $rId = $id");

    Debug.printLog("updateReminderStatus -->>" + result.toString());
    return result;
  }

  Future<int?> updateReminderTime(int id, String time) async {
    var dbClient = await db;
    var result = await dbClient.rawUpdate(
        "UPDATE $reminderTable SET $remindTime = '$time' where $rId = $id");

    Debug.printLog("updateReminderTime -->>" + result.toString());

    return result;
  }

  Future<int?> updateReminderDays(int id, String days, String repeatNo) async {
    var dbClient = await db;
    var result = await dbClient.rawUpdate(
        "UPDATE $reminderTable SET ${this.days} = '$days', ${this.repeatNo} = '$repeatNo' where $rId = $id");

    return result;
  }

  Future<int?> deleteReminder(int id) async {
    var dbClient = await db;
    var result = await dbClient
        .delete(reminderTable, where: "$rId = ?", whereArgs: [id]);

    Debug.printLog("deleteReminder -->>" + result.toString());
    return result;
  }

  Future<List<HomePlanTable>> getHomePlanList(String strPlanType) async {
    var dbClient = await db;
    List<HomePlanTable> _homePlanList = [];

    List<Map<String, dynamic>> _query = await dbClient.rawQuery(
        "SELECT * FROM $homePlanTable WHERE $planType = '$strPlanType' ORDER BY $planSort DESC");

    if (_query.isNotEmpty) {
      for (var answer in _query) {
        var homePlanTableData = HomePlanTable.fromJson(answer);
        Debug.printLog(
            "getHomePlanList -->>" + homePlanTableData.toJson().toString());
        _homePlanList.add(homePlanTableData);
      }
    }

    return _homePlanList;
  }

  Future<List<HomePlanTable>> getHomeSubPlanList(String parentPlanId) async {
    var dbClient = await db;
    List<HomePlanTable> _homePlanSubList = [];

    List<Map<String, dynamic>> _query = await dbClient.rawQuery(
        "SELECT * FROM $homePlanTable WHERE ${this.parentPlanId} = $parentPlanId AND $planType = '${Constant.planTypeBodyFocus}' ORDER BY $planSort");

    if (_query.isNotEmpty) {
      for (var answer in _query) {
        var homePlanTableData = HomePlanTable.fromJson(answer);
        Debug.printLog(
            "getHomeSubPlanList -->>" + homePlanTableData.toJson().toString());
        _homePlanSubList.add(homePlanTableData);
      }
    }

    return _homePlanSubList;
  }

  Future<List<HomePlanTable>> getBodyFocusSubPlanList(String parentPlanId) async {
    var dbClient = await db;
    List<HomePlanTable> _homePlanSubList = [];

    List<Map<String, dynamic>> _query = await dbClient.rawQuery(
        "SELECT * FROM $homePlanTable WHERE ${this.parentPlanId} = $parentPlanId ORDER BY $planSort");

    if (_query.isNotEmpty) {
      for (var answer in _query) {
        var homePlanTableData = HomePlanTable.fromJson(answer);
        Debug.printLog(
            "getHomeSubPlanList -->>" + homePlanTableData.toJson().toString());
        _homePlanSubList.add(homePlanTableData);
      }
    }

    return _homePlanSubList;
  }

  ///Todo Get Weekly Day wise Data
  Future<List<PWeeklyDayData>> getWorkoutWeeklyData(
      String strCategoryName, String planId) async {
    var dbClient = await db;
    List<PWeeklyDayData> _pWeeklyDayDataList = [];

    List<Map<String, dynamic>> _query = await dbClient.rawQuery(
        "SELECT max($dayId) as DayId, ${this.planId}, group_concat(DISTINCT(CAST($dayName as INTEGER))) as $dayName, $weekName, $isCompleted from $planDaysTable where ${this.planId} = $planId GROUP BY CAST($weekName as INTEGER)");

    if (_query.isNotEmpty) {
      for (var answer in _query) {
        var pWeeklyDayData = PWeeklyDayData.fromJson(answer);
        pWeeklyDayData.categoryName = strCategoryName;
        pWeeklyDayData.arrWeekDayData =
            await getWeekDaysData(pWeeklyDayData.weekName, planId);
        Debug.printLog(
            "getWorkoutWeeklyData -->>" + pWeeklyDayData.toJson().toString());
        _pWeeklyDayDataList.add(pWeeklyDayData);
      }
    }

    return _pWeeklyDayDataList;
  }

  Future<List<PWeekDayData>> getWeekDaysData(
      String strWeekName, String planId) async {
    var dbClient = await db;
    List<PWeekDayData> _pWeekDayDataList = [];

    List<Map<String, dynamic>> _query = await dbClient.rawQuery(
        "SELECT $dayName,$dayId,$isCompleted,$planMinutes,$planWorkouts FROM $planDaysTable WHERE $weekName = '$strWeekName' AND ${this.planId} = '$planId'");

    if (_query.isNotEmpty) {
      for (var answer in _query) {
        var pWeekDayData = PWeekDayData.fromJson(answer);
        Debug.printLog(
            "getWeekDaysData -->>" + pWeekDayData.toJson().toString());
        _pWeekDayDataList.add(pWeekDayData);
      }
    }

    return _pWeekDayDataList;
  }

  Future<int> getCompleteDayExList(String strDayId) async {
    var count = 0;
    var dbClient = await db;

    List<Map<String, dynamic>> _query = await dbClient.rawQuery(
        "Select $dayExId From $dayExTable where $dayId = $strDayId AND $isCompleted = 1 AND $isDeleted = '0'");

    if (_query != [] && _query.isNotEmpty) {
      count = _query.length;
      Debug.printLog(
          "getCompleteDayExList -->>" + _query.first.values.toString());
    }

    return count;
  }

  Future restartDayPlan(int planId) async {
    var dbClient = await db;

    await dbClient.rawUpdate(
        "UPDATE $dayExTable SET $isCompleted = '0', $status = ${Constant.statusSyncDeleted} where ${this.planId} = $planId");

    await dbClient.rawUpdate(
        "UPDATE $planDaysTable SET $isCompleted = '0', $status = ${Constant.statusSyncDeleted} where ${this.planId} = $planId");

    FirestoreHelper().syncDataWhenInternetIsConnect();
  }

  Future<List<HomeExTableClass>> getHomeDetailExList(String strPlanId) async {
    var dbClient = await db;
    List<HomeExTableClass> _homeExTableClassList = [];

    List<Map<String, dynamic>> _query = await dbClient.rawQuery(
        "SELECT DX.$dayExId, DX.$planId,"
        "       DX.$dayId,"
        "       DX.$isCompleted,"
        "       DX.$updatedExTime,"
        "       DX.$replaceExId,"
        "       DX.$planSort,"
        "       DX.$defaultSort,"
        "       DX.$isDeleted,"
        "       CASE WHEN DX.$updatedExTime != ''"
        "       THEN DX.$updatedExTime"
        "       ELSE DX.$exTime"
        "       END as $exTime, "
        "       CASE WHEN DX.$replaceExId != ''"
        "       THEN DX.$replaceExId"
        "       ELSE DX.$exId"
        "       END as $exId, "
        "EX.$exDescription, EX.$exVideo,EX.$exPath,EX.$exName,Ex.$exUnit FROM $HomeExSingleTable as DX "
        "INNER JOIN $ExerciseTable as EX ON "
        "(CASE WHEN DX.$replaceExId != ''"
        "       THEN DX.$replaceExId"
        "       ELSE DX.$exId"
        "       END)"
        "= EX.$exId WHERE DX.$planId = $strPlanId ORDER BY DX.$planSort");

    if (_query.isNotEmpty) {
      for (var answer in _query) {
        var homeExTableClassData = HomeExTableClass.fromJson(answer);
        Debug.printLog("getHomeDetailExList -->>" +
            homeExTableClassData.toJson().toString());
        _homeExTableClassList.add(homeExTableClassData);
      }
    }

    return _homeExTableClassList;
  }

  Future<List<HomeExTableClass>> getDayExList(String strDayId) async {
    var dbClient = await db;
    List<HomeExTableClass> _homeExTableClassList = [];

    List<Map<String, dynamic>> _query = await dbClient.rawQuery(
        "SELECT DX.$dayExId, DX.$planId,"
        "       DX.$dayId,"
        "       DX.$isCompleted,"
        "       DX.$updatedExTime,"
        "       DX.$replaceExId,"
        "       DX.$isDeleted,"
        "       DX.$planSort,"
        "       DX.$defaultSort,"
        "       CASE WHEN DX.$updatedExTime != ''"
        "       THEN DX.$updatedExTime"
        "       ELSE DX.$exTime"
        "       END as $exTime, "
        "       CASE WHEN DX.$replaceExId != ''"
        "       THEN DX.$replaceExId"
        "       ELSE DX.$exId"
        "       END as $exId, "
        "EX.$exDescription, EX.$exVideo,EX.$exPath,EX.$exName,Ex.$exUnit FROM $dayExTable as DX "
        "INNER JOIN $ExerciseTable as EX ON "
        "(CASE WHEN DX.$replaceExId != ''"
        "       THEN DX.$replaceExId"
        "       ELSE DX.$exId"
        "       END)"
        "= EX.$exId WHERE DX.$dayId = $strDayId AND DX.$isDeleted = '0' ORDER BY DX.$planSort");

    if (_query.isNotEmpty) {
      for (var answer in _query) {
        var homeExTableClassData = HomeExTableClass.fromJson(answer);
        Debug.printLog(
            "getDayExList -->>" + homeExTableClassData.toJson().toString());
        _homeExTableClassList.add(homeExTableClassData);
      }
    }

    return _homeExTableClassList;
  }

  /// Weight Table Queries
  Future<int> insertWeightData(WeightTable weightData) async {
    var dbClient = await db;

    var result = await dbClient.insert(weightTable, weightData.toJson());

    Debug.printLog("insert weight res: $result");
    FirestoreHelper().syncDataWhenInternetIsConnect();
    return result;
  }

  Future<List<WeightTable>> getWeightData() async {
    var dbClient = await db;
    List<WeightTable> weightDataList = [];
    List<Map<String, dynamic>> maps =
        await dbClient.rawQuery("SELECT * FROM $weightTable WHERE $status != ${Constant.statusSyncDeleted}");
    if (maps.isNotEmpty) {
      for (var answer in maps) {
        var weightData = WeightTable.fromJson(answer);
        weightDataList.add(weightData);
      }
    }
    return weightDataList;
  }

  Future<int?> getMaxWeight() async {
    var dbClient = await db;
    List<Map<String, dynamic>> _query = await dbClient
        .rawQuery("SELECT MAX(CAST($weightKg as INTEGER)) from $WeightTable WHERE $status != ${Constant.statusSyncDeleted}");
    if (_query != [] && _query.isNotEmpty) {
      return _query.first.values.first;
    }
    return null;
  }

  Future<int?> getMinWeight() async {
    var dbClient = await db;
    List<Map<String, dynamic>> _query = await dbClient
        .rawQuery("SELECT MIN(CAST($weightKg as INTEGER)) from $weightTable WHERE $status != ${Constant.statusSyncDeleted}");
    if (_query != [] && _query.isNotEmpty) {
      return _query.first.values.first;
    }
    return null;
  }

  Future<int?> updateWeight(
      {int? id, String? weightKG, String? weightLBS}) async {
    var dbClient = await db;
    var result = await dbClient.rawUpdate(
        " UPDATE $weightTable SET $weightKg = $weightKG, $weightLb = $weightLBS, $status = ${Constant.statusSyncPending} where $weightId = '$id' ");
    Debug.printLog("update weight res: $result");
    FirestoreHelper().syncDataWhenInternetIsConnect();
    return result;
  }

  Future<int> updateCompleteExByDayExId(String strDayExId) async {
    var dbClient = await db;

    var result = await dbClient.rawUpdate(
        "UPDATE $dayExTable SET $isCompleted = '1', $status = ${Constant.statusSyncPending} where $dayExId = $strDayExId");

    Debug.printLog("updateCompleteExByDayExId -->> " + result.toString());

    return result;
  }

  Future<int> updateCompleteHomeExByDayExId(String strDayExId) async {
    var dbClient = await db;

    var result = await dbClient.rawUpdate(
        "UPDATE $homeExSingleTable SET $isCompleted = '1', $status = ${Constant.statusSyncPending} where $dayExId = $strDayExId");

    Debug.printLog("updateCompleteHomeExByDayExId -->> " + result.toString());
    return result;
  }

  Future<int> addHistory(HistoryTable historyTable) async {
    var dbClient = await db;
    var result =
        await dbClient.insert(this.historyTable, historyTable.toJson());
    Debug.printLog("addHistory -->> " + result.toString());
    FirestoreHelper().syncDataWhenInternetIsConnect();
    return result;
  }

  Future<String> getPlanNameByPlanId(String strId) async {
    String planName = "";
    var dbClient = await db;

    List<Map<String, dynamic>> _query = await dbClient.rawQuery(
        "Select ${this.planName} From $homePlanTable where $planId = $strId");

    if (_query != [] && _query.isNotEmpty) {
      planName = _query.first.values.first;
      Debug.printLog(
          "getPlanNameByPlanId -->>" + _query.first.values.toString());
    }
    return planName;
  }

  Future<String> getPlanDayNameByDayId(String strId) async {
    String planDayName = "";
    var dbClient = await db;

    List<Map<String, dynamic>> _query = await dbClient.rawQuery(
        "Select $dayName,$weekName From $planDaysTable where $dayId = $strId");

    if (_query != [] && _query.isNotEmpty) {
      planDayName = _query.first.values.first;
      Debug.printLog(
          "getPlanDayNameByDayId -->>" + _query.first.values.toString());
    }
    return planDayName;
  }

  Future<String> getRemindersListString() async {
    String reminders = "";
    var dbClient = await db;

    List<Map<String, dynamic>> _query = await dbClient
        .rawQuery("Select * From $reminderTable order by $rId DESC");

    if (_query != [] && _query.isNotEmpty) {
      for (int i = 0; i < _query.length; i++) {
        if (reminders == "") {
          reminders = _query[i][remindTime];
        } else {
          reminders = "$reminders, " + _query[i][remindTime];
        }
      }
      Debug.printLog("getRemindersListString -->>" + reminders.toString());
    }
    return reminders;
  }

  Future<int> updatePlanDayCompleteByDayId(String strDayId) async {
    var dbClient = await db;

    var result = await dbClient.rawUpdate(
        "UPDATE $planDaysTable SET $isCompleted = '1', $status = ${Constant.statusSyncPending} where $dayId = $strDayId");

    Debug.printLog("updatePlanDayCompleteByDayId -->> " + result.toString());
    return result;
  }

  Future restartProgress() async {
    var dbClient = await db;
    var res1 = await dbClient.rawUpdate("UPDATE $historyTable SET $status = ${Constant.statusSyncDeleted}");
    var res2 = await dbClient.rawUpdate("UPDATE $weightTable SET $status = ${Constant.statusSyncDeleted}");
    var res3 = await dbClient.rawUpdate("UPDATE $planDaysTable SET $isCompleted = '0', $status = ${Constant.statusSyncDeleted} WHERE $isCompleted = '1'");
    var res4 = await dbClient.rawUpdate("UPDATE $homeExSingleTable SET $isCompleted = '0', $status = ${Constant.statusSyncDeleted} WHERE $isCompleted = '1'");
    var res5 = await dbClient.rawUpdate("UPDATE $dayExTable SET $isCompleted = '0', $status = ${Constant.statusSyncDeleted} WHERE $isCompleted = '1'");

    Preference.shared.setInt(Preference.prefCurrentWaterGlass, 0);
    await Preference.shared.resetLastSelectedDay();

    Preference.shared.setBool(Preference.resetCompleteAllEx, Constant.boolValueTrue);

    FirestoreHelper().syncDataWhenInternetIsConnect();

    Debug.printLog("res1 -->> " +
        res1.toString() +
        "\tres2 -->> " +
        res2.toString() +
        "\tres3 -->> " +
        res3.toString() +
        "\tres4 -->> " +
        res4.toString() +
        "\tres5 -->> " +
        res5.toString());
  }

  Future<List<HistoryTable>> getHistoryData() async {
    var dbClient = await db;
    List<HistoryTable> historyDataList = [];
    List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        "SELECT * FROM $historyTable WHERE $status != ${Constant.statusSyncDeleted}");
    if (maps.isNotEmpty) {
      for (var answer in maps) {
        var historyData = HistoryTable.fromJson(answer);
        historyData.planDetail =
            await getPlanByPlanId(int.parse(historyData.hPlanId!));
        historyDataList.add(historyData);
      }
    }
    return historyDataList;
  }

  Future<List<HistoryTable>> getRecentHistoryData() async {
    var dbClient = await db;
    List<HistoryTable> historyDataList = [];
    List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        "SELECT * FROM $historyTable WHERE $status != ${Constant.statusSyncDeleted} order by $hId DESC ");
    if (maps.isNotEmpty) {
      for (var answer in maps) {
        var historyData = HistoryTable.fromJson(answer);
        historyData.planDetail =
            await getPlanByPlanId(int.parse(historyData.hPlanId!));
        historyDataList.add(historyData);
      }
    }
    return historyDataList;
  }

  Future<List<HistoryWeekData>> getHistoryWeekData() async {
    var dbClient = await db;
    List<HistoryWeekData> historyDataList = [];
    List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        "select strftime('%W', $hDateTime) as weekNumber, max(date($hDateTime, 'weekday 0' ,'-6 day')) as weekStart, max(date($hDateTime, 'weekday 0', '-0 day')) as weekEnd from $historyTable WHERE $status != ${Constant.statusSyncDeleted} GROUP BY weekNumber");
    if (maps.isNotEmpty) {
      for (var answer in maps) {
        var historyWeekData = HistoryWeekData();
        var historyData = HistoryWeekData.fromJson(answer);

        historyWeekData.weekNumber = historyData.weekNumber;
        historyWeekData.weekStart = historyData.weekStart;
        historyWeekData.weekEnd = historyData.weekEnd;

        historyWeekData.totKcal = await getTotBurnWeekKcal(
            historyData.weekStart!, historyData.weekEnd!);

        historyWeekData.totTime = await getTotWeekWorkoutTime(
            historyData.weekStart!, historyData.weekEnd!);

        historyWeekData.arrHistoryDetail = await getWeekHistoryData(
            historyData.weekStart!, historyData.weekEnd!);

        historyWeekData.totWorkout = historyWeekData.arrHistoryDetail!.length;
        historyDataList.add(historyWeekData);
      }
    }

    return historyDataList.reversed.toList();
  }

  Future<double?> getTotBurnWeekKcal(
      String strWeekStart, String strWeekEnd) async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery(
        "SELECT sum($hBurnKcal) as HBurnKcalTotal from $historyTable WHERE date('$strWeekStart') <= date($hDateTime) AND date('$strWeekEnd') >= date($hDateTime) AND $status != ${Constant.statusSyncDeleted}");
    if (res.isNotEmpty) {
      return res.first.values.first;
    } else {
      return 0;
    }
  }

  Future<double?> getTotWeekWorkoutTime(
      String strWeekStart, String strWeekEnd) async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery(
        "SELECT sum(CAST($hCompletionTime AS DOUBLE)) as HDuration from $historyTable WHERE date('$strWeekStart') <= date($hDateTime) AND date('$strWeekEnd') >= date($hDateTime) AND $status != ${Constant.statusSyncDeleted}");
    if (res.isNotEmpty) {
      return res.first.values.first;
    } else {
      return 0;
    }
  }

  Future<List<HistoryTable>?> getWeekHistoryData(
      String strWeekStart, String strWeekEnd) async {
    var dbClient = await db;
    List<HistoryTable> historyData = [];
    List<Map<String, dynamic>> res = await dbClient.rawQuery(
        "SELECT * FROM $historyTable WHERE date('$strWeekStart') <= date($hDateTime) AND date('$strWeekEnd') >= date($hDateTime) AND $status != ${Constant.statusSyncDeleted} Order by $hId Desc");
    if (res.isNotEmpty) {
      for (var answer in res) {
        var data = HistoryTable.fromJson(answer);
        data.planDetail = await getPlanByPlanId(int.parse(data.hPlanId!));
        historyData.add(data);
      }
    }
    return historyData;
  }

  Future<HomePlanTable?> getPlanByPlanId(int planIdData) async {
    var dbClient = await db;
    HomePlanTable? homePlanTableData;
    List<Map<String, dynamic>> result = await dbClient
        .rawQuery("Select * From $homePlanTable where $planId = '$planIdData'");
    if (result.isNotEmpty) {
      for (var answer in result) {
        var data = HomePlanTable.fromJson(answer);
        homePlanTableData = data;
      }
      return homePlanTableData;
    }
    return null;
  }

  Future<int?> deleteHistory(int historyId) async {
    var dbClient = await db;
    var result = await dbClient.rawUpdate(
        "UPDATE $historyTable SET $status = ${Constant.statusSyncDeleted} where $hId = $historyId");

    Debug.printLog("deleteHistory -->>" + result.toString());
    FirestoreHelper().syncDataWhenInternetIsConnect();
    return result;
  }

  Future<int> getHistoryTotalWorkout() async {
    int totWorkoutSum = 0;
    String totWorkout = "totWorkout";
    var dbClient = await db;

    List<Map<String, dynamic>> _query = await dbClient.rawQuery(
        "SELECT SUM(CAST($hTotalEx as INTEGER)) as $totWorkout FROM $historyTable WHERE $status != ${Constant.statusSyncDeleted}");

    if (_query != [] && _query.isNotEmpty) {
      if (_query.first[totWorkout] != null) {
        totWorkoutSum = _query.first[totWorkout];
      }
      Debug.printLog("getHistoryTotalWorkout -->>" + totWorkoutSum.toString());
    }

    return totWorkoutSum;
  }

  Future<double> getHistoryTotalKCal() async {
    double totKcalSum = 0.0;
    var dbClient = await db;

    List<Map<String, dynamic>> _query = await dbClient.rawQuery(
        "SELECT SUM(CAST($hBurnKcal as Float)) as $hBurnKcal FROM $historyTable WHERE $status != ${Constant.statusSyncDeleted}");

    if (_query != [] && _query.isNotEmpty) {
      if (_query.first[hBurnKcal] != null) {
        totKcalSum = _query.first[hBurnKcal];
      }
      Debug.printLog("getHistoryTotalKCal -->>" + totKcalSum.toString());
    }

    return totKcalSum;
  }

  Future<int> getHistoryTotalMinutes() async {
    int totMinutesSum = 0;
    var dbClient = await db;

    List<Map<String, dynamic>> _query = await dbClient.rawQuery(
        "SELECT SUM(CAST($hCompletionTime as INTEGER)) as $hCompletionTime FROM $historyTable WHERE $status != ${Constant.statusSyncDeleted}");

    if (_query != [] && _query.isNotEmpty) {
      if (_query.first[hCompletionTime] != null) {
        totMinutesSum = _query.first[hCompletionTime];
      }
      Debug.printLog("getHistoryTotalMinutes -->>" + totMinutesSum.toString());
    }

    return totMinutesSum;
  }

  Future<bool?> isHistoryAvailableDateWise(String date) async {
    var dbClient = await db;
    List<Map> res = await dbClient.rawQuery(
        "SELECT $hId FROM $historyTable WHERE DateTime(strftime('%Y-%m-%d', DateTime($hDateTime))) = DateTime(strftime('%Y-%m-%d', DateTime('$date'))) AND $status != ${Constant.statusSyncDeleted}");
    if (res.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<ExerciseTable>> getAllExerciseList() async {
    var dbClient = await db;
    List<ExerciseTable> exerciseList = [];
    List<Map<String, dynamic>> res =
        await dbClient.rawQuery("Select * From $exerciseTable");
    if (res.isNotEmpty) {
      Debug.printLog("length: " + res.length.toString());
      for (var answer in res) {
        var exData = ExerciseTable.fromJson(answer);
        exerciseList.add(exData);
      }
    }
    return exerciseList;
  }

  /// Queries for edit plan
  Future<int> updatePlan(HomeExTableClass item) async {
    Map<String, dynamic> row = {
      planSort: item.planSort,
      updatedExTime: item.updatedExTime,
      replaceExId: item.replaceExId,
      status: Constant.statusSyncPending,
    };
    var dbClient = await db;
    var result = await dbClient.update(homeExSingleTable, row,
        where: '$dayExId = ?', whereArgs: [item.dayExId]);
    Debug.printLog("res:updatePlan ::::::::  $result  ");
    return result;
  }

  Future<int> deletePlan(HomeExTableClass item) async {
    Debug.printLog("deleted ==> ${item.isDeleted}");
    Map<String, dynamic> row = {
      isDeleted: '1',
      status: Constant.statusSyncPending,
    };
    var dbClient = await db;
    var result = await dbClient.update(homeExSingleTable, row,
        where: '$dayExId = ?', whereArgs: [item.dayExId]);
    Debug.printLog("res:deletePlan ::::::::  $result  ");
    return result;
  }

  Future<int> updatePlanDayEx(HomeExTableClass item) async {
    Map<String, dynamic> row = {
      planSort: item.planSort,
      updatedExTime: item.updatedExTime,
      replaceExId: item.replaceExId,
      status: Constant.statusSyncPending,
    };
    var dbClient = await db;
    var result = await dbClient.update(dayExTable, row,
        where: '$dayExId = ?', whereArgs: [item.dayExId]);
    Debug.printLog("res:updatePlan ::::::::  $result  ");
    return result;
  }

  Future<int> deletePlanDayEx(HomeExTableClass item) async {
    Debug.printLog("deleted ==> ${item.isDeleted}");
    Map<String, dynamic> row = {
      isDeleted: '1',
      status: Constant.statusSyncPending,
    };
    var dbClient = await db;
    var result = await dbClient.update(dayExTable, row,
        where: '$dayExId = ?', whereArgs: [item.dayExId]);
    Debug.printLog("res:deletePlanDayEx ::::::::  $result  ");
    return result;
  }

  Future<int> resetPlan(HomeExTableClass item) async {
    Map<String, dynamic> row = {
      planSort: item.defaultPlanSort,
      updatedExTime: "",
      replaceExId: "",
      isDeleted: "0",
      status: Constant.statusSyncPending,
    };
    var dbClient = await db;
    var result = await dbClient.update(homeExSingleTable, row,
        where: '$dayExId = ?', whereArgs: [item.dayExId]);
    Debug.printLog("res:resetPlan ::::::::  $result  ");
    return result;
  }

  Future<int> resetPlanDayEx(HomeExTableClass item) async {
    Map<String, dynamic> row = {
      planSort: item.defaultPlanSort,
      updatedExTime: "",
      replaceExId: "",
      isDeleted: "0",
      status: Constant.statusSyncPending,
    };
    var dbClient = await db;
    var result = await dbClient.update(dayExTable, row,
        where: '$dayExId = ?', whereArgs: [item.dayExId]);
    Debug.printLog("res:resetPlanDay ::::::::  $result  ");
    return result;
  }

  Future restartPlanDayEx(int strId, bool daysPlan) async {
    var dbClient = await db;
    Map<String, dynamic> row = {
      isCompleted: '0',
      status: Constant.statusSyncPending,
    };
    int result;

    if (daysPlan) {
      result = await dbClient
          .update(dayExTable, row, where: '$dayId = ?', whereArgs: [strId]);
    } else {
      result = await dbClient.update(homeExSingleTable, row,
          where: '$planId = ?', whereArgs: [strId]);
    }

    return result;
  }

  /// <><><><><>----------------->><><><><><> For The Sync <><><><><><<-----------------<><><><><>

  /// DayExTable

  Future<List<DayExTable>> getDayExTableData() async {
    var dbClient = await db;
    List<DayExTable> _dayExTableList = [];

    List<Map<String, dynamic>> _query = await dbClient
        .rawQuery("SELECT * FROM $dayExTable where $status != ${Constant.statusSyncCompleted}");

    if (_query.isNotEmpty) {
      for (var answer in _query) {
        var _dayExTableData = DayExTable.fromJson(answer);
        Debug.printLog("_dayExTableData -->>" + _dayExTableData.toJson().toString());
        _dayExTableList.add(_dayExTableData);
      }
    }
    return _dayExTableList;
  }

  Future<int> updateDayExTableData(Map<String, dynamic> element) async {
    var dbClient = await db;
    element.remove(createdAt);
    var result = await dbClient.update(dayExTable, element,
        where: '$dayExId = ?', whereArgs: [element[dayExId]]);
    return result;
  }

  Future deleteDayExTableData(List<DayExTable> element) async {
    var dbClient = await db;
    for (var item in element) {
      await dbClient.rawUpdate("UPDATE $dayExTable SET $isCompleted = '0', $status = ${Constant.statusSyncCompleted} WHERE $dayExId = ${item.id}");
    }
  }

  /// HistoryTable

  Future<List<HistoryTable>> getHistoryTableData() async {
    var dbClient = await db;
    List<HistoryTable> _historyTableList = [];

    List<Map<String, dynamic>> _query = await dbClient.rawQuery(
        "SELECT * FROM $historyTable WHERE $status != ${Constant.statusSyncCompleted} ");

    if (_query.isNotEmpty) {
      for (var answer in _query) {
        var _historyTableData = HistoryTable.fromJson(answer);
        Debug.printLog(
            "_historyTableData -->>" + _historyTableData.toJson().toString());
        _historyTableList.add(_historyTableData);
      }
    }
    return _historyTableList;
  }

  Future<int> updateHistoryTableData(Map<String, dynamic> element) async {
    var dbClient = await db;

    var query = "SELECT * FROM $historyTable WHERE $hId = '${element[hId]}'";

    List<Map<String, dynamic>> list = await dbClient.rawQuery(query);
    element.remove(createdAt);
    dynamic result;
    if (list.isEmpty) {
      result = await dbClient.insert(historyTable, element);
    } else {
      result = await dbClient.update(historyTable, element,
          where: '$hId = ?', whereArgs: [element[hId]]);
    }

    return result;
  }

  Future deleteHistoryTableData(List<HistoryTable> element) async {
    var dbClient = await db;
    for (var item in element) {
      await dbClient
          .delete(historyTable, where: "$hId = ?", whereArgs: [item.hid]);
    }
  }

  /// HomeExSingleTable

  Future<List<HomeExSingleTable>> getHomeExSingleTableData() async {
    var dbClient = await db;
    List<HomeExSingleTable> _homeExSingleTableList = [];

    List<Map<String, dynamic>> _query = await dbClient
        .rawQuery("SELECT * FROM $homeExSingleTable where $status != ${Constant.statusSyncCompleted}");

    if (_query.isNotEmpty) {
      for (var answer in _query) {
        var _homeExSingleTableData = HomeExSingleTable.fromJson(answer);
        Debug.printLog("_homeExSingleTableData -->>" +
            _homeExSingleTableData.toJson().toString());
        _homeExSingleTableList.add(_homeExSingleTableData);
      }
    }
    return _homeExSingleTableList;
  }

  Future<int> updateHomeExSingleTableData(Map<String, dynamic> element) async {
    var dbClient = await db;
    element.remove(createdAt);
    var result = await dbClient.update(homeExSingleTable, element,
        where: '$dayExId = ?', whereArgs: [element[dayExId]]);
    return result;
  }

  Future deleteHomeExSingleTableData(List<HomeExSingleTable> element) async {
    var dbClient = await db;
    for (var item in element) {
      await dbClient.rawUpdate("UPDATE $homeExSingleTable SET $isCompleted = '0', $status = ${Constant.statusSyncCompleted} WHERE $dayExId = ${item.id}");
    }
  }

  /// PlanDaysTable

  Future<List<PlanDaysTable>> getPlanDaysTableData() async {
    var dbClient = await db;
    List<PlanDaysTable> _planDaysTableList = [];

    List<Map<String, dynamic>> _query = await dbClient
        .rawQuery("SELECT * FROM $planDaysTable where $status != ${Constant.statusSyncCompleted}");

    if (_query.isNotEmpty) {
      for (var answer in _query) {
        var _planDaysTableData = PlanDaysTable.fromJson(answer);
        Debug.printLog(
            "_planDaysTableData -->>" + _planDaysTableData.toJson().toString());
        _planDaysTableList.add(_planDaysTableData);
      }
    }
    return _planDaysTableList;
  }

  Future<int> updatePlanDaysTableData(Map<String, dynamic> element) async {
    var dbClient = await db;
    element.remove(createdAt);
    var result = await dbClient.update(planDaysTable, element,
        where: '$dayId = ?', whereArgs: [element[dayId]]);
    return result;
  }

  Future deletePlanDaysTableData(List<PlanDaysTable> element) async {
    var dbClient = await db;
    for (var item in element) {
      await dbClient.rawUpdate("UPDATE $planDaysTable SET $isCompleted = '0', $status = ${Constant.statusSyncCompleted} WHERE $dayId = ${item.dayId}");
    }
  }

  /// WeightTable

  Future<List<WeightTable>> getWeightTableData() async {
    var dbClient = await db;
    List<WeightTable> _weightTableList = [];

    List<Map<String, dynamic>> _query = await dbClient
        .rawQuery("SELECT * FROM $weightTable WHERE $status != ${Constant.statusSyncCompleted} ");

    if (_query.isNotEmpty) {
      for (var answer in _query) {
        var _weightTableData = WeightTable.fromJson(answer);
        Debug.printLog(
            "_weightTableData -->>" + _weightTableData.toJson().toString());
        _weightTableList.add(_weightTableData);
      }
    }
    return _weightTableList;
  }

  Future<int> updateWeightTableData(Map<String, dynamic> element) async {
    var dbClient = await db;

    var query =
        "SELECT * FROM $weightTable WHERE $weightId = '${element[weightId]}'";

    List<Map<String, dynamic>> list = await dbClient.rawQuery(query);
    element.remove(createdAt);
    dynamic result;
    if (list.isEmpty) {
      result = await dbClient.insert(weightTable, element);
    } else {
      result = await dbClient.update(weightTable, element,
          where: '$weightId = ?', whereArgs: [element[weightId]]);
    }

    return result;
  }

  Future deleteWeightTableData(List<WeightTable> element) async {
    var dbClient = await db;
    for (var item in element) {
      await dbClient
          .delete(weightTable, where: "$weightId = ?", whereArgs: [item.weightId]);
    }
  }
}
