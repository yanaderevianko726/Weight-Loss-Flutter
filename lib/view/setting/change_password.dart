import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../generated/l10n.dart';
import '../../models/model_update_password.dart';
import '../../models/userdetail_model.dart';
import '../../util/color_category.dart';
import '../../util/constant_url.dart';
import '../../util/constant_widget.dart';
import '../../util/pref_data.dart';
import 'package:http/http.dart' as http;

import '../controller/controller.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  Future<bool> _requestPop() {
    Get.back();
    return new Future.value(true);
  }

  final changePassForm = GlobalKey<FormState>();

  ChangePasswordController controller = Get.put(ChangePasswordController());

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
                key: changePassForm,
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
                              "Change Password",
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
                              "Old Password", controller.oldPasswordController,
                              isEnable: false,
                              height: 50.h,
                              withprefix: true,
                              image: "eye.svg",
                              isPass: true, validator: (oldPass) {
                            if (oldPass == null || oldPass.isEmpty) {
                              return "Please enter old password.";
                            }
                            return null;
                          }),
                          SizedBox(
                            height: 20.h,
                          ),
                          ConstantWidget.getDefaultTextFiledWithLabel(context,
                              "New Password", controller.newPasswordController,
                              isEnable: false,
                              height: 50.h,
                              withprefix: true,
                              image: "eye.svg",
                              isPass: true, validator: (newPass) {
                            if (newPass == null || newPass.isEmpty) {
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
                              isPass: true, validator: (confPass) {
                            if (controller.newPasswordController.text !=
                                confPass) {
                              return "new password and confirm password not match.";
                            }
                            if (confPass == null || confPass.isEmpty) {
                              return "Please enter new password.";
                            }
                            return null;
                          }),
                          SizedBox(
                            height: 40.h,
                          ),
                          ConstantWidget.getButtonWidget(
                              context, 'Submit', blueButton, () {
                            if (changePassForm.currentState!.validate()) {
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

    if (ConstantUrl.isNotEmpty(controller.oldPasswordController.text) &&
        ConstantUrl.isNotEmpty(controller.newPasswordController.text) &&
        ConstantUrl.isNotEmpty(controller.confirmPasswordController.text)) {
      if ((controller.oldPasswordController.text.length >= 6) &&
          controller.newPasswordController.text.length >= 6 &&
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
    String s = await PrefData.getUserDetail();

    print("s----" + s);

    if (s.isNotEmpty) {
      UserDetail userDetail = await ConstantUrl.getUserDetail();
      String deviceId = await ConstantUrl.getDeviceId();
      String session = await PrefData.getSession();
      Map data = {
        ConstantUrl.paramUserId: userDetail.userId,
        ConstantUrl.paramSession: session,
        ConstantUrl.paramDeviceId: deviceId,
        ConstantUrl.paramOldPassword: controller.oldPasswordController.text,
        ConstantUrl.paramNewPassword: controller.confirmPasswordController.text,
      };

      final response =
          await http.post(Uri.parse(ConstantUrl.urlUpdatePassword), body: data);

      if (response.statusCode == 200) {
        print("questionRes------" + response.body.toString());

        Map<String, dynamic> map = json.decode(response.body);

        UpdatePasswordModel changePasswordModel =
            UpdatePasswordModel.fromJson(map);

        if (changePasswordModel.data!.success == 1) {
          _requestPop();
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
}
