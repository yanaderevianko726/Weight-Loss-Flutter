import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/login_model.dart';
import '../../routes/app_routes.dart';
import '../../util/color_category.dart';
import '../../util/constant_url.dart';
import '../../util/constant_widget.dart';

import 'package:get/get.dart';

import '../../util/pref_data.dart';
import '../controller/controller.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPage createState() {
    return _SignInPage();
  }
}

class _SignInPage extends State<SignInPage> {
  LoginController controller = Get.put(LoginController());
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  HomeController homeController = Get.put(HomeController());
  SettingController settingController = Get.put(SettingController());
  final loginForm = GlobalKey<FormState>();

  var dio = Dio();
  RxBool isProcess = false.obs;

  @override
  Widget build(BuildContext context) {
    final function = ModalRoute.of(context)!.settings.arguments as Function;

    setStatusBarColor(bgDarkWhite);
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: bgDarkWhite,
        appBar: getNoneAppBar(context),
        body: Container(
          child: Form(
            key: loginForm,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20.h),
                    children: [
                      SizedBox(
                        height: 80.h,
                      ),
                      ConstantWidget.getTextWidget("Login", textColor,
                          TextAlign.left, FontWeight.w700, 28.sp),
                      SizedBox(
                        height: 10.h,
                      ),
                      ConstantWidget.getTextWidget(
                          "Welcome back to our account!",
                          descriptionColor,
                          TextAlign.left,
                          FontWeight.w500,
                          15.sp),
                      SizedBox(
                        height: 40.h,
                      ),
                      ConstantWidget.getDefaultTextFiledWithLabel(
                          context, "Username", emailController,
                          isEnable: false,
                          height: 50.h,
                          withprefix: true,
                          image: "mail.svg", validator: (username) {
                        if (username == null || username.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      }),
                      SizedBox(
                        height: 20.h,
                      ),
                      ConstantWidget.getDefaultTextFiledWithLabel(
                          context, "Password", passwordController,
                          isEnable: false,
                          height: 50.h,
                          withprefix: true,
                          image: "eye.svg",
                          isPass: true, validator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'Please enter password';
                        }
                        if (password.length < 6) {
                          return "Please atleast 6 digit password enter.";
                        }
                        return null;
                      }),
                      ConstantWidget.getVerSpace(20.h),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              child: ConstantWidget.getTextWidget(
                                  'Forgot Password ?',
                                  textColor,
                                  TextAlign.end,
                                  FontWeight.w500,
                                  17.sp),
                              onTap: () {
                                Get.toNamed(Routes.forgotPasswordRoute);
                              },
                            ),
                          ),
                        ],
                      ),
                      ConstantWidget.getVerSpace(40.h),
                      Obx(
                        () => isProcess.value
                            ? ConstantWidget.getProcessWidget(context)
                            : ConstantWidget.getButtonWidget(
                                context, 'Login', blueButton, () {
                                if (loginForm.currentState!.validate()) {
                                  checkValidation(function);
                                }
                              }),
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    // if (await PrefData.getIsSetting() == true) {
                    Get.toNamed(Routes.introRoute, arguments: () {
                      Get.back();
                    });
                    // } else {
                    //   if (await PrefData.getFirstSignUp() == false) {
                    //     Get.toNamed(Routes.introRoute, arguments: () {
                    //       Get.back();
                    //     });
                    //   } else {
                    //     Navigator.pop(context);
                    //   }
                    // }
                  },
                  child: ConstantWidget.getRichText(
                      "Don’t have an account? ",
                      descriptionColor,
                      FontWeight.w500,
                      17.sp,
                      "Sign Up",
                      textColor,
                      FontWeight.w700,
                      17.sp),
                ),
                ConstantWidget.getVerSpace(36.h)
              ],
            ),
          ),
        ),
      ),
      onWillPop: () {
        PrefData.setIsSetting(false);
        // Navigator.pop(context);
        Get.back();
        return new Future.value(false);
      },
    );
  }

  void checkValidation(Function function) {
    // FocusScopeNode currentFocus = FocusScope.of(context);
    // if (!currentFocus.hasPrimaryFocus) {
    //   currentFocus.unfocus();
    // }
    //
    // if (ConstantUrl.isNotEmpty(controller.emailController.text) &&
    //     ConstantUrl.isNotEmpty(controller.passwordController.text)) {
    checkNetwork(function);
    // } else {
    //   ConstantUrl.showToast(S.of(context).fillDetails, context);
    // }
  }

  checkNetwork(Function function) async {
    isProcess.value = true;
    bool isNetwork = await ConstantUrl.getNetwork();
    if (isNetwork) {
      signIn(function);
    } else {
      isProcess.value = false;
      getNoInternet(context);
    }
  }

  Future<void> signIn(Function function) async {
    String deviceId = await ConstantUrl.getDeviceId();
    print("device_id------------${deviceId}");
    var data = {
      ConstantUrl.paramUserName: emailController.text,
      ConstantUrl.paramPassword: passwordController.text,
      ConstantUrl.paramDeviceId: deviceId,
    };

    final response = await dio.post(
      ConstantUrl.loginUrl,
      data: data,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.data);

      ModelLogin user = ModelLogin.fromJson(map);
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      if (user.data.success == 1) {
        if (user.data.login.userdetail!.isActive == "1") {
          ConstantUrl.showToast(user.data.login.error!, context);
          isProcess.value = false;
          PrefData.setUserDetail(json.encode(user.data.login.userdetail));
          PrefData.setSession(user.data.login.session!);
          PrefData.setIsSignIn(true);
          settingController.changeLogin();
          setState(() {
            emailController.text = "";
            passwordController.text = "";
          });
          homeController.onChange(0.obs);

          function();
          PrefData.setIsSetting(false);
        } else {
          isProcess.value = false;
          ConstantUrl.showToast("User not active", context);
        }
      }
    }
  }
}
