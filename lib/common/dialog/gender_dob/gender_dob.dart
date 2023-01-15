import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/ui/report/controllers/report_controller.dart';
import 'package:women_lose_weight_flutter/utils/preference.dart';

import '../../../utils/color.dart';
import '../../../utils/constant.dart';
import '../../../utils/sizer_utils.dart';

class GenderDOBDialog extends StatefulWidget {
  const GenderDOBDialog({Key? key}) : super(key: key);

  @override
  State<GenderDOBDialog> createState() => _GenderDOBDialogState();
}

class _GenderDOBDialogState extends State<GenderDOBDialog> {
  bool isMale = true;
  bool isFemale = false;
  int dobMonth = 01;
  int dobDay = 01;
  int dobYear = 1960;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.transparent,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: Wrap(
            children: [
              GetBuilder<ReportController>(id: Constant.idGenderDOBDialog, builder: (logic) {
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
                        margin: EdgeInsets.only(
                            top: AppSizes.height_3,
                            bottom: AppSizes.height_1,
                            right: AppSizes.width_5,
                            left: AppSizes.width_5),
                        child: Text(
                          "txtGender".tr,
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: AppFontSize.size_16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: AppSizes.height_1_5),
                        padding:
                        EdgeInsets.symmetric(horizontal: AppSizes.width_5),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (!isMale) {
                                      isMale = true;
                                      isFemale = false;
                                    logic.update([Constant.idGenderDOBDialog]);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: AppSizes.width_1_5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: (isMale)
                                        ? AppColor.primary
                                        : AppColor.white,
                                    border: Border.all(
                                      color: (isMale)
                                          ? AppColor.primary
                                          : AppColor.txtColor666,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text(
                                    "txtMale".tr,
                                    style: TextStyle(
                                      color: (isMale)
                                          ? AppColor.white
                                          : AppColor.txtColor666,
                                      fontSize: AppFontSize.size_11,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: AppSizes.width_4),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (!isFemale) {
                                      isFemale = true;
                                      isMale = false;
                                    logic.update([Constant.idGenderDOBDialog]);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: AppSizes.width_1_5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: (isFemale)
                                        ? AppColor.primary
                                        : AppColor.white,
                                    border: Border.all(
                                      color: (isFemale)
                                          ? AppColor.primary
                                          : AppColor.txtColor666,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Container(
                                    margin:
                                    const EdgeInsets.only(left: 5, right: 5),
                                    child: Text(
                                      "txtFemale".tr,
                                      style: TextStyle(
                                        color: (isFemale)
                                            ? AppColor.white
                                            : AppColor.txtColor666,
                                        fontSize: AppFontSize.size_11,
                                        fontWeight: FontWeight.w400,
                                      ),
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
                            top: AppSizes.height_5,
                            bottom: AppSizes.height_1,
                            right: AppSizes.width_5,
                            left: AppSizes.width_5),
                        child: Text(
                          "txtYearOfBirth".tr,
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: AppFontSize.size_16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        margin:
                        EdgeInsets.symmetric(vertical: AppSizes.height_5),
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.width_13),
                        child: Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: AppSizes.fullHeight * 0.25,
                                child: CupertinoPicker(
                                  useMagnifier: Constant.boolValueFalse,
                                  scrollController:
                                  FixedExtentScrollController(initialItem: 0),
                                  looping: Constant.boolValueTrue,
                                  onSelectedItemChanged: (value) {
                                      dobMonth = value + 1;
                                    logic.update([Constant.idGenderDOBDialog]);
                                  },
                                  itemExtent: 50.0,
                                  selectionOverlay: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                            width: 1.8,
                                            color: AppColor
                                                .numberPickerDividerColor),
                                        bottom: BorderSide(
                                            width: 1.8,
                                            color: AppColor
                                                .numberPickerDividerColor),
                                      ),
                                    ),
                                  ),
                                  children: List.generate(
                                    12,
                                        (index) {
                                      index += 1;
                                      return Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          index.toString().padLeft(2, "0"),
                                          style: TextStyle(
                                            color: AppColor.primary,
                                            fontSize: AppFontSize.size_18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: AppSizes.width_5),
                            Expanded(
                              child: SizedBox(
                                height: AppSizes.fullHeight * 0.25,
                                child: CupertinoPicker(
                                  useMagnifier: Constant.boolValueFalse,
                                  scrollController:
                                  FixedExtentScrollController(initialItem: 0),
                                  looping: Constant.boolValueTrue,
                                  onSelectedItemChanged: (value) {
                                      dobDay = value + 1;
                                    logic.update([Constant.idGenderDOBDialog]);
                                  },
                                  itemExtent: 50.0,
                                  selectionOverlay: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                            width: 1.8,
                                            color: AppColor
                                                .numberPickerDividerColor),
                                        bottom: BorderSide(
                                            width: 1.8,
                                            color: AppColor
                                                .numberPickerDividerColor),
                                      ),
                                    ),
                                  ),
                                  children: List.generate(
                                    30,
                                        (index) {
                                      index += 1;
                                      return Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          index.toString().padLeft(2, "0"),
                                          style: TextStyle(
                                            color: AppColor.primary,
                                            fontSize: AppFontSize.size_18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: AppSizes.width_5),
                            Expanded(
                              child: SizedBox(
                                height: AppSizes.fullHeight * 0.25,
                                child: CupertinoPicker(
                                  useMagnifier: Constant.boolValueFalse,
                                  scrollController:
                                  FixedExtentScrollController(initialItem: 0),
                                  looping: Constant.boolValueTrue,
                                  onSelectedItemChanged: (value) {
                                      dobYear = value + 1960;
                                    logic.update([Constant.idGenderDOBDialog]);
                                  },
                                  itemExtent: 50.0,
                                  selectionOverlay: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                            width: 1.8,
                                            color: AppColor
                                                .numberPickerDividerColor),
                                        bottom: BorderSide(
                                            width: 1.8,
                                            color: AppColor
                                                .numberPickerDividerColor),
                                      ),
                                    ),
                                  ),
                                  children: List.generate(
                                    52,
                                        (index) {
                                      index += 1960;
                                      return Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          index.toString().padLeft(2, "0"),
                                          style: TextStyle(
                                            color: AppColor.primary,
                                            fontSize: AppFontSize.size_18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: AppSizes.height_7,
                            right: AppSizes.width_5,
                            left: AppSizes.width_5,
                            bottom: AppSizes.height_3),
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
                                "txtPrevious".tr.toUpperCase(),
                                style: TextStyle(
                                  color: AppColor.primary,
                                  fontSize: AppFontSize.size_11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Spacer(),
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
                                var dob = dobMonth.toString().padLeft(2, "0") +
                                    "-" + dobDay.toString().padLeft(2, "0") +
                                    "-" + dobYear.toString();
                                Preference.shared.setString(
                                    Preference.prefDOB, dob);
                                if (isMale) {
                                  Preference.shared.setString(
                                      Preference.prefGender, Constant.male);
                                } else {
                                  Preference.shared.setString(
                                      Preference.prefGender, Constant.female);
                                }
                                Get.back();
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
}
