import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/debug.dart';

class EnterOtpScreen extends StatelessWidget {
  const EnterOtpScreen({Key? key}) : super(key: key);

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
      alignment: Alignment.centerLeft,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          SizedBox(height: AppSizes.height_10),
          Text(
            "txtEnterOtp".tr.toUpperCase(),
            textAlign: TextAlign.left,
            style: TextStyle(
              color: AppColor.white,
              fontSize: AppFontSize.size_15,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSizes.height_0_4),
          Text(
            "txtDescEnterOtp".tr,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: AppColor.white,
              fontSize: AppFontSize.size_10,
              fontWeight: FontWeight.w700,
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
          vertical: AppSizes.height_7, horizontal: AppSizes.width_5),
      child: Column(
        children: [
          _pinCodeTextField(),
          SizedBox(height: AppSizes.height_5),
          _verifyButton(),
          SizedBox(height: AppSizes.height_3),
          _txtNotReceivedCode(),
        ],
      ),
    );
  }

  _pinCodeTextField() {
    return PinCodeTextField(
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        disabledColor: AppColor.grayLight,
        inactiveColor: AppColor.grayLight,
        activeColor: AppColor.grayLight,
        selectedColor: AppColor.grayLight,
        inactiveFillColor: AppColor.grayLight,
        selectedFillColor: AppColor.grayLight,
        activeFillColor: AppColor.grayLight,
        borderRadius: BorderRadius.circular(8),
        fieldHeight: AppSizes.height_5_5,
        fieldWidth: AppSizes.height_5_5,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: AppColor.transparent,
      enableActiveFill: Constant.boolValueTrue,
      onCompleted: (v) {
        Debug.printLog("Completed ==>> $v");
      },
      onChanged: (value) {},
      beforeTextPaste: (text) {
        Debug.printLog("Allowing to paste ==>> $text");
        return true;
      },
      appContext: Get.context!,
    );
  }

  _verifyButton() {
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
          Get.toNamed(AppRoutes.emailVerified);
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
            "txtVerify".tr,
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

  _txtNotReceivedCode() {
    return RichText(
      text: TextSpan(
        text: 'NotReceivedCode'.tr + "? ",
        style: TextStyle(
          color: AppColor.txtColor999,
          fontSize: AppFontSize.size_12_5,
          fontWeight: FontWeight.w700,
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'txtResendNow'.tr,
            style: const TextStyle(
              color: AppColor.txtColorGreen,
            ),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
        ],
      ),
    );
  }
}
