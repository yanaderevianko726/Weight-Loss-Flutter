import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:women_workout/util/color_category.dart';
import 'package:women_workout/view/workout_category/workout_category.dart';

import '../../ads/ads_file.dart';
import '../../models/model_detail_exercise_list.dart';
import '../../models/model_dummy_send.dart';
import '../../util/constant_url.dart';
import '../../util/constant_widget.dart';
import '../../util/constants.dart';
import '../../util/service_provider.dart';
import '../../util/widgets.dart';
import '../controller/controller.dart';

class WorkoutCategoryExerciseList extends StatefulWidget {
  final ModelDummySend _modelWorkoutList;

  WorkoutCategoryExerciseList(this._modelWorkoutList);

  @override
  State<WorkoutCategoryExerciseList> createState() =>
      _WorkoutCategoryExerciseListState();
}

class _WorkoutCategoryExerciseListState
    extends State<WorkoutCategoryExerciseList> with TickerProviderStateMixin {
  ScrollController? _scrollViewController;
  bool isScrollingDown = false;

  AnimationController? animationController;
  Animation<double>? animation;

  double getCal = 0;
  int getTime = 0;
  List? priceList;

  AdsFile? adsFile;
  SettingController settingController = Get.find<SettingController>();

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    super.initState();
    Future.delayed(Duration.zero, () async {
      adsFile = new AdsFile(context);

      adsFile!.getFacebookBanner(setState);
      adsFile!.createAnchoredBanner(context, setState);
      adsFile!.createInterstitialAd(
          setState,
          await () {
                  Get.to(() => WorkoutCategory(
                      _list, widget._modelWorkoutList, getCal, getTime));
                }
          // await ConstantUrl.isLogin()
          //     ? () {
          //         Get.to(() => WorkoutCategory(
          //             _list, widget._modelWorkoutList, getCal, getTime));
          //       }
          //     : () {
          //         ConstantUrl.sendLoginPage(context, function: () {
          //           if (settingController.isLogin.value) {
          //             Get.to(() => WorkoutCategory(
          //                 _list, widget._modelWorkoutList, getCal, getTime));
          //           }
          //         }, name: () {
          //           Get.back();
          //         });
          //       }
          );
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

    disposeInterstitialAd(adsFile);
    disposeBannerAd(adsFile);
    super.dispose();
  }

  PageController controller = PageController();
  double margin = 0;
  List<Exercise> _list = [];

  @override
  Widget build(BuildContext context) {
    margin = ConstantWidget.getWidthPercentSize(context, 4);

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getColorStatusBar(widget._modelWorkoutList.color),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
                height: double.infinity,
                color: Colors.white,
                width: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ListView(
                        primary: true,
                        shrinkWrap: true,
                        children: [
                          buildImageWidget(),
                          ConstantWidget.getVerSpace(20.h),
                          ListView(
                            padding: EdgeInsets.symmetric(horizontal: 20.h),
                            primary: false,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: <Widget>[
                              FutureBuilder<ModelDetailExerciseList>(
                                future: getDetailExerciseList(
                                    context, widget._modelWorkoutList),
                                builder: (context, snapshot) {
                                  getCal = 0;
                                  getTime = 0;
                                  if (snapshot.hasData) {
                                    ModelDetailExerciseList
                                        modelExerciseDetailList =
                                        snapshot.data!;
                                    if (modelExerciseDetailList.data.success ==
                                        1) {
                                      _list =
                                          modelExerciseDetailList.data.exercise;

                                      _list.forEach((price) {
                                        getTime = getTime +
                                            int.parse(price.exerciseTime);
                                      });
                                      getCal = Constants.calDefaultCalculation *
                                          getTime;
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 13.h),
                                                decoration: BoxDecoration(
                                                    color: '#E5FFFD'.toColor(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.h)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    getAssetImage("clock1.png",
                                                        height: 30.h,
                                                        width: 30.h),
                                                    ConstantWidget.getHorSpace(
                                                        10.h),
                                                    getCustomText(
                                                        Constants
                                                            .getTimeFromSec(
                                                                getTime),
                                                        textColor,
                                                        1,
                                                        TextAlign.start,
                                                        FontWeight.w500,
                                                        15.sp)
                                                  ],
                                                ),
                                              )),
                                              ConstantWidget.getHorSpace(20.h),
                                              Expanded(
                                                  child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 13.h),
                                                decoration: BoxDecoration(
                                                    color: '#FFF6E3'.toColor(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.h)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    getAssetImage(
                                                        "calories.png",
                                                        height: 30.h,
                                                        width: 30.h),
                                                    ConstantWidget.getHorSpace(
                                                        10.h),
                                                    getCustomText(
                                                        "${Constants.calFormatter.format(getCal)} Calories",
                                                        textColor,
                                                        1,
                                                        TextAlign.start,
                                                        FontWeight.w500,
                                                        15.sp)
                                                  ],
                                                ),
                                              ))
                                            ],
                                          ),
                                          ConstantWidget.getVerSpace(20.h),
                                          getCustomText(
                                              widget._modelWorkoutList.name,
                                              textColor,
                                              1,
                                              TextAlign.start,
                                              FontWeight.w700,
                                              28.sp),
                                          ConstantWidget.getVerSpace(12.h),
                                          ListView.separated(
                                            separatorBuilder: (context, index) {
                                              return Container(
                                                height: 12.h,
                                                color: Colors.transparent,
                                              );
                                            },
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: _list.length,
                                            primary: false,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              Exercise _modelExerciseList =
                                                  _list[index];
                                              final Animation<double>
                                                  animation = Tween<double>(
                                                          begin: 0.0, end: 1.0)
                                                      .animate(
                                                CurvedAnimation(
                                                  parent: animationController!,
                                                  curve: Curves.fastOutSlowIn,
                                                ),
                                              );
                                              animationController!.forward();
                                              return AnimatedBuilder(
                                                  builder: (context, child) {
                                                    return FadeTransition(
                                                      opacity: animation,
                                                      child: Transform(
                                                        transform: Matrix4
                                                            .translationValues(
                                                                0.0,
                                                                50 *
                                                                    (1.0 -
                                                                        animation
                                                                            .value),
                                                                0.0),
                                                        child: Container(
                                                          height: 100.h,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      14.h),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color:
                                                                        containerShadow,
                                                                    blurRadius:
                                                                        32,
                                                                    offset:
                                                                        Offset(
                                                                            -2,
                                                                            5))
                                                              ],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          22.h)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      height:
                                                                          78.h,
                                                                      width:
                                                                          78.h,
                                                                      decoration: BoxDecoration(
                                                                          color:
                                                                              category2,
                                                                          borderRadius:
                                                                              BorderRadius.circular(12.h)),
                                                                      child: Image.network(ConstantUrl
                                                                              .uploadUrl +
                                                                          _modelExerciseList
                                                                              .image),
                                                                    ),
                                                                    ConstantWidget
                                                                        .getHorSpace(
                                                                            12.h),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          getCustomText(
                                                                              _modelExerciseList.exerciseName,
                                                                              textColor,
                                                                              1,
                                                                              TextAlign.start,
                                                                              FontWeight.w700,
                                                                              17.sp),
                                                                          ConstantWidget.getVerSpace(
                                                                              6.h),
                                                                          Row(
                                                                            children: [
                                                                              getSvgImage("Clock.svg", height: 14.h, width: 14.h),
                                                                              ConstantWidget.getHorSpace(6.h),
                                                                              getCustomText("${_modelExerciseList.exerciseTime} Second", descriptionColor, 1, TextAlign.start, FontWeight.w600, 13.sp)
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  showBottomDialog(
                                                                      _modelExerciseList);
                                                                },
                                                                child: getAssetImage(
                                                                    "play.png",
                                                                    height:
                                                                        40.h,
                                                                    width:
                                                                        40.h),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  animation:
                                                      animationController!);
                                            },
                                          )
                                        ],
                                      );
                                    } else {
                                      return getNoData(context);
                                    }
                                  } else {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Shimmer.fromColors(
                                              baseColor: Colors.grey.shade300,
                                              highlightColor:
                                                  Colors.grey.shade100,
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 13.h),
                                                decoration: BoxDecoration(
                                                    color: '#E5FFFD'.toColor(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.h)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    getAssetImage("clock1.png",
                                                        height: 30.h,
                                                        width: 30.h),
                                                    ConstantWidget.getHorSpace(
                                                        10.h),
                                                    getCustomText(
                                                        Constants
                                                            .getTimeFromSec(
                                                                getTime),
                                                        textColor,
                                                        1,
                                                        TextAlign.start,
                                                        FontWeight.w500,
                                                        15.sp)
                                                  ],
                                                ),
                                              ),
                                            )),
                                            ConstantWidget.getHorSpace(20.h),
                                            Expanded(
                                                child: Shimmer.fromColors(
                                              baseColor: Colors.grey.shade300,
                                              highlightColor:
                                                  Colors.grey.shade100,
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 13.h),
                                                decoration: BoxDecoration(
                                                    color: '#FFF6E3'.toColor(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.h)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    getAssetImage(
                                                        "calories.png",
                                                        height: 30.h,
                                                        width: 30.h),
                                                    ConstantWidget.getHorSpace(
                                                        10.h),
                                                    getCustomText(
                                                        "${Constants.calFormatter.format(getCal)} Calories",
                                                        textColor,
                                                        1,
                                                        TextAlign.start,
                                                        FontWeight.w500,
                                                        15.sp)
                                                  ],
                                                ),
                                              ),
                                            ))
                                          ],
                                        ),
                                        ConstantWidget.getVerSpace(20.h),
                                        getCustomText(
                                            widget._modelWorkoutList.name,
                                            textColor,
                                            1,
                                            TextAlign.start,
                                            FontWeight.w700,
                                            28.sp),
                                        ConstantWidget.getVerSpace(12.h),
                                        ListView.separated(
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount: 5,
                                          itemBuilder: (context, index) {
                                            return Shimmer.fromColors(
                                              baseColor: Colors.grey.shade300,
                                              highlightColor:
                                                  Colors.grey.shade100,
                                              child: Container(
                                                height: 100.h,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 14.h),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color:
                                                              containerShadow,
                                                          blurRadius: 32,
                                                          offset: Offset(-2, 5))
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            22.h)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            height: 78.h,
                                                            width: 78.h,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    lightOrange,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.h)),
                                                          ),
                                                          ConstantWidget
                                                              .getHorSpace(
                                                                  12.h),
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                getCustomText(
                                                                    "_modelExerciseList.exerciseName",
                                                                    textColor,
                                                                    1,
                                                                    TextAlign
                                                                        .start,
                                                                    FontWeight
                                                                        .w700,
                                                                    17.sp),
                                                                ConstantWidget
                                                                    .getVerSpace(
                                                                        6.h),
                                                                Row(
                                                                  children: [
                                                                    getSvgImage(
                                                                        "Clock.svg",
                                                                        height: 14
                                                                            .h,
                                                                        width: 14
                                                                            .h),
                                                                    ConstantWidget
                                                                        .getHorSpace(
                                                                            6.h),
                                                                    getCustomText(
                                                                        "${""} Second",
                                                                        descriptionColor,
                                                                        1,
                                                                        TextAlign
                                                                            .start,
                                                                        FontWeight
                                                                            .w600,
                                                                        13.sp)
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    getAssetImage("play.png",
                                                        height: 40.h,
                                                        width: 40.h)
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return Container(
                                              height: 12.h,
                                              color: Colors.transparent,
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  }
                                },
                              )

                              // buildList()
                            ],
                          )
                        ],
                      ),
                    ),
                    GetBuilder<SettingController>(
                      init: SettingController(),
                      builder: (controller) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.h),
                        child: ConstantWidget.getButtonWidget(
                            context, 'Start Workout', blueButton, () async {
                          // if (await ConstantUrl.isLogin()) {
                          //   showInterstitialAd(adsFile, () {
                          //     Get.to(() => WorkoutCategory(_list,
                          //         widget._modelWorkoutList, getCal, getTime));
                          //   }, setState);
                          // } else {
                          //   ConstantUrl.sendLoginPage(context, function: () {
                          //     if (controller.isLogin.value) {
                          //       showInterstitialAd(adsFile, () {
                          //         Get.to(() => WorkoutCategory(
                          //             _list,
                          //             widget._modelWorkoutList,
                          //             getCal,
                          //             getTime));
                          //       }, setState);
                          //     }
                          //   }, name: () {
                          //     Get.back();
                          //   });
                          // }
                          showInterstitialAd(adsFile, () async {
                            await Get.to(() => WorkoutCategory(_list,
                                    widget._modelWorkoutList, getCal, getTime));
                          }
                          //   await ConstantUrl.isLogin()
                          //       ? Get.to(() => WorkoutCategory(_list,
                          //           widget._modelWorkoutList, getCal, getTime))
                          //       : ConstantUrl.sendLoginPage(context,
                          //           function: () {
                          //           if (controller.isLogin.value) {
                          //             Get.to(() => WorkoutCategory(
                          //                 _list,
                          //                 widget._modelWorkoutList,
                          //                 getCal,
                          //                 getTime));
                          //           }
                          //         }, name: () {
                          //           Get.back();
                          //         });
                          // }
                          , setState);
                        }),
                      ),
                    ),
                    ConstantWidget.getVerSpace(20.h),
                    showBanner(adsFile),
                    ConstantWidget.getVerSpace(10.h),
                  ],
                ))),
      ),
      onWillPop: () async {
        onBackClicked();
        return false;
      },
    );
  }

  void showBottomDialog(Exercise exerciseDetail) {
    showModalBottomSheet<void>(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          decoration: getDecorationWithSide(
              radius: 22.h,
              bgColor: bgDarkWhite,
              isTopLeft: true,
              isTopRight: true),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            primary: false,
            children: [
              ConstantWidget.getVerSpace(44.h),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ConstantWidget.getCustomTextWidget(
                        'Info',
                        Colors.black,
                        22.sp,
                        FontWeight.w700,
                        TextAlign.start,
                        1),
                  ),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child:
                          getSvgImage("close.svg", height: 24.h, width: 24.h))
                ],
              ),
              ConstantWidget.getVerSpace(23.h),
              Image.network(
                "${ConstantUrl.uploadUrl}${exerciseDetail.image}",
                height: 332.h,
                width: 233.h,
                fit: BoxFit.fill,
              ),
              ConstantWidget.getVerSpace(16.h),
              getCustomText("How to perform?", textColor, 1, TextAlign.start,
                  FontWeight.w700, 20.sp),
              ConstantWidget.getVerSpace(13.h),
              HtmlWidget(
                Constants.decode(exerciseDetail.description),
                textStyle: TextStyle(
                    color: descriptionColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 17.sp,
                    height: 1.41.h,
                    fontFamily: Constants.fontsFamily),
              ),
              ConstantWidget.getVerSpace(34.h),
            ],
          ),
        );
      },
    );
  }

  Stack buildImageWidget() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 283.h,
          decoration: getDecorationWithSide(
              radius: 22.h,
              bgColor: widget._modelWorkoutList.color,
              isBottomLeft: true,
              isBottomRight: true),
          child: Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.symmetric(horizontal: 98.h),
            child: Hero(
              tag: widget._modelWorkoutList.image,
              child: Image.network(
                  ConstantUrl.uploadUrl + widget._modelWorkoutList.image),
            ),
          ),
        ),
        ConstantWidget.getPaddingWidget(
          EdgeInsets.symmetric(horizontal: 20.h),
          Column(
            children: [
              ConstantWidget.getVerSpace(23.h),
              InkWell(
                onTap: () {
                  onBackClicked();
                },
                child: getSvgImage("arrow_left.svg", width: 24.h, height: 24.h),
              )
            ],
          ),
        )
      ],
    );
  }

  void onBackClicked() {
    Get.back();
  }
}
