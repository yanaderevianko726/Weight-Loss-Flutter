import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/ui/rest_day/controllers/rest_day_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';

import '../../../utils/sizer_utils.dart';
import '../../../utils/utils.dart';

class RestDayScreen extends StatelessWidget {
  RestDayScreen({Key? key}) : super(key: key);

  final RestDayController _restDayController = Get.find<RestDayController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          children: [
            _widgetBack(),
            _restDetailsWidget(),
            _finishedButton(),
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
              "\t\t\t\t" + "txtRestDay".tr,
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

  _restDetailsWidget() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Constant.getAssetIcons() + "ic_rest.webp",
            width: AppSizes.height_17_5,
            height: AppSizes.height_17_5,
          ),
          SizedBox(height: AppSizes.height_3),
          Text(
            "txtDescRestDay".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.txtColor666,
              fontSize: AppFontSize.size_11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  _finishedButton() {
    return Container(
      width: AppSizes.fullWidth,
      margin: EdgeInsets.only(
          right: AppSizes.width_13,
          left: AppSizes.width_13,
          bottom: AppSizes.height_3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColor.greenGradualStartColor,
            AppColor.greenGradualEndColor,
          ],
        ),
      ),
      child: TextButton(
        onPressed: () {
          _restDayController.onFinishedButtonClick();
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
              side: const BorderSide(
                color: AppColor.transparent,
                width: 0.7,
              ),
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSizes.height_1),
          child: Text(
            "txtFinished".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.white,
              fontSize: AppFontSize.size_14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
