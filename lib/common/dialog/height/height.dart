import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/ui/my_profile/controllers/my_profile_controller.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

import '../../../utils/color.dart';
import '../../../utils/constant.dart';
import '../../../utils/utils.dart';

class DialogHeight extends StatelessWidget {
  DialogHeight({Key? key}) : super(key: key);

  final MyProfileController _myProfileController =
      Get.find<MyProfileController>();

  @override
  Widget build(BuildContext context) {
    _myProfileController.getHeightPreferenceData();
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
                    "txtHeight".tr,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppFontSize.size_17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GetBuilder<MyProfileController>(
                  id: Constant.idChooseHeightPickerDialog,
                  builder: (logic) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              (logic.heightUnitValue == Constant.valueOne)
                                  ? AppSizes.width_20
                                  : AppSizes.width_25,
                          vertical: AppSizes.height_3_2),
                      child: Row(
                        children: [
                          if (logic.heightUnitValue == Constant.valueOne) ...{
                            Expanded(
                              child: SizedBox(
                                height: AppSizes.fullHeight * 0.25,
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: AppSizes.width_1),
                                      child: Text(
                                        "'",
                                        style: TextStyle(
                                          color: AppColor.black,
                                          fontSize: AppFontSize.size_22,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: AppSizes.fullHeight * 0.25,
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: AppSizes.width_1),
                                      child: Text(
                                        "''",
                                        style: TextStyle(
                                          color: AppColor.black,
                                          fontSize: AppFontSize.size_22,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
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
                                  scrollController:
                                      logic.fixedExtentScrollControllerCm,
                                  onSelectedItemChanged: (value) {
                                    logic.onChangeCMValue(value + 20);
                                  },
                                  itemExtent: 60.0,
                                  selectionOverlay: Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                            width: 0.8,
                                            color: AppColor.primary),
                                        bottom: BorderSide(
                                            width: 0.8,
                                            color: AppColor.primary),
                                      ),
                                    ),
                                  ),
                                  children: List.generate(
                                    381,
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
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: AppSizes.fullHeight * 0.25,
                              child: CupertinoPicker(
                                useMagnifier: Constant.boolValueFalse,
                                scrollController: FixedExtentScrollController(
                                    initialItem: logic.heightUnitValue),
                                looping: Constant.boolValueFalse,
                                onSelectedItemChanged: (value) {
                                  
                                },
                                itemExtent: 60.0,
                                selectionOverlay: Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          width: 0.8, color: AppColor.primary),
                                      bottom: BorderSide(
                                          width: 0.8, color: AppColor.primary),
                                    ),
                                  ),
                                ),
                                children: List.generate(
                                  logic.heightUnitList.length,
                                  (index) {
                                    return Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        logic.heightUnitList[index],
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
                          _myProfileController.onHeightSaveButtonClick();
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
