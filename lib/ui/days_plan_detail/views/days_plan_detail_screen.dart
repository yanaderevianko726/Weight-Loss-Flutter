import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:women_lose_weight_flutter/database/custom_classes/custom_classes.dart';
import 'package:women_lose_weight_flutter/ui/days_plan_detail/controllers/days_plan_detail_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../google_ads/custom_ad.dart';
import '../../../utils/utils.dart';

class DaysPlanDetailScreen extends StatelessWidget {
  DaysPlanDetailScreen({Key? key}) : super(key: key);

  final DaysPlanDetailController _daysPlanDetailController =
      Get.find<DaysPlanDetailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.txtColorF2F2,
      body: SafeArea(
        top: Constant.boolValueFalse,
        bottom:
            (Platform.isIOS) ? Constant.boolValueFalse : Constant.boolValueTrue,
        child: Column(
          children: [
            Expanded(
              child: NestedScrollView(
                controller: _daysPlanDetailController.scrollController,
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    _sliverAppBarWidget(),
                  ];
                },
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      _weeksList(),
                      _changePlanResetProgressWidget(),
                    ],
                  ),
                ),
              ),
            ),
            const BannerAdClass(),
          ],
        ),
      ),
    );
  }

  _sliverAppBarWidget() {
    return GetBuilder<DaysPlanDetailController>(
      id: Constant.idDaysPlanDetailSliverAppBar,
      builder: (logic) {
        return SliverAppBar(
          elevation: 0.8,
          expandedHeight: AppSizes.height_26,
          floating: Constant.boolValueFalse,
          pinned: Constant.boolValueTrue,
          backgroundColor: AppColor.white,
          centerTitle: Constant.boolValueFalse,
          automaticallyImplyLeading: Constant.boolValueFalse,
          titleSpacing: AppSizes.width_1_5,
          title: (logic.isShrink)
              ? AutoSizeText(
                  Utils.getSelectedPlanName(
                          logic.currentPlanIndex)
                      .toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.w700,
                    fontSize: AppFontSize.size_15,
                  ),
                )
              : Container(),
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Icon(
                Icons.arrow_back_sharp,
                color: (logic.isShrink) ? AppColor.black : AppColor.white,
                size: AppSizes.height_3,
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: Constant.boolValueFalse,
            background: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.width_6, vertical: 0.0),
              decoration: BoxDecoration(
                color: AppColor.transparent,
                image: DecorationImage(
                  image: AssetImage(Utils.getSelectedPlanImage(
                      logic.currentPlanIndex)),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    Utils.getSelectedPlanName(
                        logic.currentPlanIndex),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.white,
                      fontWeight: FontWeight.w700,
                      fontSize: AppFontSize.size_17,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        right: AppSizes.height_15,
                        top: AppSizes.height_1_2,
                        bottom: AppSizes.height_1_2),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: LinearProgressIndicator(
                        value: logic.pbDay,
                        minHeight: AppSizes.height_1,
                        backgroundColor: AppColor.white,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: AppSizes.height_4),
                    child: Text(
                      logic.txtDayLeft + "\t"+ "txtDaysLeft".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: AppFontSize.size_12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _weeksList() {
    return GetBuilder<DaysPlanDetailController>(
      id: Constant.idWeeksDaysList,
      builder: (logic) {
        return ListView.builder(
          itemCount: logic.pWeeklyDayList.length,
          shrinkWrap: Constant.boolValueTrue,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
              horizontal: AppSizes.width_5_5, vertical: AppSizes.height_1_5),
          itemBuilder: (BuildContext context, int index) {
            return _itemWeeksList(index, logic.pWeeklyDayList);
          },
        );
      },
    );
  }

  _itemWeeksList(int index, List<PWeeklyDayData> pWeeklyDayList) {
    bool isDoneWeek = pWeeklyDayList[index].arrWeekDayData!.where((element) => element.isCompleted != "1").toList().isEmpty;
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
              vertical: AppSizes.height_1_5, horizontal: AppSizes.width_2_8),
          child: Row(
            children: [
              Image.asset(
                Constant.getAssetIcons() + "ic_week.webp",
                width: AppSizes.height_3_5,
                height: AppSizes.height_3_5,
              ),
              SizedBox(width: AppSizes.width_3),
              Text(
                "txtWeek".tr.toUpperCase() + " " + pWeeklyDayList[index].weekName.replaceAll("0", ""),
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: AppColor.txtColor333,
                  fontSize: AppFontSize.size_13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (!isDoneWeek) ...{
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.end,
                    text: TextSpan(
                      text: _daysPlanDetailController
                          .getTotalCompletedDaysInWeek(pWeeklyDayList[index]),
                      style: TextStyle(
                        color: AppColor.primary,
                        fontSize: AppFontSize.size_12,
                        fontWeight: FontWeight.w400,
                      ),
                      children: const <TextSpan>[
                        TextSpan(
                          text: '/7',
                          style: TextStyle(color: AppColor.txtColor999),
                        ),
                      ],
                    ),
                  ),
                ),
              } else ...{
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        Constant.getAssetIcons() + "ic_well_done.png",
                        height: AppSizes.height_2_2,
                      ),
                      SizedBox(width: AppSizes.width_1_5),
                      Text(
                        "txtWellDone".tr,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: AppColor.txtColor999,
                          fontSize: AppFontSize.size_12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              },
            ],
          ),
        ),
        _weeksDaysList(index, pWeeklyDayList),
      ],
    );
  }

  _weeksDaysList(int parentIndex, List<PWeeklyDayData> pWeeklyDayList) {
    return ListView.builder(
      itemCount: pWeeklyDayList[parentIndex].arrWeekDayData!.length,
      shrinkWrap: Constant.boolValueTrue,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return _itemWeeksDaysList(index, parentIndex, pWeeklyDayList);
      },
    );
  }

  _itemWeeksDaysList(
      int childIndex, int parentIndex, List<PWeeklyDayData> pWeeklyDayList) {
    var currentItem = pWeeklyDayList[parentIndex].arrWeekDayData![childIndex];

    return Column(
      children: [
        InkWell(
          onTap: () {
            _daysPlanDetailController.onItemWeeksDaysClick(
                pWeeklyDayList[parentIndex],
                pWeeklyDayList[parentIndex].arrWeekDayData![childIndex]);
          },
          child: Container(
            height: AppSizes.height_11,
            margin: EdgeInsets.symmetric(vertical: AppSizes.height_0_8),
            padding: EdgeInsets.symmetric(horizontal: AppSizes.width_6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: (_daysPlanDetailController.isWorkoutCompleted(currentItem))
                    ? [
                        AppColor.bgCardDaysLight,
                        AppColor.bgCardDaysLight,
                      ]
                    : (_daysPlanDetailController.isWorkoutCompletedNextItem(
                            parentIndex, childIndex))
                        ? [
                            AppColor.bgCardDays,
                            AppColor.bgCardDays,
                          ]
                        : [
                            AppColor.white,
                            AppColor.white,
                          ],
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "${"txtDay".tr} ${currentItem.dayName}".toUpperCase(),
                    style: TextStyle(
                      color: (_daysPlanDetailController
                                  .isWorkoutCompleted(currentItem) ||
                              _daysPlanDetailController.isWorkoutCompletedNextItem(
                                  parentIndex, childIndex))
                          ? AppColor.white
                          : AppColor.txtColor999,
                      fontSize: AppFontSize.size_15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                FutureBuilder(
                  future: _daysPlanDetailController.getCompletedExercise(
                      pWeeklyDayList[parentIndex]
                          .arrWeekDayData![childIndex]
                          .dayId
                          .toString()),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    String progress = "0";
                    if (snapshot.hasData &&
                        !_daysPlanDetailController.isRestDay(currentItem)) {
                      progress = ((snapshot.data * 100).toInt() /
                              int.parse(currentItem.workouts.toString()))
                          .toInt()
                          .toString();
                    }

                    if (snapshot.hasData &&
                        !_daysPlanDetailController
                            .isWorkoutCompleted(currentItem) &&
                        (!_daysPlanDetailController.isWorkoutCompletedNextItem(
                                parentIndex, childIndex) ||
                            progress != "0") &&
                        !_daysPlanDetailController.isRestDay(currentItem)) {
                      return SizedBox(
                        width: AppSizes.height_7_5,
                        child: SfRadialGauge(
                          axes: <RadialAxis>[
                            RadialAxis(
                              minimum: 0,
                              maximum:
                                  double.parse(currentItem.workouts.toString()),
                              showLabels: false,
                              showTicks: false,
                              startAngle: 270,
                              endAngle: 270,
                              axisLineStyle: const AxisLineStyle(
                                thickness: 0.18,
                                color: AppColor.progressUnFillColor,
                                thicknessUnit: GaugeSizeUnit.factor,
                              ),
                              pointers: <GaugePointer>[
                                RangePointer(
                                  value: snapshot.data ?? 0,
                                  width: 0.18,
                                  sizeUnit: GaugeSizeUnit.factor,
                                  color: (_daysPlanDetailController
                                          .isWorkoutCompletedNextItem(
                                              parentIndex, childIndex))
                                      ? AppColor.white
                                      : AppColor.primary,
                                ),
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  angle: 90,
                                  positionFactor: 0.1,
                                  verticalAlignment: GaugeAlignment.center,
                                  widget: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      progress + "%",
                                      style: TextStyle(
                                        fontSize: AppFontSize.size_10,
                                        fontWeight: FontWeight.w400,
                                        color: (_daysPlanDetailController
                                                .isWorkoutCompletedNextItem(
                                                    parentIndex, childIndex))
                                            ? AppColor.white
                                            : AppColor.txtColor999,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    } else if (_daysPlanDetailController.isWorkoutCompletedNextItem(
                            parentIndex, childIndex) &&
                        progress == "0" &&
                        !_daysPlanDetailController.isRestDay(currentItem)) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            vertical: AppSizes.height_1_2,
                            horizontal: AppSizes.width_6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: AppColor.white),
                        child: Text(
                          "txtStart".tr,
                          style: TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: AppFontSize.size_15,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                if (_daysPlanDetailController.isRestDay(currentItem) &&
                    !_daysPlanDetailController.isWorkoutCompleted(currentItem)) ...{
                  Image.asset(
                    Constant.getAssetIcons() + "ic_rest_day_future.webp",
                    width: AppSizes.height_4_5,
                    height: AppSizes.height_4_5,
                  ),
                },
                if (pWeeklyDayList[parentIndex]
                        .arrWeekDayData![childIndex]
                        .isCompleted ==
                    "1") ...{
                  Icon(
                    Icons.done_rounded,
                    color: AppColor.white,
                    size: AppSizes.height_3_5,
                  ),
                },
              ],
            ),
          ),
        ),
      ],
    );
  }

  _changePlanResetProgressWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.height_4),
      padding: EdgeInsets.symmetric(horizontal: AppSizes.width_8),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                _daysPlanDetailController.onChangePlanButtonClick();
              },
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: AppSizes.height_1_5),
                    padding: EdgeInsets.symmetric(vertical: AppSizes.width_1_5),
                    width: AppSizes.height_5,
                    height: AppSizes.height_5,
                    decoration: const BoxDecoration(
                      color: AppColor.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      Constant.getAssetIcons() + "ic_swap_horiz.webp",
                      color: AppColor.primary,
                    ),
                  ),
                  Text(
                    "txtChangePlan".tr,
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: AppFontSize.size_11,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                _daysPlanDetailController.onRestartButtonClick();
              },
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: AppSizes.height_1_5),
                    width: AppSizes.height_5,
                    height: AppSizes.height_5,
                    decoration: const BoxDecoration(
                      color: AppColor.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      Constant.getAssetIcons() + "ic_restart.webp",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    "txtRestart".tr,
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: AppFontSize.size_11,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
