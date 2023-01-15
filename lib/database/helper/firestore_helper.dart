import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/database/table/home_ex_single_table.dart';
import 'package:women_lose_weight_flutter/database/table/plan_days_table.dart';
import 'package:women_lose_weight_flutter/database/table/weight_table.dart';
import 'package:women_lose_weight_flutter/main.dart';
import 'package:women_lose_weight_flutter/ui/me/controllers/me_controller.dart';
import 'package:women_lose_weight_flutter/ui/plan/controllers/plan_controller.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/preference.dart';
import 'package:women_lose_weight_flutter/utils/utils.dart';

import '../../ui/home/controllers/home_controller.dart';
import '../../utils/debug.dart';
import '../table/day_ex_table.dart';
import '../table/history_table.dart';

class FirestoreHelper {
  /// USER TABLE
  String usersTable = "Users";
  String userId = "UserId";
  String userName = "UserName";
  String userEmail = "UserEmail";
  String createdAt = "CreatedAt";
  String updatedAt = "UpdatedAt";
  String lastSync = "LastSync";
  String lastDayCompleteLoseWeight = "LastDayCompleteLoseWeight";
  String lastDayCompleteButtLift = "LastDayCompleteButtLift";
  String lastDayCompleteLoseBelly = "LastDayCompleteLoseBelly";
  String lastDayCompleteBuildMuscle = "LastDayCompleteBuildMuscle";

  final HomeController _homeController = Get.find<HomeController>();
  final MeController _meController = Get.find<MeController>();
  final PlanController _planController = Get.find<PlanController>();

  CollectionReference _getDataBaseTable(String tableName) {
    return MyApp.firebaseFirestore.collection(tableName);
  }

  Future onSyncButtonClick({bool isShowToast = Constant.boolValueTrue}) {
    return _getDataBaseTable(usersTable)
        .doc(Utils.getFirebaseUid())
        .get()
        .then((value) {
      if (!value.exists) {
        Debug.printLog("NOT EXIST");
      } else {
        sync(isShowToast: isShowToast);
      }
    });
  }

  syncDataWhenInternetIsConnect() async {
    if (await Utils.isInternetConnectivity() &&
        Utils.getFirebaseUid() != null) {
      Debug.printLog(
          "<><><><<======= syncDataWhenInternetIsConnect =======>><><><>");
      await onSyncButtonClick(isShowToast: Constant.boolValueFalse);
    }
  }

  sync({bool isShowToast = Constant.boolValueTrue}) {
    syncAllDataOnServer()
        .then((value) => syncAllDataInLocal(isShowToast))
        .then((value) => syncLastDate().then((value) => getSyncLastDate()));
  }

  Future syncAllDataOnServer() async {
    await syncGeneralData();

    await syncDayExTableData();
    await syncHistoryTableData();
    await syncHomeExSingleTableData();
    await syncPlanDaysTableData();
    await syncWeightTableData();

    Debug.printLog(
        "--------------<><><> ALL DATA SYNC SUCCESSFULLY ON SERVER <><><>--------------");
  }

  syncAllDataInLocal(bool isShowToast) async {
    await getGeneralData();

    await updateDayExTableData();
    await updateHistoryTableData();
    await updateHomeExSingleTableData();
    await updatePlanDaysTableData();
    await updateWeightTableData();

    if (isShowToast) {
      _homeController.onChangeIsShowLoading(Constant.boolValueFalse);
      Utils.showToast(Get.context!, "txtSyncSuccess".tr);
    }

    Debug.printLog(
        "--------------<><><> ALL DATA UPDATE SUCCESSFULLY ON LOCALLY <><><>--------------");
  }

  /// Main User Table

  addUser(User? user) {
    return _getDataBaseTable(usersTable).doc(user!.uid).get().then((value) {
      if (!value.exists) {
        _getDataBaseTable(usersTable).doc(user.uid).set({
          userId: user.uid,
          userName: user.displayName,
          userEmail: user.email,
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
          lastDayCompleteLoseWeight: Utils.getLastCompletedDay(1),
          lastDayCompleteButtLift: Utils.getLastCompletedDay(2),
          lastDayCompleteLoseBelly: Utils.getLastCompletedDay(3),
          lastDayCompleteBuildMuscle: Utils.getLastCompletedDay(4),
        }).then((value) {
          Debug.printLog("User Added Success");
          sync();
        }).catchError((error) => Debug.printLog("Failed to add user: $error"));
      } else {
        _getDataBaseTable(usersTable).doc(user.uid).update({
          userId: user.uid,
          userName: user.displayName!,
          userEmail: user.email,
          updatedAt: Timestamp.now(),
        }).then((value) {
          Debug.printLog("Update User Success");
          sync();
        }).catchError(
                (error) => Debug.printLog("Failed to Update user: $error"));
      }
    });
  }

