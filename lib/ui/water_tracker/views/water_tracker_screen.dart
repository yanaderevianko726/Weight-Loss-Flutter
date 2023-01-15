import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/google_ads/custom_ad.dart';
import 'package:women_lose_weight_flutter/ui/home/controllers/home_controller.dart';
import 'package:women_lose_weight_flutter/ui/water_tracker/controllers/water_tracker_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

import '../../../custom/wave/config.dart';
import '../../../custom/wave/wave_widget.dart';
import '../../../utils/utils.dart';

class WaterTrackerScreen extends StatelessWidget {
  const WaterTrackerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        bottom: Constant.boolValueFalse,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _widgetWave(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _widgetBack(),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _imageDrinkProgressNormal(),
                            _widgetPercentageDrinkWater(),
                            _text3By8Cups(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const BannerAdClass(),
          ],
        ),
      ),
    );
  }

  _widgetWave() {
    return GetBuilder<WaterTrackerController>(
        id: Constant.idWaterTrackerAnim,
        builder: (logic) {
          return WaveWidget(
            config: CustomConfig(
              gradients: [
                [AppColor.mwhStartColor20, AppColor.mwhCloseColor20],
                [AppColor.mwhStartColor50, AppColor.mwhCloseColor50],
                [AppColor.mwhStartColor80, AppColor.mwhCloseColor80],
                [AppColor.mwhStartColor, AppColor.mwhCloseColor],
              ],
              durations: [35000, 19440, 10800, 6000],
              heightPercentages: [0.22, 0.23, 0.25, 0.26],
              gradientBegin: Alignment.bottomLeft,
              gradientEnd: Alignment.topRight,
            ),
            waveAmplitude: 5,
            heightPercentage: 0.1,
            viewCenter: logic.viewCenter!,
            size: Size(
              AppSizes.fullWidth,
              AppSizes.fullHeight,
              //AppSizes.fullHeight,
            ),
          );
        });
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
            child: Utils.backWidget(iconColor: AppColor.txtColor999),
          ),
          Expanded(
            child: Text(
              "\t\t\t" + "txtWaterTracker".tr,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColor.black,
                fontSize: AppFontSize.size_14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _imageDrinkProgressNormal() {
    return Image.asset(
      Constant.getAssetImage() + "wt_drink_progress_icon_normal.webp",
      height: AppSizes.height_3_5,
    );
  }

  _widgetPercentageDrinkWater() {
    return GetBuilder<WaterTrackerController>(
        id: Constant.idWaterTrackerPercent,
        builder: (logic) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: AppSizes.height_2),
            child: Text(
              logic.percentCounter!.toString() + "%",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColor.txtColorBlue,
                fontSize: AppFontSize.size_21,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        });
  }

  _text3By8Cups() {
    return GetBuilder<HomeController>(
        id: Constant.idCurrentWaterGlass,
        builder: (logic) {
          return Text(
            logic.currentGlass.toString() + "txt3By8Cups".tr,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: AppColor.txtColorBlue,
              fontSize: AppFontSize.size_13,
              fontWeight: FontWeight.w400,
            ),
          );
        });
  }
}
