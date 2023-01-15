import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:women_lose_weight_flutter/common/dialog/add_weight/add_weight.dart';
import 'package:women_lose_weight_flutter/common/dialog/weight_height/weight_height.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/preference.dart';
import 'package:women_lose_weight_flutter/utils/utils.dart';
import '../../../database/table/weight_table.dart';
import '../../../utils/debug.dart';

class ReportController extends GetxController {
  List<charts.Series<LinearSales, DateTime>>? series;
  List<LinearSales> data = [];

  double? bmi;
  String? currentWeightUnit;
  String? currentHeightUnit;
  int? currentWeight;
  int maxWeight = 0;
  int minWeight = 0;
  String? height;
  String? bmiCategory;
  Color? bmiColor;

  int totalWorkouts = 0;
  double totalKcal = 0.0;
  int totalMinute = 0;

  List<bool> isAvailableHistory = [];
  int completedCount = 0;

  @override
  void onInit() {
    refreshData();
    int totalDaysInYear = DateTime(DateTime.now().year, 12, 31)
        .difference(DateTime(DateTime.now().year, 1, 1))
        .inDays;
    DateTime start = DateTime(DateTime.now().year, 1, 1);
    for (int i = 0; i < totalDaysInYear; i++) {
      data.add(LinearSales(start, null));
      start = start.add(const Duration(days: 1));
    }
    super.onInit();
  }

  fillChartData() {
    series = [
      charts.Series<LinearSales, DateTime>(
        id: 'Weight',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(AppColor.primary),
        domainFn: (LinearSales sales, _) => sales.date,
        measureFn: (LinearSales sales, _) => sales.sales,
        radiusPxFn: (LinearSales sales, _) => 5,
        data: data,
      )
    ];
  }

  double? bmiValuePosition(double fullWidth) {
    if (bmi! <= 15) {
      return fullWidth * -0.45;
    } else if (bmi! > 15 && bmi! < 16) {
      return _setBmiCalculationInLoop(fullWidth, 10, 0.09, -0.45, 0);
    } else if (bmi! >= 16 && bmi! <= 18.5) {
      return _setBmiCalculationInLoop(fullWidth, 25, 16.00, -0.36, 16.00);
    } else if (bmi! >= 18.5 && bmi! < 25) {
      return _setBmiCalculationInLoop(fullWidth, 65, 18.00, -0.20, 24.00);
    } else if (bmi! >= 25 && bmi! < 30) {
      return _setBmiCalculationInLoop(fullWidth, 50, 25.00, 0.04, 17.00);
    } else if (bmi! >= 30 && bmi! < 35) {
      return _setBmiCalculationInLoop(fullWidth, 50, 30.00, 0.21, 11.00);
    } else if (bmi! >= 35 && bmi! < 40) {
      return _setBmiCalculationInLoop(fullWidth, 50, 35.00, 0.32, 12.00);
    } else if (bmi! >= 40) {
      return fullWidth * 0.44;
    }
    return null;
  }

  _setBmiCalculationInLoop(double fullWidth, int totalDiffInLoop,
      double startingPoint, double totalWidth, double totalDiffForTwoPoint) {
    var pos = 0;

    for (int i = 0; i < totalDiffInLoop; i++) {
      if (bmi == startingPoint ||
          (bmi! > startingPoint &&
              bmi! <= (startingPoint + (0.10 * (i + 1))))) {
        break;
      } else {
        pos++;
      }
    }
    if (pos == 0) {
      pos = 1;
    }
    double bmiVal = 0;
    bmiVal = ((pos * totalDiffForTwoPoint) / totalDiffInLoop) / 100;
    Debug.printLog("bmiVal===>>  " + bmiVal.toString() + "  " + pos.toString());
    return fullWidth * (totalWidth + bmiVal);
  }

  _getCurrentWeightUnit() {
    currentWeightUnit =
        Preference.shared.getString(Preference.currentWeightUnit) ??
            Constant.weightUnitKg;
    update([Constant.idReportCurrentWeightUnit]);
  }

  _getCurrentWeight() {
    if (currentWeightUnit == Constant.weightUnitKg) {
      currentWeight = Preference.shared.getInt(Preference.currentWeightInKg) ??
          Constant.weightKg;
    }
    update([Constant.idReportCurrentWeight]);
  }

  _getMinWeight() async {
    var minWeightData = await DBHelper.dbHelper.getMinWeight();
    if (minWeightData != null) {
      if (currentWeightUnit == Constant.weightUnitKg) {
        minWeight = minWeightData;
        update([Constant.idReportMinWeight]);
      } else {
        minWeight =  Utils.convertWeightKgToLbs(minWeightData);
        update([Constant.idReportMinWeight]);
      }
    } else {
      minWeight = 0;
      update([Constant.idReportMinWeight]);
    }
    minWeightData = null;
  }

  _getMaxWeight() async {
    var maxWeightData = await DBHelper.dbHelper.getMaxWeight();
    if (maxWeightData != null) {
      if (currentWeightUnit == Constant.weightUnitKg) {
        maxWeight = maxWeightData;
        update([Constant.idReportMaxWeight]);
      } else {
        maxWeight = Utils.convertWeightKgToLbs(maxWeightData);
        update([Constant.idReportMaxWeight]);
      }
    } else {
      maxWeight = 0;
      update([Constant.idReportMaxWeight]);
    }
    maxWeightData = null;
  }

