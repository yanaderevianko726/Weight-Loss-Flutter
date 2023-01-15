import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/ui/my_profile/controllers/my_profile_controller.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

import '../../../utils/color.dart';
import '../../../utils/constant.dart';
import '../../../utils/utils.dart';

class DialogWeight extends StatelessWidget {
  final bool isFromCurrentWeight;

  DialogWeight(this.isFromCurrentWeight, {Key? key}) : super(key: key);
  final MyProfileController _myProfileController =
      Get.find<MyProfileController>();

  @override
  Widget build(BuildContext context) {
    if (isFromCurrentWeight) {
      _myProfileController.getWeightPreferenceData();
    } else {
      _myProfileController.getTargetWeightPreferenceData();
    }
    return Center(
      child: Wrap(
        children: [
          Container(
            width: AppSizes.fullWidth,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(2),
            ),
            margin: EdgeInsets.symmetric(horizontal: AppSizes.width_6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: AppSizes.width_5,
                      right: AppSizes.width_5,
                      top: AppSizes.height_2_5),
                  child: Text(
                    "txtWeight".tr,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppFontSize.size_17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GetBuilder<MyProfileController>(
                  id: Constant.idChooseWeightPickerDialog,
                  builder: (logic) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: ((isFromCurrentWeight
                                      ? logic.weightUnitValue
                                      : logic.targetWeightUnitValue) ==
                                  Constant.valueOne)
                              ? AppSizes.width_23
                              : AppSizes.width_28,
                          vertical: AppSizes.height_3_2),
                      child: Row(
                        children: [
                          if ((isFromCurrentWeight
                                  ? logic.weightUnitValue
                                  : logic.targetWeightUnitValue) ==
                              Constant.valueOne) ...{
                            Expanded(
                              child: SizedBox(
                                height: AppSizes.fullHeight * 0.25,
                                child: CupertinoPicker(
                                  useMagnifier: Constant.boolValueFalse,
                                  scrollController: isFromCurrentWeight
                                      ? logic.fixedExtentScrollControllerWeight
                                      : logic
                                          .fixedExtentScrollControllerTargetWeight,
                                  looping: Constant.boolValueTrue,
                                  onSelectedItemChanged: (value) {
                                    
                                  },
                                  itemExtent: 60.0,
                                  selectionOverlay: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                            width: 0.5,
                                            color: AppColor.primary),
                                        bottom: BorderSide(
                                            width: 0.5,
                                            color: AppColor.primary),
                                      ),
                                    ),
                                  ),
                                  children: List.generate(
                                    2157,
                                    (index) {
                                      index += 44;
                                      return Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          Utils.decimalNumberFormat(index)
                                              .toString(),
                                          style: TextStyle(
                                            color: AppColor.black,
                                            fontSize: AppFontSize.size_20,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          } else ...{
                            Expanded(
                              child: SizedBox(
                                height: AppSizes.fullHeight * 0.25,
                                child: CupertinoPicker(
                                  useMagnifier: Constant.boolValueTrue,
                                  looping: Constant.boolValueTrue,
                                  scrollController: isFromCurrentWeight
                                      ? logic.fixedExtentScrollControllerWeight
                                      : logic
                                          .fixedExtentScrollControllerTargetWeight,
                                  onSelectedItemChanged: (value) {
                                    if (isFromCurrentWeight) {
                                      logic.onChangeKgValue(value + 20);
                                    } else {
                                      logic.onChangeKgTargetValue(value + 20);
                                    }
                                  },
                                  itemExtent: 60.0,
                                  selectionOverlay: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                            width: 0.5,
                                            color: AppColor.primary),
                                        bottom: BorderSide(
                                            width: 0.5,
                                            color: AppColor.primary),
                                      ),
                                    ),
                                  ),
                                  children: List.generate(
                                    978,
                                    (index) {
                                      index += 20;
                                      return Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          Utils.decimalNumberFormat(index)
                                              .toString(),
                                          style: TextStyle(
                                            color: AppColor.black,
                                            fontSize: AppFontSize.size_20,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          },
                          Expanded(
                            child: SizedBox(
                              height: AppSizes.fullHeight * 0.25,
                              child: CupertinoPicker(
                                useMagnifier: Constant.boolValueFalse,
                                scrollController: FixedExtentScrollController(
                                    initialItem: (isFromCurrentWeight
                                        ? logic.weightUnitValue
                                        : logic.targetWeightUnitValue)),
                                looping: Constant.boolValueFalse,
                                onSelectedItemChanged: (value) {
                                  // if (isFromCurrentWeight) {
                                  //   logic.onChangeWeightUnit(value);
                                  // } else {
                                  //   logic.onChangeTargetWeightUnit(value);
                                  // }
                                },
                                itemExtent: 60.0,
                                selectionOverlay: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          width: 0.5, color: AppColor.primary),
                                      bottom: BorderSide(
                                          width: 0.5, color: AppColor.primary),
                                    ),
                                  ),
                                ),
                                children: List.generate(
                                  (isFromCurrentWeight)
                                      ? logic.weightUnitList.length
                                      : logic.targetWeightUnitList.length,
                                  (index) {
                                    return Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        (isFromCurrentWeight)
                                            ? logic.weightUnitList[index]
                                            : logic.targetWeightUnitList[index],
                                        style: TextStyle(
                                          color: AppColor.black,
                                          fontSize: AppFontSize.size_20,
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
                    );
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColor.grayDivider),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(2)),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: AppSizes.height_0_8),
                          child: Text(
                            "txtCancel".tr.toUpperCase(),
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: AppFontSize.size_14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColor.primary),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(2)),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: AppSizes.height_0_8),
                          child: Text(
                            "txtSave".tr.toUpperCase(),
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: AppFontSize.size_14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (isFromCurrentWeight) {
                            _myProfileController.onWeightSaveButtonClick();
                          } else {
                            _myProfileController
                                .onTargetWeightSaveButtonClick();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
