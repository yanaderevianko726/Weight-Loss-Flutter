import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:women_workout/util/constants.dart';

import '../../util/color_category.dart';
import '../../util/constant_widget.dart';
import '../iapurchase/IAPCallback.dart';
import '../iapurchase/InAppPurchaseHelper.dart';
import '../iapurchase/prefrence.dart';
import '../util/widgets.dart';
import 'controller/in_app_controller.dart';
import 'controller/subscription_controller.dart';

class InAppPurchase extends StatefulWidget {
  const InAppPurchase({Key? key}) : super(key: key);

  @override
  State<InAppPurchase> createState() => _InAppPurchaseState();
}

class _InAppPurchaseState extends State<InAppPurchase> implements IAPCallback {
  SubscriptionController subscriptionController =
      Get.put(SubscriptionController());

  Future<bool> _requestPop() {
    Get.back();

    return new Future.value(false);
  }

  @override
  void initState() {
    InAppPurchaseHelper().initialize();
    InAppPurchaseHelper().getAlreadyPurchaseItems(this);
    purchases = InAppPurchaseHelper().getPurchases();
    InAppPurchaseHelper().clearTransactions();
    subscriptionController.refreshProValue();
    super.initState();
  }

  Map<String, PurchaseDetails>? purchases;

  InAppController controller = Get.put(InAppController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: bgDarkWhite,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 228.h,
                    color: lightOrange,
                    child: Stack(
                      children: [
                        Align(
                          child: getAssetImage("plan_1.png",
                                  height: 175.h, width: 145.h)
                              .marginOnly(right: 40.h),
                          alignment: Alignment.bottomRight,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 88.h, left: 20.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              getCustomText(
                                  "Lose Weight Naturally",
                                  Colors.black,
                                  1,
                                  TextAlign.start,
                                  FontWeight.w700,
                                  22.sp),
                              ConstantWidget.getVerSpace(10.h),
                              getCustomText(
                                  "Easy and effective",
                                  Colors.black,
                                  1,
                                  TextAlign.start,
                                  FontWeight.w400,
                                  15.sp)
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                                onTap: () {
                                  _requestPop();
                                },
                                child: getSvgImage("close.svg",
                                        width: 24.h, height: 24.h)
                                    .paddingOnly(top: 20.h, right: 20.h)))
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ConstantWidget.getVerSpace(20.h),
                      // GestureDetector(
                      //   onTap: () {
                      //     _requestPop();
                      //   },
                      //   child: getSvgImage("arrow_left.svg",
                      //           width: 24.h, height: 24.h, color: Colors.white)
                      //       .paddingSymmetric(horizontal: 20.h),
                      // ),
                      // ConstantWidget.getVerSpace(50.h),
                      // ConstantWidget.getMultilineCustomFont(
                      //         "CHANGE STARTS TODAY!", 23.sp, Colors.white,
                      //         textAlign: TextAlign.start,
                      //         fontWeight: FontWeight.w700)
                      //     .paddingSymmetric(horizontal: 20.h),
                      // ConstantWidget.getVerSpace(10.h),
                      // ConstantWidget.getMultilineCustomFont(
                      //         "Result not typical Disclaimer",
                      //         16.sp,
                      //         Colors.white70,
                      //         textAlign: TextAlign.start,
                      //         fontWeight: FontWeight.w400)
                      //     .paddingSymmetric(horizontal: 20.h),
                      // ConstantWidget.getVerSpace(15.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ConstantWidget.getVerSpace(30.h),
                          GestureDetector(
                            onTap: () {
                              controller.onChange(0);
                            },
                            child: GetBuilder<InAppController>(
                              init: InAppController(),
                              builder: (controller) => Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.h, horizontal: 20.h),
                                decoration: BoxDecoration(
                                    color: controller.index.value == 0
                                        ? orangeLight
                                        : cellColor,
                                    borderRadius: BorderRadius.circular(22.h),
                                    border: Border.all(
                                        color: controller.index.value == 0
                                            ? accentColor
                                            : dividerColor,
                                        width: 1.h)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ConstantWidget.getCustomText(
                                            "Price",
                                            controller.index.value == 0
                                                ? accentColor
                                                : descriptionColor,
                                            1,
                                            TextAlign.center,
                                            FontWeight.w600,
                                            16.sp),
                                        ConstantWidget.getVerSpace(5.h),
                                        ConstantWidget.getCustomText(
                                            "Rs.2000/- 30 Diet plan",
                                            controller.index.value == 0
                                                ? accentColor
                                                : descriptionColor,
                                            1,
                                            TextAlign.center,
                                            FontWeight.w400,
                                            14.sp)
                                      ],
                                    ),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: controller.index.value == 0
                                            ? getSvgImage("check.svg",
                                                width: 24.h, height: 24.h)
                                            : null)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ConstantWidget.getVerSpace(20.h),
                          // GestureDetector(
                          //   onTap: () {
                          //     controller.onChange(1);
                          //   },
                          //   child: GetBuilder<InAppController>(
                          //     init: InAppController(),
                          //     builder: (controller) => Container(
                          //       padding: EdgeInsets.symmetric(
                          //           vertical: 12.h, horizontal: 20.h),
                          //       decoration: BoxDecoration(
                          //           color: controller.index.value == 1
                          //               ? orangeLight
                          //               : cellColor,
                          //           borderRadius: BorderRadius.circular(22.h),
                          //           border: Border.all(
                          //               color: controller.index.value == 1
                          //                   ? accentColor
                          //                   : dividerColor,
                          //               width: 1.h)),
                          //       child: Row(
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Column(
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.start,
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.center,
                          //             children: [
                          //               ConstantWidget.getCustomText(
                          //                   "Yearly Plan",
                          //                   controller.index.value == 1
                          //                       ? accentColor
                          //                       : descriptionColor,
                          //                   1,
                          //                   TextAlign.center,
                          //                   FontWeight.w600,
                          //                   16.sp),
                          //               ConstantWidget.getVerSpace(5.h),
                          //               ConstantWidget.getCustomText(
                          //                   "\Rs 99.9 / Yearly",
                          //                   controller.index.value == 1
                          //                       ? accentColor
                          //                       : descriptionColor,
                          //                   1,
                          //                   TextAlign.center,
                          //                   FontWeight.w400,
                          //                   14.sp)
                          //             ],
                          //           ),
                          //           Align(
                          //               alignment: Alignment.centerRight,
                          //               child: controller.index.value == 1
                          //                   ? getSvgImage("check.svg",
                          //                       width: 24.h, height: 24.h)
                          //                   : null)
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          ConstantWidget.getVerSpace(20.h),
                          Container(
                            padding: EdgeInsets.all(20.h),
                            decoration: BoxDecoration(
                                color: cellColor,
                                borderRadius: BorderRadius.circular(22.h)),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    children: [
                                      getSvgImage("plan.svg",
                                          height: 24.h, width: 24.h),
                                      ConstantWidget.getHorSpace(12.h),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: getCustomText(
                                              "Please contact our support to get started. email at dietplans@nutriblow.com",
                                              Colors.black,
                                              2,
                                              TextAlign.start,
                                              FontWeight.w400,
                                              15.sp),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                // Row(
                                //   children: [
                                //     getSvgImage("plan.svg",
                                //         height: 24.h, width: 24.h),
                                //     ConstantWidget.getHorSpace(10.h),
                                //     getCustomText(
                                //         "30 Days Customized Diet plan",
                                //         Colors.black,
                                //         1,
                                //         TextAlign.start,
                                //         FontWeight.w400,
                                //         15.sp)
                                //   ],
                                // ),
                                // ConstantWidget.getVerSpace(18.h),
                                // Row(
                                //   children: [
                                //     getAssetImage("fire.png",
                                //         height: 24.h, width: 24.h),
                                //     ConstantWidget.getHorSpace(10.h),
                                //     getCustomText(
                                //         "30 days Workout plan",
                                //         Colors.black,
                                //         1,
                                //         TextAlign.start,
                                //         FontWeight.w400,
                                //         15.sp)
                                //   ],
                                // ),
                                // ConstantWidget.getVerSpace(18.h),
                                // Row(
                                //   children: [
                                //     getAssetImage("remove_ads.png",
                                //         height: 24.h, width: 24.h),
                                //     ConstantWidget.getHorSpace(10.h),
                                //     getCustomText(
                                //         "Removes Ads",
                                //         Colors.black,
                                //         1,
                                //         TextAlign.start,
                                //         FontWeight.w400,
                                //         14.sp)
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                          ConstantWidget.getVerSpace(20.h),
                          // ConstantWidget.getMultilineCustomFont(
                          //     "30 days Diet and workout plan will be made by our expert Dietitian as per your need of weight management.",
                          //     15.sp,
                          //     descriptionColor,
                          //     fontWeight: FontWeight.w400,
                          //     txtHeight: 1.5)
                        ],
                      ).paddingSymmetric(horizontal: 20.h),
                    ],
                  ),
                ],
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: getButton(context, accentColor, "START", Colors.white,
              //           () {
              //     // if (controller.index.value == 0) {
              //     //   onPurchaseClick(InAppPurchaseHelper().getProductIds()[0]);
              //     // } else {
              //     //   onPurchaseClick(InAppPurchaseHelper().getProductIds()[1]);
              //     // }
              //   }, 16.sp,
              //           weight: FontWeight.w700,
              //           borderRadius: BorderRadius.circular(22.h),
              //           buttonHeight: 60.h)
              //       .marginOnly(left: 20.h, right: 20.h, bottom: 20.h),
              // )
            ],
          ),
        ),
      ),
    );
  }

  launchURL() async {
    String email = Uri.encodeComponent("support@nutriblow.com");
    String subject = Uri.encodeComponent("Hello");
    String body = Uri.encodeComponent("Hi! I'm Nutri Blow user");
    print(subject); //output: Hello%20Flutter
    Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
    if (await launchUrl(mail)) {
        Get.back();
    }
  }

  void onPurchaseClick(String id) async {
    ProductDetails? product = InAppPurchaseHelper().getProductDetail(id);
    print("getproduct==$id=$product");
    if (product != null) {
      InAppPurchaseHelper().buySubscription(product, purchases!);
    } else {
      Constants.showToast("Item not available");
    }
  }

  @override
  void onBillingError(error) {
  }

  @override
  void onLoaded(bool initialized) {
  }

  @override
  void onPending(PurchaseDetails product) {
  }

  @override
  void onPrefValChange() {
  }

  @override
  void onSuccessPurchase(PurchaseDetails product) {

    print("success == true");

    Preferences.preferences.saveBool(key: PrefernceKey.isProUser, value: true);
    subscriptionController.isuseralreadysunscription.value = true;

    Navigator.pop(context, true);
  }
}