  refreshData() {
    _getBmiData();
    _getCurrentWeightUnit();
    _getWeightData();
    _getMaxWeight();
    _getMinWeight();
    _getCurrentWeight();
    getTotalData();
    getHistoryWeekWise();
  }

  _getWeightData() async {
    List<WeightTable> weightDataList = await DBHelper.dbHelper.getWeightData();

    if (currentWeightUnit == Constant.weightUnitKg) {
      for (var element in weightDataList) {
        DateTime date = DateTime.parse(element.weightDate!);
        var index =
            data.indexWhere((element) => element.date.isAtSameMomentAs(date));
        if (index > 0) {
          data[index].sales = int.parse(element.weightKg!);
        }
      }
    } else {
      for (var element in weightDataList) {
        DateTime date = DateTime.parse(element.weightDate!);
        var index =
            data.indexWhere((element) => element.date.isAtSameMomentAs(date));
        if (index > 0) {
          data[index].sales = int.parse(element.weightLb!);
        }
      }
    }
    update([Constant.idReportWeightChart]);
  }

  _getBmiData() {
    bmi = Preference.shared.getDouble(Preference.prefCurrentBMI) ?? 0;
    currentHeightUnit =
        Preference.shared.getString(Preference.currentHeightUnit) ??
            Constant.heightUnitCm;
    currentWeightUnit =
        Preference.shared.getString(Preference.currentWeightUnit) ??
            Constant.weightUnitKg;
    if (currentHeightUnit == Constant.heightUnitCm) {
      var cm = Preference.shared.getInt(Preference.currentHeightInCm) ??
          Constant.heightCm;
      height = cm.toString() + " " + currentHeightUnit!;
    } 
    bmiTextCategory();
    update([
      Constant.idReportBmiChart,
      Constant.idReportMinWeight,
      Constant.idReportMaxWeight,
      Constant.idReportCurrentWeight
    ]);
  }

  bmiTextCategory() {
    if (bmi! < 15) {
      bmiCategory = "txtSeverelyUnderweight".tr;
      bmiColor = AppColor.black;
      Preference.shared.setString(Preference.prefBMItext, bmiCategory!);
    } else if (bmi! >= 15 && bmi! < 16) {
      bmiCategory = "txtVeryUnderweight".tr;
      bmiColor = AppColor.bmiFirstColor;
      Preference.shared.setString(Preference.prefBMItext, bmiCategory!);
    } else if (bmi! >= 16 && bmi! < 18.5) {
      bmiCategory = "txtUnderweight".tr;
      bmiColor = AppColor.bmiSecondColor;
      Preference.shared.setString(Preference.prefBMItext, bmiCategory!);
    } else if (bmi! >= 18.5 && bmi! <= 25) {
      bmiCategory = "txtHealthyWeight".tr;
      bmiColor = AppColor.bmiThirdColor;
      Preference.shared.setString(Preference.prefBMItext, bmiCategory!);
    } else if (bmi! > 25 && bmi! < 30) {
      bmiCategory = "txtOverWeight".tr;
      bmiColor = AppColor.bmiFourColor;
      Preference.shared.setString(Preference.prefBMItext, bmiCategory!);
    } else if (bmi! >= 30 && bmi! < 35) {
      bmiCategory = "txtModeratelyObese".tr;
      bmiColor = AppColor.bmiFiveColor;
      Preference.shared.setString(Preference.prefBMItext, bmiCategory!);
    } else if (bmi! >= 35 && bmi! < 40) {
      bmiCategory = "txtObese".tr;
      bmiColor = AppColor.bmiSixColor;
      Preference.shared.setString(Preference.prefBMItext, bmiCategory!);
    } else if (bmi! >= 40) {
      bmiCategory = "txtSeverelyObese".tr;
      bmiColor = AppColor.black;
      Preference.shared.setString(Preference.prefBMItext, bmiCategory!);
    }
  }

  getTotalData() async {
    totalWorkouts = await DBHelper.dbHelper.getHistoryTotalWorkout();
    totalKcal = await DBHelper.dbHelper.getHistoryTotalKCal();
    totalMinute = await DBHelper.dbHelper.getHistoryTotalMinutes();
    update([Constant.idTotal]);
  }

   getHistoryWeekWise() async {
     isAvailableHistory.clear();
     completedCount = 0;
    Utils.getDaysDateForHistoryOfWeek().forEach((element) async {
      bool? isAvailable = await DBHelper.dbHelper.isHistoryAvailableDateWise(element.toString());
      if (isAvailableHistory.length < 7) {
        if (isAvailable!) {
          completedCount += 1;
        }
        isAvailableHistory.add(isAvailable);
      }
    });
    update([Constant.idReportWeekHistory]);
  }

  onAddWeightClick(){
    showDialog(
      context: Get.context!,
      builder: (context) => const AddWeightDialog(),
    ).then((value) {
      refreshWeightData();
    });
  }

  void refreshWeightData() {
    _getCurrentWeightUnit();
    _getCurrentWeight();
    _getWeightData();
    _getMaxWeight();
    _getMinWeight();
    _getBmiData();
  }

  onBMIAddClick() {
    showDialog(
      context: Get.context!,
      builder: (context) => const WeightHeightDialog(),
    ).then((value) {
      refreshWeightData();
    });
  }
}

class LinearSales {
  DateTime date;
  int? sales;

  LinearSales(this.date, this.sales);
}
