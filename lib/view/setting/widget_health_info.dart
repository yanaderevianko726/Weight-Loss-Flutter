import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../util/color_category.dart';
import '../../util/constant_widget.dart';
import '../../util/constants.dart';
import '../../util/widgets.dart';
import '../../util/pref_data.dart';
import '../controller/controller.dart';

class HealthInfo extends StatefulWidget {
  @override
  _HealthInfo createState() => _HealthInfo();
}

class _HealthInfo extends State<HealthInfo> {
  String selectedGender = "Female";
  double weight = 50;
  double height = 100;
  var myController = TextEditingController();
  var myControllerIn = TextEditingController();
  SettingController settingController = Get.put(SettingController());

  var selectedDate = Constants.addDateFormat
      .format(DateTime.now().subtract(Duration(days: 5)));

  void onBackClicked() {
    Get.back();
  }

  bool isKg = true;

  @override
  void initState() {
    getGender();
    myController.text = weight.toString();
    super.initState();
  }

  Future<void> getGender() async {
    double getWeight = await PrefData().getWeight();
    double getHeight = await PrefData().getHeight();
    // print("iskgh-----${settingController.changeKgUnit()}");
    isKg = settingController.isKgUnit.value;

    // isKg = await PrefData().getIsKgUnit();

    weight = (isKg) ? getWeight : (Constants.kgToPound(getWeight));

    height = getHeight;
    bool male = await PrefData().getIsMale();
    if (male) {
      selectedGender = "Male";
    } else {
      selectedGender = "Female";
    }
    setState(() {});
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: bgDarkWhite,
          body: SafeArea(
            child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  children: [
                    ConstantWidget.getVerSpace(23.h),
                    buildAppBar(),
                    ConstantWidget.getVerSpace(30.h),
                    Expanded(
                      flex: 1,
                      child: ListView(
                        padding: EdgeInsets.symmetric(horizontal: 20.h),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: [
                          InkWell(
                            onTap: () {
                              showGenderSelectionDialog(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.h),
                                  boxShadow: [
                                    BoxShadow(
                                        color: "#0F000000".toColor(),
                                        blurRadius: 28,
                                        offset: Offset(0, 6))
                                  ]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getCustomText("Gender", textColor, 1,
                                      TextAlign.start, FontWeight.w500, 15.sp),
                                  getCustomText(selectedGender, accentColor, 1,
                                      TextAlign.end, FontWeight.w500, 15.sp)
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.h, vertical: 14.h),
                            ),
                          ),
                          ConstantWidget.getVerSpace(16.h),
                          InkWell(
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(), // Refer step 1
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null &&
                                  Constants.addDateFormat.format(picked) !=
                                      selectedDate)
                                setState(() {
                                  selectedDate =
                                      Constants.addDateFormat.format(picked);
                                });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.h),
                                  boxShadow: [
                                    BoxShadow(
                                        color: "#0F000000".toColor(),
                                        blurRadius: 28,
                                        offset: Offset(0, 6))
                                  ]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getCustomText("Date Of Birth", textColor, 1,
                                      TextAlign.start, FontWeight.w500, 15.sp),
                                  getCustomText(selectedDate, accentColor, 1,
                                      TextAlign.end, FontWeight.w500, 15.sp)
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.h, vertical: 14.h),
                            ),
                          ),
                          ConstantWidget.getVerSpace(16.h),
                          InkWell(
                            onTap: () {
                              if (isKg) {
                                myController.text =
                                    Constants.formatter.format(height);
                              } else {
                                Constants.meterToInchAndFeet(
                                    height, myController, myControllerIn);
                              }
                              showHeightDialog(false, context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.h),
                                  boxShadow: [
                                    BoxShadow(
                                        color: "#0F000000".toColor(),
                                        blurRadius: 28,
                                        offset: Offset(0, 6))
                                  ]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getCustomText("Height", textColor, 1,
                                      TextAlign.start, FontWeight.w500, 15.sp),
                                  getCustomText(
                                      (isKg)
                                          ? "${Constants.formatter.format(height)} Cm"
                                          : Constants.meterToInchAndFeetText(
                                              height),
                                      accentColor,
                                      1,
                                      TextAlign.end,
                                      FontWeight.w500,
                                      15.sp)
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.h, vertical: 14.h),
                            ),
                          ),
                          ConstantWidget.getVerSpace(16.h),
                          InkWell(
                            onTap: () {
                              myController.text =
                                  Constants.formatter.format(weight);
                              showWeightKGDialog(true, context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.h),
                                  boxShadow: [
                                    BoxShadow(
                                        color: "#0F000000".toColor(),
                                        blurRadius: 28,
                                        offset: Offset(0, 6))
                                  ]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getCustomText("Weight", textColor, 1,
                                      TextAlign.start, FontWeight.w500, 15.sp),
                                  getCustomText(
                                      "${Constants.formatter.format(weight)} ${(isKg) ? "Kg" : "Lbs"}",
                                      accentColor,
                                      1,
                                      TextAlign.end,
                                      FontWeight.w500,
                                      15.sp)
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.h, vertical: 14.h),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
        onWillPop: () async {
          onBackClicked();
          return false;
        });
  }

  Widget buildAppBar() {
    return ConstantWidget.getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      Row(
        children: [
          InkWell(
              onTap: () {
                onBackClicked();
              },
              child: getSvgImage("arrow_left.svg", height: 24.h, width: 24.h)),
          ConstantWidget.getHorSpace(12.h),
          getCustomText("Health info", textColor, 1, TextAlign.start,
              FontWeight.w700, 22.sp)
        ],
      ),
    );
  }

  void showGenderSelectionDialog(BuildContext contexts) async {
    List<String> ringTone = ['Female', 'Male'];
    int _currentIndex = ringTone.indexOf(selectedGender);

    return showDialog(
      context: contexts,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: getMediumBoldTextWithMaxLine(
                  "Select Gender", Colors.black87, 1),
              content: Container(
                width: 300,
                height: 100,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ringTone.length,
                  itemBuilder: (context, index) {
                    return RadioListTile(
                      value: index,
                      groupValue: _currentIndex,
                      title: getSmallNormalTextWithMaxLine(
                          ringTone[index], Colors.black87, 1),
                      onChanged: (value) {
                        setState(() {
                          _currentIndex = value as int;
                        });
                      },
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    selectedGender = ringTone[_currentIndex];
                    if (selectedGender == "Male") {
                      PrefData().setIsMale(true);
                    } else {
                      PrefData().setIsMale(false);
                    }
                    Navigator.pop(context, ringTone[_currentIndex]);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    ).then((value) => {setState(() {})});
  }

  void showWeightKGDialog(bool isWeight, BuildContext context) async {
    double height = ConstantWidget.getDefaultButtonSize(context);

    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            width: double.infinity,
            decoration: getDecorationWithSide(
                radius: 22.h,
                bgColor: bgDarkWhite,
                isTopLeft: true,
                isTopRight: true),
            child: StatefulBuilder(builder: (context, setState) {
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                primary: false,
                children: [
                  ConstantWidget.getVerSpace(46.h),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ConstantWidget.getCustomTextWidget(
                            'Select Weight',
                            Colors.black,
                            22.sp,
                            FontWeight.w700,
                            TextAlign.start,
                            1),
                      ),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: getSvgImage("close.svg",
                              height: 24.h, width: 24.h))
                    ],
                  ),
                  ConstantWidget.getVerSpace(15.h),
                  Row(
                    children: [
                      Expanded(
                        child: ConstantWidget.getDefaultTextFiledWithLabel(
                            context, "Weight", myController,
                            isEnable: false,
                            height: 60.h,
                            withprefix: false,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.,]')),
                            ],
                            keyboardType: TextInputType.number),
                      ),
                      ConstantWidget.getHorSpace(14.h),
                      getCustomText(
                          (isKg) ? "KG" : "LBS",
                          subTextColor,
                          1,
                          TextAlign.start,
                          FontWeight.w500,
                          ConstantWidget.getScreenPercentSize(context, 2)),
                    ],
                  ),
                  ConstantWidget.getVerSpace(40.h),
                  Row(
                    children: [
                      Expanded(
                          child: getButton(
                              context, accentColor, "Cancel", Colors.white, () {
                        Get.back();
                      }, 20.sp,
                              weight: FontWeight.w700,
                              buttonHeight: 60.h,
                              borderRadius: BorderRadius.circular(22.h))),
                      ConstantWidget.getHorSpace(20.h),
                      Expanded(
                          child: getButton(
                              context, Colors.white, "Submit", textColor, () {
                        if (myController.text.isNotEmpty) {
                          if (isWeight) {
                            weight = double.parse(myController.text);
                            if (isKg) {
                              PrefData().addWeight(weight);
                            } else {
                              PrefData().addWeight(Constants.poundToKg(weight));
                            }
                            Navigator.pop(context, weight);
                          } else {
                            if (isKg) {
                              height = double.parse(myController.text);
                              PrefData().addHeight(height);
                            } else {
                              double feet = double.parse(myController.text);
                              double inch = double.parse(myControllerIn.text);

                              double cm = Constants.feetAndInchToCm(feet, inch);
                              height = cm;

                              PrefData().addHeight(cm);
                            }

                            Navigator.pop(context, height);
                          }
                        } else {
                          Navigator.pop(context, "");
                        }
                      }, 20.sp,
                              weight: FontWeight.w700,
                              buttonHeight: 60.h,
                              borderRadius: BorderRadius.circular(22.h),
                              isBorder: true,
                              borderColor: accentColor,
                              borderWidth: 1.5.h))
                    ],
                  ),
                  ConstantWidget.getVerSpace(20.h),
                ],
              );
            }),
          ),
        );
      },
    ).then((value) => {setState(() {})});
  }

  void showHeightDialog(bool isWeight, BuildContext context) async {
    double height = ConstantWidget.getDefaultButtonSize(context);

    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            width: double.infinity,
            decoration: getDecorationWithSide(
                radius: 22.h,
                bgColor: bgDarkWhite,
                isTopLeft: true,
                isTopRight: true),
            child: StatefulBuilder(builder: (context, setState) {
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                primary: false,
                children: [
                  ConstantWidget.getVerSpace(46.h),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ConstantWidget.getCustomTextWidget(
                            'Select Height',
                            Colors.black,
                            22.sp,
                            FontWeight.w700,
                            TextAlign.start,
                            1),
                      ),
                      InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: getSvgImage("close.svg",
                              height: 24.h, width: 24.h))
                    ],
                  ),
                  ConstantWidget.getVerSpace(15.h),
                  Row(
                    children: [
                      Expanded(
                        child: ConstantWidget.getDefaultTextFiledWithLabel(
                            context,
                            (!isKg && !isWeight) ? "ft" : "Height",
                            myController,
                            isEnable: false,
                            height: 60.h,
                            withprefix: false,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.,]')),
                            ],
                            keyboardType: TextInputType.number),
                      ),
                      Visibility(
                          visible: (!isKg && !isWeight) ? true : false,
                          child: getCustomText(" , ", Colors.black, 1,
                                  TextAlign.center, FontWeight.w700, 15.sp)
                              .paddingSymmetric(horizontal: 10.h)),
                      Visibility(
                        visible: (!isKg && !isWeight) ? true : false,
                        child: Expanded(
                          child: ConstantWidget.getDefaultTextFiledWithLabel(
                              context, "in", myControllerIn,
                              isEnable: false,
                              height: 60.h,
                              withprefix: false,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9.,]')),
                              ],
                              keyboardType: TextInputType.number),
                        ),
                      ),
                      ConstantWidget.getHorSpace(14.h),
                      getCustomText(
                          (isKg) ? "CM" : "FT/In",
                          subTextColor,
                          1,
                          TextAlign.start,
                          FontWeight.w500,
                          ConstantWidget.getScreenPercentSize(context, 2)),
                    ],
                  ),
                  ConstantWidget.getVerSpace(40.h),
                  Row(
                    children: [
                      Expanded(
                          child: getButton(
                              context, accentColor, "Cancel", Colors.white, () {
                        Get.back();
                      }, 20.sp,
                              weight: FontWeight.w700,
                              buttonHeight: 60.h,
                              borderRadius: BorderRadius.circular(22.h))),
                      ConstantWidget.getHorSpace(20.h),
                      Expanded(
                          child: getButton(
                              context, Colors.white, "Submit", textColor, () {
                        if (myController.text.isNotEmpty) {
                          if (isWeight) {
                            weight = double.parse(myController.text);
                            if (isKg) {
                              PrefData().addWeight(weight);
                            } else {
                              PrefData().addWeight(Constants.poundToKg(weight));
                            }
                            Navigator.pop(context, weight);
                          } else {
                            if (isKg) {
                              height = double.parse(myController.text);
                              PrefData().addHeight(height);
                            } else {
                              double feet = double.parse(myController.text);
                              double inch = double.parse(myControllerIn.text);

                              double cm = Constants.feetAndInchToCm(feet, inch);
                              height = cm;

                              PrefData().addHeight(cm);
                            }

                            Navigator.pop(context, height);
                          }
                        } else {
                          Navigator.pop(context, "");
                        }
                      }, 20.sp,
                              weight: FontWeight.w700,
                              buttonHeight: 60.h,
                              borderRadius: BorderRadius.circular(22.h),
                              isBorder: true,
                              borderColor: accentColor,
                              borderWidth: 1.5.h))
                    ],
                  ),
                  ConstantWidget.getVerSpace(20.h),
                ],
              );
            }),
          ),
        );
      },
    ).then((value) => {
          setState(() {
            getGender();
          })
        });
  }
}