  /// Last Sync Date

  Future syncLastDate() async {
    await _getDataBaseTable(usersTable)
        .doc(Utils.getFirebaseUid())
        .update({
      lastSync: Timestamp.now(),
    })
        .then((value) => Debug.printLog("Update Last Sync Date Success"))
        .catchError((error) =>
        Debug.printLog("Failed to Update Last Sync Date: $error"));
  }

  getSyncLastDate() async {
    var data =
    await _getDataBaseTable(usersTable).doc(Utils.getFirebaseUid()).get();

    await Preference.shared.setString(Preference.lastSyncDate,
        DateFormat.jm().format(data[lastSync].toDate()).toString());

    _meController.getLastSyncDate();
    _planController.refreshData();

    Debug.printLog(
        "--------------<><><> UPDATE LAST SYNC DATE <><><>-------------- ${data[lastSync]
            .toDate()}");
  }

  /// General Data

  syncGeneralData() async {
    var data =
    await _getDataBaseTable(usersTable).doc(Utils.getFirebaseUid()).get();

    Map<String, dynamic> map = {
      if (Utils.getLastCompletedDay(1) > data[lastDayCompleteLoseWeight] ||
          Utils.getResetCompletedDay(1) ||
          Utils.getResetCompletedAllEx())
        lastDayCompleteLoseWeight: Utils.getLastCompletedDay(1),
      if (Utils.getLastCompletedDay(2) > data[lastDayCompleteButtLift] ||
          Utils.getResetCompletedDay(2) ||
          Utils.getResetCompletedAllEx())
        lastDayCompleteButtLift: Utils.getLastCompletedDay(2),
      if (Utils.getLastCompletedDay(3) > data[lastDayCompleteLoseBelly] ||
          Utils.getResetCompletedDay(3) ||
          Utils.getResetCompletedAllEx())
        lastDayCompleteLoseBelly: Utils.getLastCompletedDay(3),
      if (Utils.getLastCompletedDay(4) > data[lastDayCompleteBuildMuscle] ||
          Utils.getResetCompletedDay(4) ||
          Utils.getResetCompletedAllEx())
        lastDayCompleteBuildMuscle: Utils.getLastCompletedDay(4),
    };

    await _getDataBaseTable(usersTable)
        .doc(Utils.getFirebaseUid())
        .update(map)
        .then((value) => Debug.printLog("Sync General Data Success"))
        .catchError(
            (error) => Debug.printLog("Failed to Sync General Data: $error"));
  }

  getGeneralData() async {
    var data =
    await _getDataBaseTable(usersTable).doc(Utils.getFirebaseUid()).get();

    Utils.setLastCompletedDay(1, (data[lastDayCompleteLoseWeight] - 1));
    Utils.setLastCompletedDay(2, (data[lastDayCompleteButtLift] - 1));
    Utils.setLastCompletedDay(3, (data[lastDayCompleteLoseBelly] - 1));
    Utils.setLastCompletedDay(4, (data[lastDayCompleteBuildMuscle] - 1));

    await Preference.shared.clearResetCompletedDay();
  }

  /// DayExTable

  syncDayExTableData() async {
    var mainList = await DBHelper.dbHelper.getDayExTableData();
    await deleteAllDayExTableDataFireStore(mainList);
    var uploadList = mainList
        .where((element) => element.status == Constant.statusSyncPending);

    for (var element in uploadList) {
      await _getDataBaseTable(usersTable)
          .doc(Utils.getFirebaseUid())
          .collection(DBHelper.dbHelper.dayExTable)
          .doc(element.id.toString())
          .set({
        DBHelper.dbHelper.dayExId: element.id,
        DBHelper.dbHelper.planId: element.planId,
        DBHelper.dbHelper.dayId: element.dayId,
        DBHelper.dbHelper.exId: element.exId,
        DBHelper.dbHelper.exTime: element.exTime,
        DBHelper.dbHelper.exUnit: element.exUnit,
        DBHelper.dbHelper.isCompleted: element.isCompleted,
        DBHelper.dbHelper.updatedExTime: element.updatedExTime,
        DBHelper.dbHelper.replaceExId: element.replaceExId,
        DBHelper.dbHelper.isDeleted: element.isDeleted,
        DBHelper.dbHelper.planSort: element.sort,
        DBHelper.dbHelper.defaultSort: element.defaultSort,
        DBHelper.dbHelper.createdAt: Timestamp.now(),
        DBHelper.dbHelper.status: 0,
      })
          .then((value) => Debug.printLog("Sync DayExTable Success"))
          .catchError(
              (error) => Debug.printLog("Failed to Sync DayExTable: $error"));
    }
  }

