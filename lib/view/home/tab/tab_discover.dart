import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../ads/ads_file.dart';
import '../../../iapurchase/prefrence.dart';
import '../../../models/model_discover.dart';
import '../../../models/model_dummy_send.dart';
import '../../../models/model_quick_workout.dart';
import '../../../models/model_stretches.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import '../../../util/color_category.dart';
import '../../../util/constant_url.dart';
import '../../../util/constant_widget.dart';

import '../../../util/constants.dart';
import '../../../util/service_provider.dart';
import '../../../util/widgets.dart';

import 'package:get/get.dart';

import '../../controller/controller.dart';
import '../../in_app_purchase.dart';
import '../../workout_category/workout_category_exercise_list.dart';

class TabDiscover extends StatefulWidget {
  @override
  _TabDiscover createState() => _TabDiscover();
}

class _TabDiscover extends State<TabDiscover> with TickerProviderStateMixin {
  ScrollController? _scrollViewController;
  bool isScrollingDown = false;

  AnimationController? animationController;
  Animation<double>? animation;
  AdsFile? adsFile;
  bool i = true;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    super.initState();
    inApp().then((value) {
      setState(() {
        i = value;
      });
    });
    Future.delayed(Duration.zero, () {
      adsFile = new AdsFile(context);
      adsFile!.createRewardedAd();
    });

    _scrollViewController = new ScrollController();
    _scrollViewController!.addListener(() {
      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          setState(() {});
        }
      }

