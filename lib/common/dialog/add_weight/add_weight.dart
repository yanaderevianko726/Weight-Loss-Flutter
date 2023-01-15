import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/database/table/weight_table.dart';
import 'package:women_lose_weight_flutter/ui/report/controllers/report_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/preference.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';
import 'package:women_lose_weight_flutter/utils/utils.dart';
import '../../../utils/constant.dart';
import '../../../utils/debug.dart';

class AddWeightDialog extends StatefulWidget {
  const AddWeightDialog({Key? key}) : super(key: key);

  @override
  _AddWeightDialogState createState() => _AddWeightDialogState();
}

class _AddWeightDialogState extends State<AddWeightDialog> {
  final DatePickerController _datePickerController = DatePickerController();
  TextEditingController weightController = TextEditingController();

  DateTime _selectedDate = Utils.getDate(DateTime.now());
  bool? isKg;

  int? daysCount;
  DateTime? startDate;
  DateTime? endDate;
  List<WeightTable> weightDataList = [];

  @override
  void initState() {
    getCurrentWeightUnit();
    Future.delayed(const Duration(milliseconds: 100), () {
      _datePickerController.animateToSelection();
    });

    startDate = DateTime(
        DateTime
            .now()
            .year - 1, DateTime
        .now()
        .month, DateTime
        .now()
        .day);
    endDate = DateTime.now().add(const Duration(days: 4));
    daysCount = endDate!.difference(startDate!).inDays;

    getDataFromDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.transparent,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: Wrap(
            children: [
              GetBuilder<ReportController>(id: Constant.idAddWeight, builder: (logic) {
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: AppSizes.width_5),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: AppSizes.height_3),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                var previousMonthDate = DateTime(
                                    _selectedDate.year,
                                    _selectedDate.month - 1,
                                    _selectedDate.day);
                                if (previousMonthDate != startDate) {
                                  _datePickerController
                                      .animateToDate(previousMonthDate);
                                  _selectedDate = previousMonthDate;
                                  logic.update([Constant.idAddWeight]);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppSizes.width_4),
                                child: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  size: AppSizes.height_2,
                                  color: AppColor.txtColor666,
                                ),
                              ),
                            ),
                            Text(
                              DateFormat("MMMM yyyy", Utils.getCurrentLocale())
                                  .format(_selectedDate)
                                  .toString(),
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: AppColor.txtColor666,
                                fontSize: AppFontSize.size_11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                var nextMonthDate = DateTime(_selectedDate.year,
                                    _selectedDate.month + 1, _selectedDate.day);
                                if (nextMonthDate !=
                                    DateTime(
                                        DateTime
                                            .now()
                                            .year,
                                        DateTime
                                            .now()
                                            .month + 1,
                                        DateTime
                                            .now()
                                            .day)) {
                                  _datePickerController
                                      .animateToDate(nextMonthDate);
                                  _selectedDate = nextMonthDate;
                                  logic.update([Constant.idAddWeight]);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: AppSizes.width_4),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: AppSizes.height_2,
                                  color: AppColor.txtColor666,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: AppSizes.height_2),
                        child: DatePicker(
                          DateTime(DateTime
                              .now()
                              .year - 1, DateTime
                              .now()
                              .month,
                              DateTime
                                  .now()
                                  .day),
                          daysCount: daysCount!,
                          controller: _datePickerController,
                          initialSelectedDate: DateTime.now(),
                          selectionColor: AppColor.primary,
                          selectedTextColor: AppColor.white,
                          locale: Utils.getCurrentLocale(),
                          monthTextStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: AppFontSize.size_8_5,
                            color: AppColor.black,
                          ),
                          dateTextStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: AppFontSize.size_15,
                            color: AppColor.black,
                          ),
                          dayTextStyle: TextStyle(
                            fontSize: AppFontSize.size_8_5,
                            fontWeight: FontWeight.w400,
                            color: AppColor.black,
                          ),
                          deactivatedColor: Colors.black26,
                          inactiveDates: [
                            DateTime.now().add(const Duration(days: 1)),
                            DateTime.now().add(const Duration(days: 2)),
                            DateTime.now().add(const Duration(days: 3)),
                          ],
                          onDateChange: (date) {
                            weightController.text = "";
                            _selectedDate = date;

                            if (weightDataList.isNotEmpty) {
                              for (var element in weightDataList) {
                                if (element.weightDate ==
                                    _selectedDate.toString()) {
                                  if (isKg!) {
                                    weightController.text = element.weightKg!;
                                  } else {
                                    weightController.text = element.weightLb!;
                                  }
                                }
                              }
                            }
                            logic.update([Constant.idAddWeight]);
                          },
                        ),
                      ),
                      Divider(
                        thickness: AppSizes.height_0_1,
                        color: AppColor.grayDivider,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: AppSizes.height_2,
                            right: AppSizes.width_5,
                            left: AppSizes.width_5),
                        child: Text(
                          "txtWeight".tr,
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: AppFontSize.size_16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: AppSizes.width_5),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: weightController,
                                maxLines: 1,
                                maxLength: 5,
                                textInputAction: TextInputAction.done,
                                keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,1}')),
                                ],
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: AppFontSize.size_12,
                                  fontWeight: FontWeight.w400,
                                ),
                                cursorColor: AppColor.black,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0.0),
                                  hintText: "0.0",
                                  hintStyle: TextStyle(
                                    color: AppColor.black,
                                    fontSize: AppFontSize.size_12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  counterText: "",
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColor.black),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColor.black),
                                  ),
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColor.black),
                                  ),
                                ),
                                onEditingComplete: () {
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                isKg = true;
                                if (weightController.text.isNotEmpty) {
                                  weightController
                                      .text = Utils.convertWeightLbsToKg(
                                      double.parse(weightController.text))
                                      .toString();
                                }
                                logic.update([Constant.idAddWeight]);
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: AppSizes.width_3),
                                height: AppSizes.height_4_3,
                                width: AppSizes.height_4_3,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:
                                  (isKg!) ? AppColor.primary : AppColor.white,
                                  border: Border.all(
                                    color: (isKg!)
                                        ? AppColor.primary
                                        : AppColor.txtColor666,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Text(
                                  "KG",
                                  // "txtKG".tr.toUpperCase(),
                                  style: TextStyle(
                                    color: (isKg!)
                                        ? AppColor.white
                                        : AppColor.txtColor666,
                                    fontSize: AppFontSize.size_11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                
                              },
                              child: Container(
                                height: AppSizes.height_4_3,
                                width: AppSizes.height_4_3,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColor.white,
                                  border: Border.all(
                                    color: AppColor.txtColor666,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Container(
                                  margin:
                                  const EdgeInsets.only(left: 5, right: 5),
                                  child: Text(
                                    "LB",
                                    // "txtLB".tr.toUpperCase(),
                                    style: TextStyle(
                                      color: AppColor.txtColor666,
                                      fontSize: AppFontSize.size_11,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: AppSizes.height_5_5,
                            right: AppSizes.width_5,
                            left: AppSizes.width_5,
                            bottom: AppSizes.height_2_5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Text(
                                "txtCancel".tr.toUpperCase(),
                                style: TextStyle(
                                  color: AppColor.primary,
                                  fontSize: AppFontSize.size_11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: AppSizes.width_6),
                            InkWell(
                              onTap: () {
                                /// check min & max limit
                                if (double.parse(weightController.text) >=
                                    Constant.minKG &&
                                    double.parse(weightController.text) <=
                                        Constant.maxKG) {
                                  /// insert to database or update if already exist and save prefs
                                  Preference.shared.setString(
                                      Preference.currentWeightUnit,
                                      Constant.weightUnitKg);
                                  onSave();
                                } else {
                                  /// add toast warning for kg
                                  Utils.showToast(
                                      context, 'txtWarningForKg'.tr);
                                }
                              },
                              child: Text(
                                "txtSave".tr.toUpperCase(),
                                style: TextStyle(
                                  color: AppColor.primary,
                                  fontSize: AppFontSize.size_11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  getDataFromDatabase() async {
    weightDataList = await DBHelper.dbHelper.getWeightData();

    if (weightDataList.isNotEmpty) {
      for (var element in weightDataList) {
        if (element.weightDate == _selectedDate.toString()) {
          if (isKg!) {
            weightController.text = element.weightKg!;
          } else {
            weightController.text = element.weightLb!;
          }
        }
      }
    }
  }

  onSave() {
    if (weightDataList.isNotEmpty) {
      Debug.printLog("not empty");
      var res = weightDataList.where((element) =>
      element.weightId ==
          DateTime(
              _selectedDate.year,
              _selectedDate.month,
              _selectedDate.day,
              0,
              0,
              0,
              0,
              0)
              .millisecondsSinceEpoch);
      Debug.printLog("result ==> $res");
      if (res.isNotEmpty) {
        updateWeightDatabase();
      } else {
        insertWeightToDatabase();
      }
    } else {
      insertWeightToDatabase();
    }
    if (_selectedDate.toString() == Utils.getDate(DateTime.now()).toString()) {
      setCurrentWeightPref();
    }
    Get.back();
  }

  void updateWeightDatabase() {
    DBHelper.dbHelper.updateWeight(
      weightKG: double.parse(weightController.text).round().toString(),
      weightLBS: "0",
      id: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          0,
          0,
          0,
          0,
          0)
          .millisecondsSinceEpoch,
    );
  }

  void insertWeightToDatabase() {
    DBHelper.dbHelper.insertWeightData(WeightTable(
      weightId: DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          0,
          0,
          0,
          0,
          0)
          .millisecondsSinceEpoch,
      weightKg: double.parse(weightController.text).round().toString(),
      weightLb: "0",
      weightDate: _selectedDate.toString(),
      currentTimeStamp: DateTime.now().toString(),
      status: Constant.statusSyncPending,
    ));
  }

  void setCurrentWeightPref() {
    Preference.shared.setInt(Preference.currentWeightInKg,
          double.parse(weightController.text).round());
  }

  getCurrentWeightUnit() {
    isKg = true;
  }
}
