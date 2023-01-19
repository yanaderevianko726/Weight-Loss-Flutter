import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../dialog/account_created_dialog.dart';
import '../../models/check_register_model.dart';
import '../../models/guide_intro_model.dart';
import '../../models/login_model.dart';
import '../../models/register_model.dart';
import '../../util/color_category.dart';
import '../../util/constant_url.dart';
import '../../util/constant_widget.dart';

import '../../util/constants.dart';
import '../../util/pref_data.dart';
import '../controller/controller.dart';

class SignUpPage extends StatefulWidget {
  final GuideIntroModel dataModel;

  SignUpPage(this.dataModel);

  @override
  _SignUpPage createState() {
    return _SignUpPage();
  }
}

class _SignUpPage extends State<SignUpPage> {
  SignUpController controller = Get.put(SignUpController());
  SettingController settingController = Get.put(SettingController());
  var dio = Dio();

  Future<bool> _requestPop() async {
    Navigator.pop(context);
    PrefData.setIsSetting(false);
    return new Future.value(false);
  }

  RegExp emaailExpress = new RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final signUpForm = GlobalKey<FormState>();
  TextEditingController fullNameController = new TextEditingController();
  TextEditingController textPasswordController = new TextEditingController();
  TextEditingController phoneNumberController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: bgDarkWhite,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Form(
                key: signUpForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstantWidget.getVerSpace(20.h),
                    InkWell(
                        onTap: () {
                          _requestPop();
                        },
                        child: getSvgImage("arrow_left.svg",
                            width: 24.h, height: 24.h)),
                    ConstantWidget.getVerSpace(20.h),
                    Expanded(
                      flex: 1,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          ConstantWidget.getTextWidget("Sign Up", textColor,
                              TextAlign.left, FontWeight.w700, 28.sp),
                          ConstantWidget.getVerSpace(10.h),
                          ConstantWidget.getTextWidget(
                              "Create a account",
                              descriptionColor,
                              TextAlign.left,
                              FontWeight.w500,
                              15.sp),
                          ConstantWidget.getVerSpace(40.h),
                          ConstantWidget.getDefaultTextFiledWithLabel(
                              context, "Full Name", fullNameController,
                              isEnable: false,
                              height: 50.h,
                              withprefix: true,
                              image: "profile.svg", validator: (fullName) {
                            if (fullName == null || fullName.isEmpty) {
                              return "Please enter full name.";
                            }
                            return null;
                          }),
                          ConstantWidget.getVerSpace(20.h),
                          ConstantWidget.getDefaultTextFiledWithLabel(
                              context, "Email", emailController,
                              isEnable: false,
                              height: 50.h,
                              withprefix: true,
                              image: "mail.svg", validator: (email) {
                            if (email == null || email.isEmpty) {
                              return "Please enter email";
                            }
                            if (!emaailExpress.hasMatch(email)) {
                              return "Please enter valid email.";
                            }
                            return null;
                          }),
                          ConstantWidget.getVerSpace(20.h),
                          ConstantWidget.getCountryTextFiled(
                              context, "Phone Number", phoneNumberController,
                              isEnable: false,
                              height: 50.h,
                              withprefix: true,
                              validator: (number) {
                                if (number == null || number.isEmpty) {
                                  return "Please enter phone number";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) {
                                controller.getImage(value.toString());
                              }),
                          ConstantWidget.getVerSpace(20.h),
                          ConstantWidget.getDefaultTextFiledWithLabel(
                            context,
                            "Password",
                            textPasswordController,
                            isEnable: false,
                            height: 50.h,
                            withprefix: true,
                            image: "eye.svg",
                            isPass: true,
                            validator: (password) {
                              if (password == null || password.isEmpty) {
                                return "Please enter password.";
                              }
                              return null;
                            },
                          ),
                          ConstantWidget.getVerSpace(20.h),
                          Row(
                            children: [
                              ConstantWidget.getHorSpace(10.h),
                              GetX<SignUpController>(
                                init: SignUpController(),
                                builder: (controller) => InkWell(
                                    onTap: () {
                                      controller.onCheck();
                                    },
                                    child: getSvgImage(
                                        controller.check.value == true
                                            ? "check.svg"
                                            : "uncheck.svg",
                                        height: 20.h,
                                        width: 20.h)),
                              ),
                              ConstantWidget.getHorSpace(12.h),
                              ConstantWidget.getTextWidget(
                                  "I agree with",
                                  textColor,
                                  TextAlign.start,
                                  FontWeight.w300,
                                  15.sp),
                              ConstantWidget.getHorSpace(5.h),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    launchURL();
                                  },
                                  child: ConstantWidget.getTextDecorationWidget(
                                      "Terms & Privacy",
                                      accentColor,
                                      TextAlign.start,
                                      FontWeight.w300,
                                      15.sp),
                                ),
                                flex: 1,
                              ),
                            ],
                          ),
                          ConstantWidget.getVerSpace(40.h),
                          GetBuilder<SignUpController>(
                            init: SignUpController(),
                            builder: (controller) => Obx(() => isProcess.value
                                ? ConstantWidget.getProcessWidget(context)
                                : ConstantWidget.getButtonWidget(
                                    context, 'Sign Up', blueButton, () {
                                    print("pass==${isPass.value}");
                                    if (!isPass.value) {
                                      if (signUpForm.currentState!.validate()) {
                                        if (controller.check.value == true) {
                                          checkValidation();
                                        } else {
                                          Constants.showToast(
                                              "Please check term & Privacy.");
                                        }
                                      }
                                    }
                                  })),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        // if (await PrefData.getFirstSignUp() == false) {
                        Navigator.pop(context);
                        // } else {
                        //   if (await PrefData.getIsSetting() == true) {
                        //     Navigator.pop(context);
                        //   } else {
                        //     ConstantUrl.sendLoginPage(context, function: () {
                        //       settingController.changeLogin();
                        //     }, name: function);
                        //   }
                        // }

                        // Get.back();
                      },
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstantWidget.getRichText(
                            "Already have a account? ",
                            descriptionColor,
                            FontWeight.w500,
                            17.sp,
                            "Login",
                            textColor,
                            FontWeight.w700,
                            17.sp),
                      ),
                    ),
                    ConstantWidget.getVerSpace(40.h)
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  launchURL() async {
    if (!await launchUrl(Uri.parse(ConstantUrl.termsAndCondition))) {
      throw 'Could not launch ';
    }
  }

  void checkValidation() {
    sendSignInPage();
  }

  // String? pinCode;

  Future<void> checkRegister() async {
    final response = await dio.post(
      ConstantUrl.checkAlreadyRegisterUrl,
      data: {
        ConstantUrl.paramMobile:
            controller.code.value + phoneNumberController.text,
        ConstantUrl.paramUserName: fullNameController.text
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    print(
        "DATA===${controller.code.value + phoneNumberController.text}===${fullNameController.text}");

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.data);

      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      print("response-12-----${response.data}");
      CheckRegisterModel user = CheckRegisterModel.fromJson(map);

      if (user.data!.success == 0) {
        isPass.value = true;
        checkNetwork();

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => VerifyCodePage(
        //           controller.code.value + phoneNumberController.text, (value) {
        //         isPass.value = false;
        //         checkNetwork();
        //       }),
        //     )).then((value) {
        //   isPass.value = false;
        // });
      } else {
        ConstantUrl.showToast(user.data!.login!.error!, context);
      }
    }
  }

  RxBool isPass = false.obs;

  void sendSignInPage() async {
    bool isNetwork = await ConstantUrl.getNetwork();
    if (isNetwork) {
      checkRegister();
    } else {
      getNoInternet(context);
    }
  }

  RxBool isProcess = false.obs;

  checkNetwork() async {
    isProcess.value = true;
    bool isNetwork = await ConstantUrl.getNetwork();
    if (isNetwork) {
      signUp();
    } else {
      isProcess.value = false;
      getNoInternet(context);
    }
  }

  Future<void> signUp() async {
    String deviceId = await ConstantUrl.getDeviceId();

    final response = await dio.post(ConstantUrl.registerUrl,
        data: {
          ConstantUrl.paramFirstName: fullNameController.text,
          ConstantUrl.paramLastName: "ghjg",
          ConstantUrl.paramUserName: fullNameController.text,
          ConstantUrl.paramEmail: emailController.text,
          ConstantUrl.paramPassword: textPasswordController.text,
          ConstantUrl.paramMobile:
              controller.code.value + phoneNumberController.text,
          ConstantUrl.paramAge: widget.dataModel.age,
          ConstantUrl.paramGender: widget.dataModel.gender,
          ConstantUrl.paramHeight: widget.dataModel.height,
          ConstantUrl.paramWeight: widget.dataModel.weight,
          ConstantUrl.paramAddress: "sdsd",
          ConstantUrl.paramCity: "sdsd",
          ConstantUrl.paramState: "sdsd",
          ConstantUrl.paramCountry: "sdsd",
          ConstantUrl.paramTimeInWeek: widget.dataModel.timeInWeek,
          ConstantUrl.paramIntensively: "sdsd",
          ConstantUrl.paramDeviceId: deviceId,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType));

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.data);

      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      RegisterModel user = RegisterModel.fromJson(map);

      if (user.dataModel.success == 1) {
        if (user.dataModel.login!.userDetail!.isActive == "1") {
          ConstantUrl.showToast(user.dataModel.login!.error!, context);
          signIn();
        } else {
          isProcess.value = false;
          ConstantUrl.showToast("User not active", context);
        }
      }
      print("res--1" + user.toString());
    } else {
      isProcess.value = false;
    }
  }

  Future<void> signIn() async {
    String deviceId = await ConstantUrl.getDeviceId();

    var data = {
      ConstantUrl.paramUserName: fullNameController.text,
      ConstantUrl.paramPassword: textPasswordController.text,
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

      ConstantUrl.showToast(user.data.login.error!, context);
      isProcess.value = false;
      if (user.data.success == 1) {
        PrefData.setUserDetail(json.encode(user.data.login.userdetail));
        PrefData.setSession(user.data.login.session!);
        PrefData.setIsSignIn(true);
        settingController.changeLogin();
        showDialog(
                barrierDismissible: false,
                builder: (context) {
                  return AccountCreateDialog();
                },
                context: context)
            .then((value) {
          PrefData.setFirstSignUp(false);
          Get.back();
          Get.back();
          PrefData.setIsSetting(false);
        });
        phoneNumberController.text = "";
        emailController.text = "";
      }
    }
  }
}
