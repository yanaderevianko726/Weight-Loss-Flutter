// ignore_for_file: unused_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import '../../util/widgets.dart';
import 'package:get/get.dart';

import '../ads/ads_file.dart';
import '../generated/l10n.dart';
import '../iapurchase/prefrence.dart';
import '../routes/app_routes.dart';
import '../view/controller/controller.dart';
import '../view/in_app_purchase.dart';
import 'color_category.dart';
import 'constant_url.dart';
import 'constants.dart';
import '../view/home/home_widget.dart';
import 'country_code_picker.dart';

initializeScreenSize(BuildContext context,
    {double width = 414, double height = 896}) {
  ScreenUtil.init(context, designSize: Size(width, height), minTextAdapt: true);
}

getNoData(BuildContext context) {
  return Container(
      // color: mainBgColor,
      margin: EdgeInsets.symmetric(
          vertical: ConstantWidget.getScreenPercentSize(context, 5)),
      child: Center(
        child: Text(
          'No Data Found',
          style: TextStyle(
              color: Colors.black87,
              fontFamily: Constants.fontsFamily,
              fontWeight: FontWeight.bold),
        ),
      ));
}

getNoInternet(BuildContext context) {
  return Container(
      color: bgDarkWhite,
      child: Center(
        child: Text(
          S.of(context).noInternetConnection,
          style: TextStyle(
              color: Colors.black87,
              fontFamily: Constants.fontsFamily,
              fontWeight: FontWeight.bold),
        ),
      ));
}

void showCustomToast(String texts, BuildContext context) {
  Fluttertoast.showToast(
      msg: texts,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
  // Toast.show(texts, context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
}

Widget getSvgImage(String image,
    {double? width,
    double? height,
    Color? color,
    BoxFit boxFit = BoxFit.contain}) {
  return SvgPicture.asset(
    Constants.assetsImagePath + image,
    color: color,
    width: width,
    height: height,
    fit: boxFit,
    matchTextDirection: true,
  );
}

BoxDecoration getButtonDecoration(Color bgColor,
    {BorderRadius? borderRadius,
    Border? border,
    List<BoxShadow> shadow = const [],
    DecorationImage? image}) {
  return BoxDecoration(
      color: bgColor,
      borderRadius: borderRadius,
      border: border,
      boxShadow: shadow,
      image: image);
}

checkInApp(
    {required BuildContext context,
    required Function function,
    required AdsFile adsFile}) async {
  bool isPurchase = await Preferences.preferences
      .getBool(key: PrefernceKey.isProUser, defValue: false);

  print("isPurchase===$isPurchase");

  if (isPurchase) {
    function();
  } else {
    showInAppDialog(
      context,
      () {
        showRewardedAd(adsFile, () {
          function();
        }, function1: () {
          Constants.showToast("Video not loaded, Please try again");
        });
      },
    );
  }
}

getProWidget(
    {required String isActive,
    required BuildContext context,
    double? horSpace,
    double? verSpace,
    Alignment? alignment}) {
  return
      // (isActive == "1")
      //   ? FutureBuilder<bool>(
      //       future: Preferences.preferences
      //           .getBool(key: PrefernceKey.isProUser, defValue: false),
      //       builder: (context, snapshot) {
      //         if (snapshot.data != null && !snapshot.data!) {
      //           return Align(
      //             alignment: alignment == null ? Alignment.bottomLeft : alignment,
      //             child: Container(
      //               decoration: BoxDecoration(
      //                 color: Colors.white,
      //                 borderRadius: BorderRadius.all(Radius.circular(20)),
      //                 boxShadow: [
      //                   BoxShadow(
      //                       color: containerShadow,
      //                       blurRadius: 32,
      //                       offset: Offset(-2, 5)),
      //                 ],
      //               ),
      //               padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      //               child: Row(
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: [
      //                   Image.asset(
      //                     Constants.assetsImagePath + "crown_1.png",
      //                     height: 20.h,
      //                   ),
      //                   ConstantWidget.getHorSpace(8.w),
      //                   getCustomText("Pro", textColor, 1, TextAlign.start,
      //                       FontWeight.w500, 16.sp),
      //                 ],
      //               ),
      //             ),
      //           ).marginSymmetric(
      //               horizontal: horSpace == null ? 10.w : horSpace,
      //               vertical: verSpace == null ? 25.h : verSpace);
      //         } else {
      //           return Container(
      //             height: 0,
      //             width: 0,
      //           );
      //         }
      //       },
      //     )
      //   :
      Container(
    height: 0,
    width: 0,
  );
}

getHomeProWidget(
    {required BuildContext context,
    double? horSpace,
    double? verSpace,
    double? size}) {
  // return FutureBuilder<bool>(
  //   future: Preferences.preferences
  //       .getBool(key: PrefernceKey.isProUser, defValue: false),
  //   builder: (context, snapshot) {
  //     if (snapshot.data != null && !snapshot.data!) {
  //       return Align(
  //         alignment: Alignment.topLeft,
  //         child: Image.asset(
  //           Constants.assetsImagePath + "crown.png",
  //           height: size == null ? 20.h : size,
  //         ),
  //       ).marginSymmetric(
  //           horizontal: horSpace == null ? 10.w : horSpace,
  //           vertical: verSpace == null ? 25.h : verSpace);
  //     } else {
  //       return Container(
  //         height: 0,
  //         width: 0,
  //       );
  //     }
  //   },
  // );

  return Container();
}

checkIsProPlan(
    {required BuildContext context,
    required String isActive,
    required Function function,
    required AdsFile adsFile}) async {
  print("isPro====$isActive");

  // if (isActive == "1") {
  //   checkInApp(
  //       context: context,
  //       function: () {
  //         function();
  //       },
  //       adsFile: adsFile);
  // } else {
  function();
  // }
}

showInAppDialog(BuildContext context, Function function) {
  showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          decoration: getDecorationWithSide(
              radius: 22.h,
              bgColor: bgDarkWhite,
              isTopLeft: true,
              isBottomLeft: true,
              isBottomRight: true,
              isTopRight: true),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      getSvgImage("lock1.svg", height: 52.h, width: 52.h),
                      ConstantWidget.getVerSpace(20.h),
                      getCustomText("Watch Video to Unlock", textColor, 1,
                          TextAlign.center, FontWeight.w700, 22.sp),
                      ConstantWidget.getVerSpace(10.h),
                      ConstantWidget.getMultilineCustomFont(
                          "Watch the video to use training plan once",
                          17.sp,
                          textColor,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center),
                      ConstantWidget.getVerSpace(22.h),
                      GestureDetector(
                        onTap: () {
                          function();
                          Get.back();
                        },
                        child: Container(
                          height: 60.h,
                          decoration: BoxDecoration(
                              color: accentColor,
                              borderRadius: BorderRadius.circular(22.h)),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getSvgImage("video_play.svg",
                                  height: 24.h, width: 24.h),
                              ConstantWidget.getHorSpace(10.h),
                              getCustomText("Unlock Once", Colors.white, 1,
                                  TextAlign.center, FontWeight.w600, 17.sp)
                            ],
                          ),
                        ),
                      ),
                      ConstantWidget.getVerSpace(20.h),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          setStatusBarColor(accentColor);
                          Get.to(InAppPurchase());
                        },
                        child: Container(
                          height: 60.h,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              // color: "#4B4E55".toColor(),
                              border: Border.all(color: accentColor, width: 1),
                              borderRadius: BorderRadius.circular(22.h)),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getCustomText("Free 7 Days Trial", Colors.black,
                                  1, TextAlign.center, FontWeight.w600, 18.sp)
                            ],
                          ),
                        ),
                      ),
                      ConstantWidget.getVerSpace(19.h),
                      ConstantWidget.getMultilineCustomFont(
                          "Free 7 days trial, then \$3500.00/year,Cancle anytime during the trial.",
                          15.sp,
                          descriptionColor,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.center,
                          txtHeight: 1.5),
                    ],
                  ).marginSymmetric(horizontal: 20.h),
                  Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: getSvgImage("close.svg",
                              height: 24.h, width: 24.h)))
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
  // showGeneralDialog(
  //   context: context,
  //   barrierColor: Colors.transparent,
  //   barrierLabel: 'Label',
  //   barrierDismissible: true,
  //
  //   pageBuilder: (i, _, ___) => Container(
  //
  //     decoration: getDecorationWithSide(
  //         radius: 22.h,
  //         bgColor: bgDarkWhite,
  //         isTopLeft: true,
  //         isTopRight: true),
  //     child: Stack(
  //       children: [
  //         Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             getAssetImage("lock_purchase.png",
  //                 width: 24.h, height: 24.h, color: Colors.white),
  //             ConstantWidget.getVerSpace(15.h),
  //             getCustomText("WATCH VIDEO TO UNLOCK", Colors.white, 1,
  //                 TextAlign.center, FontWeight.w700, 20.sp),
  //             ConstantWidget.getVerSpace(15.h),
  //             ConstantWidget.getMultilineCustomFont(
  //                 "Watch the video to use training plan once",
  //                 17.sp,
  //                 Colors.white60,
  //                 fontWeight: FontWeight.w500,
  //                 textAlign: TextAlign.center),
  //             ConstantWidget.getVerSpace(15.h),
  //             GestureDetector(
  //               onTap: () {
  //                 function();
  //                 Get.back();
  //               },
  //               child: Container(
  //                 height: 60.h,
  //                 decoration: BoxDecoration(
  //                     color: accentColor,
  //                     borderRadius: BorderRadius.circular(12.h)),
  //                 alignment: Alignment.center,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     getSvgImage("video_play.svg", height: 20.h, width: 20.h),
  //                     ConstantWidget.getHorSpace(20.h),
  //                     getCustomText("UNLOCK ONCE", Colors.white, 1,
  //                         TextAlign.center, FontWeight.w600, 17.sp)
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             ConstantWidget.getVerSpace(15.h),
  //             GestureDetector(
  //               onTap: () {
  //                 Get.back();
  //                 Get.to(InAppPurchase());
  //               },
  //               child: Container(
  //                 height: 60.h,
  //                 decoration: BoxDecoration(
  //                     color: "#4B4E55".toColor(),
  //                     borderRadius: BorderRadius.circular(12.h)),
  //                 alignment: Alignment.center,
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     getCustomText("FREE 7 DAYS TRIAL", Colors.white, 1,
  //                         TextAlign.center, FontWeight.w600, 17.sp)
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             ConstantWidget.getVerSpace(15.h),
  //             ConstantWidget.getMultilineCustomFont(
  //                 "Free 7 Days Trial,then \$3500.00/year.", 14.sp, Colors.white60,
  //                 fontWeight: FontWeight.w500, textAlign: TextAlign.center),
  //             ConstantWidget.getVerSpace(5.h),
  //             ConstantWidget.getMultilineCustomFont(
  //                 "Cancel anytime during the trial.", 14.sp, Colors.white60,
  //                 fontWeight: FontWeight.w500, textAlign: TextAlign.center),
  //           ],
  //         ).marginSymmetric(horizontal: 20.h),
  //         GestureDetector(
  //             onTap: () {
  //               Get.back();
  //             },
  //             child: getSvgImage("arrow_left.svg", color: Colors.white)
  //                 .marginOnly(top: 50.h, left: 20.h))
  //       ],
  //     ),
  //   ),
  // );
}

