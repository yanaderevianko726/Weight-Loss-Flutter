import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../util/color_category.dart';
import '../../util/constant_url.dart';
import '../../util/constant_widget.dart';
import '../../util/SizeConfig.dart';

import '../../generated/l10n.dart';

class VerifyCodePage extends StatefulWidget {
  final String phone;
  final ValueChanged<String> function;

  VerifyCodePage(this.phone, this.function);

  @override
  _VerifyCodePage createState() {
    return _VerifyCodePage();
  }
}

class _VerifyCodePage extends State<VerifyCodePage>
    with WidgetsBindingObserver {
  // TextEditingController _pinEditingController = TextEditingController(text: '');
  FirebaseAuth auth = FirebaseAuth.instance;
  String? verificationId;
  String pinNumber = "";
  int _countDown = 60;

  RxBool isProcess = false.obs;
  Timer? _timer;
  String resendString = " ";

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _cancelTimer();
    } else if (state == AppLifecycleState.resumed) {
      startTimer();
    }
  }

  void _cancelTimer() {
    print("timer---true");
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  void startTimer() {
    _cancelTimer();
    print("_countDown12" + _countDown.toString());
    var oneSec = Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (_countDown < 1) {
        if (mounted) {
          setState(() {
            timer.cancel();
            resendString = S.of(context).resend;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _countDown = _countDown - 1;
            resendString = S.of(context).resendSms +
                " " +
                _countDown.toString() +
                " " +
                S.of(context).sec;
          });
        }
      }
    });
  }

  Future<bool> _requestPop() {
    Get.back();
    return new Future.value(true);
  }

  void setNumber() async {
    _countDown = 60;
    startTimer();
    await auth.verifyPhoneNumber(
      verificationFailed: (FirebaseAuthException e) {
        print("codeSend---fail---$e");
        print(
            "Phone number verification failed. Code: ${e.code}. Message: ${e.message}");
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }

        // Handle other errors
      },
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("codeComplete---true");
        await auth.signInWithCredential(credential);
      },
      codeSent: (String? id, int? resendToken) async {
        verificationId = id;
        print("codeSend---true");
      },
      phoneNumber: widget.phone,
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );
  }

  @override
  void initState() {
    super.initState();

    setNumber();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: bgDarkWhite,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              color: bgDarkWhite,
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
                      children: [
                        ConstantWidget.getTextWidget("Verify", textColor,
                            TextAlign.left, FontWeight.w700, 28.sp),
                        ConstantWidget.getVerSpace(10.h),
                        ConstantWidget.getMultilineCustomFont(
                            "Enter code sent to your mobile number",
                            15.sp,
                            descriptionColor,
                            fontWeight: FontWeight.w500,
                            txtHeight: 1.46.h),
                        ConstantWidget.getVerSpace(40.h),
                        Container(
                          height: 60.h,
                          child: OtpTextField(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            numberOfFields: 6,
                            fieldWidth: 50.h,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.black,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700),
                            focusedBorderColor: accentColor,
                            borderWidth: 1.h,
                            borderRadius: BorderRadius.circular(16.h),
                            borderColor: subTextColor,
                            showFieldAsBox: true,
                            onCodeChanged: (String code) {},
                            onSubmit: (String verificationCode) {
                              // _signInWithPhoneNumber(verificationCode);
                              pinNumber = verificationCode;

                              if (pinNumber.length > 5) {
                                verify();
                              }
                            },
                          ),
                        ),
                        ConstantWidget.getVerSpace(40.h),
                        InkWell(
                          onTap: () {
                            if (resendString == (S.of(context).resend)) {
                              setNumber();
                            }
                          },
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: ConstantWidget.getRichText(
                                "Don’t receive code? ",
                                "#7D7D7D".toColor(),
                                FontWeight.w500,
                                17.sp,
                                resendString,
                                textColor,
                                FontWeight.w700,
                                17.sp),
                          ),
                        ),
                        ConstantWidget.getVerSpace(40.h),
                        Obx(
                          () => isProcess.value
                              ? ConstantWidget.getProcessWidget(
                                  context,
                                )
                              : ConstantWidget.getButtonWidget(
                                  context, 'Verify & Proceed', blueButton, () {
                                  verify();
                                }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  verify() {
    if (!isProcess.value) {
      isProcess.value = true;
      if (pinNumber.isEmpty) {
        isProcess.value = false;
        showCustomToast(S.of(context).fillOtp, context);
      } else {
        if (verificationId != null && verificationId!.isNotEmpty) {
          _signInWithPhoneNumber(pinNumber);
        } else {
          isProcess.value = false;
          showCustomToast(S.of(context).somethingWrong, context);
        }
      }
    }
  }

  void _signInWithPhoneNumber(String smsCode) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: smsCode);

    var authResult = await auth
        .signInWithCredential(phoneAuthCredential)
        .catchError((error) {
      print(error);

      isProcess.value = false;
    });

    User? user = authResult.user;
    if (user != null) {
      checkValidation();
      FirebaseAuth.instance.currentUser!.delete();
    } else {
      showCustomToast(S.of(context).userError, context);
    }
  }

  void checkValidation() {
    print("text---${pinNumber}");
    isProcess.value = false;
    if (ConstantUrl.isNotEmpty(pinNumber)) {
      widget.function(pinNumber);
    } else {
      ConstantUrl.showToast(S.of(context).fillDetails, context);
    }
  }
}
