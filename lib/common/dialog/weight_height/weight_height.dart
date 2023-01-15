import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/common/dialog/gender_dob/gender_dob.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/database/table/weight_table.dart';
import 'package:women_lose_weight_flutter/ui/report/controllers/report_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

import '../../../utils/constant.dart';
import '../../../utils/debug.dart';
import '../../../utils/preference.dart';
import '../../../utils/utils.dart';

class WeightHeightDialog extends StatefulWidget {
  const WeightHeightDialog({Key? key}) : super(key: key);

  @override
  _WeightHeightDialogState createState() => _WeightHeightDialogState();
}

class _WeightHeightDialogState extends State<WeightHeightDialog> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  TextEditingController iController = TextEditingController();
  TextEditingController nController = TextEditingController();

  bool? isKg;
  bool? isCm;

  String? gender;
  String? dob;

  List<WeightTable> weightDataList = [];

  @override
  void initState() {
    getPrefs();
    getCurrentWeightHeightUnit();
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
              Container(
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
                      margin: EdgeInsets.only(
                          top: AppSizes.height_3,
                          bottom: AppSizes.height_1,
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
                    GetBuilder<ReportController>(id: Constant.idBMIWeight, builder: (logic) {
                      return Padding(
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
                                cursorColor: AppColor.primary,
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
                                    borderSide:
                                    BorderSide(color: AppColor.primary),
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
                      );
                    }),
                    Container(
                      margin: EdgeInsets.only(
                          top: AppSizes.height_5,
                          bottom: AppSizes.height_1,
                          right: AppSizes.width_5,
                          left: AppSizes.width_5),
                      child: Text(
                        "txtHeight".tr,
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: AppFontSize.size_16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GetBuilder<ReportController>(id: Constant.idBMIHeight, builder: (logic) {
                      return Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: AppSizes.width_5),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: iController,
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
                                      cursorColor: AppColor.primary,
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.all(
                                            0.0),
                                        hintText: "0.0",
                                        hintStyle: TextStyle(
                                          color: AppColor.black,
                                          fontSize: AppFontSize.size_12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        counterText: "",
                                        enabledBorder: const UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: AppColor.black),
                                        ),
                                        focusedBorder: const UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: AppColor.primary),
                                        ),
                                        border: const UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: AppColor.black),
                                        ),
                                      ),
                                      onEditingComplete: () {
                                        FocusScope.of(context).unfocus();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {

                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: AppSizes.width_3),
                                height: AppSizes.height_4_3,
                                width: AppSizes.height_4_3,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:
                                  (isCm!) ? AppColor.primary : AppColor.white,
                                  border: Border.all(
                                    color: (isCm!)
                                        ? AppColor.primary
                                        : AppColor.txtColor666,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Text(
                                  "CM",
                                  style: TextStyle(
                                    color: (isCm!)
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
                                if (isCm!) {
                                    isCm = false;
                                    if (iController.text.isNotEmpty) {
                                      var inch = Utils.cmToInch(
                                          double.parse(iController.text));
                                      iController.text =
                                          Utils.calcInchToFeet(inch).toString();
                                      nController.text =
                                          Utils.calcInFromInch(inch).toString();
                                    }
                                  logic.update([Constant.idBMIHeight]);
                                }
                              },
                              child: Container(
                                height: AppSizes.height_4_3,
                                width: AppSizes.height_4_3,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color:AppColor.white,
                                  border: Border.all(
                                    color: AppColor.txtColor666,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    Container(
                      margin: EdgeInsets.only(
                          top: AppSizes.height_7,
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
                              if (weightController.text.isEmpty ||
                                  iController.text.isEmpty) {
                                Utils.showToast(
                                    context, "txtWarningForBMIDialog".tr);
                              } else if (isKg! &&
                                  (double.parse(weightController.text) >
                                      Constant.maxKG ||
                                      double.parse(weightController.text) <
                                          Constant.minKG)) {
                                Utils.showToast(context, "txtWarningForKg".tr);
                              } else if (isCm! &&
                                  (double.parse(iController.text) >
                                      Constant.maxCM ||
                                      double.parse(iController.text) <
                                          Constant.minCM)) {
                                Utils.showToast(context, "txtWarningForCm".tr);
                              } else if (!isCm! &&
                                  (double.parse(iController.text) >
                                      Constant.maxFT ||
                                      double.parse(iController.text) <
                                          Constant.minFT)) {
                                Utils.showToast(context, "txtWarningForFt".tr);
                              } else if (!isCm! &&
                                  (double.parse(nController.text) >
                                      Constant.maxIn ||
                                      double.parse(nController.text) <
                                          Constant.minIN)) {
                                Utils.showToast(context, "txtWarningForIn".tr);
                              } else {
                                dynamic weight;
                                if (isKg!) {
                                  weight = double.parse(weightController.text);
                                  Preference.shared.setInt(
                                      Preference.currentWeightInKg,
                                      weight.toInt());
                                  Preference.shared.setString(
                                      Preference.currentWeightUnit,
                                      Constant.weightUnitKg);
                                }
                                
                                addWeightToDatabase();

                                if (gender == null && dob == null) {
                                  Get.back();
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                    const GenderDOBDialog(),
                                  );
                                } else {
                                  Get.back();
                                }
                              }
                            },
                            child: Text(
                              gender != null && dob != null
                                  ? "txtSet".tr.toUpperCase()
                                  : "txtNext".tr.toUpperCase(),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  getCurrentWeightHeightUnit() {
    isKg = true;
    var wt = Preference.shared.getInt(Preference.currentWeightInKg) ?? "";
    weightController.text = wt.toString();

    var hUnit = Preference.shared.getString(Preference.currentHeightUnit) ??
        Constant.heightUnitCm;
    if (hUnit == Constant.heightUnitCm) {
      isCm = true;
      var cm = Preference.shared.getInt(Preference.currentHeightInCm) ?? "";
      iController.text = cm.toString();
    } 
  }

  getPrefs() {
    gender = Preference.shared.getString(Preference.prefGender);
    dob = Preference.shared.getString(Preference.prefDOB);
  }

  getDataFromDatabase() async {
    weightDataList = await DBHelper.dbHelper.getWeightData();

    if (weightDataList.isNotEmpty) {
      for (var element in weightDataList) {
        if (element.weightDate == Utils.getDate(DateTime.now()).toString()) {
          if (isKg!) {
            weightController.text = element.weightKg!;
          } else {
            weightController.text = element.weightLb!;
          }
        }
      }
    }
  }

  addWeightToDatabase() {
    if (weightDataList.isNotEmpty) {
      Debug.printLog("not empty");
      var res = weightDataList.where((element) =>
      element.weightId == DateTime(
          DateTime
              .now()
              .year,
          DateTime
              .now()
              .month,
          DateTime
              .now()
              .day,
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
  }

  void updateWeightDatabase() {
    DBHelper.dbHelper.updateWeight(
      weightKG: double.parse(weightController.text).round().toString(),
      weightLBS: "0",
      id: DateTime(
          DateTime
              .now()
              .year,
          DateTime
              .now()
              .month,
          DateTime
              .now()
              .day,
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
          DateTime
              .now()
              .year,
          DateTime
              .now()
              .month,
          DateTime
              .now()
              .day,
          0,
          0,
          0,
          0,
          0)
          .millisecondsSinceEpoch,
      weightKg: double.parse(weightController.text).round().toString(),
      weightLb: "0",
      weightDate: Utils.getDate(DateTime.now()).toString(),
      currentTimeStamp: DateTime.now().toString(),
      status: Constant.statusSyncPending,
    ));
  }
}
