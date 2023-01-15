import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/ui/choose_height/controllers/choose_height_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

import '../../../utils/utils.dart';

class ChooseHeightScreen extends StatelessWidget {
  ChooseHeightScreen({Key? key}) : super(key: key);

  final ChooseHeightController _chooseHeightController =
      Get.find<ChooseHeightController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          children: [
            _textSkip(),
            _textHowMuchDoYouWeight(),
            _widgetHeightSelection(),
            _btnNext(),
          ],
        ),
      ),
    );
  }

  _textSkip() {
    return Container(
      width: AppSizes.fullWidth,
      margin: EdgeInsets.only(
          left: AppSizes.width_6,
          right: AppSizes.width_7_5,
          top: AppSizes.height_3_7),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Utils.backWidget(),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              Utils.onIntroductionSkipButtonClick();
            },
            child: Text(
              "txtSkip".tr.toUpperCase(),
              textAlign: TextAlign.end,
              style: TextStyle(
                color: AppColor.txtColor999,
                fontSize: AppFontSize.size_12_5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _textHowMuchDoYouWeight() {
    return Container(
      width: AppSizes.fullWidth,
      margin: EdgeInsets.only(top: AppSizes.height_2_5),
      padding: EdgeInsets.symmetric(horizontal: AppSizes.width_6),
      child: Text(
        "txtHowTallAreYou".tr.toUpperCase(),
        textAlign: TextAlign.start,
        style: TextStyle(
          color: AppColor.primary,
          fontSize: AppFontSize.size_22,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _widgetHeightSelection() {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              Image.asset(
                Constant.getAssetIcons() + "icon_guide_height.webp",
                height: AppSizes.height_35,
              ),
              Expanded(child: Container()),
            ],
          ),
          GetBuilder<ChooseHeightController>(
            id: Constant.idChooseHeightPicker,
            builder: (logic) {
              return Container(
                margin: EdgeInsets.only(
                    left: (logic.heightUnitValue == Constant.valueOne)
                        ? AppSizes.width_30
                        : AppSizes.width_36_5,
                    right: (logic.heightUnitValue == Constant.valueOne)
                        ? AppSizes.width_20
                        : AppSizes.width_24_5),
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
                                padding:
                                    EdgeInsets.only(left: AppSizes.width_1),
                                child: Text(
                                  "'",
                                  style: TextStyle(
                                    color: AppColor.primary,
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
                                padding:
                                    EdgeInsets.only(right: AppSizes.width_1),
                                child: Text(
                                  "''",
                                  style: TextStyle(
                                    color: AppColor.primary,
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
                                      width: 1.8,
                                      color: AppColor.numberPickerDividerColor),
                                  bottom: BorderSide(
                                      width: 1.8,
                                      color: AppColor.numberPickerDividerColor),
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
                                    Utils.decimalNumberFormat(index).toString(),
                                    style: TextStyle(
                                      color: AppColor.primary,
                                      fontSize: AppFontSize.size_22,
                                      fontWeight: FontWeight.w600,
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
                                    width: 1.8,
                                    color: AppColor.numberPickerDividerColor),
                                bottom: BorderSide(
                                    width: 1.8,
                                    color: AppColor.numberPickerDividerColor),
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
                                    color: AppColor.primary,
                                    fontSize: AppFontSize.size_22,
                                    fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }

  _btnNext() {
    return Container(
      margin: EdgeInsets.only(
          bottom: AppSizes.height_2_5,
          right: AppSizes.width_14,
          left: AppSizes.width_14),
      width: AppSizes.fullWidth,
      child: TextButton(
        onPressed: () {
          _chooseHeightController.onNextButtonClick();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColor.primary),
          elevation: MaterialStateProperty.all(2),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
              side: const BorderSide(color: AppColor.transparent, width: 0.7),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSizes.height_1_2),
          child: Text(
            "txtNext".tr.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColor.white,
                fontSize: AppFontSize.size_15,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
