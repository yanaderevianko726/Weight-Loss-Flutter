import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/ui/whats_your_goal/controllers/whats_your_goal_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

import '../../../google_ads/custom_ad.dart';
import '../../../utils/utils.dart';

class WhatsYourGoalScreen extends StatelessWidget {
  WhatsYourGoalScreen({Key? key}) : super(key: key);

  final WhatsYourGoalController _whatsYourGoalController =
      Get.find<WhatsYourGoalController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  _widgetBack(),
                  _textWhatsYourGoal(),
                  _textDescWhatsYourGoal(),
                  _whatsYourGoalList(),
                ],
              ),
            ),
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
          left: AppSizes.width_7_5,
          right: AppSizes.width_7_5,
          top: AppSizes.height_3_7),
      child: InkWell(
        onTap: () {
          Get.back();
        },
        child: Utils.backWidget(),
      ),
    );
  }

  _textWhatsYourGoal() {
    return Container(
      width: AppSizes.fullWidth,
      margin: EdgeInsets.only(top: AppSizes.height_2_5),
      padding: EdgeInsets.symmetric(horizontal: AppSizes.width_6),
      child: Text(
        "txtWhatsYourGoal".tr,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColor.black,
          fontSize: AppFontSize.size_17,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _textDescWhatsYourGoal() {
    return Container(
      width: AppSizes.fullWidth,
      margin: EdgeInsets.only(
          top: AppSizes.height_1_2, bottom: AppSizes.height_5),
      padding: EdgeInsets.symmetric(horizontal: AppSizes.width_20),
      child: Text(
        "txtDescWhatsYourGoal".tr,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColor.txtColor666,
          fontSize: AppFontSize.size_12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  _whatsYourGoalList() {
    return GetBuilder<WhatsYourGoalController>(
      id: Constant.idWhatsYourGoalList,
      builder: (logic) {
        return Container(
          margin: EdgeInsets.only(bottom: AppSizes.height_2_5),
          child: ListView.builder(
            itemCount: logic.whatsYourGoalList.length,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext buildContext, int index) {
              return _itemChoosePlanList(index, logic.whatsYourGoalList);
            },
          ),
        );
      },
    );
  }

  _itemChoosePlanList(int index, List<String> whatsYourGoalList) {
    return InkWell(
      onTap: () {
        _whatsYourGoalController.onWhatsYourGoalClick(index);

        Future.delayed(const Duration(milliseconds: 100), () {
          Get.back(result: true);
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color:
                (index == _whatsYourGoalController.selectedWhatsYourGoalIndex)
                    ? AppColor.primary
                    : AppColor.primaryLight,
            borderRadius: BorderRadius.circular(100.0)),
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.width_8_5,
            vertical: AppSizes.height_3_3),
        margin: EdgeInsets.only(
            left: AppSizes.width_2_8,
            right: AppSizes.width_2_8,
            bottom: AppSizes.height_1_8),
        child: Text(
          whatsYourGoalList[index],
          textAlign: TextAlign.center,
          style: TextStyle(
            color:
                (index == _whatsYourGoalController.selectedWhatsYourGoalIndex)
                    ? AppColor.white
                    : AppColor.colorWhatsYourGoal,
            fontSize: AppFontSize.size_15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
