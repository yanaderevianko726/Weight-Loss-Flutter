import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../dialog/password_change_dialog.dart';
import '../../generated/l10n.dart';
import '../../models/model_reset_password.dart';
import '../../util/color_category.dart';
import '../../util/constant_url.dart';
import '../../util/constant_widget.dart';
import '../controller/controller.dart';
import 'package:http/http.dart' as http;

class ResetPassword extends StatefulWidget {
  final String phoneNumber;

  ResetPassword(this.phoneNumber);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  Future<bool> _requestPop() {
    Get.back();
    return new Future.value(true);
  }

  final resetForm = GlobalKey<FormState>();
  ResetController controller = Get.put(ResetController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: bgDarkWhite,
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.h),
              color: bgDarkWhite,
              child: Form(
                key: resetForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstantWidget.getVerSpace(20.h),
                    InkWell(
                        onTap: () {
                          _requestPop();
                        },
                        child: getSvgImage("arrow_left.svg")),
                    ConstantWidget.getVerSpace(20.h),
                    Expanded(
                      flex: 1,
                      child: ListView(
                        children: [
                          ConstantWidget.getTextWidget(
                              "Reset Password",
                              textColor,
                              TextAlign.left,
                              FontWeight.w700,
                              28.sp),
                          SizedBox(
                            height: 10.h,
                          ),
                          ConstantWidget.getMultilineCustomFont(
                              "Enter New password!  ", 15.sp, descriptionColor,
                              fontWeight: FontWeight.w500, txtHeight: 1.46.h),
                          SizedBox(
                            height: 40.h,
                          ),
                          ConstantWidget.getDefaultTextFiledWithLabel(context,
                              "New Password", controller.newPasswordController,
                              isEnable: false,
                              height: 50.h,
                              withprefix: true,
                              image: "eye.svg",
                              isPass: true, validator: (password) {
                            if (password == null || password.isEmpty) {
                              return "Please enter new password.";
                            }
                            return null;
                          }),
                          SizedBox(
                            height: 20.h,
                          ),
                          ConstantWidget.getDefaultTextFiledWithLabel(
                              context,
                              "Confirm Password",
                              controller.confirmPasswordController,
                              isEnable: false,
                              height: 50.h,
                              withprefix: true,
                              image: "eye.svg",
                              isPass: true, validator: (confPassword) {
                            if (confPassword == null || confPassword.isEmpty) {
                              return "Please enter confirm password.";
                            }
                            if (controller.newPasswordController.text !=
                                controller.confirmPasswordController.text) {
                              return "Password not match.";
                            }
                            return null;
                          }),
                          SizedBox(
                            height: 40.h,
                          ),
                          ConstantWidget.getButtonWidget(
                              context, 'Submit', blueButton, () {
                            if (resetForm.currentState!.validate()) {
                              checkValidation();
                            }
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  void checkValidation() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if (ConstantUrl.isNotEmpty(controller.newPasswordController.text) &&
        ConstantUrl.isNotEmpty(controller.confirmPasswordController.text)) {
      if ((controller.newPasswordController.text.length >= 6) &&
          controller.confirmPasswordController.text.length >= 6) {
        checkNetwork();
      } else {
        ConstantUrl.showToast(S.of(context).passwordError, context);
      }
    } else {
      ConstantUrl.showToast(S.of(context).fillDetails, context);
    }
  }

  checkNetwork() async {
    bool isNetwork = await ConstantUrl.getNetwork();
    if (isNetwork) {
      changePassword();
    } else {
      getNoInternet(context);
    }
  }

  Future<void> changePassword() async {
    print("phone-----${widget.phoneNumber}");
    Map data = {
      ConstantUrl.paramMobile: widget.phoneNumber,
      ConstantUrl.paramNewPassword: controller.confirmPasswordController.text,
    };

    final response =
        await http.post(Uri.parse(ConstantUrl.urlResetPassword), body: data);
    if (response.statusCode == 200) {
      print("questionRes------" + response.body.toString());

      Map<String, dynamic> map = json.decode(response.body);

      ResetPasswordModel changePasswordModel = ResetPasswordModel.fromJson(map);

      if (changePasswordModel.data!.success == 1) {
        showDialog(
            barrierDismissible: false,
            builder: (context) {
              return PasswordChangeDialog();
            },
            context: context);
      }
      if (changePasswordModel.data!.updatepassword != null) {
        if (changePasswordModel.data!.updatepassword!.length > 0) {
          ConstantUrl.showToast(
              changePasswordModel.data!.updatepassword![0].error!, context);
        }
      }
    }
  }
}