  updateDayExTableData() async {
    var data = await _getDataBaseTable(usersTable)
        .doc(Utils.getFirebaseUid())
        .collection(DBHelper.dbHelper.dayExTable)
        .get();

    final allData = data.docs.map((doc) => doc.data()).toList();
    for (var element in allData) {
      await DBHelper.dbHelper.updateDayExTableData(element);
    }
  }

  Future<void> deleteAllDayExTableDataFireStore(List<DayExTable> list) async {
    var deleteList = list
        .where((element) => (element.status == Constant.statusSyncDeleted))
        .toList();

    if (deleteList.isEmpty) {
      return;
    }

    for (var element in deleteList) {
      await _getDataBaseTable(usersTable)
          .doc(Utils.getFirebaseUid())
          .collection(DBHelper.dbHelper.dayExTable)
          .doc(element.id.toString())
          .delete();
    }

    await DBHelper.dbHelper.deleteDayExTableData(list);
  }

  /// HistoryTable

  syncHistoryTableData() async {
    var mainList = await DBHelper.dbHelper.getHistoryTableData();
    await deleteAllHistoryTableDataFireStore(mainList);
    var uploadList = mainList
        .where((element) => element.status == Constant.statusSyncPending);

    for (var element in uploadList) {
      var doc = _getDataBaseTable(usersTable)
          .doc(Utils.getFirebaseUid())
          .collection(DBHelper.dbHelper.historyTable)
          .doc();

      await doc
          .set({
        DBHelper.dbHelper.hId: element.hid,
        DBHelper.dbHelper.hPlanName: element.hPlanName,
        DBHelper.dbHelper.hPlanId: element.hPlanId,
        DBHelper.dbHelper.hDayName: element.hDayName,
        DBHelper.dbHelper.hBurnKcal: element.hBurnKcal,
        DBHelper.dbHelper.hTotalEx: element.hTotalEx,
        DBHelper.dbHelper.hKg: element.hKg,
        DBHelper.dbHelper.hFeet: element.hFeet,
        DBHelper.dbHelper.hInch: element.hInch,
        DBHelper.dbHelper.hFeelRate: element.hFeelRate,
        DBHelper.dbHelper.hCompletionTime: element.hCompletionTime,
        DBHelper.dbHelper.hDateTime: element.hDateTime,
        DBHelper.dbHelper.hDayId: element.hDayId,
        DBHelper.dbHelper.status: 0,
        DBHelper.dbHelper.createdAt: Timestamp.now(),
        DBHelper.dbHelper.fireStoreID: doc.id,
      })
          .then((value) => Debug.printLog("Sync HistoryTable Success"))
          .catchError(
              (error) => Debug.printLog("Failed to Sync HistoryTable: $error"));
    }
  }

