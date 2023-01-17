import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:launch_review/launch_review.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:wakelock/wakelock.dart';
import 'package:women_workout/view/home/tab/tab_diet.dart';

import '../../../models/logout_model.dart';
import '../../../models/userdetail_model.dart';
import '../../../routes/app_routes.dart';
import '../../../util/color_category.dart';
import '../../../util/constant_url.dart';
import '../../../util/constant_widget.dart';
import '../../../util/constants.dart';
import '../../../util/pref_data.dart';
import '../../../util/widgets.dart';

import '../../../util/slider/slider.dart';
import '../../../util/slider/slider_shapes.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';

import '../../controller/controller.dart';
import '../../setting/change_password.dart';

class TabSettings extends StatefulWidget {
  @override
  _TabSettings createState() => _TabSettings();
}

class _TabSettings extends State<TabSettings> {
  SettingController controller = Get.put(SettingController());
  HomeController homeController = Get.find();
  String firstname = "";
  String email = '';
  String? imageUrl;
  int getRestTime = 0;
  String remindDays = "";
  String remindTime = "05:30";
  String remindAmPm = "AM";
  bool isScreenOn = false;
  bool isSwitchOn = false;
  int orgRemindHour = 5;
  int orgRemindMinute = 30;
  int orgRemindSec = 0;
  bool isKg = true;

  // bool isLogin = false;

  List<int> spinnerItems = [10, 20, 30, 40, 50, 60];

  Future<void> _isScreenOn() async {
    isScreenOn = await Wakelock.enabled;
    remindTime = await PrefData().getRemindTime();
    remindAmPm = await PrefData().getRemindAmPm();
    isSwitchOn = await PrefData().getIsReminderOn();
    remindDays = await PrefData().getRemindDays();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _isScreenOn();
    _configureLocalTimeZone();
    getUser();
    getSignIn();
    // _getRestTimes();
  }

  getSignIn() {
    controller.changeLogin();
  }

  Future<void> share() async {
    String share = "Women Workout \n${Constants.getAppLink()}";

    await FlutterShare.share(
      title: 'share',
      text: share,
    );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();

    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();

    try {
      Location getlocal =
          tz.getLocation(timeZoneName!.replaceAll("Calcutta", "Kolkata"));
      tz.setLocalLocation(getlocal);
    } catch (e) {
      print(e);
      Location getlocal = tz.getLocation("Calcutta");
      tz.setLocalLocation(getlocal);
    }
  }

  // _getRestTimes() async {
  //   getRestTime = await PrefData().getRestTime();
  //   controller.dropDownValue.value = "$getRestTime";
  // }
  // void getSignIn() async {
  //
  //   setState(() async {
  //     isLogin = await ConstantUrl.isLogin();
  //   });
  // }

  void getUser() async {
    String s = await PrefData.getUserDetail();
    if (s.isNotEmpty) {
      UserDetail userDetail = await ConstantUrl.getUserDetail();

      setState(() {
        firstname = userDetail.firstName!;
        email = userDetail.email!;

        if (userDetail.image != null) {
          if (userDetail.image!.isNotEmpty) {
            imageUrl = userDetail.image!;
          }
        }
      });
    }
  }

  getProfileImage() {
    if (imageUrl != null) {
      return CachedNetworkImage(
        height: 80.h,
        width: 80.h,
        imageUrl: ConstantUrl.uploadUrl + imageUrl!,
      );
    } else {
      return Image.asset(Constants.assetsImagePath + "profile_imge.png",
          width: 80.h, height: 80.h);
    }
  }