Widget getButton(BuildContext context, Color bgColor, String text,
    Color textColor, Function function, double fontsize,
    {bool isBorder = false,
    EdgeInsetsGeometry? insetsGeometry,
    borderColor = Colors.transparent,
    FontWeight weight = FontWeight.bold,
    bool isIcon = false,
    String? image,
    Color? imageColor,
    double? imageWidth,
    double? imageHeight,
    bool smallFont = false,
    double? buttonHeight,
    double? buttonWidth,
    List<BoxShadow> boxShadow = const [],
    EdgeInsetsGeometry? insetsGeometrypadding,
    BorderRadius? borderRadius,
    double? borderWidth}) {
  return InkWell(
    onTap: () {
      function();
    },
    child: Container(
      margin: insetsGeometry,
      padding: insetsGeometrypadding,
      width: buttonWidth,
      height: buttonHeight,
      decoration: getButtonDecoration(
        bgColor,
        borderRadius: borderRadius,
        shadow: boxShadow,
        border: (isBorder)
            ? Border.all(color: borderColor, width: borderWidth!)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          (isIcon) ? getSvgImage(image!) : ConstantWidget.getHorSpace(0),
          (isIcon)
              ? ConstantWidget.getHorSpace(15.h)
              : ConstantWidget.getHorSpace(0),
          getCustomText(text, textColor, 1, TextAlign.center, weight, fontsize)
        ],
      ),
    ),
  );
}

Widget getAssetImage(String image,
    {double? width,
    double? height,
    Color? color,
    BoxFit boxFit = BoxFit.contain}) {
  return Image.asset(
    Constants.assetsImagePath + image,
    color: color,
    width: width,
    height: height,
    fit: boxFit,
    matchTextDirection: true,
  );
}

Widget gettoolbarMenu(BuildContext context, String image, Function function,
    {bool istext = false,
    double? fontsize,
    String? title,
    Color? textColor,
    FontWeight? weight,
    String fontFamily = Constants.fontsFamily,
    bool isrightimage = false,
    String? rightimage,
    Function? rightFunction,
    bool isleftimage = true}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      (isleftimage)
          ? InkWell(
              onTap: () {
                function();
              },
              child: getSvgImage(image, height: 24.h, width: 24.h))
          : Container(),
      ConstantWidget.getHorSpace(18.h),
      Expanded(
        child: Container(
          child: (istext)
              ? ConstantWidget.getTextWidget(
                  title!, textColor!, TextAlign.start, weight!, fontsize!)
              : null,
        ),
      ),
      (isrightimage)
          ? InkWell(
              onTap: () {
                rightFunction!();
              },
              child: getSvgImage(rightimage!, height: 24.h, width: 24.h))
          : Container(),
    ],
  );
}

Widget getSearchWidget(
    BuildContext context,
    TextEditingController searchController,
    Function filterClick,
    ValueChanged<String> onChanged,
    {bool withPrefix = true}) {
  double height = 56.h;

  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        width: double.infinity,
        height: height,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: borderColor, width: 1.h),
            borderRadius: BorderRadius.circular(22.h)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 13.h, left: 16.h),
              child: getSvgImage("search.svg", height: 24.h, width: 24.h),
            ),
            Expanded(
              flex: 1,
              child: TextField(
                enabled: true,
                onTap: () {
                  filterClick();
                },
                autofocus: false,
                onChanged: onChanged,
                textInputAction: TextInputAction.search,
                controller: searchController,
                decoration: InputDecoration(
                    isDense: true,
                    hintText: "Search...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                        color: descriptionColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 17.sp,
                        fontFamily: Constants.fontsFamily)),
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.sp,
                    fontFamily: Constants.fontsFamily),
                textAlign: TextAlign.start,
                maxLines: 1,
              ),
            ),
            ConstantWidget.getHorSpace(3.h),
          ],
        ),
      );
    },
  );
}

Widget getDurationTextField(
    BuildContext context, String s, TextEditingController textEditingController,
    {bool withprefix = false,
    bool withSufix = false,
    bool minLines = false,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
    bool isPass = false,
    bool isEnable = true,
    double? height,
    double? imageHeight,
    double? imageWidth,
    String? image,
    String? suffiximage,
    Function? imagefunction,
    AlignmentGeometry alignmentGeometry = Alignment.centerLeft,
    List<TextInputFormatter>? inputFormatters,
    bool defFocus = false,
    FocusNode? focus1,
    TextInputType? keyboardType}) {
  FocusNode myFocusNode = (focus1 == null) ? FocusNode() : focus1;
  Color color = borderColor;

  return StatefulBuilder(
    builder: (context, setState) {
      return Focus(
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            setState(() {
              myFocusNode.canRequestFocus = true;
              color = accentColor;
            });
          } else {
            setState(() {
              myFocusNode.canRequestFocus = false;
              color = borderColor;
            });
          }
        },
        focusNode: myFocusNode,
        child: Container(
          height: height,
          margin: margin,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: color, width: 1.h),
              borderRadius: BorderRadius.circular(12.h)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (!withprefix)
                  ? ConstantWidget.getHorSpace(12.h)
                  : Padding(
                      padding: EdgeInsets.only(right: 12.h, left: 20.h),
                      child: getSvgImage(image!, height: 24.h, width: 24.h),
                    ),
              Expanded(
                flex: 1,
                child: TextField(
                  keyboardType: keyboardType,
                  enabled: true,
                  inputFormatters: inputFormatters,
                  maxLines: (minLines) ? null : 1,
                  controller: textEditingController,
                  obscuringCharacter: "*",
                  autofocus: false,
                  obscureText: isPass,
                  showCursor: false,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20.sp,
                      fontFamily: Constants.fontsFamily),
                  decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: s,
                      hintStyle: TextStyle(
                          color: descriptionColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                          fontFamily: Constants.fontsFamily)),
                ),
              ),
              (!withSufix)
                  ? ConstantWidget.getHorSpace(12.h)
                  : Padding(
                      padding: EdgeInsets.only(right: 20.h, left: 12.h),
                      child: InkWell(
                        onTap: () {
                          if (imagefunction != null) {
                            imagefunction();
                          }
                        },
                        child: getSvgImage(suffiximage!,
                            height: 24.h, width: 24.h),
                      ),
                    ),
            ],
          ),
        ),
      );
    },
  );
}

