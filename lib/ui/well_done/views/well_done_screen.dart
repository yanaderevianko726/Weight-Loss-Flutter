import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/google_ads/custom_ad.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

class WellDoneScreen extends StatelessWidget {
  const WellDoneScreen({Key? key}) : super(key: key);

  // final WellDoneController _wellDoneController = Get.find<WellDoneController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Spacer(),
                  _iconWellDone(),
                  _textWellDone(),
                  _textWaterIsNecessary(),
                  const Spacer(),
                  _buttonDone(),
                ],
              ),
            ),
            const BannerAdClass(),
          ],
        ),
      ),
    );
  }

  _iconWellDone() {
    return Image.asset(
      Constant.getAssetIcons() + "ic_well_done.webp",
      height: AppSizes.height_21,
    );
  }

  _textWellDone() {
    return Container(
      width: AppSizes.fullWidth,
      margin: EdgeInsets.only(top: AppSizes.height_4),
      padding: EdgeInsets.symmetric(horizontal: AppSizes.width_6),
      child: Text(
        "txtWellDone".tr,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColor.black,
          fontSize: AppFontSize.size_17,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _textWaterIsNecessary() {
    return Container(
      width: AppSizes.fullWidth,
      margin: EdgeInsets.only(top: AppSizes.height_2_5),
      padding: EdgeInsets.symmetric(horizontal: AppSizes.width_6),
      child: Text(
        "txtWaterIsNecessary".tr,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColor.txtColor666,
          fontSize: AppFontSize.size_13,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  _buttonDone() {
    return Container(
      width: AppSizes.fullWidth,
      margin: EdgeInsets.only(
          left: AppSizes.width_14,
          right: AppSizes.width_14,
          bottom: AppSizes.height_2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColor.greenGradualStartColor,
            AppColor.greenGradualEndColor,
          ],
        ),
      ),
      child: TextButton(
        onPressed: () {
          Get.back();
        },
        style: ButtonStyle(
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
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSizes.height_1),
          child: Text(
            "txtDone".tr.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.white,
              fontSize: AppFontSize.size_14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
