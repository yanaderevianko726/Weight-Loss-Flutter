import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/google_ads/custom_ad.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';

import '../../../common/dialog/height/height.dart';
import '../../../common/dialog/weight/weight.dart';
import '../../../utils/color.dart';
import '../../../utils/sizer_utils.dart';
import '../../../utils/utils.dart';
import '../controllers/my_profile_controller.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _widgetBack(),
            _heightWeightTargetWeightWidget(),
            const BannerAdClass(),
          ],
        ),
      ),
    );
  }

  _widgetBack() {
    return Container(
      width: AppSizes.fullWidth,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
          left: AppSizes.width_5,
          right: AppSizes.width_5,
          top: AppSizes.height_2),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Utils.backWidget(iconColor: AppColor.black),
          ),
          Expanded(
            child: Text(
              "\t\t\t\t" + "txtMyProfile".tr,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColor.black,
                fontSize: AppFontSize.size_15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _heightWeightTargetWeightWidget() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: AppSizes.height_5, horizontal: AppSizes.width_7),
        child: GetBuilder<MyProfileController>(
          id: Constant.idKgCmLbsFtSelection,
          builder: (logic) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "txtHeight".tr,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColor.txtColor666,
                          fontSize: AppFontSize.size_14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _dialogHeight();
                      },
                      child: IntrinsicWidth(
                        child: Column(
                          children: [
                            Text(logic.heightInCM!,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: AppFontSize.size_14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Divider(
                              color: AppColor.grayDivider,
                              thickness: AppSizes.height_0_15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.height_3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "txtWeight".tr,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColor.txtColor666,
                          fontSize: AppFontSize.size_14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _dialogWeight(Constant.boolValueTrue);
                      },
                      child: IntrinsicWidth(
                        child: Column(
                          children: [
                            Text(
                              logic.weightInKG!,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: AppFontSize.size_14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Divider(
                              color: AppColor.grayDivider,
                              thickness: AppSizes.height_0_15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSizes.height_3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "txtTargetWeight".tr,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColor.txtColor666,
                          fontSize: AppFontSize.size_14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _dialogWeight(Constant.boolValueFalse);
                      },
                      child: IntrinsicWidth(
                        child: Column(
                          children: [
                            Text(
                              logic.targetWeightInKG!,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: AppFontSize.size_14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Divider(
                              color: AppColor.grayDivider,
                              thickness: AppSizes.height_0_15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  _dialogHeight() {
    return showDialog(
      context: Get.context!,
      barrierDismissible: Constant.boolValueTrue,
      builder: (context) {
        return Scaffold(
          backgroundColor: AppColor.transparent,
          body: DialogHeight(),
        );
      },
    );
  }

  _dialogWeight(bool value) {
    return showDialog(
      context: Get.context!,
      barrierDismissible: Constant.boolValueTrue,
      builder: (context) {
        return Scaffold(
          backgroundColor: AppColor.transparent,
          body: DialogWeight(value),
        );
      },
    );
  }
}