Widget getCountryTextField(BuildContext context, String s,
    TextEditingController textEditingController, String code,
    {bool withprefix = false,
    bool withSufix = false,
    bool minLines = false,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
    bool isPass = false,
    bool isEnable = true,
    double? height,
    String? image,
    required Function function,
    Function? imagefunction}) {
  FocusNode myFocusNode = FocusNode();
  Color color = borderColor;
  return StatefulBuilder(
    builder: (context, setState) {
      return AbsorbPointer(
        absorbing: isEnable,
        child: Focus(
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              setState(() {
                color = accentColor;
                myFocusNode.canRequestFocus = true;
              });
            } else {
              setState(() {
                color = borderColor;
                myFocusNode.canRequestFocus = false;
              });
            }
          },
          child: Container(
            height: height,
            margin: margin,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: color, width: 1.h),
                borderRadius: BorderRadius.circular(22.h)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.selectCountryRoute);
                  },
                  child: Row(
                    children: [
                      ConstantWidget.getHorSpace(20.h),
                      getAssetImage(image!, width: 24.h, height: 24.h),
                      ConstantWidget.getHorSpace(12.h),
                      ConstantWidget.getTextWidget(code, descriptionColor,
                          TextAlign.start, FontWeight.w500, 15.sp),
                      getSvgImage("arrow_down.svg", width: 16.h, height: 16.h),
                      ConstantWidget.getHorSpace(12.h),
                    ],
                  ),
                ),
                Expanded(
                  child: TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLines: (minLines) ? null : 1,
                    controller: textEditingController,
                    obscuringCharacter: "*",
                    autofocus: false,
                    focusNode: myFocusNode,
                    obscureText: isPass,
                    showCursor: false,
                    onTap: () {
                      function();
                    },
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                        fontFamily: Constants.fontsFamily),
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                        hintText: s,
                        hintStyle: TextStyle(
                            color: descriptionColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                            fontFamily: Constants.fontsFamily)),
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

getDefaultNextButton(BuildContext context,
    {Function? function, IconData? icon}) {
  double height = ConstantWidget.getScreenPercentSize(context, 7);

  double subHeight = ConstantWidget.getPercentSize(height, 35);
  return InkWell(
    onTap: () {
      if (function != null) {
        function();
      }
    },
    child: Container(
      height: subHeight,
      width: subHeight,
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black,
              width: ConstantWidget.getPercentSize(subHeight, 7)),
          borderRadius: BorderRadius.all(
              Radius.circular(ConstantWidget.getPercentSize(subHeight, 42)))),
      child: Center(
        child: Icon(
          (icon != null) ? icon : Icons.close,
          color: Colors.black,
          size: ConstantWidget.getPercentSize(subHeight, 70),
        ),
      ),
    ),
  );
}

getDefaultButton(BuildContext context, {Function? function}) {
  double height = ConstantWidget.getScreenPercentSize(context, 7);

  double subHeight = ConstantWidget.getPercentSize(height, 35);
  return InkWell(
    onTap: () {
      if (function != null) {
        function();
      }
    },
    child: Container(
      height: subHeight,
      width: subHeight,
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black,
              width: ConstantWidget.getPercentSize(subHeight, 7)),
          borderRadius: BorderRadius.all(
              Radius.circular(ConstantWidget.getPercentSize(subHeight, 42)))),
      child: Center(
        // child: SvgPicture.asset(
        //   icon==null?  Constants.assetsImagePath + 'Arrow _Left.svg',
        //   height: ConstantWidget.getScreenPercentSize(
        //       context, 3),
        // ),
        child: Icon(
          Icons.close,
          color: Colors.black,
          size: ConstantWidget.getPercentSize(subHeight, 70),
        ),
      ),
    ),
  );
}

getDefaultBackButton(BuildContext context, {Function? function}) {
  double height = ConstantWidget.getScreenPercentSize(context, 7);

  double subHeight = ConstantWidget.getPercentSize(height, 44);
  return Container(
    child: InkWell(
      onTap: () {
        if (function != null) {
          function();
        }
      },
      child: SvgPicture.asset(
        Constants.assetsImagePath + 'Arrow - Left.svg',
        height: subHeight,
        width: subHeight,
        fit: BoxFit.fitWidth,
      ),
    ),
  );
}

getDefaultButtonWithAsset(BuildContext context,
    {Function? function, String? icon}) {
  double height = ConstantWidget.getScreenPercentSize(context, 7);

  double subHeight = ConstantWidget.getPercentSize(height, 35);
  return InkWell(
    onTap: () {
      if (function != null) {
        function();
      }
    },
    child: Container(
      height: subHeight,
      width: subHeight,
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black,
              width: ConstantWidget.getPercentSize(subHeight, 7)),
          borderRadius: BorderRadius.all(
              Radius.circular(ConstantWidget.getPercentSize(subHeight, 42)))),
      child: Center(
        child: Image.asset(
          (icon != null)
              ? Constants.assetsImagePath + icon
              : Constants.assetsImagePath + 'Icons.close',
          color: Colors.black,
          height: ConstantWidget.getPercentSize(subHeight, 60),
          width: ConstantWidget.getPercentSize(subHeight, 60),
        ),
      ),
    ),
  );
}

getIntroTitleBar(Function onBack, String title) {
  return Container(
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      // alignment: Alignment.center,
      children: [
        // Row(
        //   children: [
        //     InkWell(
        //         onTap: () {
        //           onBack();
        //         },
        //         child: getSvgImage("arrow_left.svg", height: 24.h, width: 24.h))
        //   ],
        // ),

        InkWell(
            onTap: () {
              onBack();
            },
            child: getSvgImage("arrow_left.svg", height: 24.h, width: 24.h)),

        SizedBox(
          height: 10.h,
        ),
        Center(
          child: ConstantWidget.getMultilineCustomFont(title, 28.sp, textColor,
              fontWeight: FontWeight.w700, textAlign: TextAlign.center),
        ).paddingSymmetric(horizontal: 40.w)
      ],
    ),
  );
}

class ConstantWidget {
  static Widget textFieldProfileWidget(
      BuildContext context,
      String s,
      var icon,
      bool isEnabled,
      TextEditingController textEditingController,
      Function function) {
    double height = ConstantWidget.getScreenPercentSize(context, 7);

    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 25);

