import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:women_workout/view/login/reset_password.dart';

import '../../generated/l10n.dart';
import '../../util/color_category.dart';
import '../../util/constant_url.dart';
import '../../util/constant_widget.dart';

class OTPPage extends StatefulWidget {
  final String mobile;

  OTPPage(
    this.mobile,
  );

  @override
  _OTPPage createState() {
    return _OTPPage();
  }
}

class _OTPPage extends State<OTPPage> with WidgetsBindingObserver {
  String? verificationId;
  String pinNumber = "";
  int _countDown = 60;

  Future<bool> _requestPop() {
    Get.back();
    return new Future.value(true);
  }

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

  FirebaseAuth auth = FirebaseAuth.instance;

  PhoneAuthCredential? phoneAuthCredential;

  void setNumber() async {
    print("number------${widget.mobile}");
    await auth.verifyPhoneNumber(
      verificationFailed: (FirebaseAuthException e) {
        print("codeSend---fail");
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("codeComplete---true");
        await auth.signInWithCredential(credential);
      },
      codeSent: (String? id, int? resendToken) async {
        verificationId = id;
        print("codeSend---true");
      },
      phoneNumber: widget.mobile,
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {},
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
    return WillPopScope(
        child: Scaffold(
          backgroundColor: bgDarkWhite,
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.h),
              color: bgDarkWhite,
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
                        ConstantWidget.getTextWidget("Verify Code", textColor,
                            TextAlign.left, FontWeight.w700, 28.sp),
                        SizedBox(
                          height: 10.h,
                        ),
                        ConstantWidget.getMultilineCustomFont(
                            "We will send you a OTP sms.",
                            15.sp,
                            descriptionColor,
                            fontWeight: FontWeight.w500,
                            txtHeight: 1.46.h),
                        SizedBox(
                          height: 40.h,
                        ),
                        OtpTextField(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          numberOfFields: 6,
                          fieldWidth: 55.h,
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.black,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700),
                          focusedBorderColor: accentColor,
                          borderWidth: 1.h,
                          borderRadius: BorderRadius.circular(16.h),
                          borderColor: subTextColor,
                          showFieldAsBox: true,
                          onCodeChanged: (String code) {},
                          onSubmit: (String verificationCode) {
                            _signInWithPhoneNumber(verificationCode);
                            pinNumber = verificationCode;
                          },
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        ConstantWidget.getButtonWidget(
                            context, 'Verify', blueButton, () {
                          if (verificationId != null &&
                              verificationId!.isNotEmpty) {
                            _signInWithPhoneNumber(pinNumber);
                          } else {
                            ConstantUrl.showToast(
                                S.of(context).fillOtp, context);
                          }
                        }),
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

  void _signInWithPhoneNumber(String smsCode) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: smsCode);
    User? user = (await auth.signInWithCredential(phoneAuthCredential)).user;
    if (user != null) {
      checkValidation();
    }
  }

  void checkValidation() {
    print("text---${pinNumber}");
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (ConstantUrl.isNotEmpty(pinNumber)) {
      // Navigator.of(context).pop();
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => ResetPasswordPage(widget.email),
      //     ));
      Get.back();
      Get.to(() => ResetPassword(widget.mobile));
    } else {
      ConstantUrl.showToast(S.of(context).fillDetails, context);
    }
  }
}