      if (_scrollViewController!.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          setState(() {});
        }
      }
    });
  }

  Future<bool> inApp() async {
    return await checkInApp();
  }

  Future<bool> checkInApp() async {
    bool isPurchase = await Preferences.preferences
        .getBool(key: PrefernceKey.isProUser, defValue: false);

    return isPurchase;
  }

  HomeController homeController = Get.find();

  @override
  void dispose() {
    _scrollViewController!.removeListener(() {});
    _scrollViewController!.dispose();
    try {
      if (animationController != null) {
        animationController!.dispose();
      }
    } catch (e) {
      print(e);
    }
    disposeRewardedAd(adsFile);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: bgDarkWhite,
      child: Column(
        children: [
          ConstantWidget.getVerSpace(20.h),
          buildAppBar(),
          ConstantWidget.getVerSpace(30.h),
          Expanded(
            flex: 1,
            child: ListView(
              primary: true,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                buildDiscoverList(),
                ConstantWidget.getVerSpace(30.h),
                buildWorkoutForYou(),
                ConstantWidget.getVerSpace(30.h),
                buildStretchList(),
                ConstantWidget.getVerSpace(5.h),
                buildDietPlan(),
                ConstantWidget.getVerSpace(60.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
  buildDietPlan() {
    return  GetBuilder<SettingController>(
      init: SettingController(),
      builder: (controller) => Container(
        height: 169.h,
        margin: EdgeInsets.symmetric(vertical: 10.h),
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
            margin: EdgeInsetsDirectional.only(end: 20.h, start: 20.h),
            width: double.infinity,
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
                          color: category4,
                          borderRadius: BorderRadius.circular(22.h)),
                      child: Row(
                        children: [
                          ConstantWidget.getHorSpace(20.h),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              getCustomText(
                                  "Custom Diet Plans",
                                  textColor,
                                  1,
                                  TextAlign.start,
                                  FontWeight.w700,
                                  22.sp),
                              ConstantWidget.getVerSpace(4.h),
                              Container(
                                width: 203.h,
                                child: ConstantWidget.getMultilineCustomFont(
                                    "Get Easy Homemade Diet Plans As Per Need",
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
                        ],
                      ),
                    ),
                    Positioned(
                      // top: -60.h,
                      // right: 15.h,
                        height: 155.h,
                        width: 170.h,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(
                              end: 15.h, bottom: 0.h),
                          child: getAssetImage(
                            "plan_1.png",
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStretchList() {
    return FutureBuilder<ModelSetting?>(
      future: getSetting(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ModelSetting? modelSetting = snapshot.data;
          if (modelSetting!.data.success == 1) {
            Setting setting = modelSetting.data.setting;
            if (setting.stretches == "1") {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 20.h),
                    child: getCustomText('Stretches', textColor, 1,
                        TextAlign.start, FontWeight.w700, 20.sp),
                  ),
                  ConstantWidget.getVerSpace(12.h),
                  FutureBuilder<ModelStretches?>(
                    future: getAllStretch(context),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        ModelStretches? modelStretch = snapshot.data!;
                        if (modelStretch.data!.success == 1) {
                          List<Stretches> _quickWorkoutList =
                              modelStretch.data!.stretches!;
                          return ListView.builder(
                            padding: EdgeInsetsDirectional.only(
                                start: 20.h, end: 20.h),
                            primary: false,
                            shrinkWrap: true,
                            itemCount: _quickWorkoutList.length,
                            itemBuilder: (context, index) {
                              Stretches _modelQuickWorkout =
                                  _quickWorkoutList[index];
                              final Animation<double> animation =
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController!,
                                  curve: Curves.easeInOut,
                                ),
                              );
                              animationController!.forward();
                              return InkWell(
                                onTap: () async {
                                  checkIsProPlan(
                                      context: context,
                                      adsFile: adsFile!,
                                      isActive: _modelQuickWorkout.isActive!,
                                      function: () {
                                        ModelDummySend dummySend =
                                            new ModelDummySend(
                                                _modelQuickWorkout.stretchesId!,
                                                _modelQuickWorkout.stretches!,
                                                ConstantUrl
                                                    .urlGetStretchesExercise,
                                                ConstantUrl.varStretchesId,
                                                getStretchesColor(index),
                                                _modelQuickWorkout.image!,
                                                true,
                                                _modelQuickWorkout.description!,
                                                STRETCH_WORKOUT);
                                        Get.to(() =>
                                            WorkoutCategoryExerciseList(
                                                dummySend));
                                      });
                                },
                                child: AnimatedBuilder(
                                  animation: animationController!,
                                  builder: (context, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: Transform(
                                        transform: Matrix4.translationValues(
                                            0.0,
                                            50 * (1.0 - animation.value),
                                            0.0),
                                        child: Container(
                                            margin: EdgeInsetsDirectional.only(
                                                bottom: 12.h),
                                            height: 100.h,
                                            decoration: BoxDecoration(
                                                color: getStretchesColor(index),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        22.h)),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.h,
                                                vertical: 4.h),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      getProWidget(
                                                          isActive:
                                                              _modelQuickWorkout
                                                                  .isActive!,
                                                          context: context,
                                                          verSpace: 3.h,
                                                          horSpace: 0),
                                                      FutureBuilder<bool>(
                                                        future: Preferences
                                                            .preferences
                                                            .getBool(
                                                                key: PrefernceKey
                                                                    .isProUser,
                                                                defValue:
                                                                    false),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot.data !=
                                                                  null &&
                                                              !snapshot.data!) {
                                                            return ConstantWidget
                                                                .getVerSpace(
                                                                    15.h);
                                                          } else {
                                                            return Container(
                                                              height: 0,
                                                              width: 0,
                                                            );
                                                          }
                                                        },
                                                      ),
                                                      ConstantWidget
                                                          .getMultilineCustomFont(
                                                              _modelQuickWorkout
                                                                  .stretches!,
                                                              18.sp,
                                                              textColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              txtHeight:
                                                                  1.29.h),
                                                    ],
                                                  ),
                                                  flex: 1,
                                                ),
                                                Hero(
                                                    tag: _modelQuickWorkout
                                                        .image!,
                                                    child: Image.network(
                                                        ConstantUrl.uploadUrl +
                                                            _modelQuickWorkout
                                                                .image!,
                                                        width: 88.h))
                                              ],
                                            )),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20.h),
                          primary: false,
                          shrinkWrap: true,
                          itemCount: 7,
                          itemBuilder: (context, index) {
                            final Animation<double> animation =
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                              CurvedAnimation(
                                parent: animationController!,
                                curve: Curves.easeInOut,
                              ),
                            );
                            animationController!.forward();
                            return AnimatedBuilder(
                              animation: animationController!,
                              builder: (context, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: Transform(
                                    transform: Matrix4.translationValues(
                                        0.0, 50 * (1.0 - animation.value), 0.0),
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                          margin: EdgeInsets.only(bottom: 12.h),
                                          height: 81.h,
                                          decoration: BoxDecoration(
                                              color: getStretchesColor(index),
                                              borderRadius:
                                                  BorderRadius.circular(22.h)),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.h, vertical: 4.h),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ConstantWidget.getMultilineCustomFont(
                                                  "_modelQuickWorkout.stretches!",
                                                  17.sp,
                                                  textColor,
                                                  fontWeight: FontWeight.w700,
                                                  txtHeight: 1.29.h),
                                              Container(width: 88.h)
                                            ],
                                          )),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
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

  Widget buildWorkoutForYou() {
    return FutureBuilder<ModelSetting?>(
      future: getSetting(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ModelSetting? modelSetting = snapshot.data;
          if (modelSetting!.data.success == 1) {
            Setting setting = modelSetting.data.setting;
            if (setting.quickworkout == "1") {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(start: 20.h),
                    child: getCustomText('Workout For You', textColor, 1,
                        TextAlign.start, FontWeight.w700, 20.sp),
                  ),
                  ConstantWidget.getVerSpace(12.h),
                  FutureBuilder<ModelQuickWorkout?>(
                    future: getAllYogaStyleWorkout(
                      context,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        ModelQuickWorkout? _quickWorkout = snapshot.data!;
                        if (_quickWorkout.data!.success == 1) {
                          List<Quickworkout>? _quickWorkoutList =
                              _quickWorkout.data!.quickworkout;
                          return Container(
                            height: 199.h,
                            child: ListView.builder(
                              itemCount: _quickWorkoutList!.length,
                              primary: false,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                Quickworkout _modelQuickWorkout =
                                    _quickWorkoutList[index];
                                return InkWell(
                                  onTap: () {
                                    checkIsProPlan(
                                        context: context,
                                        adsFile: adsFile!,
                                        isActive: _modelQuickWorkout.isActive!,
                                        function: () {
                                          ModelDummySend dummySend =
                                              new ModelDummySend(
                                                  _modelQuickWorkout
                                                      .quickworkoutId!,
                                                  _modelQuickWorkout
                                                      .quickworkout!,
                                                  ConstantUrl
                                                      .urlGetQuickWorkoutExercise,
                                                  ConstantUrl.varQuickWorkoutId,
                                                  getQuickWorkoutColor(index),
                                                  _modelQuickWorkout.image!,
                                                  true,
                                                  _modelQuickWorkout.desc!,
                                                  QUICK_WORKOUT);

                                          Get.to(() =>
                                              WorkoutCategoryExerciseList(
                                                  dummySend));
                                        });
                                  },
                                  child: Container(
                                    margin: EdgeInsetsDirectional.only(
                                        end: 20.h,
                                        start: index == 0 ? 20.h : 0),
                                    width: 348.h,
                                    decoration: BoxDecoration(
                                        color: getQuickWorkoutColor(index),
                                        borderRadius:
                                            BorderRadius.circular(22.h)),
                                    child: Stack(
                                      children: [
                                        Row(
                                          children: [
                                            Stack(
                                              clipBehavior: Clip.none,
                                              alignment: Alignment.centerLeft,
                                              children: [
                                                Container(
                                                  width: 95.h,
                                                  margin: EdgeInsets.only(
                                                      top: 30.h, bottom: 27.h),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          getQuickWorkoutShapeColor(
                                                              index),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topRight: Radius
                                                                  .circular(
                                                                      22.h),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      22.h))),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: ConstantWidget
                                                      .getPaddingWidget(
                                                    EdgeInsets.only(
                                                        top: 16.h,
                                                        bottom: 27.h),
                                                    Image.network(
                                                      ConstantUrl.uploadUrl +
                                                          _modelQuickWorkout
                                                              .image
                                                              .toString(),
                                                      width: 100.h,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            ConstantWidget.getHorSpace(34.h),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ConstantWidget
                                                      .getMultilineCustomFont(
                                                          _modelQuickWorkout
                                                                  .quickworkout ??
                                                              '',
                                                          20.sp,
                                                          textColor,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          txtHeight: 1.5.h),
                                                  // ConstantWidget.getVerSpace(8.h),
                                                  // Row(
                                                  //   children: [
                                                  //     getSvgImage("Clock.svg",
                                                  //         width: 14.h, height: 14.h),
                                                  //     ConstantWidget.getHorSpace(11.h),
                                                  //     getCustomText("4 week", descriptionColor, 1,
                                                  //         TextAlign.start, FontWeight.w600, 14.sp)
                                                  //   ],
                                                  // ),
                                                  // ConstantWidget.getVerSpace(12.h),
                                                  // Row(
                                                  //   children: [
                                                  //     getSvgImage("dumble.svg",
                                                  //         height: 16.h, width: 16.h),
                                                  //     ConstantWidget.getHorSpace(6.h),
                                                  //     getCustomText(
                                                  //         "14 exercise",
                                                  //         descriptionColor,
                                                  //         1,
                                                  //         TextAlign.start,
                                                  //         FontWeight.w600,
                                                  //         14.sp)
                                                  //   ],
                                                  // )
                                                ],
                                              ),
                                            )
                                          ],
                                        ).paddingOnly(left: 37.h, right: 34.h),
                                        getProWidget(
                                            isActive:
                                                _modelQuickWorkout.isActive!,
                                            context: context,
                                            verSpace: 15.h,
                                            alignment: Alignment.topRight),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container(
                          height: 199.h,
                          child: ListView.builder(
                            itemCount: 3,
                            primary: false,
                            shrinkWrap: true,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: 20.h, left: index == 0 ? 20.h : 0),
                                  width: 348.h,
                                  padding:
                                      EdgeInsets.only(left: 37.h, right: 34.h),
                                  decoration: BoxDecoration(
                                      color: getQuickWorkoutColor(index),
                                      borderRadius:
                                          BorderRadius.circular(22.h)),
                                  child: Row(
                                    children: [
                                      Stack(
                                        clipBehavior: Clip.none,
                                        alignment: Alignment.centerLeft,
                                        children: [
                                          Container(
                                            width: 95.h,
                                            margin: EdgeInsets.only(
                                                top: 30.h, bottom: 27.h),
                                            decoration: BoxDecoration(
                                                color:
                                                    getQuickWorkoutShapeColor(
                                                        index),
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(22.h),
                                                    bottomLeft:
                                                        Radius.circular(22.h))),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child:
                                                ConstantWidget.getPaddingWidget(
                                                    EdgeInsets.only(
                                                        top: 16.h,
                                                        bottom: 27.h),
                                                    Container(
                                                      width: 100.h,
                                                    )),
                                          )
                                        ],
                                      ),
                                      ConstantWidget.getHorSpace(34.h),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ConstantWidget
                                                .getMultilineCustomFont(
                                                    '', 20.sp, textColor,
                                                    fontWeight: FontWeight.w700,
                                                    txtHeight: 1.5.h),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
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

  FutureBuilder<Object?> buildDiscoverList() {
    return FutureBuilder<ModelSetting?>(
      future: getSetting(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ModelSetting? modelSetting = snapshot.data;
          if (modelSetting!.data.success == 1) {
            Setting setting = modelSetting.data.setting;
            if (setting.discover == "1") {
              return FutureBuilder<ModelDiscover?>(
                future: getAllDiscover(
                  context,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    ModelDiscover? _modelDiscover = snapshot.data!;
                    if (_modelDiscover.data.success == 1) {
                      List<Discover>? _discoverList =
                          _modelDiscover.data.discover;

                      return Container(
                        height: 290.h,
                        child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: _discoverList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            Discover discover = _discoverList[index];
                            return Container(
                              margin: EdgeInsetsDirectional.only(
                                  end: 20.h, start: index == 0 ? 20.h : 0),
                              child: InkWell(
                                onTap: () {
                                  checkIsProPlan(
                                      context: context,
                                      adsFile: adsFile!,
                                      isActive: discover.isActive,
                                      function: () {
                                        ModelDummySend dummySend =
                                            new ModelDummySend(
                                                discover.discoverId,
                                                discover.discover,
                                                ConstantUrl
                                                    .urlGetDiscoverExercise,
                                                ConstantUrl.varDiscoverId,
                                                getDiscoverWorkoutColor(index),
                                                discover.image,
                                                false,
                                                discover.description,
                                                DISCOVER_WORKOUT);

                                        Get.to(() =>
                                            WorkoutCategoryExerciseList(
                                                dummySend));
                                      });
                                },
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Column(
                                      children: [
                                        ConstantWidget.getVerSpace(35.h),
                                        Container(
                                          height: 255.h,
                                          width: 252.h,
                                          decoration: BoxDecoration(
                                              color: getDiscoverWorkoutColor(
                                                  index),
                                              borderRadius:
                                                  BorderRadius.circular(22.h)),
                                          alignment: Alignment.bottomLeft,
                                          padding: EdgeInsets.only(
                                              top: 48.88.h, right: 59.h),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(22.h)),
                                            child: getAssetImage(
                                                getDiscoverWorkoutShape(index)),
                                          ),
                                        )
                                      ],
                                    ),
                                    Positioned(
                                        child: Hero(
                                      tag: discover.image,
                                      child: Container(
                                        height: 290.h,
                                        width: 252.h,
                                        child: Image.network(
                                            ConstantUrl.uploadUrl +
                                                discover.image),
                                      ),
                                    )),
                                    Positioned(
                                        child: Container(
                                      height: 113.h,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              textColor.withOpacity(0.0),
                                              textColor.withOpacity(0.56)
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(22.h)),
                                      width: 252.h,
                                    )),
                                    Positioned(
                                      child: getCustomText(
                                          discover.discover,
                                          Colors.white,
                                          1,
                                          TextAlign.center,
                                          FontWeight.w700,
                                          28.sp),
                                      bottom: 23.h,
                                    ),
                                    Positioned.fill(
                                      child: getProWidget(
                                          isActive: discover.isActive,
                                          context: context,
                                          verSpace: 48.h,
                                          alignment: Alignment.topRight,
                                          horSpace: 5.w),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      return Container();
                    }
                  } else {
                    return Container(
                      height: 290.h,
                      child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: 3,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: 20.h, left: index == 0 ? 20.h : 0),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Column(
                                    children: [
                                      ConstantWidget.getVerSpace(35.h),
                                      Container(
                                        height: 255.h,
                                        width: 252.h,
                                        decoration: BoxDecoration(
                                            color:
                                                getDiscoverWorkoutColor(index),
                                            borderRadius:
                                                BorderRadius.circular(22.h)),
                                        alignment: Alignment.bottomLeft,
                                        padding: EdgeInsets.only(
                                            top: 48.88.h, right: 59.h),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft:
                                                  Radius.circular(22.h)),
                                          child: getAssetImage(
                                              getDiscoverWorkoutShape(index)),
                                        ),
                                      )
                                    ],
                                  ),
                                  Positioned(
                                      child: Container(
                                    height: 290.h,
                                    width: 252.h,
                                  )),
                                  Positioned(
                                      child: Container(
                                    height: 113.h,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            textColor.withOpacity(0.0),
                                            textColor.withOpacity(0.56)
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(22.h)),
                                    width: 252.h,
                                  )),
                                  Positioned(
                                    child: getCustomText(
                                        "discover.discover",
                                        Colors.white,
                                        1,
                                        TextAlign.center,
                                        FontWeight.w700,
                                        28.sp),
                                    bottom: 23.h,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
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

  Widget buildAppBar() {
    return ConstantWidget.getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                  child:
                      getSvgImage("arrow_left.svg", width: 24.h, height: 24.h),
                  onTap: () {
                    homeController.onChange(0.obs);
                  }),
              ConstantWidget.getHorSpace(12.h),
              getCustomText("Discover Workout", textColor, 1, TextAlign.start,
                  FontWeight.w700, 22.sp)
            ],
          ),
        ],
      ),
    );
  }
}