    return getShadowWidget(
      verticalMargin: ConstantWidget.getScreenPercentSize(context, 1.2),
      widget: Container(
        height: height,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                maxLines: 1,
                controller: textEditingController,
                enabled: isEnabled,
                style: TextStyle(
                    fontFamily: Constants.fontsFamily,
                    color: isEnabled ? accentColor : Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize),
                decoration: InputDecoration(
                    // contentPadding: EdgeInsets.only(
                    //     left: ConstantWidget.getWidthPercentSize(context, 1.5)),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: s,
                    // icon:  Padding(
                    //   padding: const EdgeInsets.only(left:8.0),
                    //   child: Icon(Icons.account_circle_sharp),
                    // ),

                    icon: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        icon,
                        color: isEnabled ? accentColor : Colors.grey,
                      ),
                    ),
                    // icon: getIcon(icon, ),

                    // prefixIcon: Icon(Icons.account_circle_sharp),
                    hintStyle: TextStyle(
                        fontFamily: Constants.fontsFamily,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: fontSize)),
              ),
            )
          ],
        ),
      ),
      radius: radius,
    );
  }

  static Widget editAddressWidget(BuildContext context, String s, var icon,
      bool isEnabled, TextEditingController textEditingController) {
    double height = ConstantWidget.getScreenPercentSize(context, 7);

    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 25);

    return getShadowWidget(
        widget: Container(
          // height: height,

          alignment: Alignment.centerLeft,
          child: TextField(
            controller: textEditingController,
            enabled: isEnabled,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            style: TextStyle(
                fontFamily: Constants.fontsFamily,
                color: isEnabled ? accentColor : Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: fontSize),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(
                    ConstantWidget.getWidthPercentSize(context, 2.5)),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: s,
                hintStyle: TextStyle(
                    fontFamily: Constants.fontsFamily,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize)),
          ),
          // ),
        ),
        radius: radius);
  }

  static Widget editProfileWidget(
      BuildContext context,
      String s,
      var icon,
      bool isEnabled,
      TextEditingController textEditingController,
      Function function) {
    double height = ConstantWidget.getScreenPercentSize(context, 7);

    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 25);

    return getShadowWidget(
      radius: radius,
      verticalMargin: ConstantWidget.getScreenPercentSize(context, 1.2),
      widget: InkWell(
        onTap: () {
          if (isEnabled) {
            function();
          }
        },
        child: Container(
          height: height,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(
              left: ConstantWidget.getWidthPercentSize(context, 2.5)),
          child: TextField(
            maxLines: 1,
            controller: textEditingController,
            enabled: false,
            style: TextStyle(
                fontFamily: Constants.fontsFamily,
                color: Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: fontSize),
            decoration: InputDecoration(
                // contentPadding: EdgeInsets.only(
                //     left: ConstantWidget.getWidthPercentSize(context, 1.5)),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                hintText: s,
                suffixIcon: getIcon(icon),
                hintStyle: TextStyle(
                    fontFamily: Constants.fontsFamily,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize)),
          ),
        ),
      ),
    );
  }

  static getIcon(var icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Icon(icon),
    );
  }

  static double getPercentSize(double total, double percent) {
    return (total * percent) / 100;
  }

  static Widget getAddressWidget(BuildContext context, String s,
      TextEditingController textEditingController, double margin) {
    double height = ConstantWidget.getScreenPercentSize(context, 8.5);

    double radius = ConstantWidget.getPercentSize(height, 15);
    double fontSize = ConstantWidget.getPercentSize(height, 23);
    double padding = ConstantWidget.getScreenPercentSize(context, 1.2);

    // return getShadowWidget(widget: Container(
    //   padding: EdgeInsets.only(
    //       top: ConstantWidget.getScreenPercentSize(context,1)),
    //
    //
    //
    //
    //
    //   child: TextField(
    //     maxLines: 5,
    //     controller: textEditingController,
    //     style: TextStyle(
    //         fontFamily: Constants.fontsFamily,
    //         color: Colors.black,
    //         fontWeight: FontWeight.w400,
    //         fontSize: fontSize),
    //     decoration: InputDecoration(
    //         contentPadding: EdgeInsets.only(
    //             left: ConstantWidget.getWidthPercentSize(context, 2)),
    //         border: InputBorder.none,
    //         focusedBorder: InputBorder.none,
    //         enabledBorder: InputBorder.none,
    //         errorBorder: InputBorder.none,
    //         disabledBorder: InputBorder.none,
    //         hintText: s,
    //         hintStyle: TextStyle(
    //             fontFamily: Constants.fontsFamily,
    //             color: Colors.grey,
    //             fontWeight: FontWeight.w400,
    //             fontSize: fontSize)),
    //   ),
    // ), radius: radius,horizontalMargin: margin
    // );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1),
      padding: EdgeInsets.all(padding),
      decoration:
          getDefaultDecoration(borderColor: borderColor, radius: radius),
      child: Container(
        // padding: EdgeInsets.only(
        //     top: ConstantWidget.getScreenPercentSize(context,1)),

        child: TextField(
          maxLines: 5,
          controller: textEditingController,
          style: TextStyle(
              fontFamily: Constants.fontsFamily,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: fontSize),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: s,
              hintStyle: TextStyle(
                  fontFamily: Constants.fontsFamily,
                  color: subTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize)),
        ),
      ),
    );
  }

  static Widget getIntroBorderButtonWidget(
      BuildContext context, String s, Function function) {
    double height = ConstantWidget.getScreenPercentSize(context, 7);
    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 30);

    return InkWell(
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(
            vertical: ConstantWidget.getScreenPercentSize(context, 1.2),
            horizontal: ConstantWidget.getScreenPercentSize(context, 1.2)),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: accentColor),
          borderRadius: BorderRadius.all(
            Radius.circular(radius),
          ),
        ),
        child: Center(
            child: getDefaultTextWidget(
                s, TextAlign.center, FontWeight.bold, fontSize, Colors.black)),
      ),
      onTap: () {
        function();
      },
    );
  }

  static Widget getIntroButtonWidget(
      BuildContext context, String s, var color, Function function) {
    double height = ConstantWidget.getScreenPercentSize(context, 7);
    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 30);

    return InkWell(
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(
          vertical: ConstantWidget.getScreenPercentSize(context, 1.2),
        ),

        decoration: getDefaultDecoration(
          radius: radius,
          bgColor: color,
        ),

        // decoration: BoxDecoration(
        //     color: color,
        //     borderRadius: BorderRadius.all(
        //       Radius.circular(radius),
        //     ),
        //     boxShadow: [getShadow()]),
        child: Center(
            child: getDefaultTextWidget(
                s, TextAlign.center, FontWeight.bold, fontSize, Colors.white)),
      ),
      onTap: () {
        function();
      },
    );
  }

  static Widget getCustomTextWidget(String string, Color color, double size,
      FontWeight fontWeight, TextAlign align, int maxLine) {
    return Text(string,
        textAlign: align,
        maxLines: maxLine,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontWeight: fontWeight,
            fontSize: size,
            fontFamily: Constants.fontsFamily,
            color: color));
  }

  static OutlineInputBorder getOutlineBorder(var color, var width, var radius) {
    return new OutlineInputBorder(
        borderSide: BorderSide(color: color, width: width),
        borderRadius: BorderRadius.all(Radius.circular(radius)));
  }

  static Widget getHorizonSpace(double space) {
    return SizedBox(
      width: space,
    );
  }

  static Widget getCustomTextWithUnderLine(String text, TextAlign textAlign,
      Color color, FontWeight fontWeight, double fontSize) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
          decoration: TextDecoration.underline,
          color: color,
          fontSize: fontSize,
          fontFamily: Constants.fontsFamily,
          fontWeight: fontWeight),
    );
  }

  static Widget getCustomTextWithFontFamilyWidget(String string, Color color,
      double size, FontWeight fontWeight, TextAlign align, int maxLine) {
    return Text(string,
        textAlign: align,
        maxLines: maxLine,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontWeight: fontWeight,
            fontSize: size,
            fontFamily: Constants.fontsFamily,
            color: color));
  }

  static Widget getButtonWithoutSpaceWidget(
      BuildContext context, String s, var color, Function function) {
    double height = getScreenPercentSize(context, 7);
    double radius = getPercentSize(height, 20);
    double fontSize = getPercentSize(height, 30);

    return InkWell(
      child: Material(
        color: Colors.transparent,
        shadowColor: primaryColor.withOpacity(0.3),
        elevation: getPercentSize(height, 45),
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(getPercentSize(radius, 85)))),
        child: Container(
          height: height,
          margin: EdgeInsets.only(
            bottom: getScreenPercentSize(context, 1.5),
          ),
          decoration: ShapeDecoration(
            color: color,
            shape: SmoothRectangleBorder(
              side: BorderSide(color: subTextColor, width: 0.3),
              borderRadius: SmoothBorderRadius(
                cornerRadius: radius,
                cornerSmoothing: 0.8,
              ),
            ),
          ),
          child: Center(
              child: getDefaultTextWidget(s, TextAlign.center, FontWeight.w500,
                  fontSize, Colors.white)),
        ),
      ),
      onTap: () {
        function();
      },
    );
  }

  static Widget getLoginAppBar(BuildContext context,
      {bool? isMargin,
      Function? function,
      String? title,
      bool? isInfo,
      Function? infoFunction}) {
    double height = getScreenPercentSize(context, 7);
    return Container(
      height: height,
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          horizontal: isMargin != null
              ? 0
              : Constants.getDefaultHorizontalMargin(context)),
      child: Stack(
        children: [
          Center(
            child: ConstantWidget.getTextWidget(
                (title == null) ? '' : title,
                textColor,
                TextAlign.center,
                FontWeight.bold,
                ConstantWidget.getPercentSize(height, 30)),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: getDefaultBackButton(context, function: function),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: isInfo == null
                  ? Container()
                  : InkWell(
                      onTap: () {
                        if (infoFunction != null) {
                          infoFunction();
                        }
                      },
                      child: Icon(Icons.info,
                          color: textColor,
                          size: ConstantWidget.getScreenPercentSize(
                              context, 3)))),
        ],
      ),
    );
  }

  static Widget getHorSpace(double verSpace) {
    return SizedBox(
      width: verSpace,
    );
  }

  static Widget getVerSpace(double verSpace) {
    return SizedBox(
      height: verSpace,
    );
  }

  static Widget getDefaultTextFiledWithLabel(BuildContext context, String s,
      TextEditingController textEditingController,
      {bool withprefix = false,
      bool withSufix = false,
      bool minLines = false,
      EdgeInsetsGeometry margin = EdgeInsets.zero,
      bool isPass = false,
      bool isEnable = true,
      double? height,
      double? imageHeight,
      double? imageWidth,
      String? image,
      String? suffiximage,
      Function? imagefunction,
      AlignmentGeometry alignmentGeometry = Alignment.centerLeft,
      List<TextInputFormatter>? inputFormatters,
      bool defFocus = false,
      FocusNode? focus1,
      TextInputType? keyboardType,
      FormFieldValidator<String>? validator,
      double maxWidth = 60,
      ValueChanged<String>? onChanged,
      int? maxLine}) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType,
      onChanged: onChanged,
      enabled: true,
      validator: validator,
      inputFormatters: inputFormatters,
      maxLines: (minLines) ? maxLine : 1,
      controller: textEditingController,
      obscuringCharacter: "*",
      obscureText: isPass,
      showCursor: true,
      cursorColor: Colors.black,
      style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 15.sp,
          fontFamily: Constants.fontsFamily),
      decoration: InputDecoration(
          prefixIcon: (!withprefix)
              ? getHorSpace(12.h)
              : Padding(
                  padding: EdgeInsets.only(right: 12.h, left: 20.h),
                  child: getSvgImage(image!, height: 24.h, width: 24.h),
                ),
          prefixIconConstraints:
              BoxConstraints(maxHeight: 24.h, maxWidth: maxWidth.h),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.h),
            borderSide: BorderSide(color: borderColor, width: 1.h),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.h),
            borderSide: BorderSide(color: accentColor, width: 1.h),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.h),
            borderSide: BorderSide(color: Colors.redAccent, width: 1.h),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22.h),
            borderSide: BorderSide(color: Colors.redAccent, width: 1.h),
          ),
          hintText: s,
          hintStyle: TextStyle(
              color: descriptionColor,
              fontWeight: FontWeight.w500,
              fontSize: 15.sp,
              fontFamily: Constants.fontsFamily)),
    );
  }

  static Widget getFormTextFiledWithLabel(BuildContext context, String s,
      TextEditingController textEditingController,
      {bool withprefix = false,
      bool withSufix = false,
      bool minLines = false,
      EdgeInsetsGeometry margin = EdgeInsets.zero,
      bool isPass = false,
      bool isEnable = true,
      double? height,
      double? imageHeight,
      double? imageWidth,
      String? image,
      String? suffiximage,
      Function? imagefunction,
      AlignmentGeometry alignmentGeometry = Alignment.centerLeft,
      List<TextInputFormatter>? inputFormatters,
      bool defFocus = false,
      FocusNode? focus1,
      TextInputType? keyboardType,
      FormFieldValidator<String>? validator,
      double maxWidth = 60,
      ValueChanged<String>? onChanged,
      int? maxLine}) {
    return Container(
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: keyboardType,
        onChanged: onChanged,
        enabled: true,
        validator: validator,
        inputFormatters: inputFormatters,
        controller: textEditingController,
        obscuringCharacter: "*",
        obscureText: isPass,
        showCursor: true,
        cursorColor: Colors.black,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
            fontFamily: Constants.fontsFamily),
        decoration: InputDecoration(
            isCollapsed: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 16.h, horizontal: 15.h),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.h),
              borderSide: BorderSide(color: borderColor, width: 1.h),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.h),
              borderSide: BorderSide(color: accentColor, width: 1.h),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.h),
              borderSide: BorderSide(color: Colors.redAccent, width: 1.h),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.h),
              borderSide: BorderSide(color: Colors.redAccent, width: 1.h),
            ),
            hintText: s,
            hintStyle: TextStyle(
                color: descriptionColor,
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
                fontFamily: Constants.fontsFamily)),
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
      ),
    );
  }

  static Widget getDescTextFiledWithLabel(BuildContext context, String s,
      TextEditingController textEditingController,
      {bool withprefix = false,
      bool withSufix = false,
      bool minLines = false,
      EdgeInsetsGeometry margin = EdgeInsets.zero,
      bool isPass = false,
      bool isEnable = true,
      double? height,
      double? imageHeight,
      double? imageWidth,
      String? image,
      String? suffiximage,
      Function? imagefunction,
      AlignmentGeometry alignmentGeometry = Alignment.centerLeft,
      List<TextInputFormatter>? inputFormatters,
      bool defFocus = false,
      FocusNode? focus1,
      TextInputType? keyboardType,
      FormFieldValidator<String>? validator,
      double maxWidth = 60,
      ValueChanged<String>? onChanged,
      int? maxLine}) {
    return Container(
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: keyboardType,
        onChanged: onChanged,
        maxLines: 5,
        enabled: true,
        validator: validator,
        inputFormatters: inputFormatters,
        controller: textEditingController,
        obscuringCharacter: "*",
        obscureText: isPass,
        showCursor: true,
        cursorColor: Colors.black,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
            fontFamily: Constants.fontsFamily),
        decoration: InputDecoration(
            isCollapsed: true,
            contentPadding:
                EdgeInsets.symmetric(vertical: 16.h, horizontal: 15.h),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.h),
              borderSide: BorderSide(color: borderColor, width: 1.h),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.h),
              borderSide: BorderSide(color: accentColor, width: 1.h),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.h),
              borderSide: BorderSide(color: Colors.redAccent, width: 1.h),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.h),
              borderSide: BorderSide(color: Colors.redAccent, width: 1.h),
            ),
            hintText: s,
            hintStyle: TextStyle(
                color: descriptionColor,
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
                fontFamily: Constants.fontsFamily)),
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
      ),
    );
  }

  static Widget getCountryTextFiled(BuildContext context, String s,
      TextEditingController textEditingController,
      {bool withprefix = false,
      bool withSufix = false,
      bool minLines = false,
      EdgeInsetsGeometry margin = EdgeInsets.zero,
      bool isPass = false,
      bool isEnable = true,
      double? height,
      double? imageHeight,
      double? imageWidth,
      String? image,
      String? suffiximage,
      Function? imagefunction,
      AlignmentGeometry alignmentGeometry = Alignment.centerLeft,
      List<TextInputFormatter>? inputFormatters,
      bool defFocus = false,
      FocusNode? focus1,
      TextInputType? keyboardType,
      FormFieldValidator<String>? validator,
      double maxWidth = 60,
      ValueChanged<CountryCode>? onChanged}) {
    return GetBuilder<ForgotController>(
      init: ForgotController(),
      builder: (controller) => TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: keyboardType,
        enabled: true,
        validator: validator,
        inputFormatters: inputFormatters,
        maxLines: (minLines) ? null : 1,
        controller: textEditingController,
        obscuringCharacter: "*",
        obscureText: isPass,
        showCursor: true,
        cursorColor: Colors.black,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
            fontFamily: Constants.fontsFamily),
        decoration: InputDecoration(
            prefixIcon: (!withprefix)
                ? getHorSpace(12.h)
                : Padding(
                    padding: EdgeInsets.only(right: 12.h, left: 20.h),
                    child: CountryCodePicker(
                      onChanged: onChanged,
                      initialSelection: controller.codeName,
                      flagWidth: 24.h,
                      padding: EdgeInsets.zero,
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400),
                      favorite: [controller.code, controller.codeName],
                      showCountryOnly: false,
                      showDropDownButton: true,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                    ),
                  ),
            prefixIconConstraints:
                BoxConstraints(maxHeight: 24.h, maxWidth: 130.h),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22.h),
              borderSide: BorderSide(color: borderColor, width: 1.h),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22.h),
              borderSide: BorderSide(color: accentColor, width: 1.h),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22.h),
              borderSide: BorderSide(color: Colors.redAccent, width: 1.h),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22.h),
              borderSide: BorderSide(color: Colors.redAccent, width: 1.h),
            ),
            hintText: s,
            hintStyle: TextStyle(
                color: descriptionColor,
                fontWeight: FontWeight.w500,
                fontSize: 15.sp,
                fontFamily: Constants.fontsFamily)),
      ),
    );
    // );
    //   },
    // );
  }

  static Widget getDefaultTextFiledWidget(BuildContext context, String s,
      TextEditingController textEditingController,
      {bool? isEnabled}) {
    double height = getDefaultButtonSize(context);

    double radius = getPercentSize(height, 20);
    double fontSize = getPercentSize(height, 27);

    Color color = borderColor;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          height: height,
          margin: EdgeInsets.symmetric(
              vertical: getScreenPercentSize(context, 1.2)),
          alignment: Alignment.centerLeft,
          decoration: getDefaultDecoration(radius: radius, borderColor: color),
          child: Focus(
            onFocusChange: (hasFocus) {},
            child: TextFormField(
              // focusNode: myFocusNode,
              maxLines: 1,
              enabled: (isEnabled != null) ? isEnabled : true,
              controller: textEditingController,
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                  color: textColor,
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize),
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: getWidthPercentSize(context, 4)),
                  border: OutlineInputBorder(),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: s,
                  isDense: true,
                  hintStyle: TextStyle(
                      fontFamily: Constants.fontsFamily,
                      color: subTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: fontSize)),
            ),
          ),
        );
      },
    );
  }

  // static Widget getDefaultTextFiledWidget(BuildContext context, String s,
  //     TextEditingController textEditingController) {
  //   double height = ConstantWidget.getScreenPercentSize(context, 8.5);
  //
  //   double radius = ConstantWidget.getPercentSize(height, 20);
  //   double fontSize = ConstantWidget.getPercentSize(height, 25);
  //
  //   return Container(
  //     height: height,
  //     margin: EdgeInsets.symmetric(
  //         vertical: ConstantWidget.getScreenPercentSize(context, 1.2)),
  //     alignment: Alignment.centerLeft,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.all(
  //         Radius.circular(radius),
  //       ),
  //     ),
  //     child: TextField(
  //       maxLines: 1,
  //       controller: textEditingController,
  //       style: TextStyle(
  //           fontFamily: Constants.fontsFamily,
  //           color: Colors.black,
  //           fontWeight: FontWeight.w400,
  //           fontSize: fontSize),
  //       decoration: InputDecoration(
  //           contentPadding: EdgeInsets.only(
  //               left: ConstantWidget.getWidthPercentSize(context, 2)),
  //           border: InputBorder.none,
  //           focusedBorder: InputBorder.none,
  //           enabledBorder: InputBorder.none,
  //           errorBorder: InputBorder.none,
  //           disabledBorder: InputBorder.none,
  //           hintText: s,
  //           hintStyle: TextStyle(
  //               fontFamily: Constants.fontsFamily,
  //               color: Colors.grey,
  //               fontWeight: FontWeight.w400,
  //               fontSize: fontSize)),
  //     ),
  //   );
  // }

  static Widget getRoundCornerButtonWithoutIcon(String texts, Color color,
      Color textColor, double btnRadius, Function function) {
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(btnRadius),
              shape: BoxShape.rectangle,
              color: color,
            ),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            child: Center(
              child: getCustomText(
                  texts, textColor, 1, TextAlign.center, FontWeight.w500, 18),
            ),
          )
        ],
      ),
      onTap: () {
        function();
      },
    );
  }

  static getDefaultButtonSize(BuildContext context) {
    return getScreenPercentSize(context, 6.5);
  }

  // static Widget getButtonWidget1(
  //     BuildContext context, String s, var color, Function function) {
  //   double height = getDefaultButtonSize(context);
  //   double radius = ConstantWidget.getPercentSize(height, 20);
  //   double fontSize = ConstantWidget.getPercentSize(height, 30);
  //
  //   return InkWell(
  //     child: Container(
  //       height: height,
  //       margin: EdgeInsets.symmetric(
  //           vertical: ConstantWidget.getScreenPercentSize(context, 1.2)),
  //       decoration: BoxDecoration(
  //         color: color,
  //         borderRadius: BorderRadius.all(
  //           Radius.circular(radius),
  //         ),
  //       ),
  //       child: Center(
  //           child: getDefaultTextWidget(
  //               s, TextAlign.center, FontWeight.w500, fontSize, Colors.black)),
  //     ),
  //     onTap: () {
  //       function();
  //     },
  //   );
  // }

  static Widget getPasswordTextFiled(BuildContext context, String s,
      TextEditingController textEditingController) {
    double height = getDefaultButtonSize(context);

    double radius = getPercentSize(height, 20);
    double fontSize = getPercentSize(height, 27);
    FocusNode myFocusNode = FocusNode();

    Color color = borderColor;

    return StatefulBuilder(
      builder: (context, setState) {
        myFocusNode.addListener(() {
          print("focus---${myFocusNode.hasFocus}---$s");

          setState(() {
            if (myFocusNode.hasFocus) {
              color = primaryColor;
            } else {
              color = borderColor;
            }
          });
        });
        return Container(
          height: height,
          margin: EdgeInsets.symmetric(
              vertical: getScreenPercentSize(context, 1.2)),
          alignment: Alignment.centerLeft,
          decoration: getDefaultDecoration(radius: radius, borderColor: color),
          child: Focus(
            onFocusChange: (hasFocus) {},
            child: TextFormField(
              focusNode: myFocusNode,
              maxLines: 1,
              controller: textEditingController,
              textAlign: TextAlign.start,
              obscureText: true,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                  fontFamily: Constants.fontsFamily,
                  color: textColor,
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize),
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: getWidthPercentSize(context, 4)),
                  border: OutlineInputBorder(),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: s,
                  suffixIcon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: subTextColor,
                    size: getPercentSize(height, 40),
                  ),
                  isDense: true,
                  hintStyle: TextStyle(
                      fontFamily: Constants.fontsFamily,
                      color: subTextColor,
                      fontWeight: FontWeight.w400,
                      fontSize: fontSize)),
            ),
          ),
        );
      },
    );
  }

  // static Widget getPasswordTextFiled(BuildContext context, String s,
  //     TextEditingController textEditingController) {
  //   double height = ConstantWidget.getScreenPercentSize(context, 8.5);
  //   double radius = ConstantWidget.getPercentSize(height, 20);
  //   double fontSize = ConstantWidget.getPercentSize(height, 25);
  //
  //   return Container(
  //       height: height,
  //       alignment: Alignment.centerLeft,
  //       margin: EdgeInsets.symmetric(
  //           vertical: ConstantWidget.getScreenPercentSize(context, 1.2)),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.all(
  //           Radius.circular(radius),
  //         ),
  //       ),
  //       child: TextField(
  //         maxLines: 1,
  //         obscureText: true,
  //         controller: textEditingController,
  //         style: TextStyle(
  //             fontFamily: Constants.fontsFamily,
  //             color: Colors.black,
  //             fontWeight: FontWeight.w400,
  //             fontSize: fontSize),
  //         decoration: InputDecoration(
  //             contentPadding: EdgeInsets.only(
  //                 left: ConstantWidget.getWidthPercentSize(context, 2)),
  //             border: InputBorder.none,
  //             focusedBorder: InputBorder.none,
  //             enabledBorder: InputBorder.none,
  //             errorBorder: InputBorder.none,
  //             disabledBorder: InputBorder.none,
  //             hintText: s,
  //             hintStyle: TextStyle(
  //                 fontFamily: Constants.fontsFamily,
  //                 color: Colors.grey,
  //                 fontWeight: FontWeight.w400,
  //                 fontSize: fontSize)),
  //       ));
  // }

  static Widget getPaddingWidget(EdgeInsets edgeInsets, Widget widget) {
    return Padding(
      padding: edgeInsets,
      child: widget,
    );
  }

  static Widget getButtonWidget(
      BuildContext context, String s, var color, Function function) {
    double radius = 22.h;

    return InkWell(
      child: Container(
        height: 60.h,
        decoration: getDefaultDecoration(radius: radius, bgColor: accentColor),
        child: Center(
            child: getDefaultTextWidget(
                s, TextAlign.center, FontWeight.w700, 20.sp, Colors.white)),
      ),
      onTap: () {
        function();
      },
    );
  }

  static Widget getProcessWidget(
    BuildContext context,
  ) {
    double radius = 22.h;

    return InkWell(
      child: Container(
        height: 60.h,
        decoration: getDefaultDecoration(radius: radius, bgColor: accentColor),
        child: Center(child: getProgressDialog(color: Colors.transparent)),
      ),
      onTap: () {},
    );
  }

  static Widget getBorderButtonWidget(
      BuildContext context, String s, Function function,
      {Color? borderColor, double? btnHeight}) {
    double height = btnHeight == null
        ? ConstantWidget.getDefaultButtonSize(context)
        : btnHeight;
    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 30);

    return InkWell(
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(
            vertical: ConstantWidget.getScreenPercentSize(context, 1.2)),
        decoration: getDefaultDecoration(
            radius: radius,
            borderColor: borderColor == null ? accentColor : borderColor),
        child: Center(
            child: getDefaultTextWidget(s, TextAlign.center, FontWeight.bold,
                fontSize, borderColor == null ? accentColor : borderColor)),
      ),
      onTap: () {
        function();
      },
    );
  }

  static double largeTextSize = 28;

  static double getMarginTop(BuildContext context) {
    // double height = getScreenPercentSize(context, 20);
    double height = getScreenPercentSize(context, 23);

    return (height / 2) + getScreenPercentSize(context, 2.5);
  }

  static double getBlankTop(BuildContext context) {
    double height = getScreenPercentSize(context, 20);

    return getPercentSize(height, 85);
  }

  static Widget getCustomTextWithoutAlign(
      String text, Color color, FontWeight fontWeight, double fontSize) {
    return Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontFamily: Constants.fontsFamily,
          decoration: TextDecoration.none,
          fontWeight: fontWeight),
    );
  }

  static double getScreenPercentSize(BuildContext context, double percent) {
    return (MediaQuery.of(context).size.height * percent) / 100;
  }

  static double getWidthPercentSize(BuildContext context, double percent) {
    return (MediaQuery.of(context).size.width * percent) / 100;
  }

  static Widget getSpace(double space) {
    return SizedBox(
      height: space,
    );
  }

  static Widget getTextWidgetWithFontWithMaxLine1(
      String text,
      Color color,
      TextAlign textAlign,
      FontWeight fontWeight,
      double textSizes,
      String font) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: textSizes,
          color: color,
          fontFamily: font,
          letterSpacing: 1,
          fontWeight: fontWeight),
      textAlign: textAlign,
    );
  }

  static Widget getShadowWidget(
      {required Widget widget,
      double? margin,
      double? verticalMargin,
      double? horizontalMargin,
      double? radius,
      double? topPadding,
      double? leftPadding,
      double? rightPadding,
      double? bottomPadding,
      Color? color,
      bool? isShadow}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: (margin == null) ? 0 : margin),
      margin: EdgeInsets.symmetric(
          vertical: (verticalMargin == null) ? 0 : verticalMargin,
          horizontal: (horizontalMargin == null) ? 0 : horizontalMargin),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: isShadow == null
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]
              : [],
        ),
        child: Container(
          decoration: getDefaultDecoration(
              bgColor: (color == null) ? Colors.white : color,
              radius: (radius == null) ? 0 : radius),
          padding: EdgeInsets.only(
            top: (topPadding == null) ? 0 : topPadding,
            bottom: (bottomPadding == null) ? 0 : bottomPadding,
            right: (rightPadding == null) ? 0 : rightPadding,
            left: (leftPadding == null) ? 0 : leftPadding,
          ),
          child: widget,
        ),
      ),
    );
  }

  static Widget getCustomText(String text, Color color, int maxLine,
      TextAlign textAlign, FontWeight fontWeight, double textSizes) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: textSizes,
          color: color,
          fontFamily: Constants.fontsFamily,
          fontWeight: fontWeight),
      maxLines: maxLine,
      textAlign: textAlign,
    );
  }

  static Widget getMultilineCustomFont(
      String text, double fontSize, Color fontColor,
      {String? fontFamily,
      TextOverflow overflow = TextOverflow.ellipsis,
      TextDecoration decoration = TextDecoration.none,
      FontWeight fontWeight = FontWeight.normal,
      TextAlign textAlign = TextAlign.start,
      txtHeight = 1.0}) {
    return Text(
      text,
      style: TextStyle(
          decoration: decoration,
          fontSize: fontSize,
          fontStyle: FontStyle.normal,
          color: fontColor,
          fontFamily: Constants.fontsFamily,
          height: txtHeight,
          fontWeight: fontWeight),
      textAlign: textAlign,
    );
  }

  static Widget getCustomTextFont(
      String text,
      Color color,
      int maxLine,
      TextAlign textAlign,
      FontWeight fontWeight,
      double textSizes,
      String font) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: textSizes,
          color: color,
          fontFamily: font,
          height: 1.1,
          fontWeight: fontWeight),
      maxLines: maxLine,
      textAlign: textAlign,
    );
  }

  static Widget getCustomTextFontWithSpace(
      String text,
      Color color,
      int maxLine,
      TextAlign textAlign,
      FontWeight fontWeight,
      double textSizes,
      String font) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: textSizes,
          color: color,
          fontFamily: font,
          height: 1.3,
          fontWeight: fontWeight),
      maxLines: maxLine,
      textAlign: textAlign,
    );
  }

  static Widget getTextWidgetWithSpacing(String text, Color color,
      TextAlign textAlign, FontWeight fontWeight, double textSizes) {
    return Text(
      text,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: textSizes,
          color: color,
          height: 1.5,
          fontFamily: Constants.fontsFamily,
          fontWeight: fontWeight),
      textAlign: textAlign,
    );
  }

  static Widget getTextWidget(String text, Color color, TextAlign textAlign,
      FontWeight fontWeight, double textSizes) {
    return Text(
      text,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: textSizes,
          color: color,
          fontFamily: Constants.fontsFamily,
          fontWeight: fontWeight),
      textAlign: textAlign,
    );
  }

  static Widget getTextDecorationWidget(String text, Color color,
      TextAlign textAlign, FontWeight fontWeight, double textSizes) {
    return Text(
      text,
      style: TextStyle(
          decoration: TextDecoration.underline,
          fontSize: textSizes,
          color: color,
          fontFamily: Constants.fontsFamily,
          fontWeight: fontWeight),
      textAlign: textAlign,
    );
  }

  static BoxDecoration getButtonDecoration(Color bgColor,
      {BorderRadius? borderRadius,
      Border? border,
      List<BoxShadow> shadow = const [],
      DecorationImage? image}) {
    return BoxDecoration(
        color: bgColor,
        borderRadius: borderRadius,
        border: border,
        boxShadow: shadow,
        image: image);
  }

  static Widget getButtonWithShadow(BuildContext context, Color bgColor,
      String text, Color textColor, Function function, double fontsize,
      {bool isBorder = false,
      EdgeInsetsGeometry? insetsGeometry,
      borderColor = Colors.transparent,
      FontWeight weight = FontWeight.bold,
      bool isIcon = false,
      String? image,
      Color? imageColor,
      double? imageWidth,
      double? imageHeight,
      bool smallFont = false,
      double? buttonHeight,
      double? buttonWidth,
      List<BoxShadow> boxShadow = const [],
      EdgeInsetsGeometry? insetsGeometrypadding,
      BorderRadius? borderRadius,
      double? borderWidth}) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        margin: insetsGeometry,
        padding: insetsGeometrypadding,
        width: buttonWidth,
        height: buttonHeight,
        decoration: getButtonDecoration(
          bgColor,
          borderRadius: borderRadius,
          shadow: boxShadow,
          border: (isBorder)
              ? Border.all(color: borderColor, width: borderWidth!)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            (isIcon)
                ? getSvgImage(image!, width: 20.h, height: 20.h)
                : getHorSpace(0),
            (isIcon) ? getHorSpace(10.h) : getHorSpace(0),
            ConstantWidget.getTextWidget(
                text, textColor, TextAlign.center, weight, fontsize),
          ],
        ),
      ),
    );
  }

  static Widget getRichText(
      String firstText,
      Color firstColor,
      FontWeight firstWeight,
      double firstSize,
      String secondText,
      Color secondColor,
      FontWeight secondWeight,
      double secondSize,
      {TextAlign textAlign = TextAlign.center,
      double? txtHeight}) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
          text: firstText,
          style: TextStyle(
            color: firstColor,
            fontWeight: firstWeight,
            fontFamily: Constants.fontsFamily,
            fontSize: firstSize,
            height: txtHeight,
          ),
          children: [
            TextSpan(
                text: secondText,
                style: TextStyle(
                    color: secondColor,
                    fontWeight: secondWeight,
                    fontFamily: Constants.fontsFamily,
                    fontSize: secondSize,
                    height: txtHeight))
          ]),
    );
  }

  static Widget getTextWidgetWithFont(
      String text,
      Color color,
      TextAlign textAlign,
      FontWeight fontWeight,
      double textSizes,
      String font) {
    return Text(
      text,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: textSizes,
          color: color,
          fontFamily: Constants.fontsFamily,
          letterSpacing: 1,
          fontWeight: fontWeight),
      textAlign: textAlign,
    );
  }

  static Widget getTextWidgetWithFontWithMaxLine(
      String text,
      Color color,
      TextAlign textAlign,
      FontWeight fontWeight,
      double textSizes,
      String font,
      int maxLine) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLine,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: textSizes,
          color: color,
          fontFamily: font,
          letterSpacing: 1,
          fontWeight: fontWeight),
      textAlign: textAlign,
    );
  }

  static Widget getDefaultTextWidget(String s, TextAlign textAlign,
      FontWeight fontWeight, double fontSize, var color) {
    return Text(
      s,
      textAlign: textAlign,
      style: TextStyle(
          fontFamily: Constants.fontsFamily,
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color),
    );
  }
}

