import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../models/userdetail_model.dart';
import '../util/color_category.dart';
import '../util/constant_url.dart';
import '../util/constant_widget.dart';
import '../util/pref_data.dart';
import '../util/widgets.dart';

class CustomDietPlanScreen extends StatefulWidget {
  const CustomDietPlanScreen({Key? key}) : super(key: key);

  @override
  State<CustomDietPlanScreen> createState() => _CustomDietPlanScreenState();
}

class _CustomDietPlanScreenState extends State<CustomDietPlanScreen> {
  Future<bool> _requestPop() {
    Get.back();

    return new Future.value(false);
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final dietForm = GlobalKey<FormState>();
  UserDetail? userDetail;
  String? s;

  @override
  void initState() {
    super.initState();
    getDetail().then((value) {});
  }

  Future getDetail() async {
    s = await PrefData.getUserDetail();
    if (s != null) {
      userDetail = await ConstantUrl.getUserDetail();
    }
    setState(() {
      if (s != null && s!.isNotEmpty) {
        nameController.text =
            "${userDetail!.firstName} ${userDetail!.lastName}";
        phoneController.text = userDetail!.mobile.toString();
        heightController.text = userDetail!.height.toString();
        weightController.text = userDetail!.weight.toString();
        emailController.text = userDetail!.email.toString();
      }
      // else{
      //     nameController.text = "";

      //     phoneController.text = "";
      //     heightController.text = "";
      //     weightController.text = "";
      //     emailController.text = "";
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: bgDarkWhite,
        appBar: getNoneAppBar(context),
        body: SafeArea(
          child: Form(
            key: dietForm,
            child: ConstantWidget.getPaddingWidget(
              EdgeInsets.symmetric(horizontal: 20.h),
              Column(
                children: [
                  ConstantWidget.getVerSpace(20.h),
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            _requestPop();
                          },
                          child: getSvgImage("arrow_left.svg",
                              width: 24.h, height: 24.h)),
                      ConstantWidget.getHorSpace(12.h),
                      getCustomText("Custom Diet Plan", textColor, 1,
                          TextAlign.start, FontWeight.w700, 22.sp)
                    ],
                  ),
                  ConstantWidget.getVerSpace(30.h),
                  Expanded(
                    child: ListView(
                      primary: true,
                      shrinkWrap: false,
                      children: [
                        getTitle('Username'),
                        ConstantWidget.getFormTextFiledWithLabel(
                            context, "Name", nameController,
                            isEnable: false, height: 50.h, validator: (name) {
                          if (name == null || name.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        }),
                        SizedBox(
                          height: 20.h,
                        ),
                        getTitle('Phone Number'),
                        ConstantWidget.getFormTextFiledWithLabel(
                            context, "Phone Number", phoneController,
                            isEnable: false, height: 50.h, validator: (phone) {
                          if (phone == null || phone.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ]),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getTitle('Height'),
                                ConstantWidget.getFormTextFiledWithLabel(
                                    context, "Height", heightController,
                                    isEnable: false,
                                    height: 50.h, validator: (height) {
                                  if (height == null || height.isEmpty) {
                                    return 'Please enter your height';
                                  }
                                  return null;
                                },
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ]),
                              ],
                            )),
                            SizedBox(
                              width: 20.h,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getTitle('Weight'),
                                ConstantWidget.getFormTextFiledWithLabel(
                                    context, "Weight", weightController,
                                    isEnable: false,
                                    height: 50.h, validator: (weight) {
                                  if (weight == null || weight.isEmpty) {
                                    return 'Please enter your weight';
                                  }
                                  return null;
                                },
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ]),
                              ],
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        getTitle('Email'),
                        ConstantWidget.getFormTextFiledWithLabel(
                          context,
                          "Email",
                          emailController,
                          isEnable: false,
                          height: 40.h,
                          validator: (email) {
                            if (email == null || email.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        getTitle('Description'),
                        ConstantWidget.getDescTextFiledWithLabel(
                            context, "Description", descriptionController,
                            isEnable: false,
                            height: 50.h, validator: (description) {
                          if (description == null || description.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        }, minLines: true, maxLine: 4),
                      ],
                    ),
                  ),
                  ConstantWidget.getButtonWidget(context, 'Submit', blueButton,
                      () async {



                      if (dietForm.currentState!.validate()) {

                        if(await PrefData().checkUserAccess()) {
                        if (Platform.isIOS) {
                          final bool canSend = await FlutterMailer
                              .canSendMail();
                          if (!canSend) {
                            const SnackBar snackbar = const SnackBar(
                                content: Text('no Email App Available'));
                            ScaffoldMessenger.of(context).showSnackBar(
                                snackbar);
                            return;
                          }
                        }

                        final MailOptions mailOptions = MailOptions(
                          body:
                          'Name: ${nameController.text}\nPhone Number: ${phoneController.text}\nHeight: ${heightController.text}'
                              '\nWeight: ${weightController.text}\nEmail: ${emailController.text}\nDescription: ${descriptionController.text}',
                          subject: 'Detail',
                          recipients: ['simplyfitmemail@gmail.com'],
                          isHTML: true,
                          attachments: [],
                        );
                        await FlutterMailer.send(mailOptions);
                      }
                    }

                  }),
                  SizedBox(
                    height: 40.h,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getTitle(String string) {
    return ConstantWidget.getMultilineCustomFont(
            string, 14.sp, descriptionColor,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.start,
            txtHeight: 1.25.h)
        .marginOnly(bottom: 10.h);
  }
}
