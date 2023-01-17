import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../data/data_file.dart';
import '../../models/modal_activity.dart';
import '../../util/color_category.dart';
import '../../util/constant_widget.dart';
import '../../util/constants.dart';
import '../../util/widgets.dart';
import '../controller/controller.dart';

class ActivityList extends StatefulWidget {
  const ActivityList({Key? key}) : super(key: key);

  @override
  State<ActivityList> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList>
    with TickerProviderStateMixin {
  Future<bool> _requestPop() {
    Get.back();

    return new Future.value(false);
  }

  List<ModalActivity> activityList = DataFile.activitylists;
  ActivityController controller = Get.put(ActivityController());

  ScrollController? _scrollViewController;
  bool isScrollingDown = false;

  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    super.initState();

    _scrollViewController = new ScrollController();
    _scrollViewController!.addListener(() {
      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          setState(() {});
        }
      }

      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollViewController!.removeListener(() {});
    _scrollViewController!.dispose();
    try {
      if (animationController != null) {
        animationController!.dispose();
      }
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: bgDarkWhite,
        body: SafeArea(
          child: Column(
            children: [
              ConstantWidget.getVerSpace(20.h),
              buildAppBar(),
              ConstantWidget.getVerSpace(20.h),
              buildTabBar(),
              ConstantWidget.getVerSpace(20.h),
              buildActivitylist(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTabBar() {
    return ConstantWidget.getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      Container(
        height: 32.h,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: containerShadow, blurRadius: 32, offset: Offset(-2, 5))
            ],
            borderRadius: BorderRadius.circular(9.h)),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  controller.itemChange(0.obs, 5.obs);
                  animationController = AnimationController(
                      duration: const Duration(milliseconds: 1000),
                      vsync: this);
                },
                child: GetX<ActivityController>(
                  init: ActivityController(),
                  builder: (controller) => Container(
                    alignment: Alignment.center,
                    height: 32.h,
                    decoration: BoxDecoration(
                        color: controller.select.value == 0
                            ? accentColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(6.93.h)),
                    child: getCustomText(
                        "All",
                        controller.select.value == 0 ? Colors.white : textColor,
                        1,
                        TextAlign.center,
                        FontWeight.w600,
                        14.sp),
                  ),
                ),
              ),
            ),
            VerticalDivider(
              thickness: 0.71,
              color: subTextColor,
              indent: 6.h,
              endIndent: 6.h,
              width: 0,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  controller.itemChange(1.obs, 2.obs);
                  animationController = AnimationController(
                      duration: const Duration(milliseconds: 1000),
                      vsync: this);
                },
                child: GetX<ActivityController>(
                  init: ActivityController(),
                  builder: (controller) => Container(
                    alignment: Alignment.center,
                    height: 32.h,
                    decoration: BoxDecoration(
                        color: controller.select.value == 1
                            ? accentColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(6.93.h)),
                    child: getCustomText(
                        "Daily",
                        controller.select.value == 1 ? Colors.white : textColor,
                        1,
                        TextAlign.center,
                        FontWeight.w600,
                        14.sp),
                  ),
                ),
              ),
            ),
            VerticalDivider(
              thickness: 0.71,
              color: subTextColor,
              indent: 6.h,
              endIndent: 6.h,
              width: 0,
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  controller.itemChange(2.obs, 4.obs);
                  animationController = AnimationController(
                      duration: const Duration(milliseconds: 1000),
                      vsync: this);
                },
                child: GetX<ActivityController>(
                  init: ActivityController(),
                  builder: (controller) => Container(
                    alignment: Alignment.center,
                    height: 32.h,
                    decoration: BoxDecoration(
                        color: controller.select.value == 2
                            ? accentColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(6.93.h)),
                    child: getCustomText(
                        "Monthly",
                        controller.select.value == 2 ? Colors.white : textColor,
                        1,
                        TextAlign.center,
                        FontWeight.w600,
                        14.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildActivitylist() {
    return Expanded(
      flex: 1,
      child: ListView(
        primary: true,
        shrinkWrap: true,
        children: [
          ConstantWidget.getPaddingWidget(
            EdgeInsets.symmetric(horizontal: 20.h),
            buildCalendar(),
          ),
          ConstantWidget.getVerSpace(20.h),
          GetX<ActivityController>(
            init: ActivityController(),
            builder: (controller) => ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              primary: false,
              shrinkWrap: true,
              itemCount: controller.item.value,
              itemBuilder: (context, index) {
                ModalActivity modalActivity = activityList[index];
                final Animation<double> animation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animationController!,
                    curve: Curves.easeInOut,
                  ),
                );
                animationController!.forward();
                return AnimatedBuilder(
                  animation: animationController!,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: Transform(
                        transform: Matrix4.translationValues(
                            0.0, 50 * (1.0 - animation.value), 0.0),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20.h),
                          padding: EdgeInsets.only(
                              left: 12.h, top: 12.h, bottom: 12.h, right: 20.h),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: containerShadow,
                                    blurRadius: 32,
                                    offset: Offset(-2, 5))
                              ],
                              borderRadius: BorderRadius.circular(22.h)),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: lightOrange,
                                    borderRadius: BorderRadius.circular(12.h)),
                                child: getAssetImage("select_workout.png",
                                    height: 68.h, width: 25.h),
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.h, horizontal: 20.h),
                              ),
                              ConstantWidget.getHorSpace(12.h),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        getCustomText(
                                            modalActivity.name ?? '',
                                            textColor,
                                            1,
                                            TextAlign.start,
                                            FontWeight.w700,
                                            17.sp),
                                        getCustomText(
                                            modalActivity.date ?? '',
                                            textColor,
                                            1,
                                            TextAlign.end,
                                            FontWeight.w500,
                                            14.sp)
                                      ],
                                    ),
                                    ConstantWidget.getVerSpace(10.h),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: "#E0F0FA".toColor(),
                                              borderRadius:
                                                  BorderRadius.circular(4.h)),
                                          child: Row(
                                            children: [
                                              getAssetImage("time.png",
                                                  width: 16.h, height: 16.h),
                                              ConstantWidget.getHorSpace(4.h),
                                              getCustomText(
                                                  "00:00:40",
                                                  textColor,
                                                  1,
                                                  TextAlign.start,
                                                  FontWeight.w500,
                                                  10.sp)
                                            ],
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.h, horizontal: 16.h),
                                        ),
                                        ConstantWidget.getHorSpace(8.h),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: "#FFEDE9".toColor(),
                                              borderRadius:
                                                  BorderRadius.circular(4.h)),
                                          child: Row(
                                            children: [
                                              getAssetImage("fire.png",
                                                  width: 16.h, height: 16.h),
                                              ConstantWidget.getHorSpace(4.h),
                                              getCustomText(
                                                  "78 Calories",
                                                  textColor,
                                                  1,
                                                  TextAlign.start,
                                                  FontWeight.w500,
                                                  10.sp)
                                            ],
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.h, horizontal: 16.h),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container buildCalendar() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: '#E9E9E9'.toColor(),
                blurRadius: 24,
                offset: Offset(0, 13))
          ],
          borderRadius: BorderRadius.circular(8.h)),
      child: GetX<ActivityController>(
        init: ActivityController(),
        builder: (controller) => TableCalendar(
          availableGestures: AvailableGestures.none,
          firstDay: new DateTime(2018, 1, 13),
          lastDay: DateTime.now().add(Duration(days: 365)),
          focusedDay: controller.selectDate.value,
          startingDayOfWeek: StartingDayOfWeek.monday,
          selectedDayPredicate: (day) {
            return isSameDay(controller.selectDate.value, day);
          },
          eventLoader: (day) {
            return [];
          },
          rowHeight: 50.h,
          calendarStyle: CalendarStyle(
            cellMargin: EdgeInsets.symmetric(vertical: 7.h),
            todayDecoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8.h)),
            todayTextStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
                fontFamily: Constants.fontsFamily),
            outsideDaysVisible: true,
            outsideTextStyle: TextStyle(
                color: "#9C9D9F".toColor(),
                fontFamily: Constants.fontsFamily,
                fontWeight: FontWeight.w500,
                fontSize: 13.sp),
            defaultDecoration: BoxDecoration(color: Colors.white),
            defaultTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                fontFamily: Constants.fontsFamily),
            selectedTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                fontFamily: Constants.fontsFamily),
            selectedDecoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8.h)),
            canMarkersOverflow: false,
            weekendDecoration: BoxDecoration(color: Colors.white),
            weekendTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                fontFamily: Constants.fontsFamily),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle(
                  color: "#9C9D9F".toColor(),
                  fontFamily: Constants.fontsFamily,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500),
              weekdayStyle: TextStyle(
                  color: "#9C9D9F".toColor(),
                  fontFamily: Constants.fontsFamily,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500)),
          headerStyle: HeaderStyle(
              titleCentered: true,
              titleTextStyle: TextStyle(
                  color: textColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: Constants.fontsFamily),
              formatButtonVisible: false,
              leftChevronIcon: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.h),
                height: 32.h,
                width: 32.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.h),
                    border: Border.all(color: grayLight, width: 1.h)),
                child: getSvgImage("arrow_left.svg"),
              ),
              rightChevronIcon: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 8.h),
                height: 32.h,
                width: 32.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.h),
                    border: Border.all(color: grayLight, width: 1.h)),
                child: getSvgImage("arrow_right.svg"),
              )),
          onDaySelected: (day, events) {
            controller.onChange(day.obs);
          },
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return ConstantWidget.getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      Row(
        children: [
          InkWell(
              onTap: () {
                _requestPop();
              },
              child: getSvgImage("arrow_left.svg", height: 24.h, width: 24.h)),
          ConstantWidget.getHorSpace(12.h),
          getCustomText(
              "Activity", textColor, 1, TextAlign.start, FontWeight.w700, 22.sp)
        ],
      ),
    );
  }
}