TextStyle homeWhiteRegularTextStyle = TextStyle(
  fontFamily: Constants.fontsFamily,
  fontSize: 17,
  color: Colors.white,
);

getDefaultDecoration({double? radius, Color? bgColor, Color? borderColor}) {
  return ShapeDecoration(
    color: (bgColor == null) ? Colors.transparent : bgColor,
    shape: SmoothRectangleBorder(
      side: BorderSide(
          color: (borderColor == null) ? Colors.transparent : borderColor,
          width: (borderColor == null) ? 0 : 1),
      borderRadius: SmoothBorderRadius(
        cornerRadius: (radius == null) ? 0 : radius,
        cornerSmoothing: 0.8,
      ),
    ),
  );
}

getDecorationWithSide(
    {double? radius,
    Color? bgColor,
    Color? borderColor,
    bool? isTopRight,
    bool? isTopLeft,
    bool? isBottomRight,
    bool? isBottomLeft}) {
  return ShapeDecoration(
    color: (bgColor == null) ? Colors.transparent : bgColor,
    shape: SmoothRectangleBorder(
      side: BorderSide(
          color: (borderColor == null) ? Colors.transparent : borderColor,
          width: (borderColor == null) ? 0 : 1),
      borderRadius: SmoothBorderRadius.only(
        bottomRight: SmoothRadius(
          cornerRadius: (isBottomRight == null) ? 0 : radius!,
          cornerSmoothing: 1,
        ),
        bottomLeft: SmoothRadius(
          cornerRadius: (isBottomLeft == null) ? 0 : radius!,
          cornerSmoothing: 1,
        ),
        topLeft: SmoothRadius(
          cornerRadius: (isTopLeft == null) ? 0 : radius!,
          cornerSmoothing: 1,
        ),
        topRight: SmoothRadius(
          cornerRadius: (isTopRight == null) ? 0 : radius!,
          cornerSmoothing: 1,
        ),
      ),
    ),
  );
}

