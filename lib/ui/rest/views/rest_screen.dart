import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:women_lose_weight_flutter/google_ads/custom_ad.dart';
import 'package:women_lose_weight_flutter/ui/rest/controllers/rest_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../utils/constant.dart';
import '../../../utils/utils.dart';

class RestScreen extends StatelessWidget {
  RestScreen({Key? key}) : super(key: key);

  final RestController _restController = Get.find<RestController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _restController.onRestTimeComplete();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColor.grayLight_,
        body: Column(
          children: [
            Expanded(
              child: SafeArea(
                child: Column(
                  children: [
                    _topProgressIndicator(),
                    _countDownExercise(),
                  ],
                ),
              ),
            ),
            _exerciseDetails(),
            const BannerAdClass(),
          ],
        ),
      ),
    );
  }

  _topProgressIndicator() {
    return SizedBox(
      height: AppSizes.height_1,
      child: ListView.builder(
        itemCount: _restController.exerciseList.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: AppSizes.height_1,
            width: AppSizes.fullWidth / _restController.exerciseList.length,
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    color: (_restController.currentPos + 1) > index
                        ? AppColor.primary
                        : AppColor.txtColor999,
                    thickness: AppSizes.height_0_7,
                  ),
                ),
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 2,
                  width: 2,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _countDownExercise() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.width_10),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                _restController.onAdd20SecondsClick();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.width_4_5,
                    vertical: AppSizes.height_0_8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: AppColor.primary),
                ),
                child: Text(
                  "+20" + "txtS".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: AppFontSize.size_11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            GetBuilder<RestController>(
              id: Constant.idRestCountDownTimer,
              builder: (logic) {
                return Expanded(
                  child: SizedBox(
                    width: AppSizes.height_19,
                    height: AppSizes.height_19,
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: logic.completedCount.toDouble(),
                          showLabels: false,
                          showTicks: false,
                          startAngle: 270,
                          endAngle: 270,
                          axisLineStyle: const AxisLineStyle(
                            thickness: 0.10,
                            color: AppColor.white,
                            thicknessUnit: GaugeSizeUnit.factor,
                          ),
                          pointers: <GaugePointer>[
                            RangePointer(
                              value: logic.progressCount.toDouble(),
                              width: 0.08,
                              sizeUnit: GaugeSizeUnit.factor,
                              color: AppColor.primary,
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
                                  Utils.secondToMMSSFormat(logic.timerCount),
                                  style: TextStyle(
                                    fontSize: AppFontSize.size_30,
                                    color: AppColor.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            InkWell(
              onTap: () {
                _restController.onRestTimeComplete();
              },
              child: AutoSizeText(
                "txtSkip".tr.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: AppFontSize.size_14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _exerciseDetails() {
    return InkWell(
      onTap: () {
        _restController.onNextExClick(_restController.currentPos + 1);
      },
      child: Container(
        color: AppColor.white,
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.width_5, vertical: AppSizes.height_1_2),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_restController.currentPos + 2} / ${_restController.exerciseList.length}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColor.txtColor666,
                      fontSize: AppFontSize.size_11_5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: AppSizes.height_1_2),
                    child: Text(
                      Utils.getMultiLanguageString(_restController
                          .exerciseList[_restController.currentPos + 1].exName!)
                          .toUpperCase(),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColor.black,
                        fontSize: AppFontSize.size_14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    (_restController
                                .exerciseList[_restController.currentPos + 1]
                                .exUnit ==
                            Constant.workoutTypeStep)
                        ? "X " +
                            _restController
                                .exerciseList[_restController.currentPos + 1]
                                .exTime
                                .toString()
                        : Utils.secToString(int.parse(_restController
                            .exerciseList[_restController.currentPos + 1]
                            .exTime!)),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: AppFontSize.size_12_5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _restController
                  .listOfAnimation[_restController.currentPos + 1],
              builder: (BuildContext context, Widget? child) {
                String frame = _restController
                    .listOfAnimation[_restController.currentPos + 1].value
                    .toString();
                return Image.asset(
                  'assets/${_restController.exerciseList[_restController.currentPos + 1].exPath}/$frame.webp',
                  gaplessPlayback: true,
                  height: AppSizes.height_12,
                  width: AppSizes.height_14,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
