import 'package:align_positioned/align_positioned.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:women_lose_weight_flutter/ui/report/controllers/report_controller.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';

import '../../../common/chart/custom_circle_symbol_renderer.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/color.dart';
import '../../../utils/sizer_utils.dart';
import '../../../utils/utils.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({Key? key}) : super(key: key);
  final ReportController _reportController = Get.find<ReportController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: AppSizes.height_2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _commonTitleText("txtTotal".tr),
          _widgetTotal(),
          Divider(
            color: AppColor.txtColor999,
            thickness: AppSizes.height_0_1,
            height: AppSizes.height_4,
          ),
          _widgetHistory(),
          Divider(
            color: AppColor.grayLight_,
            thickness: AppSizes.height_1_5,
            height: AppSizes.height_5,
          ),
          _widgetWeight(),
          Divider(
            color: AppColor.grayLight_,
            thickness: AppSizes.height_1_5,
            height: AppSizes.height_5,
          ),
          _widgetBmiChart(),
          Divider(
            color: AppColor.txtColor999,
            thickness: AppSizes.height_0_1,
            height: AppSizes.height_4,
          ),
          _widgetHeight(),
        ],
      ),
    );
  }

  _commonTitleText(String title) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.width_4),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: AppColor.black,
          fontSize: AppFontSize.size_14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _widgetTotal() {
    return GetBuilder<ReportController>(
      id: Constant.idTotal,
      builder: (logic) {
        return Container(
          margin: EdgeInsets.only(top: AppSizes.height_3),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      logic.totalWorkouts.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: AppFontSize.size_19,
                        color: AppColor.primary,
                      ),
                    ),
                    SizedBox(height: AppSizes.height_1),
                    Text(
                      "txtWorkouts".tr.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: AppFontSize.size_9,
                        color: AppColor.txtColor999,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      logic.totalKcal.toStringAsFixed(2),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: AppFontSize.size_19,
                        color: AppColor.primary,
                      ),
                    ),
                    SizedBox(height: AppSizes.height_1),
                    Text(
                      "txtKcal".tr.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: AppFontSize.size_9,
                        color: AppColor.txtColor999,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      Utils.secToString(logic.totalMinute),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: AppFontSize.size_19,
                        color: AppColor.primary,
                      ),
                    ),
                    SizedBox(height: AppSizes.height_1),
                    Text(
                      "txtMinute".tr.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: AppFontSize.size_9,
                        color: AppColor.txtColor999,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _widgetHistory() {
    return GetBuilder<ReportController>(
        id: Constant.idReportWeekHistory,
        builder: (logic) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  Get.toNamed(AppRoutes.history, arguments: Constant.boolValueTrue)!
                      .then((value) => _reportController.getTotalData());
                },
                child: Column(
                  children: [
                    Row(
                      children: [
                        _commonTitleText("txtHistory".tr),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.width_3),
                          child: const Icon(
                            Icons.navigate_next,
                            color: AppColor.darkGray,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      constraints: const BoxConstraints(
                        maxHeight: 70,
                        minHeight: 70,
                      ),
                      margin:
                          EdgeInsets.symmetric(vertical: AppSizes.height_2_5),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: logic.isAvailableHistory.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return _itemOfHistory(index, logic);
                        },
                      ),
                    )
                  ],
                ),
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: logic.completedCount.toString() + " ",
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: AppFontSize.size_13,
                    fontWeight: FontWeight.w500,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'txtDayInARow'.tr.toUpperCase(),
                      style: const TextStyle(color: AppColor.txtColor999),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  _itemOfHistory(int index, ReportController logic) {
    return SizedBox(
      width: AppSizes.fullWidth / 7.3,
      child: Column(
        children: [
          Text(
            Utils.getDaysNameOfWeek()[index].toString()[0],
            textAlign: TextAlign.left,
            style: TextStyle(
              color: AppColor.txtColor999,
              fontSize: AppFontSize.size_13,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Container(
            height: AppSizes.height_5,
            width: AppSizes.height_5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: AppSizes.height_0_1,
                color: AppColor.txtColor999,
              ),
            ),
            child: (logic.isAvailableHistory.isNotEmpty &&
                    !logic.isAvailableHistory[index])
                ? Container(
                    alignment: Alignment.center,
                    child: Text(
                      Utils.getDaysDateOfWeek()[index].toString(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Utils.getDaysDateOfWeek()[index].toString() !=
                                DateFormat(DateFormat.DAY)
                                    .format(DateTime.now())
                            ? AppColor.txtColor666
                            : AppColor.primary,
                        fontSize: AppFontSize.size_10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    child: Image.asset(Constant.getAssetIcons() +
                        "ic_challenge_complete_day.webp")),
          ),
        ],
      ),
    );
  }

  _widgetWeight() {
    return GetBuilder<ReportController>(
        id: Constant.idReportCurrentWeightUnit,
        builder: (logic) {
          return Container(
            margin: EdgeInsets.only(top: AppSizes.height_1_5),
            child: Column(
              children: [
                Row(
                  children: [
                    _commonTitleText("txtWeight".tr),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        logic.onAddWeightClick();
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: AppSizes.width_3),
                        child: const Icon(
                          Icons.add,
                          color: AppColor.black,
                        ),
                      ),
                    ),
                  ],
                ),
                _weightChart(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.width_4,
                      vertical: AppSizes.height_1),
                  child: Row(
                    children: [
                      Text(
                        "txtCurrent".tr + ":",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColor.txtColor999,
                          fontSize: AppFontSize.size_12_5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      GetBuilder<ReportController>(
                          id: Constant.idReportCurrentWeight,
                          builder: (logic) {
                            return Text(
                              logic.currentWeight.toString() +
                                  " " +
                                  logic.currentWeightUnit!,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: AppColor.txtColor333,
                                fontSize: AppFontSize.size_12_5,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.width_4,
                      vertical: AppSizes.height_1),
                  child: Row(
                    children: [
                      Text(
                        "txtHeaviest".tr + ":",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColor.txtColor999,
                          fontSize: AppFontSize.size_12_5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      GetBuilder<ReportController>(
                          id: Constant.idReportMaxWeight,
                          builder: (logic) {
                            return Text(
                              logic.maxWeight.toString() +
                                  " " +
                                  logic.currentWeightUnit!,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: AppColor.txtColor333,
                                fontSize: AppFontSize.size_12_5,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.width_4,
                      vertical: AppSizes.height_1),
                  child: Row(
                    children: [
                      Text(
                        "txtLightest".tr + ":",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColor.txtColor999,
                          fontSize: AppFontSize.size_12_5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      GetBuilder<ReportController>(
                          id: Constant.idReportMinWeight,
                          builder: (logic) {
                            return Text(
                              logic.minWeight.toString() +
                                  " " +
                                  logic.currentWeightUnit!,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: AppColor.txtColor333,
                                fontSize: AppFontSize.size_12_5,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  _weightChart() {
    return GetBuilder<ReportController>(
      id: Constant.idReportWeightChart,
      builder: (logic) {
        logic.fillChartData();
        return Container(
          padding: EdgeInsets.symmetric(
              vertical: AppSizes.width_2, horizontal: AppSizes.width_2_5),
          width: double.infinity,
          height: AppSizes.height_40,
          child: charts.TimeSeriesChart(
            logic.series!,
            animate: false,
            domainAxis: charts.DateTimeAxisSpec(
              tickProviderSpec:
                  const charts.DayTickProviderSpec(increments: [1]),
              viewport: charts.DateTimeExtents(
                  start: DateTime.now().subtract(const Duration(days: 5)),
                  end: DateTime.now().add(const Duration(days: 3))),
              tickFormatterSpec: const charts.AutoDateTimeTickFormatterSpec(
                  day: charts.TimeFormatterSpec(
                      format: 'd', transitionFormat: 'dd/MM')),
              renderSpec: charts.SmallTickRendererSpec(
                labelStyle: charts.TextStyleSpec(
                  fontSize: AppFontSize.size_10.toInt(),
                  fontWeight: FontWeight.w500.toString(),
                  color: charts.ColorUtil.fromDartColor(AppColor.black),
                ),
                lineStyle: charts.LineStyleSpec(
                  thickness: AppSizes.height_0_1.toInt(),
                  color: charts.ColorUtil.fromDartColor(AppColor.black),
                ),
              ),
            ),
            behaviors: [
              charts.PanBehavior(),
              charts.LinePointHighlighter(
                  symbolRenderer: CustomCircleSymbolRenderer())
            ],
            primaryMeasureAxis: charts.NumericAxisSpec(
              tickProviderSpec: const charts.BasicNumericTickProviderSpec(
                  zeroBound: false,
                  dataIsInWholeNumbers: true,
                  desiredTickCount: 5),
              renderSpec: charts.GridlineRendererSpec(
                lineStyle: charts.LineStyleSpec(
                  thickness: AppSizes.height_0_1.toInt(),
                  color: charts.ColorUtil.fromDartColor(AppColor.black),
                ),
                labelStyle: charts.TextStyleSpec(
                  fontSize: AppFontSize.size_10.toInt(),
                  fontWeight: FontWeight.w500.toString(),
                  color: charts.ColorUtil.fromDartColor(AppColor.black),
                ),
              ),
            ),
            selectionModels: [
              charts.SelectionModelConfig(
                  changedListener: (charts.SelectionModel model) {
                if (model.hasDatumSelection) {
                  final value = model.selectedSeries[0]
                      .measureFn(model.selectedDatum[0].index);
                  CustomCircleSymbolRenderer.value = value.toString();
                }
              }),
            ],
          ),
        );
      },
    );
  }

  _widgetBmiChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.width_4),
          child: Row(
            children: [
              Text(
                "txtBmiKg".tr + " : ",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: AppFontSize.size_14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GetBuilder<ReportController>(
                  id: Constant.idReportBmiChart,
                  builder: (logic) {
                    return Visibility(
                      visible: logic.bmi! != 0,
                      child: Text(
                        logic.bmi!.toStringAsFixed(1),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: AppFontSize.size_16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }),
              const Spacer(),
              InkWell(
                onTap: () {
                  _reportController.onBMIAddClick();
                },
                child: Text(
                  "txtEdit".tr.toUpperCase(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: AppFontSize.size_12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        ),
        GetBuilder<ReportController>(
          id: Constant.idReportBmiChart,
          builder: (logic) {
            return Visibility(
              visible: logic.bmi != 0,
              child: Container(
                margin: EdgeInsets.only(top: AppSizes.height_1),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: AppSizes.width_4,
                              right: AppSizes.width_4,
                              top: AppSizes.height_4_1),
                          height: AppSizes.height_5_5,
                          child: Row(
                            children: [
                              Container(
                                width: AppSizes.fullWidth * 0.09,
                                margin: EdgeInsets.symmetric(
                                    horizontal: AppSizes.width_0_6),
                                color: AppColor.bmiFirstColor,
                              ),
                              Container(
                                width: AppSizes.fullWidth * 0.16,
                                color: AppColor.bmiSecondColor,
                              ),
                              Container(
                                width: AppSizes.fullWidth * 0.22,
                                margin: EdgeInsets.symmetric(
                                    horizontal: AppSizes.width_0_6),
                                color: AppColor.bmiThirdColor,
                              ),
                              Container(
                                width: AppSizes.fullWidth * 0.16,
                                color: AppColor.bmiFourColor,
                              ),
                              Container(
                                width: AppSizes.fullWidth * 0.11,
                                margin: EdgeInsets.symmetric(
                                    horizontal: AppSizes.width_0_6),
                                color: AppColor.bmiFiveColor,
                              ),
                              Container(
                                width: AppSizes.fullWidth * 0.12,
                                color: AppColor.bmiSixColor,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: AppSizes.width_4,
                              vertical: AppSizes.height_0_5),
                          child: Row(
                            children: const [
                              Text("15"),
                              Expanded(flex: 1, child: Text(" ")),
                              Text("16"),
                              Expanded(flex: 3, child: Text(" ")),
                              Text("18.5"),
                              Expanded(flex: 5, child: Text(" ")),
                              Text("25"),
                              Expanded(flex: 3, child: Text(" ")),
                              Text("30"),
                              Expanded(flex: 2, child: Text(" ")),
                              Text("35"),
                              Expanded(flex: 2, child: Text(" ")),
                              Text("40"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: AppSizes.height_9_5,
                      child: AlignPositioned(
                        dx: logic.bmiValuePosition(AppSizes.fullWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              logic.bmi!.toStringAsFixed(1),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: AppColor.black,
                                fontSize: AppFontSize.size_12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: AppSizes.width_4),
                              height: AppSizes.height_6,
                              child: const VerticalDivider(
                                thickness: 5,
                                color: AppColor.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Container(
          margin: EdgeInsets.only(top: AppSizes.height_0_5),
          child: GetBuilder<ReportController>(
              id: Constant.idReportBmiChart,
              builder: (logic) {
                return Visibility(
                  visible: logic.bmi != 0,
                  child: Text(
                    logic.bmiCategory.toString(),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: logic.bmiColor!,
                      fontSize: AppFontSize.size_12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }

  _widgetHeight() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.width_4),
          child: Row(
            children: [
              Text(
                "txtHeight".tr,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: AppFontSize.size_14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  _reportController.onBMIAddClick();
                },
                child: Text(
                  "txtEdit".tr.toUpperCase(),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: AppFontSize.size_12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppSizes.width_4, vertical: AppSizes.height_5),
          child: Row(
            children: [
              Text(
                "txtCurrent".tr + ":",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColor.txtColor999,
                  fontSize: AppFontSize.size_12_5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              IntrinsicWidth(
                child: Column(
                  children: [
                    GetBuilder<ReportController>(
                        id: Constant.idReportBmiChart,
                        builder: (logic) {
                          return Text(
                            logic.height!,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: AppColor.txtColor666,
                              fontSize: AppFontSize.size_13,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }),
                    Divider(
                      color: AppColor.txtColor666,
                      thickness: AppSizes.height_0_15,
                      height: AppSizes.height_0_5,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