getColorStatusBar(Color? color) {
  return AppBar(
    backgroundColor: color,
    toolbarHeight: 0,
    elevation: 0,
    systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: color, statusBarColor: color),
  );
}

setStatusBarColor(Color color) {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: color));
}

double getScreenPercentSize(BuildContext context, double percent) {
  return (MediaQuery.of(context).size.height * percent) / 100;
}

Widget getPrimaryAppBarText(BuildContext buildContext, String s) {
  return getCustomTextWithoutAlign(
      s, Colors.black, FontWeight.w700, getWidthPercentSize(buildContext, 5));
}

Widget getTextWidget(String text, Color color, TextAlign textAlign,
    FontWeight fontWeight, double textSizes) {
  return Text(
    text,
    style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: textSizes,
        color: color,
        fontFamily: Constants.fontsFamily,
        fontWeight: fontWeight),
    textAlign: textAlign,
  );
}

getShadow() {
  return BoxShadow(
    color: Colors.black12,
    blurRadius: 3.0,
    offset: Offset(0, 4),
  );
}

double getPercentSize(double total, double percent) {
  return (total * percent) / 100;
}

Widget getPrimaryAppBarIcon() {
  return Icon(
    Icons.keyboard_backspace,
    color: Colors.black,
  );
}

Widget getCustomTextWithoutAlign(
    String text, Color color, FontWeight fontWeight, double fontSize) {
  return Text(
    text,
    style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: Constants.fontsFamily,
        decoration: TextDecoration.none,
        fontWeight: fontWeight),
  );
}

