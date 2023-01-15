import 'package:flutter/material.dart';
import 'package:women_lose_weight_flutter/common/dialog/progress_dialog/progress_dialog.dart';
import 'package:women_lose_weight_flutter/inapppurchase/in_app_purchase_helper.dart';
import 'package:women_lose_weight_flutter/ui/access_all_features/controllers/access_all_features_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:get/get.dart';
import '../../../utils/sizer_utils.dart';

class AccessAllFeaturesScreen extends StatelessWidget {
  const AccessAllFeaturesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AccessAllFeaturesController>(
          id: Constant.idAccessFeatureProgress,
          builder: (logic) {
            return ProgressDialog(
              inAsyncCall: logic.isShowProgress,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        _changeStartTodayImageWidget(),
                        _accessAllFeatureButtonWidget(),
                        SizedBox(height: AppSizes.height_4),
                        _functionalityWidget(),
                        _descriptionWidget(),
                      ],
                    ),
                  ),
                  _startButton(logic),
                ],
              ),
            );
          }),
    );
  }

  _changeStartTodayImageWidget() {
    return SizedBox(
      height: AppSizes.height_30,
      width: AppSizes.fullWidth,
      child: Stack(
        children: [
          Image.asset(
            Constant.getAssetImage() + "cover_subscription.webp",
            fit: BoxFit.cover,
            width: AppSizes.fullWidth,
          ),
          IconButton(
            onPressed: () {
              Get.back();
            },
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
                vertical: AppSizes.height_4, horizontal: AppSizes.width_5_5),
            icon: Icon(
              Icons.close,
              size: AppSizes.height_3,
              color: AppColor.white,
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.only(
                bottom: AppSizes.height_8,
                left: AppSizes.width_5,
                right: AppSizes.width_5),
            child: Text(
              "txtChangeStartsToday".tr.toUpperCase(),
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColor.white,
                fontSize: AppFontSize.size_18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.only(
                bottom: AppSizes.height_4,
                left: AppSizes.width_5,
                right: AppSizes.width_5),
            child: Text(
              "txtChangeStartsTodayDesc".tr,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColor.white,
                fontSize: AppFontSize.size_11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _accessAllFeatureButtonWidget() {
    return GetBuilder<AccessAllFeaturesController>(
      id: Constant.idAccessAllFeaturesButtons,
      builder: (logic) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                logic.onChangePlanSelection(Constant.boolValueTrue);
              },
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: AppSizes.width_5, vertical: AppSizes.height_2),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: AppSizes.height_1_8),
                      width: AppSizes.fullWidth,
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                            color: (logic.isSelected)
                                ? AppColor.primary
                                : AppColor.txtColor999),
                      ),
                      child: Column(
                        children: [
                          Text(
                            "txtAccessAllFeatures".tr,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: logic.isSelected
                                  ? AppColor.primary
                                  : AppColor.txtColor999,
                              fontSize: AppFontSize.size_14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: AppSizes.height_0_5),
                          Text(
                            (InAppPurchaseHelper()
                                        .getProductDetail(InAppPurchaseHelper
                                            .monthlySubscriptionId)
                                        ?.price !=
                                    null)
                                ? InAppPurchaseHelper()
                                        .getProductDetail(InAppPurchaseHelper
                                            .monthlySubscriptionId)!
                                        .price +
                                    "/" +
                                    "txtMonth".tr
                                : (430.00).toStringAsFixed(2) +
                                    "/" +
                                    "txtMonth".tr,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: logic.isSelected
                                  ? AppColor.primary
                                  : AppColor.txtColor999,
                              fontSize: AppFontSize.size_11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (logic.isSelected) ...{
                      Container(
                        height: AppSizes.height_4,
                        width: AppSizes.height_4,
                        margin: EdgeInsets.only(right: AppSizes.width_5),
                        decoration: const BoxDecoration(
                          color: AppColor.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.done_rounded,
                            color: AppColor.white),
                      ),
                    },
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                logic.onChangePlanSelection(Constant.boolValueFalse);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: AppSizes.width_5),
                child: IntrinsicHeight(
                  child: Stack(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: AppSizes.height_1_8),
                        margin: EdgeInsets.only(top: AppSizes.height_3),
                        width: AppSizes.fullWidth,
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                              color: (!logic.isSelected)
                                  ? AppColor.primary
                                  : AppColor.txtColor999),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "txtAccessAllFeatures".tr,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: !logic.isSelected
                                    ? AppColor.primary
                                    : AppColor.txtColor999,
                                fontSize: AppFontSize.size_14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: AppSizes.height_0_5),
                            Text(
                              (InAppPurchaseHelper()
                                          .getProductDetail(InAppPurchaseHelper
                                              .yearlySubscriptionId)
                                          ?.price !=
                                      null)
                                  ? InAppPurchaseHelper()
                                          .getProductDetail(InAppPurchaseHelper
                                              .yearlySubscriptionId)!
                                          .price +
                                      "/" +
                                      "txtYear".tr
                                  : (1700.00).toStringAsFixed(2) +
                                      "/" +
                                      "txtYear".tr,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: !logic.isSelected
                                    ? AppColor.primary
                                    : AppColor.txtColor999,
                                fontSize: AppFontSize.size_11,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.width_2,
                              vertical: AppSizes.height_0_5),
                          margin: EdgeInsets.only(
                              right: AppSizes.width_10, top: AppSizes.height_1),
                          decoration: BoxDecoration(
                            color: AppColor.bgBlue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "txtSave".tr + " 67%",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: AppFontSize.size_11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      if (!logic.isSelected) ...{
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: AppSizes.height_4,
                            width: AppSizes.height_4,
                            margin: EdgeInsets.only(
                                right: AppSizes.width_5,
                                top: AppSizes.height_3),
                            decoration: const BoxDecoration(
                              color: AppColor.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.done_rounded,
                                color: AppColor.white),
                          ),
                        ),
                      },
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _functionalityWidget() {
    return Container(
      margin: EdgeInsets.only(left: AppSizes.width_18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                Constant.getAssetIcons() + "ic_noads.webp",
                height: AppSizes.height_2_5,
                width: AppSizes.height_2_5,
              ),
              SizedBox(width: AppSizes.width_2),
              Text(
                "txtRemoveAds".tr,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColor.txtColor666,
                  fontSize: AppFontSize.size_12_5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: AppSizes.height_2_2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  Constant.getAssetIcons() + "icon_fast.webp",
                  height: AppSizes.height_2_5,
                  width: AppSizes.height_2_5,
                ),
                SizedBox(width: AppSizes.width_2),
                Text(
                  "txt100Workouts".tr,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColor.txtColor666,
                    fontSize: AppFontSize.size_12_5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                Constant.getAssetIcons() + "ic_feature.webp",
                height: AppSizes.height_2_5,
                width: AppSizes.height_2_5,
              ),
              SizedBox(width: AppSizes.width_2),
              Text(
                "txtUnlimited".tr,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColor.txtColor666,
                  fontSize: AppFontSize.size_12_5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _descriptionWidget() {
    return Container(
      margin:
          EdgeInsets.only(top: AppSizes.height_2_5, bottom: AppSizes.height_10),
      padding: EdgeInsets.symmetric(horizontal: AppSizes.width_5),
      child: Text(
        "txtIAPDetail".tr,
        textAlign: TextAlign.left,
        style: TextStyle(
          color: AppColor.txtColor999,
          fontSize: AppFontSize.size_11,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  _startButton(AccessAllFeaturesController logic) {
    return SafeArea(
      child: Container(
        width: AppSizes.fullWidth,
        margin: EdgeInsets.only(
            top: AppSizes.height_4,
            bottom: AppSizes.height_1_8,
            right: AppSizes.width_5,
            left: AppSizes.width_5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColor.primary,
              AppColor.primary,
            ],
          ),
        ),
        child: TextButton(
          onPressed: () {
            logic.onPurchaseClick();
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
              "txtStart".tr.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColor.white,
                fontSize: AppFontSize.size_14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
