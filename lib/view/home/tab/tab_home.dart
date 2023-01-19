// ignore_for_file: unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shimmer/shimmer.dart';
import 'package:women_workout/ads/ads_file.dart';
import 'package:women_workout/view/in_app_purchase.dart';

import '../../../iapurchase/prefrence.dart';
import '../../../models/DietCategoryModel.dart';
import '../../../models/model_all_challenges.dart';
import '../../../models/model_all_workout_category.dart';
import '../../../models/model_dummy_send.dart';
import '../../../models/setting_model.dart';
import '../../../models/userdetail_model.dart';
import '../../../routes/app_routes.dart';
import '../../../util/category_cont.dart';
import '../../../util/color_category.dart';
import '../../../util/constant_url.dart';
import '../../../util/constant_widget.dart';

import '../../../util/constants.dart';
import '../../../util/net_check_cont.dart';
import '../../../util/pref_data.dart';
import '../../../util/service_provider.dart';
import '../../../util/widgets.dart';

import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../controller/controller.dart';
import '../../diet/diet_sub_cateogory.dart';
import '../../workout/widget_challenges_exercise_list.dart';
import '../../workout_category/workout_category_exercise_list.dart';

class TabHome extends StatefulWidget {
  @override
  _TabHome createState() => _TabHome();
}

class _TabHome extends State<TabHome> with TickerProviderStateMixin {
  HomeController controller = Get.put(HomeController());
  String? imageUrl;
  var tdata;
  String firstname = "";

  // double? progress;
  // double? sliderProgress;

  // int? progressIndex;

  AdsFile? adsFile;
  bool i = true;

  @override
  void initState() {
    super.initState();
    inApp().then((value) {
      setState(() {
        i = value;
      });
    });
    Future.delayed(Duration.zero, () {
      adsFile = new AdsFile(context);
      adsFile!.createRewardedAd();
      catController.loadDietCategory(context);
    });

    getUser();
  }

  Future<bool> inApp() async {
    return await checkInApp();
  }

  Future<bool> checkInApp() async {
    bool isPurchase = await Preferences.preferences
        .getBool(key: PrefernceKey.isProUser, defValue: false);

    return isPurchase;
  }

  @override
  void dispose() {
    super.dispose();

    disposeRewardedAd(adsFile);
  }

  void getUser() async {
    // progressIndex = await PrefData.getProgressIndex();
    String s = await PrefData.getUserDetail();
    if (s.isNotEmpty) {
      UserDetail userDetail = await ConstantUrl.getUserDetail();

      setState(() {
        firstname = userDetail.firstName!;
        if (userDetail.image != null) {
          if (userDetail.image!.isNotEmpty) {
            imageUrl = userDetail.image!;
          }
        }
      });
    }
  }