getNoneAppBar(BuildContext context, {Color? color, bool? isFullScreen}) {
  if (color == null) {
    color = bgDarkWhite;
  }
  var overlayStyle = SystemUiOverlayStyle.light; // 1

  if (overlayStyle == SystemUiOverlayStyle.light) {
    overlayStyle = SystemUiOverlayStyle.dark;
  } else {
    overlayStyle = SystemUiOverlayStyle.light;
  }

  if (color == bgDarkWhite) {
    overlayStyle = SystemUiOverlayStyle.dark;
  }

  return AppBar(
    toolbarHeight: 0,
    elevation: 0,
    primary: false,
    backgroundColor: color,
    systemOverlayStyle: overlayStyle.copyWith(
      statusBarColor: color,
    ),
  );
}

Widget buildNetworkImage(String imageName,
    {double imageWidth = double.infinity,
    double imageHeight = double.infinity,
    BoxFit fit = BoxFit.none}) {
  return Center(
    child: CachedNetworkImage(
      placeholder: (context, url) {
        return Shimmer.fromColors(
            child: Container(
              color: Colors.white,
            ),
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade300);
      },
      placeholderFadeInDuration: Duration.zero,
      imageUrl: ConstantUrl.uploadUrl + imageName,
      cacheKey: imageName,
      useOldImageOnUrlChange: false,
      height: imageHeight,
      width: imageWidth,
      fit: fit,
    ),
  );
}

double getWidthPercentSize(BuildContext context, double percent) {
  return (MediaQuery.of(context).size.width * percent) / 100;
}

Widget getCustomTextWidget(String text, Color color, int maxLine,
    TextAlign textAlign, FontWeight fontWeight, double textSizes) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: textSizes,
        color: color,
        fontFamily: Constants.fontsFamily,
        fontWeight: fontWeight),
    maxLines: maxLine,
    textAlign: textAlign,
  );
}
