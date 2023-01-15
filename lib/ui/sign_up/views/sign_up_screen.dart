import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/constant.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgGrayScreen,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Stack(
          children: [
            _txtSignUpWidget(),
            _signUpDetailsWidget(),
          ],
        ),
      ),
    );
  }

  _txtSignUpWidget() {
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
                  "txtSkip".tr,
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
            "txtSignUp".tr.toUpperCase(),
            textAlign: TextAlign.left,
            style: TextStyle(
              color: AppColor.white,
              fontSize: AppFontSize.size_15,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSizes.height_0_4),
          Text(
            "txtDescSignUp".tr,
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

  _signUpDetailsWidget() {
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
          bottom: AppSizes.height_3),
      padding: EdgeInsets.symmetric(
          vertical: AppSizes.height_3, horizontal: AppSizes.width_5),
      child: Column(
        children: [
          _fullNameTextField(),
          SizedBox(height: AppSizes.height_2),
          _emailTextField(),
          SizedBox(height: AppSizes.height_2),
          _passwordTextField(),
          SizedBox(height: AppSizes.height_3),
          _signUpButton(),
          SizedBox(height: AppSizes.height_3_5),
          _txtPrivacyPolicy(),
          SizedBox(height: AppSizes.height_3_5),
          _txtOrConnectingUsing(),
          SizedBox(height: AppSizes.height_4_5),
          _signInWithGoogleButton(),
          _txtAlreadyAccountSignIn(),
        ],
      ),
    );
  }

  _fullNameTextField() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: TextFormField(
        maxLines: 1,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: TextStyle(
          color: AppColor.black,
          fontSize: AppFontSize.size_12,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: AppColor.primary,
        decoration: InputDecoration(
          hintText: "txtFullName".tr,
          hintStyle: TextStyle(
            color: AppColor.txtColor999,
            fontSize: AppFontSize.size_12,
            fontWeight: FontWeight.w500,
          ),
          filled: Constant.boolValueTrue,
          fillColor: AppColor.bgGaryTextFormField,
          counterText: "",
          prefixIcon: const Icon(
            Icons.person,
            color: AppColor.txtColor999,
          ),
          border: InputBorder.none,
        ),
        onEditingComplete: () {
          FocusScope.of(Get.context!).unfocus();
        },
      ),
    );
  }

  _emailTextField() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: TextFormField(
        maxLines: 1,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: TextStyle(
          color: AppColor.black,
          fontSize: AppFontSize.size_12,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: AppColor.primary,
        decoration: InputDecoration(
          hintText: "txtEmail".tr,
          hintStyle: TextStyle(
            color: AppColor.txtColor999,
            fontSize: AppFontSize.size_12,
            fontWeight: FontWeight.w500,
          ),
          filled: Constant.boolValueTrue,
          fillColor: AppColor.bgGaryTextFormField,
          counterText: "",
          prefixIcon: const Icon(
            Icons.email,
            color: AppColor.txtColor999,
          ),
          border: InputBorder.none,
        ),
        onEditingComplete: () {
          FocusScope.of(Get.context!).unfocus();
        },
      ),
    );
  }

  _passwordTextField() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: TextFormField(
        maxLines: 1,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: TextStyle(
          color: AppColor.black,
          fontSize: AppFontSize.size_12,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: AppColor.primary,
        decoration: InputDecoration(
          hintText: "txtPassword".tr,
          hintStyle: TextStyle(
            color: AppColor.txtColor999,
            fontSize: AppFontSize.size_12,
            fontWeight: FontWeight.w500,
          ),
          filled: Constant.boolValueTrue,
          fillColor: AppColor.bgGaryTextFormField,
          counterText: "",
          prefixIcon: const Icon(
            Icons.lock_rounded,
            color: AppColor.txtColor999,
          ),
          border: InputBorder.none,
        ),
        onEditingComplete: () {
          FocusScope.of(Get.context!).unfocus();
        },
      ),
    );
  }

  _signUpButton() {
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
          Get.toNamed(AppRoutes.enterOtp);
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
            "txtSignUp".tr,
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

  _txtPrivacyPolicy() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'txtBySigningUp'.tr,
        style: TextStyle(
          color: AppColor.txtColor999,
          fontSize: AppFontSize.size_9,
          fontWeight: FontWeight.w700,
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'txtTermsOfServices'.tr,
            style: const TextStyle(
              color: AppColor.txtColorGreen,
            ),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(text: 'txtAnd'.tr),
          TextSpan(
            text: 'txtPrivacyPolicy'.tr,
            style: const TextStyle(
              color: AppColor.txtColorGreen,
            ),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
        ],
      ),
    );
  }

  _txtOrConnectingUsing() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColor.grayDivider,
            thickness: AppSizes.height_0_1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.width_6),
          child: Text(
            "txtOrConnectUsing".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.txtColorGreen,
              fontSize: AppFontSize.size_13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColor.grayDivider,
            thickness: AppSizes.height_0_1,
          ),
        ),
      ],
    );
  }

  _signInWithGoogleButton() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          Constant.getAssetIcons() + "ic_google.png",
          width: AppSizes.fullWidth,
          height: AppSizes.height_8,
        ),
        Padding(
          padding: EdgeInsets.only(left: AppSizes.width_6),
          child: Text(
            "txtSignInWithGoogle".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.txtColor666,
              fontSize: AppFontSize.size_13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  _txtAlreadyAccountSignIn() {
    return Container(
      margin: EdgeInsets.only(
          top: AppSizes.height_3_5, bottom: AppSizes.height_2_5),
      child: RichText(
        text: TextSpan(
          text: 'txtAlreadyAccount'.tr + "? ",
          style: TextStyle(
            color: AppColor.txtColor999,
            fontSize: AppFontSize.size_12_5,
            fontWeight: FontWeight.w700,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'txtSignIn'.tr,
              style: const TextStyle(
                color: AppColor.txtColorGreen,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.back();
                },
            ),
          ],
        ),
      ),
    );
  }
}
