import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:women_lose_weight_flutter/database/custom_classes/custom_classes.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/database/table/history_table.dart';
import 'package:women_lose_weight_flutter/google_ads/custom_ad.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';

import '../../../utils/sizer_utils.dart';
import '../../../utils/utils.dart';
import '../controllers/history_controller.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({Key? key}) : super(key: key);

  final HistoryController _historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          children: [
            _widgetBack(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _calenderWidget(),
                    Divider(
                      thickness: AppSizes.height_1_7,
                      color: AppColor.grayLight,
                    ),
                    _totalExCountAndTimeList(),
                  ],
                ),
              ),
            ),
            const BannerAdClass(),
          ],
        ),
      ),
    );
  }

  _widgetBack() {
    return Container(
      width: AppSizes.fullWidth,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
          left: AppSizes.width_5,
          right: AppSizes.width_5,
          top: AppSizes.height_2),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Utils.backWidget(iconColor: AppColor.black),
          ),
          Expanded(
            child: Text(
              "\t\t\t\t" + "txtHistory".tr,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColor.black,
                fontSize: AppFontSize.size_15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _calenderWidget() {
    return GetBuilder<HistoryController>(
      id: Constant.idCalender,
      builder: (logic) {
        return TableCalendar(
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.monday,
          locale: Utils.getCurrentLocale(),
          headerVisible: Constant.boolValueTrue,
          firstDay: DateTime(1900, 01, 01),
          focusedDay: DateTime.now(),
          lastDay: DateTime(2100, 12, 31),
          selectedDayPredicate: (day) {
            if (day ==
                DateTime.parse(
                    DateTime.parse(DateTime.now().toString().split(" ")[0])
                            .toString() +
                        "Z")) {
              return false;
            } else {
              return _historyController.calendarDates.contains(day);
            }
          },
          calendarStyle: CalendarStyle(
            defaultDecoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.transparent,
            ),
            todayDecoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.primary.withOpacity(.25),
            ),
            selectedDecoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.primary,
            ),
            defaultTextStyle: TextStyle(
              color: AppColor.txtColor999,
              fontSize: AppFontSize.size_10_5,
              fontWeight: FontWeight.w400,
            ),
            selectedTextStyle: TextStyle(
              color: AppColor.txtColor666,
              fontSize: AppFontSize.size_10_5,
              fontWeight: FontWeight.w400,
            ),
            todayTextStyle: TextStyle(
              color: AppColor.primary,
              fontSize: AppFontSize.size_10_5,
              fontWeight: FontWeight.w400,
            ),
            outsideTextStyle: TextStyle(
              color: AppColor.txtColor999.withOpacity(.3),
              fontSize: AppFontSize.size_10_5,
              fontWeight: FontWeight.w400,
            ),
            holidayTextStyle: TextStyle(
              color: AppColor.txtColor999,
              fontSize: AppFontSize.size_10_5,
              fontWeight: FontWeight.w400,
            ),
            weekendTextStyle: TextStyle(
              color: AppColor.txtColor999,
              fontSize: AppFontSize.size_10_5,
              fontWeight: FontWeight.w400,
            ),
          ),
          headerStyle: HeaderStyle(
            leftChevronVisible: Constant.boolValueTrue,
            rightChevronVisible: Constant.boolValueTrue,
            formatButtonVisible: Constant.boolValueFalse,
            titleCentered: Constant.boolValueTrue,
            titleTextFormatter: (date, locale) =>
                DateFormat("MMM - y", locale).format(date),
            titleTextStyle: TextStyle(
              color: AppColor.black,
              fontSize: AppFontSize.size_12_5,
              fontWeight: FontWeight.w400,
            ),
            leftChevronIcon: RotatedBox(
              quarterTurns: 90,
              child: Icon(
                Icons.play_arrow,
                color: AppColor.primary,
                size: AppSizes.height_2_2,
              ),
            ),
            rightChevronIcon: Icon(
              Icons.play_arrow,
              color: AppColor.primary,
              size: AppSizes.height_2_2,
            ),
            headerMargin: EdgeInsets.only(
              left: AppSizes.width_24,
              right: AppSizes.width_24,
              bottom: AppSizes.height_0_8,
            ),
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: AppColor.txtColor999,
              fontSize: AppFontSize.size_11_5,
              fontWeight: FontWeight.w600,
            ),
            weekendStyle: TextStyle(
              color: AppColor.txtColor999,
              fontSize: AppFontSize.size_11_5,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      },
    );
  }

  _totalExCountAndTimeList() {
    return GetBuilder<HistoryController>(
      id: Constant.idHistoryList,
      builder: (logic) {
        return Container(
          margin: EdgeInsets.only(top: AppSizes.height_1_2),
          child: ListView.builder(
            itemCount: logic.historyWeekDataList.length,
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: AppSizes.height_3),
            itemBuilder: (BuildContext buildContext, int index) {
              return _itemTotalExCountAndTimeList(
                  index, logic.historyWeekDataList[index]);
            },
          ),
        );
      },
    );
  }

  _itemTotalExCountAndTimeList(int index, HistoryWeekData historyWeekDataList) {
    return Column(
      children: [
        if (index != 0) ...{
          Container(
            margin: EdgeInsets.only(
                top: AppSizes.height_1_2, bottom: AppSizes.height_1_5),
            height: AppSizes.height_1,
            color: AppColor.grayLight,
          ),
        },
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.width_4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_historyController.convertStringFromDate(historyWeekDataList.weekStart.toString())} - ${_historyController.convertStringFromDate(historyWeekDataList.weekEnd.toString())}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColor.txtColor666,
                      fontSize: AppFontSize.size_10_5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: AppSizes.height_0_6),
                  Text(
                    "${historyWeekDataList.totWorkout} " + "txtWorkouts".tr,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColor.txtColor999,
                      fontSize: AppFontSize.size_9,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        Constant.getAssetIcons() + "ic_workout_time.webp",
                        height: AppSizes.height_2_3,
                        width: AppSizes.height_2_3,
                      ),
                      SizedBox(height: AppSizes.height_0_8),
                      Image.asset(
                        Constant.getAssetIcons() + "ic_workout_calories.webp",
                        height: AppSizes.height_2_3,
                        width: AppSizes.height_2_3,
                      ),
                    ],
                  ),
                  SizedBox(width: AppSizes.width_2_2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Utils.secToString(historyWeekDataList.totTime!.round()),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColor.txtColor666,
                          fontSize: AppFontSize.size_9,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: AppSizes.height_0_8),
                      Text(
                        "${historyWeekDataList.totKcal!.toStringAsFixed(2)} " +
                            "txtKcal".tr,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColor.txtColor666,
                          fontSize: AppFontSize.size_9,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(color: AppColor.grayDivider, height: AppSizes.height_2_5),
        _completedExList(historyWeekDataList.arrHistoryDetail),
      ],
    );
  }

  _completedExList(List<HistoryTable>? arrHistoryDetail) {
    return ListView.builder(
      itemCount: arrHistoryDetail!.length,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (BuildContext buildContext, int index) {
        return _itemCompletedExList(index, arrHistoryDetail);
      },
    );
  }

  _itemCompletedExList(int index, List<HistoryTable> arrHistoryDetail) {
    return InkWell(
      onTap: () {
        _historyController.onCompletedExItemClick(index, arrHistoryDetail[index]);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.width_4),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    Constant.getAssetImage() +
                        arrHistoryDetail[index].planDetail!.planThumbnail +
                        ".webp",
                    height: AppSizes.height_6_5,
                    width: AppSizes.height_6_5,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: AppSizes.width_5, right: AppSizes.width_1),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat("MMM dd, HH:mm a",
                                        Get.locale!.languageCode)
                                    .format(DateFormat("yyyy-MM-dd HH:mm:ss")
                                        .parse(arrHistoryDetail[index]
                                            .hDateTime!)),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: AppColor.txtColor999,
                                  fontSize: AppFontSize.size_9,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: AppSizes.height_0_8),
                                child: Text(
                                  _historyController
                                      .getExName(arrHistoryDetail[index]),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: AppFontSize.size_12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    Constant.getAssetIcons() +
                                        "ic_workout_time.webp",
                                    height: AppSizes.height_2_3,
                                    width: AppSizes.height_2_3,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: AppSizes.width_2,
                                        right: AppSizes.width_4),
                                    child: Text(
                                      Utils.secToString(int.parse(
                                          arrHistoryDetail[index]
                                              .hCompletionTime!)),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: AppColor.txtColor666,
                                        fontSize: AppFontSize.size_9,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    Constant.getAssetIcons() +
                                        "ic_workout_calories.webp",
                                    height: AppSizes.height_2_3,
                                    width: AppSizes.height_2_3,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: AppSizes.width_2,
                                        right: AppSizes.width_4),
                                    child: Text(
                                     double.parse(arrHistoryDetail[index].hBurnKcal!).toStringAsFixed(2) + " " +
                                          "txtKcal".tr,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: AppColor.txtColor666,
                                        fontSize: AppFontSize.size_9,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton(
                          icon: const Icon(
                            Icons.more_vert_rounded,
                            color: AppColor.txtColor666,
                          ),
                          offset: const Offset(0.0, 40),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
                            PopupMenuItem(
                              value: 0,
                              height: AppSizes.height_4,
                              child: Text(
                                "txtDelete".tr,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.txtRed,
                                  fontSize: AppFontSize.size_12,
                                ),
                              ),
                            ),
                          ],
                          onSelected: (Object? value) {
                            _sureWantToDeleteDialog(
                                arrHistoryDetail[index].hid);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (index != arrHistoryDetail.length - 1) ...{
            Container(
              color: AppColor.grayDivider,
              height: AppSizes.height_0_05,
              margin: EdgeInsets.symmetric(vertical: AppSizes.height_1_3),
            ),
          },
        ],
      ),
    );
  }

  _sureWantToDeleteDialog(int? hid) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: AppSizes.width_6),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: AppSizes.height_3, horizontal: AppSizes.width_6),
              child: Text(
                "txtAreYouSureWantToDelete".tr + "?",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: AppFontSize.size_13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  child: Text(
                    "txtCancel".tr.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: AppFontSize.size_11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
                TextButton(
                  child: Text(
                    "txtDelete".tr.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: AppFontSize.size_11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () async {
                    if (hid != null) {
                      DBHelper.dbHelper.deleteHistory(hid).then(
                          (value) => _historyController.getDataFromDatabase());
                    }
                    Get.back();
                  },
                ),
                SizedBox(width: AppSizes.width_4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
