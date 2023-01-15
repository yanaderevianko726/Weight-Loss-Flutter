import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

import '../../../routes/app_routes.dart';

class EmailVerifiedScreen extends StatelessWidget {
  const EmailVerifiedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgGrayScreen,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Stack(
          children: [
            _txtEnterOtpWidget(),
            _enterOtpDetailsWidget(),
          ],
        ),
      ),
    );
  }

  _txtEnterOtpWidget() {
    return Container(
      alignment: Alignment.topRight,
      width: AppSizes.fullWidth,
      height: AppSizes.fullHeight / 2,
      decoration: const BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
          left: AppSizes.width_5,
          right: AppSizes.width_5,
          top: AppSizes.height_6),
      child: Row(
        children: [
          const Spacer(),
          InkWell(
            onTap: () {
              Get.offAllNamed(AppRoutes.chooseYourPlan);
            },
            child: Text(
              "txtSkip".tr.toUpperCase(),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColor.white,
                fontSize: AppFontSize.size_12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _enterOtpDetailsWidget() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: kElevationToShadow[4],
      ),
      margin: EdgeInsets.only(
          left: AppSizes.width_5,
          right: AppSizes.width_5,
          top: AppSizes.fullHeight / 3.5,
          bottom: AppSizes.height_10),
      padding: EdgeInsets.symmetric(
          vertical: AppSizes.height_4, horizontal: AppSizes.width_5),
      child: Column(
        children: [
          _textEmailVerified(),
          SizedBox(height: AppSizes.height_5),
          _donIcon(),
          SizedBox(height: AppSizes.height_5),
          _backToLoginButton(),
        ],
      ),
    );
  }

  _textEmailVerified() {
    return Column(
      children: [
        Text(
          "txtEmailVerified".tr.toUpperCase(),
          textAlign: TextAlign.right,
          style: TextStyle(
            color: AppColor.primary,
            fontSize: AppFontSize.size_20,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: AppSizes.height_1),
        Text(
          "txtDescEmailVerified".tr,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColor.txtColor999,
            fontSize: AppFontSize.size_12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  _donIcon() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.primary,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(AppSizes.height_2),
      child: Icon(
        Icons.check_rounded,
        color: AppColor.white,
        size: AppSizes.height_8,
      ),
    );
  }

  _backToLoginButton() {
    return Container(
      width: AppSizes.fullWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: const LinearGradient(
          begin: Alignment.center,
          end: Alignment.center,
          colors: [
            AppColor.primary,
            AppColor.primary,
          ],
        ),
      ),
      child: TextButton(
        onPressed: () {
          Get.back();
          Get.back();
          Get.back();
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
            "txtBackToLogin".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.white,
              fontSize: AppFontSize.size_13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
