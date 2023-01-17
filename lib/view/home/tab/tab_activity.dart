import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../data/data_file.dart';
import '../../../dialog/weight_dialog.dart';
import '../../../models/home_workout.dart';
import '../../../models/modal_chart.dart';
import '../../../models/model_workout_history.dart';
import '../../../util/color_category.dart';
import '../../../util/constant_widget.dart';
import '../../../util/constants.dart';
import '../../../util/my_assets_bar.dart';
import '../../../util/pref_data.dart';

import '../../../util/service_provider.dart';
import '../../../util/widgets.dart';
import '../../controller/controller.dart';

class TabActivity extends StatefulWidget {
  @override
  _TabActivity createState() => _TabActivity();
}

class _TabActivity extends State<TabActivity> {
  ActivityController controller = Get.put(ActivityController());
  int bmi = 0;

  double getTotalCal = 0;
  int getTodayTotalDuration = 0;
  int getTodayTotalWorkout = 0;
  double getCal = 0;




  SettingController settingController = Get.put(SettingController());

  var myController = TextEditingController();
  var myControllerWeight = TextEditingController();
  var myControllerIn = TextEditingController();

  double weight = 50;
  double height = 100;
  bool isKg = true;

  void _calcTotalCal() async {
    WorkoutHistoryModel? modelWorkout = await getAllWorkoutHistory(
        context, addDateFormat.format(DateTime.now()));
    List<CompletedHistoryworkout> workoutList = [];
    if (modelWorkout != null && modelWorkout.data!.success == 1) {
      workoutList = modelWorkout.data!.completedworkout!;
    }

    if (workoutList.length > 0) {
      workoutList.forEach((price) {
        setState(() {
          getTotalCal = (double.parse(price.kcal.toString())) + getTotalCal;
          getTodayTotalDuration = ((int.parse(price.workoutTime.toString())) +
              getTodayTotalDuration);
        });
      });
      getTodayTotalWorkout = workoutList.length;
    }
    setState(() {});
  }

  void _calcTotal() async {
    getHomeWorkoutData(context).then((value) {
      print("value---$value");

      if (value != null && value.data!.success == 1) {
        Homeworkout homeWorkout = value.data!.homeworkout!;
        double kcal = double.parse(homeWorkout.kcal!);

        setState(() {
          getCal = kcal;
        });
      } else {
        print("second---true");
      }
    });

    setState(() {});
  }

  getHeights() async {
    double getWeight = await PrefData().getWeight();
    double getHeight = await PrefData().getHeight();
    isKg = settingController.isKgUnit.value;
    weight = getWeight;
    height = getHeight;
    getBmiVal();
  }

  @override
  void initState() {
    _calcTotalCal();
    print("calories------${getTotalCal}");
    _calcTotal();
    super.initState();
    getHeights();
  }