  getProfileImage() {
    if (imageUrl != null) {
      return CachedNetworkImage(
        height: 40.h,
        width: 40.h,
        imageUrl: ConstantUrl.uploadUrl + imageUrl!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    tdata = DateTime.now().hour;
    setStatusBarColor(bgDarkWhite);
    return Column(
      children: [
        ConstantWidget.getVerSpace(20.h),
        buildAppBar(),
        ConstantWidget.getVerSpace(25.h),
        Expanded(
          flex: 1,
          child: ListView(
            primary: true,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: [
              ConstantWidget.getVerSpace(20.h),
              buildWorkout(),
              ConstantWidget.getVerSpace(20.h),
              buildWorkoutCategory(),
              ConstantWidget.getVerSpace(20.h),
              buildDiet(),
              // ConstantWidget.getVerSpace(6.h),
              // buildDietPlan(),
              ConstantWidget.getVerSpace(25.h),
              buildPlan(),
              ConstantWidget.getVerSpace(65.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildGoodMorningWidget(var time) {
    if (time < 12) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstantWidget.getMultilineCustomFont(
              "Good Morning, ${firstname}!", 15.sp, descriptionColor,
              fontWeight: FontWeight.w500, txtHeight: 1.46.h),
          ConstantWidget.getTextWidget("Let’s Shape Yourself", textColor,
              TextAlign.start, FontWeight.w700, 28.sp),
        ],
      );
    } else if (time < 17) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstantWidget.getMultilineCustomFont(
              "Good Afternoon, ${firstname}!", 15.sp, descriptionColor,
              fontWeight: FontWeight.w500, txtHeight: 1.46.h),
          ConstantWidget.getTextWidget("Let’s Shape Yourself", textColor,
              TextAlign.start, FontWeight.w700, 28.sp),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstantWidget.getMultilineCustomFont(
              "Good Evening, ${firstname}!", 15.sp, descriptionColor,
              fontWeight: FontWeight.w500, txtHeight: 1.46.h),
          ConstantWidget.getTextWidget("Let’s Shape Yourself", textColor,
              TextAlign.start, FontWeight.w700, 28.sp),
        ],
      );
    }
  }

  Widget buildAppBar() {
    return ConstantWidget.getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: buildGoodMorningWidget(tdata),
            flex: 1,
          ),
          // getSvgImage("menu.svg", width: 24.h, height: 24.h),
          // InkWell(
          //   onTap: () {
          //     Get.to(InAppPurchase())!.then((value) => setState);
          //   },
          //   child: getHomeProWidget(context: context, size: 30.h),
          // ),
          SizedBox(
            width: 5.w,
          ),
          InkWell(
            onTap: () {
              Get.toNamed(Routes.editProfileRoute)!.then((value) {
                setState(() {
                  getUser();
                });
              });
            },
            child: ClipOval(
              child: Material(
                child: getProfileImage(),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Column buildDietPlan() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       ConstantWidget.getPaddingWidget(
  //         EdgeInsets.symmetric(horizontal: 20.h),
  //         getCustomText("My Diet Plans", textColor, 1, TextAlign.start,
  //             FontWeight.w700, 20.sp),
  //       ),
  //       ConstantWidget.getVerSpace(10.h),
  //       GetBuilder<SettingController>(
  //         init: SettingController(),
  //         builder: (controller) => Container(
  //           height: 169.h,
  //           width: 203.h,
  //           child: InkWell(
  //             onTap: () async {
  //               String s = await PrefData.getUserDetail();
  //               // if (await ConstantUrl.isLogin()) {
  //                 Get.toNamed(Routes.CustomDietPlanRoute);
  //               // } else {
  //               //   ConstantUrl.sendLoginPage(context, function: () {
  //               //     if (controller.isLogin.value) {
  //               //       Get.toNamed(Routes.CustomDietPlanRoute);
  //               //     }
  //               //   }, name: () {
  //               //     Get.back();
  //               //   });
  //               // }
  //             },
  //             child: Container(
  //               margin: EdgeInsetsDirectional.only(end: 20.h, start: 20.h),
  //               width: double.infinity,
  //               child: Column(
  //                 children: [
  //                   ConstantWidget.getVerSpace(11.h),
  //                   Stack(
  //                     clipBehavior: Clip.none,
  //                     alignment: AlignmentDirectional.centerEnd,
  //                     children: [
  //                       Container(
  //                         height: 158.h,
  //                         decoration: BoxDecoration(
  //                             color: category4,
  //                             borderRadius: BorderRadius.circular(22.h)),
  //                         child: Row(
  //                           children: [
  //                             ConstantWidget.getHorSpace(20.h),
  //                             Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: [
  //                                 getCustomText(
  //                                     "Custom Diet Plans",
  //                                     textColor,
  //                                     1,
  //                                     TextAlign.start,
  //                                     FontWeight.w700,
  //                                     22.sp),
  //                                 ConstantWidget.getVerSpace(4.h),
  //                                 Container(
  //                                   width: 203.h,
  //                                   child: ConstantWidget.getMultilineCustomFont(
  //                                       "Get Easy Homemade Diet Plans As Per Need",
  //                                       12.sp,
  //                                       descriptionColor,
  //                                       fontWeight: FontWeight.w500,
  //                                       textAlign: TextAlign.start,
  //                                       txtHeight: 1.25.h),
  //                                 ),
  //                                 ConstantWidget.getVerSpace(12.h),
  //                                 Container(
  //                                   width: 203.h,
  //                                   child:
  //                                       ConstantWidget.getMultilineCustomFont(
  //                                           "", 12.sp, descriptionColor,
  //                                           fontWeight: FontWeight.w500,
  //                                           textAlign: TextAlign.start,
  //                                           txtHeight: 1.25.h),
  //                                 ),
  //                                 ConstantWidget.getVerSpace(0.h),
  //                                 Row(
  //                                   children: [
  //                                     getCustomText(
  //                                         "Let’s Start",
  //                                         textColor,
  //                                         1,
  //                                         TextAlign.start,
  //                                         FontWeight.w600,
  //                                         16.sp),
  //                                     ConstantWidget.getHorSpace(6.h),
  //                                     getSvgImage("arrow_right.svg",
  //                                         height: 24.h,
  //                                         width: 24.h,
  //                                         color: textColor)
  //                                   ],
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Positioned(
  //                           // top: -60.h,
  //                           // right: 15.h,
  //                           height: 155.h,
  //                           width: 170.h,
  //                           child: Padding(
  //                             padding: EdgeInsetsDirectional.only(
  //                                 end: 15.h, bottom: 0.h),
  //                             child: getAssetImage(
  //                               "plan_1.png",
  //                             ),
  //                           ))
  //                     ],
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  Column buildPlan() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConstantWidget.getPaddingWidget(
          EdgeInsets.symmetric(horizontal: 20.h),
          getCustomText(
              "My Plan", textColor, 1, TextAlign.start, FontWeight.w700, 20.sp),
        ),
        ConstantWidget.getVerSpace(12.h),
        Container(
          height: 169.h,
          child: InkWell(
            onTap: () {
              controller.onChange(2.obs);
            },
            child: Container(
              margin: EdgeInsetsDirectional.only(end: 20.h, start: 20.h),
              child: Column(
                children: [
                  ConstantWidget.getVerSpace(11.h),
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: AlignmentDirectional.centerEnd,
                    children: [
                      Container(
                        height: 158.h,
                        decoration: BoxDecoration(
                            color: category2,
                            // color: "FFF3D0".toColor(),
                            borderRadius: BorderRadius.circular(22.h)),
                        child: Row(
                          children: [
                            ConstantWidget.getHorSpace(20.h),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                getCustomText("Custom Workout", textColor, 1,
                                    TextAlign.start, FontWeight.w700, 22.sp),
                                ConstantWidget.getVerSpace(4.h),
                                Container(
                                  width: 203.h,
                                  child: ConstantWidget.getMultilineCustomFont(
                                      "Add your custom plan by tapping to create a new plan",
                                      12.sp,
                                      descriptionColor,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.start,
                                      txtHeight: 1.25.h),
                                ),
                                ConstantWidget.getVerSpace(12.h),
                                Row(
                                  children: [
                                    getCustomText(
                                        "Let’s Start",
                                        textColor,
                                        1,
                                        TextAlign.start,
                                        FontWeight.w600,
                                        16.sp),
                                    ConstantWidget.getHorSpace(6.h),
                                    getSvgImage("arrow_right.svg",
                                        height: 24.h,
                                        width: 24.h,
                                        color: textColor)
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          // top: -60.h,
                          // right: 15.h,
                          height: 263.h,
                          width: 170.h,
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                                end: 15.h, bottom: 15.h),
                            child: getAssetImage(
                              "plan.png",
                            ),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }  

  CategoryController catController = Get.put(CategoryController());
  Widget buildDiet() {
    return GetBuilder<GetXNetworkManager>(
      init: GetXNetworkManager(),
      builder: (GetxController controller) {
        return GetBuilder(
          init: CategoryController(),
          builder: (controller) {
            if (!catController.isLoading &&
                catController.dietCategory != null) {
              DietCategoryModel? modelWorkout = catController.dietCategory;
              if (modelWorkout!.data != null &&
                  modelWorkout.data!.success == 1) {
                List<Dietcategory> dietCategory =
                    modelWorkout.data!.dietcategory ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstantWidget.getPaddingWidget(
                      EdgeInsets.symmetric(horizontal: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getCustomText(
                            "Diet Plans",
                            textColor,
                            1,
                            TextAlign.start,
                            FontWeight.w700,
                            20.sp,
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.dietListRoute);
                            },
                            child: getCustomText("See all", descriptionColor, 1,
                                TextAlign.end, FontWeight.w500, 15.sp),
                          )
                        ],
                      ),
                    ),
                    ConstantWidget.getVerSpace(12.h),
                    Container(
                      height: 194.h,
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: [
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: dietCategory.length,
                              scrollDirection: Axis.horizontal,
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                Dietcategory _modelWorkoutList =
                                    dietCategory[index];

                                return GetBuilder<SettingController>(
                                  init: SettingController(),
                                  builder: (settingController) => Container(
                                    margin: EdgeInsetsDirectional.only(
                                        end: 18.h,
                                        start: index == 0 ? 20.h : 0),
                                    height: 194.h,
                                    width: 348.h,
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            Constants.sendToScreen1(
                                                  context,
                                                  SubDietCategory(
                                                      _modelWorkoutList
                                                          .dietCategoryId!,
                                                      _modelWorkoutList));
                                            // if (await ConstantUrl.isLogin()) {
                                            //   Constants.sendToScreen1(
                                            //       context,
                                            //       SubDietCategory(
                                            //           _modelWorkoutList
                                            //               .dietCategoryId!,
                                            //           _modelWorkoutList));
                                            // } else {
                                            //   // if (await PrefData
                                            //   //         .getFirstSignUp() ==
                                            //   //     true) {
                                            //   //   Get.toNamed(Routes.introRoute,
                                            //   //       arguments: () {
                                            //   //     if (settingController
                                            //   //         .isLogin.value) {
                                            //   //       Constants.sendToScreen1(
                                            //   //           context,
                                            //   //           SubDietCategory(
                                            //   //               _modelWorkoutList
                                            //   //                   .dietCategoryId!,
                                            //   //               _modelWorkoutList));
                                            //   //     }
                                            //   //   });
                                            //   // } else {
                                            //   ConstantUrl.sendLoginPage(context,
                                            //       function: () {
                                            //     if (settingController
                                            //         .isLogin.value) {
                                            //       Constants.sendToScreen1(
                                            //           context,
                                            //           SubDietCategory(
                                            //               _modelWorkoutList
                                            //                   .dietCategoryId!,
                                            //               _modelWorkoutList));
                                            //     }
                                            //   }, name: () {
                                            //     Get.back();
                                            //   });
                                            //   // }
                                            // }
                                          },
                                          child: Stack(
                                            alignment:
                                                AlignmentDirectional.bottomEnd,
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                width: 348.w,
                                                height: 182.h,
                                                decoration: BoxDecoration(
                                                    color:
                                                        getRandomColor(index),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            22.h)),
                                                padding:
                                                    EdgeInsetsDirectional.only(
                                                        start: 20.h),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ConstantWidget.getVerSpace(
                                                        20.h),
                                                    getCustomText(
                                                            _modelWorkoutList
                                                                .category!,
                                                            textColor,
                                                            3,
                                                            TextAlign.start,
                                                            FontWeight.w700,
                                                            20.sp)
                                                        .marginOnly(
                                                            right: 200.h),
                                                    ConstantWidget.getVerSpace(
                                                        10.h),
                                                  ],
                                                ),
                                              ),
                                              // Align(
                                              //   alignment:
                                              //   AlignmentDirectional
                                              //       .centerEnd,
                                              //   child: ClipRRect(
                                              //     borderRadius:
                                              //     BorderRadius
                                              //         .horizontal(
                                              //       right:
                                              //       Radius.circular(
                                              //           22.h),
                                              //     ),
                                              //     child: getAssetImage(
                                              //         "shape1.png",
                                              //         boxFit:
                                              //         BoxFit.fill,
                                              //         height: 176.h,
                                              //         width: 190.h),
                                              //   ),
                                              // ),
                                              Positioned(
                                                  height: 200.h,
                                                  width: 160.h,
                                                  // bottom: -3.h,
                                                  // right: 19.h,
                                                  child: Hero(
                                                    tag: _modelWorkoutList
                                                        .image!,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .only(end: 19.h),
                                                      child: CachedNetworkImage(
                                                        imageUrl: ConstantUrl
                                                                .uploadUrl +
                                                            _modelWorkoutList
                                                                .image!,
                                                      ),
                                                    ),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );

                                // return Container(
                                //   margin: EdgeInsetsDirectional.only(
                                //       end: 12.h, start: index == 0 ? 20.h : 0),
                                //   height: 209.h,
                                //   width: 177.h,
                                //   child: Column(
                                //     children: [
                                //       ConstantWidget.getVerSpace(13.h),
                                //       InkWell(
                                //         onTap: () {},
                                //         child: Stack(
                                //           clipBehavior: Clip.none,
                                //           alignment: Alignment.bottomRight,
                                //           children: [
                                //             Container(
                                //               alignment: Alignment.bottomRight,
                                //               height: 127.h,
                                //               width: 177.h,
                                //               decoration: BoxDecoration(
                                //                 color: getRandomColor(index),
                                //                 borderRadius:
                                //                     BorderRadius.circular(22.h),
                                //               ),
                                //             ),
                                //             // Align(
                                //             //   alignment: Alignment.bottomRight,
                                //             //   child: ClipRRect(
                                //             //     borderRadius: BorderRadius.only(
                                //             //         bottomRight:
                                //             //             Radius.circular(22.h)),
                                //             //     child: getAssetImage(
                                //             //         "shape_workout.png",
                                //             //         boxFit: BoxFit.fill,
                                //             //         height: 43.h,
                                //             //         width: 150.h,
                                //             //         color:
                                //             //             getCellShapeColor(index)),
                                //             //   ),
                                //             // ),
                                //             Align(
                                //                 alignment: Alignment.bottomCenter,
                                //                 child: Hero(
                                //                   tag: _modelWorkoutList.image!,
                                //                   child: CachedNetworkImage(
                                //                     height: 140.h,
                                //                     width: 160.h,
                                //                     imageUrl: ConstantUrl
                                //                             .uploadUrl +
                                //                         _modelWorkoutList.image!,
                                //                   ),
                                //                 )),
                                //           ],
                                //         ),
                                //       ),
                                //       ConstantWidget.getVerSpace(8.h),
                                //       ConstantWidget.getMultilineCustomFont(
                                //           _modelWorkoutList.category!,
                                //           18.sp,
                                //           textColor,
                                //           fontWeight: FontWeight.w600,
                                //           txtHeight: 1.1.h,
                                //           textAlign: TextAlign.center)
                                //     ],
                                //   ),
                                // );
                              }),
                          GetBuilder<SettingController>(
                            init: SettingController(),
                            builder: (controller) => Container(
                              // height: 194.h,
                              // decoration: BoxDecoration(
                              //     color: category4,
                              //     borderRadius: BorderRadius.circular(22.h)),
                              // width: 400.h,

                              alignment: Alignment.topLeft,
                              width: 348.w,
                              height: 182.h,
                              decoration: BoxDecoration(
                                  color: category4,
                                  borderRadius: BorderRadius.circular(22.h)),
                              // padding: EdgeInsetsDirectional.only(
                              //     start: 20.h),

                              margin:
                                  EdgeInsets.only(bottom: 12.h, right: 20.h),
                              child: InkWell(
                                onTap: () async {
                                  if (!i) {
                                    Get.to(InAppPurchase())!
                                        .then((value) => setState);
                                  } else {
                                    Get.toNamed(Routes.CustomDietPlanRoute);
                                    // if (await ConstantUrl.isLogin()) {
                                    //   Get.toNamed(Routes.CustomDietPlanRoute);
                                    // } else {
                                    //   ConstantUrl.sendLoginPage(context,
                                    //       function: () {
                                    //         if (controller.isLogin.value) {
                                    //           Get.toNamed(
                                    //               Routes.CustomDietPlanRoute);
                                    //         }
                                    //       }, name: () {
                                    //         Get.back();
                                    //       });
                                    // }
                                  }
                                },
                                child: Container(
                                    margin: EdgeInsetsDirectional.only(
                                        end: 20.h, start: 20.h),
                                    width: double.infinity,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      alignment: AlignmentDirectional.centerEnd,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 160.h,
                                              child: getCustomText(
                                                  "Custom Diet Plans",
                                                  textColor,
                                                  2,
                                                  TextAlign.start,
                                                  FontWeight.w700,
                                                  22.sp),
                                            ),
                                            ConstantWidget.getVerSpace(4.h),
                                            Container(
                                              width: 160.h,
                                              child: ConstantWidget
                                                  .getMultilineCustomFont(
                                                      "Get Easy Homemade Diet Plans As Per Need",
                                                      12.sp,
                                                      descriptionColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      textAlign:
                                                          TextAlign.start,
                                                      txtHeight: 1.25.h),
                                            ),
                                            ConstantWidget.getVerSpace(12.h),
                                            Row(
                                              children: [
                                                getCustomText(
                                                    "Let’s Start",
                                                    textColor,
                                                    1,
                                                    TextAlign.start,
                                                    FontWeight.w600,
                                                    16.sp),
                                                ConstantWidget.getHorSpace(6.h),
                                                getSvgImage("arrow_right.svg",
                                                    height: 24.h,
                                                    width: 24.h,
                                                    color: textColor)
                                              ],
                                            ),
                                            !i
                                                ? Container(
                                              margin: EdgeInsets.only(
                                                  top: 10.h),
                                              width: 85.h,
                                              padding:
                                              EdgeInsets.symmetric(
                                                  horizontal: 10.h,
                                                  vertical: 2.h),
                                              decoration: BoxDecoration(
                                                  color: bgDarkWhite,
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      20.h)),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  getAssetImage(
                                                      "crown.png",
                                                      height: 20.h,
                                                      width: 20.h),
                                                  10.h.horizontalSpace,
                                                  getCustomText(
                                                      "Pro",
                                                      textColor,
                                                      1,
                                                      TextAlign.start,
                                                      FontWeight.w600,
                                                      14.sp)
                                                ],
                                              ),
                                            )
                                                : 0.h.verticalSpace
                                          ],
                                        ),
                                        Positioned(
                                            // top: -60.h,
                                            // right: 15.h,
                                            height: 194.h,
                                            width: 170.h,
                                            child: Padding(
                                              padding:
                                                  EdgeInsetsDirectional.only(
                                                      end: 15.h, bottom: 0.h),
                                              child: getAssetImage(
                                                "plan_1.png",
                                              ),
                                            ))
                                      ],
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    // GridView.count(
                    //   crossAxisCount: 2,
                    //   childAspectRatio: 1.2,
                    //   padding: EdgeInsets.all(7),
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   children: List.generate(
                    //       (dietCategory.length >= 6)
                    //           ? 6
                    //           : dietCategory.length, (index) {
                    //     Dietcategory categoryModel = dietCategory[index];
                    //     return InkWell(
                    //       onTap: () {
                    //         Constants.sendToScreen1(
                    //           context,
                    //           SubDietCategory(categoryModel.dietCategoryId!,
                    //               categoryModel),
                    //         );
                    //       },
                    //       child: Card(
                    //         color: cellColor,
                    //         elevation: 1.0,
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(7),
                    //         ),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: <Widget>[
                    //             Expanded(
                    //               child: Padding(
                    //                 padding: EdgeInsets.only(
                    //                     left: 5, top: 5, right: 5),
                    //                 child: ClipRRect(
                    //                     borderRadius:
                    //                         BorderRadius.circular(7),
                    //                     child: buildNetworkImage(
                    //                         categoryModel.image!,
                    //                         imageWidth: double.infinity,
                    //                         fit: BoxFit.cover)),
                    //               ),
                    //               flex: 1,
                    //             ),
                    //             new Padding(
                    //               padding: EdgeInsets.all(8),
                    //               child: getCustomTextWidget(
                    //                   categoryModel.category!,
                    //                   textColor,
                    //                   1,
                    //                   TextAlign.start,
                    //                   FontWeight.w600,
                    //                   getWidthPercentSize(context, 4)),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     );
                    //   }),
                    // )
                  ],
                );
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          },
        );
      },
    );
  }

  FutureBuilder<ModelSetting?> buildWorkoutCategory() {
    return FutureBuilder<ModelSetting?>(
      future: getSetting(context),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          ModelSetting? modelSetting = snapshot.data;
          if (modelSetting!.data.success == 1) {
            Setting setting = modelSetting.data.setting;
            if (setting.category == "1") {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstantWidget.getPaddingWidget(
                    EdgeInsets.symmetric(horizontal: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        getCustomText(
                          "Workout Categories",
                          textColor,
                          1,
                          TextAlign.start,
                          FontWeight.w700,
                          20.sp,
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.workoutCategoryListRoute);
                          },
                          child: getCustomText("See all", descriptionColor, 1,
                              TextAlign.end, FontWeight.w500, 15.sp),
                        )
                      ],
                    ),
                  ),
                  ConstantWidget.getVerSpace(12.h),
                  FutureBuilder<ModelAllWorkout?>(
                    future: getYogaWorkout(context),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        ModelAllWorkout? modelWorkout = snapshot.data;

                        if (modelWorkout!.data.success == 1) {
                          List<Category>? workoutList =
                              modelWorkout.data.category;

                          return Container(
                            height: 209.h,
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: workoutList.length,
                                scrollDirection: Axis.horizontal,
                                primary: false,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  Category _modelWorkoutList =
                                      workoutList[index];

                                  ModelDummySend dummySend = new ModelDummySend(
                                      _modelWorkoutList.categoryId,
                                      _modelWorkoutList.category,
                                      ConstantUrl.urlGetWorkoutExercise,
                                      ConstantUrl.varCatId,
                                      getCellColor(index),
                                      _modelWorkoutList.image,
                                      true,
                                      _modelWorkoutList.description,
                                      CATEGORY_WORKOUT);

                                  return Container(
                                    margin: EdgeInsetsDirectional.only(
                                        end: 12.h,
                                        start: index == 0 ? 20.h : 0),
                                    height: 209.h,
                                    width: 177.h,
                                    child: Column(
                                      children: [
                                        ConstantWidget.getVerSpace(13.h),
                                        InkWell(
                                          onTap: () {
                                            checkIsProPlan(
                                                context: context,
                                                adsFile: adsFile!,
                                                isActive:
                                                    _modelWorkoutList.isActive,
                                                function: () {
                                                  Get.to(() =>
                                                      WorkoutCategoryExerciseList(
                                                          dummySend));
                                                });
                                          },
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              Container(
                                                alignment:
                                                    Alignment.bottomRight,
                                                height: 127.h,
                                                width: 177.h,
                                                decoration: BoxDecoration(
                                                  color: getCellColor(index),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          22.h),
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomRight:
                                                              Radius.circular(
                                                                  22.h)),
                                                  child: getAssetImage(
                                                      "shape_workout.png",
                                                      boxFit: BoxFit.fill,
                                                      height: 43.h,
                                                      width: 150.h,
                                                      color: getCellShapeColor(
                                                          index)),
                                                ),
                                              ),
                                              Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Hero(
                                                    tag:
                                                        _modelWorkoutList.image,
                                                    child: CachedNetworkImage(
                                                      height: 140.h,
                                                      width: 160.h,
                                                      imageUrl: ConstantUrl
                                                              .uploadUrl +
                                                          _modelWorkoutList
                                                              .image,
                                                    ),
                                                  )),
                                              Container(
                                                alignment:
                                                    Alignment.bottomRight,
                                                height: 127.h,
                                                width: 177.h,
                                                child: getProWidget(
                                                    isActive: _modelWorkoutList
                                                        .isActive,
                                                    context: context,
                                                    verSpace: 10.h),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ConstantWidget.getVerSpace(8.h),
                                        ConstantWidget.getMultilineCustomFont(
                                            _modelWorkoutList.category,
                                            18.sp,
                                            textColor,
                                            fontWeight: FontWeight.w600,
                                            txtHeight: 1.1.h,
                                            textAlign: TextAlign.center)
                                      ],
                                    ),
                                  );
                                }),
                          );
                        } else {
                          return getNoData(context);
                        }
                      } else {
                        return Container(
                          height: 209.h,
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: 4,
                              scrollDirection: Axis.horizontal,
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      right: 12.h, left: index == 0 ? 20.h : 0),
                                  height: 209.h,
                                  width: 177.h,
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Column(
                                      children: [
                                        ConstantWidget.getVerSpace(13.h),
                                        Stack(
                                          clipBehavior: Clip.none,
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            Container(
                                              alignment: Alignment.bottomRight,
                                              height: 127.h,
                                              width: 177.h,
                                              decoration: BoxDecoration(
                                                color: getCellColor(index),
                                                borderRadius:
                                                    BorderRadius.circular(22.h),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(22.h)),
                                                child: getAssetImage(
                                                    "shape_workout.png",
                                                    boxFit: BoxFit.fill,
                                                    height: 43.h,
                                                    width: 150.h,
                                                    color: getCellShapeColor(
                                                        index)),
                                              ),
                                            ),
                                            Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Container(
                                                  height: 140.h,
                                                  width: 160.h,
                                                ))
                                          ],
                                        ),
                                        ConstantWidget.getVerSpace(8.h),
                                        ConstantWidget.getMultilineCustomFont(
                                            "", 18.sp, textColor,
                                            fontWeight: FontWeight.w600,
                                            txtHeight: 1.1.h,
                                            textAlign: TextAlign.center)
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        );
                      }
                    },
                  )
                ],
              );
            }
          }
        } else if (snapshot.hasError) {
          // ConstantUrl.showToast(snapshot.error.toString(), context);
        } else {
          CircularProgressIndicator();
        }
        return Container();
      },
    );
  }

  FutureBuilder<Object?> buildWorkout() {
    return FutureBuilder<ModelSetting?>(
      future: getSetting(context),
      builder: (context, snapshot) {
        print("sna===${snapshot.data}");
        if (snapshot.hasData) {
          ModelSetting? modelSetting = snapshot.data;
          if (modelSetting!.data.success == 1) {
            Setting setting = modelSetting.data.setting;
            if (setting.challenges == "1") {
              return GetBuilder<HomeController>(
                init: HomeController(),
                builder: (controller) => Column(
                  children: [
                    FutureBuilder<ModelAllChallenge?>(
                      future: getAllChallenge(context),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          ModelAllChallenge? _modelAllChallenge = snapshot.data;
                          if (_modelAllChallenge!.data.success == 1) {
                            List<Challenge>? challengesList =
                                _modelAllChallenge.data.challenges;

                            double progress = (_modelAllChallenge
                                        .data
                                        .challenges[
                                            controller.progressIndex.value]
                                        .totaldayscompleted *
                                    100) /
                                _modelAllChallenge
                                    .data
                                    .challenges[controller.progressIndex.value]
                                    .totaldays;

                            if (progress > 100) {
                              progress = 100;
                            }
                            double sliderProgress = (_modelAllChallenge
                                    .data
                                    .challenges[controller.progressIndex.value]
                                    .totaldayscompleted) /
                                _modelAllChallenge
                                    .data
                                    .challenges[controller.progressIndex.value]
                                    .totaldays;

                            List<Container>? imageSliders = (challengesList !=
                                    null)
                                ? challengesList.map((item) {
                                    return Container(
                                      margin: EdgeInsetsDirectional.only(
                                          start: 20.h),
                                      child: FutureBuilder<PaletteGenerator?>(
                                        builder: (context, snapshot) {
                                          return Container(
                                            margin: EdgeInsets.only(
                                                right: 12.h, top: 18.h),
                                            height: 194.h,
                                            width: 348.h,
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    controller.onProgressChange(
                                                        challengesList
                                                            .indexOf(item)
                                                            .obs);

                                                    Get.to(() =>
                                                            WidgetChallengesExerciseList(
                                                              item,
                                                              bgColor: getWorkoutColor(
                                                                  int.parse(item
                                                                      .challengesId)),
                                                            ))!
                                                        .then((value) => {
                                                              controller
                                                                  .onProgressChange(
                                                                      0.obs)
                                                            });
                                                  },
                                                  child: Stack(
                                                    alignment:
                                                        AlignmentDirectional
                                                            .bottomEnd,
                                                    clipBehavior: Clip.none,
                                                    children: [
                                                      Container(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        width: 348.w,
                                                        height: 182.h,
                                                        decoration: BoxDecoration(
                                                            color: getWorkoutColor(
                                                                int.parse(item
                                                                    .challengesId)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        22.h)),
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .only(
                                                                    start:
                                                                        20.h),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            ConstantWidget
                                                                .getVerSpace(
                                                                    20.h),
                                                            getCustomText(
                                                                item.challengesName,
                                                                textColor,
                                                                1,
                                                                TextAlign.start,
                                                                FontWeight.w700,
                                                                20.sp),
                                                            ConstantWidget
                                                                .getVerSpace(
                                                                    10.h),
                                                            Row(
                                                              children: [
                                                                getSvgImage(
                                                                    "Clock.svg",
                                                                    height:
                                                                        14.h,
                                                                    width:
                                                                        14.h),
                                                                SizedBox(
                                                                  width: 7.h,
                                                                ),
                                                                getCustomText(
                                                                    "${item.totalweek} week",
                                                                    descriptionColor,
                                                                    1,
                                                                    TextAlign
                                                                        .start,
                                                                    FontWeight
                                                                        .w600,
                                                                    14.sp)
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                            AlignmentDirectional
                                                                .centerEnd,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .horizontal(
                                                            right:
                                                                Radius.circular(
                                                                    22.h),
                                                          ),
                                                          child: getAssetImage(
                                                              "shape1.png",
                                                              boxFit:
                                                                  BoxFit.fill,
                                                              height: 176.h,
                                                              width: 190.h),
                                                        ),
                                                      ),
                                                      Positioned(
                                                          height: 200.h,
                                                          width: 160.h,
                                                          // bottom: -3.h,
                                                          // right: 19.h,
                                                          child: Hero(
                                                            tag: item.image,
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .only(
                                                                          end: 19
                                                                              .h),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: ConstantUrl
                                                                        .uploadUrl +
                                                                    item.image,
                                                              ),
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }).toList()
                                : null;
                            return Column(
                              children: [
                                ConstantWidget.getPaddingWidget(
                                  EdgeInsets.symmetric(horizontal: 20.h),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.h),
                                        decoration: BoxDecoration(
                                            color: category3,
                                            // color: lightOrange,
                                            borderRadius:
                                                BorderRadius.circular(22.h)),
                                        child: Column(
                                          children: [
                                            ConstantWidget.getVerSpace(19.h),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ConstantWidget
                                                    .getMultilineCustomFont(
                                                        "Your Progress in this Week",
                                                        20.sp,
                                                        textColor,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        txtHeight: 1.5.h),
                                                CircularPercentIndicator(
                                                    radius: 30.h,
                                                    lineWidth: 4.h,
                                                    percent:
                                                        (sliderProgress > 1)
                                                            ? 1
                                                            : sliderProgress,
                                                    center: Text(
                                                        "${progress.toInt()}%",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14.sp,
                                                            foreground: Paint()
                                                              ..shader =
                                                                  LinearGradient(
                                                                      colors: [
                                                                    darken(
                                                                        category3,
                                                                        .3),
                                                                    darken(
                                                                        category3,
                                                                        .3),
                                                                    // Color(
                                                                    //     0xFFFF4E1B),

                                                                    // Color(
                                                                    //     0xFFFF7F37),
                                                                  ],
                                                                      stops: [
                                                                    0.0,
                                                                    1.0
                                                                  ]).createShader(
                                                                      Rect.fromLTWH(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0)))),
                                                    // linearGradient: LinearGradient(
                                                    //     begin: Alignment.topCenter,
                                                    //     end: Alignment.bottomCenter,
                                                    //     colors: <Color>[
                                                    //       Color(0xFFFF4E1B),
                                                    //       Color(0xFFFF7F37)
                                                    //     ],
                                                    //     stops: [
                                                    //       0.0,
                                                    //       1.0
                                                    //     ],
                                                    //   tileMode: TileMode.mirror
                                                    // ),
                                                    progressColor:
                                                        darken(category3, .3),
                                                    backgroundColor:
                                                        Colors.white,
                                                    rotateLinearGradient: true,
                                                    circularStrokeCap:
                                                        CircularStrokeCap.round)
                                              ],
                                            ),
                                            ConstantWidget.getVerSpace(19.h),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ConstantWidget.getVerSpace(12.h),
                                ConstantWidget.getPaddingWidget(
                                  EdgeInsets.symmetric(horizontal: 20.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      getCustomText(
                                        "Workout",
                                        textColor,
                                        1,
                                        TextAlign.start,
                                        FontWeight.w700,
                                        20.sp,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed(Routes.allWorkout);
                                        },
                                        child: getCustomText(
                                            "See all",
                                            descriptionColor,
                                            1,
                                            TextAlign.end,
                                            FontWeight.w500,
                                            15.sp),
                                      )
                                    ],
                                  ),
                                ),
                                ConstantWidget.getVerSpace(12.h),
                                Container(
                                  height: 200.h,
                                  child: ListView(
                                    primary: false,
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    children: imageSliders!,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          return Column(
                            children: [
                              ConstantWidget.getPaddingWidget(
                                EdgeInsets.symmetric(horizontal: 20.h),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Shimmer.fromColors(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.h),
                                        decoration: BoxDecoration(
                                            color: category3,
                                            borderRadius:
                                                BorderRadius.circular(22.h)),
                                        child: Column(
                                          children: [
                                            ConstantWidget.getVerSpace(19.h),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ConstantWidget
                                                    .getMultilineCustomFont(
                                                        "Your Progress in this Week",
                                                        20.sp,
                                                        textColor,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        txtHeight: 1.5.h),
                                                CircularPercentIndicator(
                                                    radius: 30.h,
                                                    lineWidth: 4.h,
                                                    percent: 0,
                                                    center: Text("${0}%",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 14.sp,
                                                            foreground: Paint()
                                                              ..shader =
                                                                  LinearGradient(
                                                                      colors: [
                                                                    darken(
                                                                        category3,
                                                                        .3),
                                                                    darken(
                                                                        category3,
                                                                        .3),
                                                                  ],
                                                                      stops: [
                                                                    0.0,
                                                                    1.0
                                                                  ]).createShader(
                                                                      Rect.fromLTWH(
                                                                          0.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0)))),
                                                    linearGradient:
                                                        LinearGradient(
                                                            begin: Alignment
                                                                .center,
                                                            end: Alignment
                                                                .center,
                                                            colors: <Color>[
                                                          darken(category3, .3),
                                                          darken(category3, .3),
                                                        ],
                                                            stops: [
                                                          0.0,
                                                          1.0
                                                        ]),
                                                    backgroundColor:
                                                        Colors.white,
                                                    rotateLinearGradient: true,
                                                    circularStrokeCap:
                                                        CircularStrokeCap.round)
                                              ],
                                            ),
                                            ConstantWidget.getVerSpace(19.h),
                                          ],
                                        ),
                                      ),
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                    ),
                                  ],
                                ),
                              ),
                              ConstantWidget.getVerSpace(12.h),
                              ConstantWidget.getPaddingWidget(
                                EdgeInsets.symmetric(horizontal: 20.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    getCustomText(
                                      "Workout",
                                      textColor,
                                      1,
                                      TextAlign.start,
                                      FontWeight.w700,
                                      20.sp,
                                    ),
                                    getCustomText(
                                        "See all",
                                        descriptionColor,
                                        1,
                                        TextAlign.end,
                                        FontWeight.w500,
                                        15.sp)
                                  ],
                                ),
                              ),
                              ConstantWidget.getVerSpace(12.h),
                              CarouselSlider(
                                  items: [
                                    Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            right: 12.h, top: 18.h),
                                        alignment: Alignment.topLeft,
                                        width: 348.w,
                                        height: 182.h,
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(22.h)),
                                      ),
                                    )
                                  ],
                                  options: CarouselOptions(
                                    height: 200.h,
                                    viewportFraction: 0.9.h,
                                    enlargeCenterPage: false,
                                    enableInfiniteScroll: true,
                                  ))
                            ],
                          );
                        }
                      },
                    )
                  ],
                ),
              );
            }
          }
        } else if (snapshot.hasError) {
        } else {
          CircularProgressIndicator();
        }
        return Container();
      },
    );
  }

  Future<PaletteGenerator?> updatePaletteGenerator(String image) async {
    PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(
      Image.network(ConstantUrl.uploadUrl + image).image,
    );
    return paletteGenerator;
  }
}