  void showDailyCaloriesTime() async {
    final dailyGoalForm = GlobalKey<FormState>();
    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                width: double.infinity,
                decoration: getDecorationWithSide(
                    radius: 22.h,
                    bgColor: bgDarkWhite,
                    isTopLeft: true,
                    isTopRight: true),
                child: StatefulBuilder(builder: (context, setState) {
                  return Form(
                    key: dailyGoalForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstantWidget.getVerSpace(46.h),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ConstantWidget.getCustomTextWidget(
                                  'Daily Goal',
                                  Colors.black,
                                  22.sp,
                                  FontWeight.w700,
                                  TextAlign.start,
                                  1),
                            ),
                            InkWell(
                              child: getSvgImage("close.svg",
                                  width: 24.h, height: 24.h),
                              onTap: () {
                                Get.back();
                              },
                            )
                          ],
                        ),
                        ConstantWidget.getVerSpace(34.h),
                        getCustomText("Calories", textColor, 1, TextAlign.start,
                            FontWeight.w600, 14.sp),
                        ConstantWidget.getVerSpace(10.h),
                        ConstantWidget.getDefaultTextFiledWithLabel(
                            context, "Calories", controller.caloriesController,
                            isEnable: false,
                            height: 60.h,
                            withprefix: true,
                            image: "edit_gray.svg",
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.,]')),
                            ],
                            keyboardType: TextInputType.number,
                            validator: (calories) {
                          if (calories == null || calories.isEmpty) {
                            return "Please enter calories";
                          }
                          return null;
                        }),
                        ConstantWidget.getVerSpace(40.h),
                        Row(
                          children: [
                            Expanded(
                                child: getButton(context, accentColor, "Cancel",
                                    Colors.white, () {
                              Get.back();
                            }, 20.sp,
                                    weight: FontWeight.w700,
                                    buttonHeight: 60.h,
                                    borderRadius: BorderRadius.circular(22.h))),
                            ConstantWidget.getHorSpace(20.h),
                            Expanded(
                                child: getButton(
                                    context, Colors.white, "Submit", textColor,
                                    () {
                              // PrefData().addDailyCalGoal(
                              //     int.parse(controller.caloriesController.text));
                              if (dailyGoalForm.currentState!.validate()) {
                                controller.caloriesChange();
                                Get.back();
                              }
                            }, 20.sp,
                                    weight: FontWeight.w700,
                                    buttonHeight: 60.h,
                                    borderRadius: BorderRadius.circular(22.h),
                                    isBorder: true,
                                    borderWidth: 1.5.h,
                                    borderColor: accentColor))
                          ],
                        ),
                        ConstantWidget.getVerSpace(20.h),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  void showTrainingTime() async {
    showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            Container(
              width: double.infinity,
              decoration: getDecorationWithSide(
                  radius: 22.h,
                  bgColor: bgDarkWhite,
                  isTopLeft: true,
                  isTopRight: true),
              child: StatefulBuilder(builder: (context, setState) {
                return Column(
                  children: [
                    ConstantWidget.getVerSpace(46.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ConstantWidget.getCustomTextWidget(
                              'Select Time',
                              Colors.black,
                              22.sp,
                              FontWeight.w700,
                              TextAlign.start,
                              1),
                          InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: getSvgImage("close.svg",
                                  width: 24.h, height: 24.h))
                        ],
                      ),
                    ),
                    ConstantWidget.getVerSpace(30.h),
                    GetBuilder<SettingController>(
                      builder: (controller) => GridView.builder(
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: GetX<SettingController>(
                                init: SettingController(),
                                builder: (controller) => Container(
                                  decoration: getDefaultDecoration(
                                      radius: 22.h,
                                      borderColor:
                                          controller.dropDownValue.value ==
                                                  spinnerItems[index]
                                              ? accentColor
                                              : subTextColor),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      getCustomText(
                                          spinnerItems[index].toString(),
                                          controller.dropDownValue.value ==
                                                  spinnerItems[index]
                                              ? accentColor
                                              : textColor,
                                          1,
                                          TextAlign.center,
                                          FontWeight.w700,
                                          20.sp),
                                      ConstantWidget.getVerSpace(3.h),
                                      getCustomText(
                                          "Seconds",
                                          controller.dropDownValue.value ==
                                                  spinnerItems[index]
                                              ? accentColor
                                              : textColor,
                                          1,
                                          TextAlign.center,
                                          FontWeight.w600,
                                          14.sp)
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                controller.dropdownChange(spinnerItems[index]);
                              },
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 20.h,
                                  mainAxisSpacing: 23.h,
                                  mainAxisExtent: 102.h),
                          itemCount: spinnerItems.length,
                          primary: true,
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 20.h)),
                      init: SettingController(),
                    ),
                    ConstantWidget.getVerSpace(40.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: ConstantWidget.getButtonWidget(
                          context, "Save", accentColor, () {
                        Get.back();
                      }),
                    ),
                    ConstantWidget.getVerSpace(20.h),
                  ],
                );
              }),
            ),
          ],
        );
      },
    ).then((value) => {setState(() {})});
  }

  void showSoundDialog() async {
    showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
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
                ConstantWidget.getVerSpace(40.h),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ConstantWidget.getCustomTextWidget(
                          'Sound',
                          Colors.black,
                          22.h,
                          FontWeight.w700,
                          TextAlign.start,
                          1),
                    ),
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child:
                            getSvgImage("close.svg", height: 24.h, width: 24.h))
                  ],
                ),
                ConstantWidget.getVerSpace(30.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.h, vertical: 14.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.h),
                      boxShadow: [
                        BoxShadow(
                            color: containerShadow,
                            blurRadius: 32,
                            offset: Offset(-2, 5))
                      ]),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              getSvgImage("volume.svg",
                                  height: 24.h, width: 24.h),
                              ConstantWidget.getHorSpace(14.h),
                              getCustomText("Sound", textColor, 1,
                                  TextAlign.start, FontWeight.w500, 17.sp)
                            ],
                          ),
                          GetBuilder<SettingController>(
                            init: SettingController(),
                            builder: (controller) => Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: controller.sound.value,
                                onChanged: (value) {
                                  controller.changeSound();
                                },
                                trackColor: bgColor,
                                thumbColor: Colors.white,
                                activeColor: accentColor,
                              ),
                            ),
                          )
                        ],
                      ),
                      GetBuilder<SettingController>(
                        init: SettingController(),
                        builder: (controller) => Column(
                          children: [
                            ConstantWidget.getVerSpace(10.h),
                            SfSlider(
                              min: 0.0,
                              max: 1.0,
                              thumbIcon: getSvgImage("box.svg",
                                  width: 14.h, height: 14.h),
                              value: controller.volume.value,
                              onChanged: (dynamic newValue) {
                                controller.changeVolume(newValue);
                                // controller.fullVolume();
                              },
                              activeColor: accentColor,
                              inactiveColor: borderColor,
                              overlayShape: SfOverlayShape(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ConstantWidget.getVerSpace(12.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.h),
                      boxShadow: [
                        BoxShadow(
                            color: containerShadow,
                            blurRadius: 32,
                            offset: Offset(-2, 5))
                      ]),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              getSvgImage("volume.svg",
                                  height: 24.h, width: 24.h),
                              ConstantWidget.getHorSpace(14.h),
                              getCustomText("TTS Voice Speed", textColor, 1,
                                  TextAlign.start, FontWeight.w500, 17.sp)
                            ],
                          ),
                          GetBuilder<SettingController>(
                            init: SettingController(),
                            builder: (controller) => Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: controller.ttsSpeak.value,
                                onChanged: (value) {
                                  controller.changeTtsSpeak();
                                },
                                trackColor: bgColor,
                                thumbColor: Colors.white,
                                activeColor: accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GetBuilder<SettingController>(
                        init: SettingController(),
                        builder: (controller) => Column(
                          children: [
                            ConstantWidget.getVerSpace(10.h),
                            SfSlider(
                              min: 0.1,
                              max: 1.0,
                              thumbIcon: getSvgImage("box.svg",
                                  width: 14.h, height: 14.h),
                              value: controller.tts_speed.value,
                              onChanged: (dynamic newValue) {
                                controller.changeTtsSpeed(newValue);
                              },
                              activeColor: accentColor,
                              inactiveColor: borderColor,
                              overlayShape: SfOverlayShape(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ConstantWidget.getVerSpace(30.h),
                ConstantWidget.getButtonWidget(context, 'Save', blueButton,
                    () async {
                  Get.back();
                }),
                ConstantWidget.getVerSpace(54.h),
              ],
            );
          }),
        );
      },
    );
  }

  Widget buildAppBar() {
    return ConstantWidget.getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      Row(
        children: [
          InkWell(
              onTap: () {
                homeController.onChange(0.obs);
              },
              child: getSvgImage("arrow_left.svg", height: 24.h, width: 24.h)),
          ConstantWidget.getHorSpace(12.h),
          getCustomText(
              "Settings", textColor, 1, TextAlign.start, FontWeight.w700, 22.sp)
        ],
      ),
    );
  }

  List<String> ringTone = ['Meters and kilograms', 'Pounds,Feet and inches'];

  Future<dynamic> showUnitDialog(BuildContext contexts) async {
    // bool isKg = await PrefData().getIsKgUnit();

    int _currentIndex = controller.unitIndex.value;

    return showDialog(
      context: contexts,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: getMediumBoldTextWithMaxLine(
                  "Change Unit System", Colors.black87, 1),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
              titlePadding:
                  EdgeInsets.symmetric(horizontal: 5.w, vertical: 25.h),
              content: Container(
                width: 400,
                height: 100,
                child: GetBuilder<SettingController>(
                  init: SettingController(),
                  builder: (controller) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: ringTone.length,
                    itemBuilder: (context, index) {
                      return RadioListTile(
                        value: index,
                        groupValue: _currentIndex,
                        title: getSmallNormalTextWithMaxLine(
                            ringTone[index], Colors.black87, 1,
                            font: 20.sp),
                        onChanged: (value) {
                          setState(() {
                            _currentIndex = value as int;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    controller.changeUnitIndex(_currentIndex);
                    controller.changeKgUnit();
                    // PrefData().setIsKgUnit((_currentIndex == 0) ? true : false);
                    // Navigator.pop(context, ringTone[_currentIndex]);
                    Get.back();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    ).then((value) {
      // getIsKg();
      // setState(() {});
    });
  }

  // void getIsKg() async {
  //   isKg = await PrefData().getIsKgUnit();
  //   setState(() {});
  // }

  openReminderDialog() async {
    List<String> selectedList = [];
    List<String> selectedOrgDayList = [];
    remindDays = await PrefData().getRemindDays();
    if (remindDays.isNotEmpty) {
      var getData = jsonDecode(remindDays);
      selectedList = new List<String>.from(getData);
    }
    List<String> daysDateTimeList = [
      DateTime.sunday.toString(),
      DateTime.monday.toString(),
      DateTime.tuesday.toString(),
      DateTime.wednesday.toString(),
      DateTime.thursday.toString(),
      DateTime.friday.toString(),
      DateTime.saturday.toString()
    ];

    List<String> daysList = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    if (selectedList.length > 0) {
      selectedOrgDayList = [];
      selectedList.forEach((element) {
        int i = daysList.indexOf(element);
        selectedOrgDayList.add(daysDateTimeList[i]);
      });
    }

    return showDialog(
        context: context,
        useSafeArea: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 20.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(22.h))),
                contentPadding: EdgeInsets.all(20.h),
                content: Container(
                  width: 300.w,
                  // padding:
                  //     EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getCustomText("Set Workout Reminder", Colors.black, 1,
                          TextAlign.start, FontWeight.w700, 22.sp),
                      ConstantWidget.getVerSpace(15.h),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          InkWell(
                            onTap: () {
                              showTimePicker(
                                initialTime: TimeOfDay.now(),
                                context: context,
                                builder: (context, child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: child!,
                                  );
                                },
                              ).then((value) {
                                orgRemindHour = value!.hour;
                                orgRemindMinute = value.minute;
                                String amPm = "PM";
                                if (value.period == DayPeriod.am) {
                                  amPm = "AM";
                                }
                                String time =
                                    (value.hourOfPeriod < 10 ? "0" : "") +
                                        value.hourOfPeriod.toString() +
                                        ":" +
                                        (value.minute < 10 ? "0" : "") +
                                        value.minute.toString();
                                setState(() {});
                                remindTime = time;
                                remindAmPm = amPm;
                                return value;
                              });
                            },
                            child: getLargeBoldTextWithMaxLine(
                                remindTime, Colors.black, 1),
                          ),
                          ConstantWidget.getHorSpace(5.h),
                          Expanded(
                            child: getSmallNormalText(
                                remindAmPm, Colors.black87, TextAlign.start),
                            flex: 1,
                          ),
                          Switch(
                            activeColor: accentColor,
                            value: isSwitchOn,
                            onChanged: (value) {
                              setState(() {
                                isSwitchOn = value;
                              });
                            },
                          )
                        ],
                      ),
                      ConstantWidget.getVerSpace(10.h),
                      Container(
                        width: double.infinity,
                        height: 35.h,
                        alignment: Alignment.center,
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return ConstantWidget.getHorSpace(10.h);
                          },
                          itemCount: 7,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            String getName = daysList[index];
                            bool isSelected = selectedList.contains(getName);
                            return InkWell(
                              onTap: () {
                                if (isSwitchOn) {
                                  setState(() {
                                    if (selectedList.contains(getName)) {
                                      selectedList.remove(getName);
                                      selectedOrgDayList.remove(
                                          daysDateTimeList[index].toString());
                                    } else {
                                      selectedList.add(getName);
                                      selectedOrgDayList.add(
                                          daysDateTimeList[index].toString());
                                    }
                                  });
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(1),
                                width: 35.h,
                                height: 35.h,
                                decoration: BoxDecoration(
                                    color: isSelected
                                        ? accentColor
                                        : Colors.black12,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: getExtraSmallNormalTextWithMaxLine(
                                      "${getName[0]}",
                                      isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                      1,
                                      TextAlign.center),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                actions: [
                  new TextButton(
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                            fontFamily: Constants.fontsFamily,
                            fontSize: 15.sp,
                            color: accentColor,
                            fontWeight: FontWeight.normal),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  new TextButton(
                      style: TextButton.styleFrom(backgroundColor: lightPink),
                      child: Text(
                        'OK',
                        style: TextStyle(
                            fontFamily: Constants.fontsFamily,
                            fontSize: 15.sp,
                            color: accentColor,
                            fontWeight: FontWeight.normal),
                      ),
                      onPressed: () {
                        if (selectedList.length > 0) {
                          String s = jsonEncode(selectedList);
                          PrefData().addReminderDays(s);
                        }
                        PrefData().setIsReminderOn(isSwitchOn);
                        PrefData().addReminderTime(remindTime);
                        PrefData().addReminderAmPm(remindAmPm);
                        _cancelAllNotifications();
                        if (selectedOrgDayList.length > 0) {
                          selectedOrgDayList.forEach((element) {
                            _scheduleWeeklyMondayTenAMNotification(
                                int.parse(element));
                          });
                        }
                        Navigator.pop(context);
                      })
                ],
              );
            },
          );
        }).then((value) {
      setState(() {});
    });
  }

  TZDateTime _nextInstanceOfMondayTenAM(int day) {
    TZDateTime scheduledDate = _nextInstanceOfTenAM();
    print("schedule===${scheduledDate.weekday}--${DateTime.monday}");
    while (scheduledDate.weekday != day) {
      print("schedule123===${scheduledDate.weekday}--${DateTime.monday}");
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _scheduleWeeklyMondayTenAMNotification(int day) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        day,
        'Women Workout Reminder',
        'Women Workout Reminder',
        _nextInstanceOfMondayTenAM(day),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'com.simplyfitme.weightloss',
              'com.simplyfitme.weightloss channel',
              channelDescription: 'Women Workout Reminder'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  TZDateTime _nextInstanceOfTenAM() {
    final TZDateTime now = tz.TZDateTime.now(tz.local);
    TZDateTime scheduledDate = TZDateTime(
        tz.local, now.year, now.month, now.day, orgRemindHour, orgRemindMinute);
    print(
        "schedule===$scheduledDate--$now--${scheduledDate.isBefore(now)}--$orgRemindHour===$orgRemindMinute");
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      init: SettingController(),
      builder: (controller) => Container(
          height: double.infinity,
          width: double.infinity,
          color: bgDarkWhite,
          child: Column(
            children: [
              ConstantWidget.getVerSpace(23.h),
              buildAppBar(),
              ConstantWidget.getVerSpace(20.h),
              Expanded(
                flex: 1,
                child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20.h),
                    scrollDirection: Axis.vertical,
                    primary: true,
                    shrinkWrap: true,
                    children: [
                      Visibility(
                        visible: controller.isLogin.value,
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.editProfileRoute)!.then((value) {
                              setState(() {
                                getUser();
                              });
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: "#0F000000".toColor(),
                                      blurRadius: 28,
                                      offset: Offset(0, 6))
                                ],
                                borderRadius: BorderRadius.circular(12.h)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipOval(
                                      child: Material(
                                        child: getProfileImage(),
                                      ),
                                    ),
                                    ConstantWidget.getHorSpace(16.h),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        getCustomText(
                                            firstname,
                                            textColor,
                                            1,
                                            TextAlign.start,
                                            FontWeight.w500,
                                            19.sp),
                                        ConstantWidget.getVerSpace(4.h),
                                        getCustomText(
                                            email,
                                            descriptionColor,
                                            1,
                                            TextAlign.start,
                                            FontWeight.w500,
                                            17.sp)
                                      ],
                                    )
                                  ],
                                ),
                                getSvgImage("edit.svg",
                                    height: 24.h, width: 24.h)
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.h, vertical: 20.h),
                          ),
                        ),
                      ),
                      ConstantWidget.getVerSpace(12.h),
                      Visibility(
                        visible: controller.isLogin.value,
                        child: InkWell(
                          onTap: () {
                            // Get.toNamed(Routes.healthInfoRoute);
                            Get.to(() => ChangePassword());
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 14.h, horizontal: 20.h),
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
                                  getCustomText("Change Password", textColor, 1,
                                      TextAlign.start, FontWeight.w500, 18.sp),
                                  getSvgImage("arrow_right.svg",
                                      height: 16.h, width: 16.h)
                                ],
                              )),
                        ),
                      ),
                      ConstantWidget.getVerSpace(20.h),
                      getCustomText('Workout', textColor, 1, TextAlign.start,
                          FontWeight.w600, 19.sp),
                      ConstantWidget.getVerSpace(12.h),
                      InkWell(
                        onTap: () {
                          showTrainingTime();
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 14.h, horizontal: 20.h),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getCustomText("Training Rest", textColor, 1,
                                    TextAlign.start, FontWeight.w500, 18.sp),
                                Row(
                                  children: [
                                    getCustomText(
                                        "${controller.dropDownValue.value} Sec",
                                        accentColor,
                                        1,
                                        TextAlign.end,
                                        FontWeight.w500,
                                        18.sp),
                                    ConstantWidget.getHorSpace(12.h),
                                    getSvgImage("arrow_right.svg",
                                        height: 16.h, width: 16.h)
                                  ],
                                )
                              ],
                            )),
                      ),
                      ConstantWidget.getVerSpace(12.h),
                      InkWell(
                        onTap: () {
                          showDailyCaloriesTime();
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 14.h, horizontal: 20.h),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.h),
                                boxShadow: [
                                  BoxShadow(
                                      color: "#0F000000".toColor(),
                                      blurRadius: 28,
                                      offset: Offset(0, 6))
                                ]),
                            child: GetBuilder<SettingController>(
                              init: SettingController(),
                              builder: (controller) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getCustomText("Daily Goal", textColor, 1,
                                      TextAlign.start, FontWeight.w500, 18.sp),
                                  Row(
                                    children: [
                                      getCustomText(
                                          "${controller.calories.value} cal",
                                          accentColor,
                                          1,
                                          TextAlign.end,
                                          FontWeight.w500,
                                          18.sp),
                                      ConstantWidget.getHorSpace(12.h),
                                      getSvgImage("arrow_right.svg",
                                          height: 16.h, width: 16.h)
                                    ],
                                  )
                                ],
                              ),
                            )),
                      ),
                      ConstantWidget.getVerSpace(12.h),
                      InkWell(
                        onTap: () {
                          showSoundDialog();
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 14.h, horizontal: 20.h),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getCustomText("Sound Options", textColor, 1,
                                    TextAlign.start, FontWeight.w500, 18.sp),
                                getSvgImage("arrow_right.svg",
                                    height: 16.h, width: 16.h)
                              ],
                            )),
                      ),
                      ConstantWidget.getVerSpace(12.h),
                      // InkWell(
                      //   onTap: () {
                      //     // Get.toNamed(Routes.activityRoute);
                      //     Get.to(TabDiet());
                      //   },
                      //   child: Container(
                      //       padding: EdgeInsets.symmetric(
                      //           vertical: 14.h, horizontal: 20.h),
                      //       decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(12.h),
                      //           boxShadow: [
                      //             BoxShadow(
                      //                 color: "#0F000000".toColor(),
                      //                 blurRadius: 28,
                      //                 offset: Offset(0, 6))
                      //           ]),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           getCustomText("Activity Report", textColor, 1,
                      //               TextAlign.start, FontWeight.w500, 18.sp),
                      //           getSvgImage("arrow_right.svg",
                      //               height: 16.h, width: 16.h)
                      //         ],
                      //       )),
                      // ),
                      InkWell(
                        onTap: () {
                          Get.to(TabDiet());
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 14.h, horizontal: 20.h),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getCustomText("Diet Plans", textColor, 1,
                                    TextAlign.start, FontWeight.w500, 18.sp),
                                getSvgImage("arrow_right.svg",
                                    height: 16.h, width: 16.h)
                              ],
                            )),
                      ),
                      ConstantWidget.getVerSpace(20.h),
                      getCustomText('General', textColor, 1, TextAlign.start,
                          FontWeight.w600, 19.sp),
                      ConstantWidget.getVerSpace(12.h),
                      InkWell(
                        onTap: () {
                          openReminderDialog();
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 14.h, horizontal: 20.h),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getCustomText("Set Workout Reminder", textColor,
                                    1, TextAlign.start, FontWeight.w500, 18.sp),
                                Row(
                                  children: [
                                    getCustomText(
                                        remindTime + " " + remindAmPm,
                                        descriptionColor,
                                        1,
                                        TextAlign.end,
                                        FontWeight.w500,
                                        18.sp),
                                    ConstantWidget.getHorSpace(12.h),
                                    getSvgImage("arrow_down.svg",
                                        height: 16.h, width: 16.h)
                                  ],
                                )
                              ],
                            )),
                      ),
                      ConstantWidget.getVerSpace(12.h),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.healthInfoRoute);
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 14.h, horizontal: 20.h),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getCustomText("Health Info", textColor, 1,
                                    TextAlign.start, FontWeight.w500, 18.sp),
                                getSvgImage("arrow_right.svg",
                                    height: 16.h, width: 16.h)
                              ],
                            )),
                      ),
                      // ConstantWidget.getVerSpace(12.h),
                      // InkWell(
                      //   onTap: () {},
                      //   child: Container(
                      //       padding: EdgeInsets.symmetric(
                      //           vertical: 14.h, horizontal: 20.h),
                      //       decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(12.h),
                      //           boxShadow: [
                      //             BoxShadow(
                      //                 color: "#0F000000".toColor(),
                      //                 blurRadius: 28,
                      //                 offset: Offset(0, 6))
                      //           ]),
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           getCustomText("Notifications", textColor, 1,
                      //               TextAlign.start, FontWeight.w500, 15.sp),
                      //           getSvgImage("arrow_right.svg",
                      //               height: 16.h, width: 16.h)
                      //         ],
                      //       )),
                      // ),
                      ConstantWidget.getVerSpace(12.h),
                      InkWell(
                        onTap: () {
                          showUnitDialog(context);
                        },
                        child: GetBuilder<SettingController>(
                          init: SettingController(),
                          builder: (controller) => Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 14.h, horizontal: 20.h),
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
                                  getCustomText(
                                      "Change Unit System",
                                      textColor,
                                      1,
                                      TextAlign.start,
                                      FontWeight.w500,
                                      18.sp),
                                  getCustomText(
                                      // (isKg) ? ringTone[0] : ringTone[1],
                                      ringTone[controller.unitIndex.value],
                                      descriptionColor,
                                      1,
                                      TextAlign.end,
                                      FontWeight.w500,
                                      15.sp),
                                ],
                              )),
                        ),
                      ),
                      ConstantWidget.getVerSpace(12.h),
                      InkWell(
                        onTap: () {},
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5.h, horizontal: 20.h),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getCustomText("Keep Screen On ", textColor, 1,
                                    TextAlign.start, FontWeight.w500, 18.sp),
                                Transform.scale(
                                  scale: 0.8,
                                  child: CupertinoSwitch(
                                    value: isScreenOn,
                                    onChanged: (value) {
                                      setState(() {
                                        isScreenOn = value;
                                        Wakelock.toggle(enable: isScreenOn);
                                      });
                                    },
                                    trackColor: bgColor,
                                    thumbColor: Colors.white,
                                    activeColor: accentColor,
                                  ),
                                )
                              ],
                            )),
                      ),

                      // FutureBuilder<bool>(
                      //   future: Preferences.preferences.getBool(
                      //       key: PrefernceKey.isProUser, defValue: false),
                      //   builder: (context, snapshot) {
                      //     if (snapshot.data != null && !snapshot.data!) {
                      //       return Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           ConstantWidget.getVerSpace(20.h),
                      //           getCustomText('Subscribe', textColor, 1,
                      //               TextAlign.start, FontWeight.w600, 19.sp),
                      //           ConstantWidget.getVerSpace(12.h),
                      //           InkWell(
                      //             onTap: () {
                      //               Get.to(InAppPurchase())!
                      //                   .then((value) => setState);
                      //             },
                      //             child: Container(
                      //                 padding: EdgeInsets.symmetric(
                      //                     vertical: 14.h, horizontal: 20.h),
                      //                 decoration: BoxDecoration(
                      //                     color: Colors.white,
                      //                     borderRadius:
                      //                         BorderRadius.circular(12.h),
                      //                     boxShadow: [
                      //                       BoxShadow(
                      //                           color: "#0F000000".toColor(),
                      //                           blurRadius: 28,
                      //                           offset: Offset(0, 6))
                      //                     ]),
                      //                 child: Row(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.spaceBetween,
                      //                   children: [
                      //                     getHomeProWidget(
                      //                         context: context,
                      //                         verSpace: 0,
                      //                         horSpace: 0),
                      //                     SizedBox(
                      //                       width: 15.w,
                      //                     ),
                      //                     Expanded(
                      //                       child: getCustomText(
                      //                           "Subscribe (Remove Ads)",
                      //                           textColor,
                      //                           1,
                      //                           TextAlign.start,
                      //                           FontWeight.w500,
                      //                           18.sp),
                      //                       flex: 1,
                      //                     ),
                      //                     getSvgImage("arrow_right.svg",
                      //                         height: 16.h, width: 16.h)
                      //                   ],
                      //                 )),
                      //           ),
                      //         ],
                      //       );
                      //     } else {
                      //       return Container(
                      //         height: 0,
                      //         width: 0,
                      //       );
                      //     }
                      //   },
                      // ),

                      ConstantWidget.getVerSpace(20.h),
                      getCustomText('Support Us', textColor, 1, TextAlign.start,
                          FontWeight.w600, 19.sp),
                      ConstantWidget.getVerSpace(12.h),
                      InkWell(
                        onTap: () {
                          LaunchReview.launch();
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 14.h, horizontal: 20.h),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getCustomText("Rate us", textColor, 1,
                                    TextAlign.start, FontWeight.w500, 18.sp),
                                getSvgImage("arrow_right.svg",
                                    height: 16.h, width: 16.h)
                              ],
                            )),
                      ),
                      ConstantWidget.getVerSpace(12.h),

                      InkWell(
                        onTap: () {
                          share();
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 14.h, horizontal: 20.h),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getCustomText("Share With Friends", textColor,
                                    1, TextAlign.start, FontWeight.w500, 18.sp),
                                getSvgImage("arrow_right.svg",
                                    height: 16.h, width: 16.h)
                              ],
                            )),
                      ),
                      ConstantWidget.getVerSpace(12.h),
                      InkWell(
                        onTap: () async {
                          if (Platform.isIOS) {
                            final bool canSend =
                                await FlutterMailer.canSendMail();
                            if (!canSend) {
                              const SnackBar snackbar = const SnackBar(
                                  content: Text('no Email App Available'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackbar);
                              return;
                            }
                          }

                          final MailOptions mailOptions = MailOptions(
                            body:
                                'a long body for the email <br> with a subset of HTML',
                            subject: 'the Email Subject',
                            recipients: ['example@example.com'],
                            isHTML: true,
                            bccRecipients: ['other@example.com'],
                            ccRecipients: ['third@example.com'],
                            attachments: [
                              'path/to/image.png',
                            ],
                          );
                          await FlutterMailer.send(mailOptions);
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 14.h, horizontal: 20.h),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                getCustomText("Feedback", textColor, 1,
                                    TextAlign.start, FontWeight.w500, 18.sp),
                                getSvgImage("arrow_right.svg",
                                    height: 16.h, width: 16.h)
                              ],
                            )),
                      ),
                      ConstantWidget.getVerSpace(20.h),
                      getButton(
                          context,
                          accentColor,
                          controller.isLogin.value ? "Logout" : "Log In",
                          Colors.white, () {
                        print("login-=------sdsdsd");
                        if (controller.isLogin.value) {
                          checkNetwork();
                        } else {
                          PrefData.setIsSetting(true);
                          ConstantUrl.sendLoginPage(context, function: () {
                            controller.changeLogin();
                          }, name: () {
                            Get.toNamed(Routes.homeScreenRoute);
                          });
                        }
                      }, 20.sp,
                          weight: FontWeight.w700,
                          buttonHeight: 60.h,
                          borderRadius: BorderRadius.circular(22.h)),
                      ConstantWidget.getVerSpace(60.h),
                    ]),
              ),
            ],
          )),
    );
  }

  checkNetwork() async {
    bool isNetwork = await ConstantUrl.getNetwork();
    if (isNetwork) {
      logOut();
    } else {
      getNoInternet(context);
    }
  }

  Future<void> logOut() async {
    String deviceId = await ConstantUrl.getDeviceId();

    String s = await PrefData.getUserDetail();

    if (s.isNotEmpty) {
      UserDetail userDetail = await ConstantUrl.getUserDetail();
      String session = await PrefData.getSession();

      Map data = {
        ConstantUrl.paramSession: session,
        ConstantUrl.paramUserId: userDetail.userId,
        ConstantUrl.paramDeviceId: deviceId,
      };

      print(
          "deviceId------$session======${userDetail.userId}--------${deviceId}");

      final response =
          await http.post(Uri.parse(ConstantUrl.logOutUrl), body: data);
      if (response.statusCode == 200) {
        // await progressDialog.hide();



        Map<String, dynamic> map = json.decode(response.body);

        LogoutModel user = LogoutModel.fromJson(map);
        print("res--" + user.data!.success.toString());
        if (user.data!.success == 1) {
          PrefData.setIsSignIn(false);
          PrefData.setSession("");
          PrefData.setUserDetail("");
          controller.changeLogin();
          ConstantUrl.showToast('Log out', context);
          // Get.toNamed(Routes.signInRoute);
        } else {
          ConstantUrl.showToast('Please Try Again', context);
        }

        print("value-----failed");
      }
    }
  }
}
