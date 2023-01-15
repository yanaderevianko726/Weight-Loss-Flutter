import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/routes/app_routes.dart';
import 'package:women_lose_weight_flutter/ui/home/controllers/home_controller.dart';
import 'package:women_lose_weight_flutter/ui/me/controllers/me_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/preference.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../utils/utils.dart';

class TurnOnWaterScreen extends StatelessWidget {
  TurnOnWaterScreen({Key? key}) : super(key: key);
  final MeController _meController = Get.find<MeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        top: Constant.boolValueFalse,
        child: Stack(
          children: [
            Image.asset(Constant.getAssetImage() + "img_drink_bg.webp"),
            Column(
              children: [
                _widgetBack(),
                _textDrinkingWater(),
                _buttonTurnOnWaterTracker(),
              ],
            ),
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
          top: AppSizes.height_5),
      child: InkWell(
        onTap: () {
          Get.back();
        },
        child: Utils.backWidget(iconColor: AppColor.txtColor999),
      ),
    );
  }

  _textDrinkingWater() {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        width: AppSizes.fullWidth,
        margin: EdgeInsets.only(top: AppSizes.height_20),
        padding: EdgeInsets.symmetric(horizontal: AppSizes.width_8),
        child: Text(
          "txtDrinkingWaterHelpsImproveFatBurningRate".tr,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: AppColor.commonBlueColor,
            fontSize: AppFontSize.size_22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  _buttonTurnOnWaterTracker() {
    return GetBuilder<HomeController>(id: Constant.idCurrentWaterGlass,builder: (logic) {
      return Container(
        width: AppSizes.fullWidth,
        margin: EdgeInsets.only(
            left: AppSizes.width_14,
            right: AppSizes.width_14,
            bottom: AppSizes.height_3),
        child: TextButton(
          onPressed: () {
            Preference.shared.setBool(
                Preference.turnOnWaterTracker, Constant.boolValueTrue);
            _meController.onTurnOnWaterTrackerToggleSwitchChange(Constant.boolValueTrue);
            Get.back();
            Get.toNamed(AppRoutes.waterTracker, arguments: [logic.currentGlass]);
            Future.delayed(const Duration(milliseconds: 300), () {
              logic.currentWaterGlass();
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                AppColor.buttonColorBlue),
            elevation: MaterialStateProperty.all(2),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100.0),
                side: const BorderSide(
                  color: AppColor.transparent,
                  width: 0.7,
                ),
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.height_1, horizontal: AppSizes.width_6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: AppSizes.height_3_3,
                  width: AppSizes.height_3_3,
                  child: Image.asset(
                    Constant.getAssetIcons() + "ic_set_water.webp",
                    color: AppColor.white,
                  ),
                ),
                Expanded(
                  child: AutoSizeText(
                    "txtTurnOnWaterTracker".tr,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: AppFontSize.size_14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