  void showWeightHeightDialog(BuildContext contexts) async {
    return showDialog(
      context: contexts,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: getMediumBoldTextWithMaxLine(
                  "Enter Height and Weight", Colors.black87, 1),
              content: Container(
                width: 300.0,
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    getCustomText("Height", Colors.black87, 1, TextAlign.start,
                        FontWeight.w600, 20),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            cursorColor: accentColor,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accentColor),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accentColor),
                                )),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.black,
                                decorationColor: accentColor,
                                fontFamily: Constants.fontsFamily),
                            controller: myController,
                          ),
                          flex: 1,
                        ),
                        Visibility(
                          child: Text(
                            " , ",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.black,
                                decorationColor: accentColor,
                                fontFamily: Constants.fontsFamily),
                          ),
                          visible: (!isKg) ? true : false,
                        ),
                        Visibility(
                          child: Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              cursorColor: accentColor,
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: accentColor),
                                  )),
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  color: Colors.black,
                                  decorationColor: accentColor,
                                  fontFamily: Constants.fontsFamily),
                              controller: myControllerIn,
                            ),
                            flex: 1,
                          ),
                          visible: (!isKg) ? true : false,
                        ),
                        getMediumNormalTextWithMaxLine((isKg) ? "CM" : "FT/In",
                            Colors.grey, 1, TextAlign.start)
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    getCustomText("Weight", Colors.black87, 1, TextAlign.start,
                        FontWeight.w600, 20),
                    SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            cursorColor: accentColor,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accentColor),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: accentColor),
                                )),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.black,
                                decorationColor: accentColor,
                                fontFamily: Constants.fontsFamily),
                            controller: myControllerWeight,
                          ),
                          flex: 1,
                        ),
                        getMediumNormalTextWithMaxLine((isKg) ? "KG" : "LBS",
                            Colors.grey, 1, TextAlign.start)
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                new TextButton(
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                          fontFamily: Constants.fontsFamily,
                          fontSize: 15,
                          color: accentColor,
                          fontWeight: FontWeight.normal),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                new TextButton(
                    // color: lightPink,
                    style: TextButton.styleFrom(backgroundColor: lightPink),
                    child: Text(
                      'CHECK',
                      style: TextStyle(
                          color: accentColor,
                          fontFamily: Constants.fontsFamily,
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                    ),
                    onPressed: () {
                      if (myController.text.isNotEmpty) {
                        if (isKg) {
                          height = double.parse(myController.text);
                        } else {
                          double inch = 0;
                          if (myControllerIn.text.isNotEmpty) {
                            inch = double.parse(myControllerIn.text);
                          }
                          double feet = double.parse(myController.text);
                          double cm = Constants.feetAndInchToCm(feet, inch);
                          height = cm;
                        }
                        PrefData().addHeight(height);
                      }

                      if (myControllerWeight.text.isNotEmpty) {
                        double weight1 = double.parse(myControllerWeight.text);
                        if (isKg) {
                          weight = weight1;
                          PrefData().addWeight(weight1);
                        } else {
                          weight = Constants.poundToKg(weight1);
                          PrefData().addWeight(weight);
                        }
                      }
                      Navigator.pop(context, weight);
                    }),
              ],
            );
          },
        );
      },
    ).then((value) {
      getBmiVal();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getBmiVal() {
    double weightKg = weight;
    double heightCm = height;

    double meterHeight = heightCm / 100;
    double bmiGet = weightKg / (meterHeight * meterHeight);
    setState(() {
      bmi = bmiGet.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgDarkWhite,
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          ConstantWidget.getVerSpace(20.h),
          buildAppBar((){
            homeController.onChange(0.obs);
          }),
          ConstantWidget.getVerSpace(25.h),
          Expanded(
            flex: 1,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              primary: true,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                buildDateWidget(),
                ConstantWidget.getVerSpace(20.h),
                buildCaloriesProgressBar(),
                ConstantWidget.getVerSpace(20.h),
                buildCaloriesWidget(),
                ConstantWidget.getVerSpace(20.h),
                getCustomText("BMI Calculator", textColor, 1, TextAlign.start,
                    FontWeight.w700, 20.sp),
                ConstantWidget.getVerSpace(12.h),
                buildBmiCalculator(context),
                ConstantWidget.getVerSpace(20.h),
                buildChartWidget(context),
                ConstantWidget.getVerSpace(20.h),
                buildCalendar(),
                ConstantWidget.getVerSpace(30.h),
                Row(
                  children: [
                    Expanded(
                      child: getCustomText('Summary', textColor, 1,
                          TextAlign.start, FontWeight.w700, 20.sp),
                      flex: 1,
                    ),
                  ],
                ),
                ConstantWidget.getVerSpace(12.h),
                buildActivityList(),
                ConstantWidget.getVerSpace(70.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildChartWidget(BuildContext context) {
    return Container(
      height: 500.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.h), color: lightOrange),
      padding: EdgeInsets.only(left: 20.h, top: 20.h, bottom: 20.h),
      child: Column(
        children: [
          ConstantWidget.getPaddingWidget(
            EdgeInsets.only(right: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getCustomText("Weight", textColor, 1, TextAlign.start,
                    FontWeight.w700, 18.sp),
                InkWell(
                  onTap: () {
                    showDialog(
                            builder: (context) {
                              return WeightDialog();
                            },
                            context: context)
                        .then((value) {
                      setState(() {});
                    });
                  },
                  child: Row(
                    children: [
                      getCustomText("Add", textColor, 1, TextAlign.end,
                          FontWeight.w500, 16.sp),
                      ConstantWidget.getHorSpace(5.h),
                      getSvgImage("add.svg",
                          height: 24.h, width: 24.h, color: Colors.black)
                    ],
                  ),
                )
              ],
            ),
          ),
          ConstantWidget.getVerSpace(20.h),
          Container(
            height: 400.h,
            child: SfCartesianChart(
              margin: EdgeInsets.zero,
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                      fontFamily: Constants.fontsFamily),
                  arrangeByIndex: true,
                  autoScrollingMode: AutoScrollingMode.start,
                  minorGridLines: MinorGridLines(width: 0),
                  majorTickLines: MajorTickLines(width: 0),
                  axisLine: AxisLine(width: 0),
                  majorGridLines: MajorGridLines(width: 0)),
              primaryYAxis: NumericAxis(
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                      fontFamily: Constants.fontsFamily),
                  majorTickLines: MajorTickLines(width: 0),
                  plotBands: [],
                  anchorRangeToVisiblePoints: false,
                  minorGridLines: MinorGridLines(width: 0),
                  axisLine: AxisLine(width: 0),
                  majorGridLines: MajorGridLines(width: 0)),
              zoomPanBehavior: ZoomPanBehavior(
                enablePanning: true,
                zoomMode: ZoomMode.x,
              ),
              series: <ChartSeries>[
                AreaSeries<SalesData, String>(
                    color: Colors.grey,
                    dataSource: DataFile.salesLists,
                    xValueMapper: (SalesData sales, _) => sales.year,
                    yValueMapper: (SalesData sales, _) => sales.sales,
                    borderWidth: 1.5.h,
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withOpacity(0.2),
                        accentColor.withOpacity(0.8),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    borderColor: Colors.black,
                    markerSettings: MarkerSettings(
                        isVisible: true,
                        color: accentColor,
                        borderWidth: 1.5.h,
                        width: 10.h,
                        height: 10.h,
                        borderColor: Colors.black))
              ],
            ),
          )
        ],
      ),
    );
  }

  GetBuilder<GetxController> buildActivityList() {
    return GetBuilder<ActivityController>(
      init: ActivityController(),
      builder: (controller) => FutureBuilder<WorkoutHistoryModel?>(
        future: getAllWorkoutHistory(
            context, addDateFormat.format(controller.selectDate.value)),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            WorkoutHistoryModel? modelWorkout =
                snapshot.data;

            if (modelWorkout!.data!.success == 1) {
              List<CompletedHistoryworkout>? workoutList =
                  modelWorkout.data!.completedworkout;
              return ListView.builder(
                primary: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: workoutList!.length,
                itemBuilder: (context, index) {
                  CompletedHistoryworkout _modelWorkoutList =
                      workoutList[index];
                  return Container(
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
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  getCustomText(
                                      getHistoryTitle(
                                          _modelWorkoutList.workoutType!),
                                      textColor,
                                      1,
                                      TextAlign.start,
                                      FontWeight.w700,
                                      17.sp),
                                  getCustomText(
                                      DateFormat("EEE,d MMMM").format(
                                          _modelWorkoutList.workoutDate!),
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
                                            Constants.getTimeFromSec(int.parse(
                                                _modelWorkoutList
                                                    .workoutTime!)),
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
                                            "${_modelWorkoutList.kcal} Calories",
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
                  );
                },
              );
            } else {
              return getNoData(context);
            }
          } else {
            return GetBuilder<SettingController>(
              init: SettingController(),
              builder: (controller) => !controller.isLogin.value ? getNoData(context) : ListView.builder(
                primary: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
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
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    getCustomText("", textColor, 1,
                                        TextAlign.start, FontWeight.w700, 17.sp),
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
                                              "",
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
                                              "Calories",
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
                  );
                },
              ),
            );
          }
        },
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

  Container buildBmiCalculator(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: containerShadow, blurRadius: 32, offset: Offset(-2, 5))
      ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: MyAssetsBar(
              width: 330.w,
              background: Colors.white,
              pointer: bmi,
              height: 20.h,
              assetsLimit: 50,
              order: OrderType.None,
              assets: [
                MyAsset(size: 15, color: Colors.grey.shade400, title: "0"),
                MyAsset(size: 3, color: "#9BE7A3".toColor(), title: "16"),
                MyAsset(size: 7, color: "#31BF3F".toColor(), title: "18"),
                MyAsset(size: 5, color: "#DCE683".toColor(), title: "25"),
                MyAsset(size: 5, color: '#FF9A00'.toColor(), title: "30"),
                MyAsset(size: 5, color: "#E26F76".toColor(), title: "35"),
                MyAsset(size: 10, color: "#EF3737".toColor(), title: "40"),
              ],
            ),
          ),
          ConstantWidget.getVerSpace(15.h),
          getButton(context, accentColor, "Check now", Colors.white, () {
            if (isKg) {
              myController.text = Constants.formatter.format(height);
              myControllerWeight.text = Constants.formatter.format(weight);
            } else {
              Constants.meterToInchAndFeet(
                  height, myController, myControllerIn);
              myControllerWeight.text =
                  Constants.formatter.format(Constants.kgToPound(weight));
            }
            showWeightHeightDialog(context);
          }, 14.sp,
              weight: FontWeight.w600,
              buttonHeight: 40.h,
              borderRadius: BorderRadius.circular(12.h))
        ],
      ),
    );
  }

  Row buildCaloriesWidget() {
    return Row(
      children: [
        Expanded(
            child: GetBuilder<SettingController>(
          init: SettingController(),
          builder: (controller) => Container(
            height: 140.h,
            decoration: BoxDecoration(
                color: "#FFF5DE".toColor(),
                borderRadius: BorderRadius.circular(22.h)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getAssetImage("calories.png", height: 46.h, width: 34.h),
                ConstantWidget.getVerSpace(9.h),
                getCustomText("Burn Calories", textColor, 1, TextAlign.center,
                    FontWeight.w700, 17.sp),
                ConstantWidget.getVerSpace(6.h),
                getCustomText(
                    "${getCal.round()}/${controller.calories.value} Cal",
                    textColor,
                    1,
                    TextAlign.center,
                    FontWeight.w500,
                    15.sp)
              ],
            ),
          ),
        )),
        ConstantWidget.getHorSpace(20.h),
        Expanded(
            flex: 1,
            child: Column(
              children: [
                Container(
                  height: 66.h,
                  decoration: BoxDecoration(
                      color: '#E2F4FF'.toColor(),
                      borderRadius: BorderRadius.circular(22.h)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getAssetImage("dumbell_1.png", height: 30.h, width: 30.h),
                      ConstantWidget.getHorSpace(6.h),
                      getCustomText("$getTodayTotalWorkout Workout", textColor,
                          1, TextAlign.center, FontWeight.w700, 17.sp)
                    ],
                  ),
                ),
                ConstantWidget.getVerSpace(8.h),
                Container(
                  height: 66.h,
                  decoration: BoxDecoration(
                      color: '#E5FFFD'.toColor(),
                      borderRadius: BorderRadius.circular(22.h)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      getAssetImage("clock1.png", height: 30.h, width: 30.h),
                      ConstantWidget.getHorSpace(6.h),
                      getCustomText(
                          "${Constants.getTimeFromSec(getTodayTotalDuration)}",
                          textColor,
                          1,
                          TextAlign.center,
                          FontWeight.w700,
                          17.sp)
                    ],
                  ),
                )
              ],
            ))
      ],
    );
  }

  Widget buildCaloriesProgressBar() {
    return GetBuilder<SettingController>(
        init: SettingController(),
        builder: (controller) => CircularPercentIndicator(
              circularStrokeCap: CircularStrokeCap.round,
              lineWidth: 14.h,
              linearGradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: <Color>[
                    Color(0xFFFF8865),
                    Color(0xFFFCBB72),
                    Color(0xFFF9F080),
                    Color(0xFF89EF99)
                  ],
                  stops: <double>[
                    0.0,
                    0.26,
                    0.65,
                    1.0
                  ]),
              percent: ((((getTotalCal * 100) /
                              double.parse(controller.calories.value)) /
                          100) >
                      1.0)
                  ? 1.0
                  : (((getTotalCal * 100) /
                          double.parse(controller.calories.value)) /
                      100),
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  getCustomText("Active Calories", descriptionColor, 1,
                      TextAlign.center, FontWeight.w500, 15.sp),
                  ConstantWidget.getVerSpace(6.h),
                  getCustomText(
                      "${Constants.calFormatter.format(getTotalCal)}/${controller.calories.value}",
                      textColor,
                      1,
                      TextAlign.center,
                      FontWeight.w700,
                      17.sp),
                  ConstantWidget.getVerSpace(5.h),
                  getCustomText("Cal", descriptionColor, 1, TextAlign.center,
                      FontWeight.w500, 15.sp),
                ],
              ),
              backgroundColor: cellColor,
              radius: 90.h,
            ));
  }

  Row buildDateWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstantWidget.getTextWidget(
            "Today", textColor, TextAlign.start, FontWeight.w600, 18.sp),
        ConstantWidget.getHorSpace(11.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 9.h),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8.h),
              ),
              color: lightOrange),
          child: ConstantWidget.getTextWidget(
              Constants.showDateFormat.format(new DateTime.now()),
              textColor,
              TextAlign.center,
              FontWeight.w600,
              14.sp),
        ),
      ],
    );
  }

  HomeController homeController = Get.find();

  Widget buildAppBar(Function function) {
    return ConstantWidget.getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                  onTap: () {
                    function();
                  },
                  child:
                      getSvgImage("arrow_left.svg", height: 24.h, width: 24.h)),
              ConstantWidget.getHorSpace(12.h),
              getCustomText("Activity", textColor, 1, TextAlign.start,
                  FontWeight.w700, 22.sp)
            ],
          ),
        ],
      ),
    );
  }

  getSubItem(String s, String s1) {
    return Container(
      margin: EdgeInsets.only(
          right: ConstantWidget.getWidthPercentSize(context, 2)),
      padding: EdgeInsets.symmetric(
          horizontal: ConstantWidget.getWidthPercentSize(context, 2),
          vertical: ConstantWidget.getScreenPercentSize(context, 1)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(
              ConstantWidget.getScreenPercentSize(context, 15)))),
      child: Row(
        children: [
          Image.asset(
            Constants.assetsImagePath + s,
            height: ConstantWidget.getScreenPercentSize(context, 2),
            width: ConstantWidget.getScreenPercentSize(context, 2),
            color: textColor,
          ),
          SizedBox(
            width: ConstantWidget.getWidthPercentSize(context, 1),
          ),
          getCustomText(s1, textColor, 1, TextAlign.center, FontWeight.w600,
              ConstantWidget.getScreenPercentSize(context, 1.6)),
        ],
      ),
    );
  }
}