  Future<void> deleteAllHistoryTableDataFireStore(
      List<HistoryTable> list) async {
    var deleteList = list
        .where((element) =>
    (element.status == Constant.statusSyncDeleted &&
        element.fireStoreId != null &&
        element.fireStoreId!.isNotEmpty))
        .toList();

    if (deleteList.isEmpty) {
      return;
    }

    var deleteCollection = await _getDataBaseTable(usersTable)
        .doc(Utils.getFirebaseUid())
        .collection(DBHelper.dbHelper.historyTable)
        .where(DBHelper.dbHelper.fireStoreID,
        whereIn: deleteList.map((e) => e.fireStoreId).toList())
        .get();

    final batch = FirebaseFirestore.instance.batch();

    for (final doc in deleteCollection.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();

    await DBHelper.dbHelper.deleteHistoryTableData(list);
  }

  updateHistoryTableData() async {
    var data = await _getDataBaseTable(usersTable)
        .doc(Utils.getFirebaseUid())
        .collection(DBHelper.dbHelper.historyTable)
        .get();

    final allData = data.docs.map((doc) => doc.data()).toList();
    for (var element in allData) {
      await DBHelper.dbHelper.updateHistoryTableData(element);
    }
  }

  /// HomeExSingleTable

  syncHomeExSingleTableData() async {
    var mainList = await DBHelper.dbHelper.getHomeExSingleTableData();
    await deleteAllHomeExSingleTableDataFireStore(mainList);
    var uploadList = mainList
        .where((element) => element.status == Constant.statusSyncPending);

    for (var element in uploadList) {
      await _getDataBaseTable(usersTable)
          .doc(Utils.getFirebaseUid())
          .collection(DBHelper.dbHelper.homeExSingleTable)
          .doc(element.id.toString())
          .set({
        DBHelper.dbHelper.dayExId: element.id,
        DBHelper.dbHelper.planId: element.planId,
        DBHelper.dbHelper.dayId: element.dayId,
        DBHelper.dbHelper.exId: element.exId,
        DBHelper.dbHelper.exTime: element.exTime,
        DBHelper.dbHelper.isCompleted: element.isCompleted,
        DBHelper.dbHelper.updatedExTime: element.updatedExTime,
        DBHelper.dbHelper.replaceExId: element.replaceExId,
        DBHelper.dbHelper.planSort: element.planId,
        DBHelper.dbHelper.defaultSort: element.defaultSort,
        DBHelper.dbHelper.exUnit: element.exUnit,
        DBHelper.dbHelper.isDeleted: element.isDeleted,
        DBHelper.dbHelper.createdAt: Timestamp.now(),
        DBHelper.dbHelper.status: 0,
      })
          .then((value) => Debug.printLog("Sync HomeExSingleTable Success"))
          .catchError((error) =>
          Debug.printLog("Failed to Sync HomeExSingleTable: $error"));
    }
  }

  updateHomeExSingleTableData() async {
    var data = await _getDataBaseTable(usersTable)
        .doc(Utils.getFirebaseUid())
        .collection(DBHelper.dbHelper.homeExSingleTable)
        .get();

    final allData = data.docs.map((doc) => doc.data()).toList();
    for (var element in allData) {
      await DBHelper.dbHelper.updateHomeExSingleTableData(element);
    }
  }

  Future<void> deleteAllHomeExSingleTableDataFireStore(
      List<HomeExSingleTable> list) async {
    var deleteList = list
        .where((element) => (element.status == Constant.statusSyncDeleted))
        .toList();

    if (deleteList.isEmpty) {
      return;
    }

    for (var element in deleteList) {
      await _getDataBaseTable(usersTable)
          .doc(Utils.getFirebaseUid())
          .collection(DBHelper.dbHelper.homeExSingleTable)
          .doc(element.id.toString())
          .delete();
    }
    await DBHelper.dbHelper.deleteHomeExSingleTableData(list);
  }

  /// PlanDaysTable

  syncPlanDaysTableData() async {
    var mainList = await DBHelper.dbHelper.getPlanDaysTableData();
    await deleteAllPlanDaysTableDataFireStore(mainList);
    var uploadList = mainList
        .where((element) => element.status == Constant.statusSyncPending);

    for (var element in uploadList) {
      await _getDataBaseTable(usersTable)
          .doc(Utils.getFirebaseUid())
          .collection(DBHelper.dbHelper.planDaysTable)
          .doc(element.dayId.toString())
          .set({
        DBHelper.dbHelper.dayId: element.dayId,
        DBHelper.dbHelper.planId: element.planId,
        DBHelper.dbHelper.dayName: element.dayName,
        DBHelper.dbHelper.isCompleted: element.isCompleted,
        DBHelper.dbHelper.dayProgress: element.dayProgress,
        DBHelper.dbHelper.weekName: element.weekName,
        DBHelper.dbHelper.planWorkouts: element.planWorkouts,
        DBHelper.dbHelper.planMinutes: element.planMinutes,
        DBHelper.dbHelper.createdAt: Timestamp.now(),
        DBHelper.dbHelper.status: 0,
      })
          .then((value) => Debug.printLog("Sync PlanDaysTable Success"))
          .catchError((error) =>
          Debug.printLog("Failed to Sync PlanDaysTable: $error"));
    }
  }

  updatePlanDaysTableData() async {
    var data = await _getDataBaseTable(usersTable)
        .doc(Utils.getFirebaseUid())
        .collection(DBHelper.dbHelper.planDaysTable)
        .get();

    final allData = data.docs.map((doc) => doc.data()).toList();
    for (var element in allData) {
      await DBHelper.dbHelper.updatePlanDaysTableData(element);
    }
  }

  Future<void> deleteAllPlanDaysTableDataFireStore(
      List<PlanDaysTable> list) async {
    var deleteList = list
        .where((element) => (element.status == Constant.statusSyncDeleted))
        .toList();

    if (deleteList.isEmpty) {
      return;
    }

    for (var element in deleteList) {
      await _getDataBaseTable(usersTable)
          .doc(Utils.getFirebaseUid())
          .collection(DBHelper.dbHelper.planDaysTable)
          .doc(element.dayId.toString())
          .delete();
    }
    await DBHelper.dbHelper.deletePlanDaysTableData(list);
  }

  /// WeightTable

  syncWeightTableData() async {
    var mainList = await DBHelper.dbHelper.getWeightTableData();
    await deleteAllWeightTableDataFireStore(mainList);
    var uploadList = mainList
        .where((element) => element.status == Constant.statusSyncPending);

    for (var element in uploadList) {
      await _getDataBaseTable(usersTable)
          .doc(Utils.getFirebaseUid())
          .collection(DBHelper.dbHelper.weightTable)
          .doc(element.weightId.toString())
          .set({
        DBHelper.dbHelper.weightId: element.weightId,
        DBHelper.dbHelper.weightKg: element.weightKg,
        DBHelper.dbHelper.weightLb: element.weightLb,
        DBHelper.dbHelper.weightDate: element.weightDate,
        DBHelper.dbHelper.currentTimeStamp: element.currentTimeStamp,
        DBHelper.dbHelper.createdAt: Timestamp.now(),
        DBHelper.dbHelper.status: 0,
      })
          .then((value) => Debug.printLog("Sync WeightTable Success"))
          .catchError(
              (error) => Debug.printLog("Failed to Sync WeightTable: $error"));
    }
  }

  updateWeightTableData() async {
    var data = await _getDataBaseTable(usersTable)
        .doc(Utils.getFirebaseUid())
        .collection(DBHelper.dbHelper.weightTable)
        .get();

    final allData = data.docs.map((doc) => doc.data()).toList();
    for (var element in allData) {
      await DBHelper.dbHelper.updateWeightTableData(element);
    }
  }

  Future<void> deleteAllWeightTableDataFireStore(List<WeightTable> list) async {
    var deleteList = list
        .where((element) => (element.status == Constant.statusSyncDeleted))
        .toList();

    if (deleteList.isEmpty) {
      return;
    }

    var deleteCollection = await _getDataBaseTable(usersTable)
        .doc(Utils.getFirebaseUid())
        .collection(DBHelper.dbHelper.weightTable)
        .where(DBHelper.dbHelper.weightId,
            whereIn: deleteList.map((e) => e.weightId).toList())
        .get();

    final batch = FirebaseFirestore.instance.batch();

    for (final doc in deleteCollection.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();

    await DBHelper.dbHelper.deleteWeightTableData(list);
  }

  Future<void> deleteUserAccountPermanently() async {
    await _getDataBaseTable(usersTable)
        .doc(Utils.getFirebaseUid())
        .collection(DBHelper.dbHelper.dayExTable)
        .get()
        .then((value) async {
      for (var doc in value.docs) {
        await doc.reference.delete();
      }
    });
    await _getDataBaseTable(usersTable)
        .doc(Utils.getFirebaseUid())
        .collection(DBHelper.dbHelper.historyTable)
        .get()
        .then((value) async {
      for (var doc in value.docs) {
        await doc.reference.delete();
      }
    });
    await _getDataBaseTable(usersTable)
        .doc(Utils.getFirebaseUid())
        .collection(DBHelper.dbHelper.homeExSingleTable)
        .get()
        .then((value) async {
      for (var doc in value.docs) {
        await doc.reference.delete();
      }
    });
    await _getDataBaseTable(usersTable)
        .doc(Utils.getFirebaseUid())
        .collection(DBHelper.dbHelper.planDaysTable)
        .get()
        .then((value) async {
      for (var doc in value.docs) {
        await doc.reference.delete();
      }
    });
    await _getDataBaseTable(usersTable)
        .doc(Utils.getFirebaseUid())
        .collection(DBHelper.dbHelper.weightTable)
        .get()
        .then((value) async {
      for (var doc in value.docs) {
        await doc.reference.delete();
      }
    });

    await _getDataBaseTable(usersTable)
        .doc(Utils.getFirebaseUid())
        .delete()
        .then((value) => Debug.printLog("Delete Account Success!!"))
        .catchError(
            (error) => Debug.printLog("Failed to Delete Account: $error"));
  }
}
