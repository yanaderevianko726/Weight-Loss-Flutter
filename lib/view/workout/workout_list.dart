import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palette_generator/palette_generator.dart';

import 'package:shimmer/shimmer.dart';
import 'package:women_workout/view/workout/widget_challenges_exercise_list.dart';
import '../../ads/ads_file.dart';
import '../../models/model_all_challenges.dart';
import '../../util/color_category.dart';
import '../../util/constant_url.dart';
import '../../util/constant_widget.dart';
import '../../util/service_provider.dart';
import '../../util/widgets.dart';

import 'package:get/get.dart';

import '../controller/controller.dart';

class WorkoutList extends StatefulWidget {
  const WorkoutList({Key? key}) : super(key: key);

  @override
  State<WorkoutList> createState() => _WorkoutListState();
}

class _WorkoutListState extends State<WorkoutList>
    with TickerProviderStateMixin {
  Future<bool> _requestPop() {
    Get.back();

    return new Future.value(false);
  }

  // List<ModalCategory> categoryList = DataFile.categoryList;
  ScrollController? _scrollViewController;
  bool isScrollingDown = false;

  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    Future.delayed(Duration.zero, () {
      adsFile = new AdsFile(context);
      adsFile!.createRewardedAd();
    });

    super.initState();

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
  }AdsFile? adsFile;

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
    setStatusBarColor(bgDarkWhite);
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: bgDarkWhite,
        body: SafeArea(
          child: ConstantWidget.getPaddingWidget(
            EdgeInsets.symmetric(horizontal: 20.h),
            Column(
              children: [
                ConstantWidget.getVerSpace(20.h),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          _requestPop();
                        },
                        child: getSvgImage("arrow_left.svg",
                            width: 24.h, height: 24.h)),
                    ConstantWidget.getHorSpace(12.h),
                    getCustomText("Workout Categories", textColor, 1,
                        TextAlign.start, FontWeight.w700, 22.sp)
                  ],
                ),
                ConstantWidget.getVerSpace(30.h),
                Expanded(
                    flex: 1,
                    child: GetBuilder<HomeController>(
                        init: HomeController(),
                        builder: (controller) {
                        return FutureBuilder<ModelAllChallenge?>(
                          future: getAllChallenge(context),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              ModelAllChallenge? modelWorkout = snapshot.data;

                              if (modelWorkout!.data.success == 1) {
                                List<Challenge>? workoutList =
                                    modelWorkout.data.challenges;
                                return ListView.builder(
                                  primary: true,
                                  shrinkWrap: true,
                                  itemCount: workoutList.length,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    Challenge item = workoutList[index];

                                    // ModelDummySend dummySend = new ModelDummySend(
                                    //     _modelWorkoutList.categoryId,
                                    //     _modelWorkoutList.category,
                                    //     ConstantUrl.urlGetWorkoutExercise,
                                    //     ConstantUrl.varCatId,
                                    //     getCellColor(index),
                                    //     _modelWorkoutList.image,
                                    //     true,
                                    //     _modelWorkoutList.description,
                                    //     CATEGORY_WORKOUT);

                                    final Animation<double> animation =
                                        Tween<double>(begin: 0.0, end: 1.0).animate(
                                      CurvedAnimation(
                                        parent: animationController!,
                                        curve: Curves.easeInOut,
                                      ),
                                    );
                                    animationController!.forward();
                                    return InkWell(
                                      onTap: () {

                                        controller.onProgressChange(
                                            workoutList
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

                                                child: FutureBuilder<PaletteGenerator?>(
                                                  builder: (context, snapshot) {
                                                    return Container(
                                                      margin: EdgeInsets.only(
                                                          right: 12.h,left: 12.h, top: 18.h),
                                                      height: 194.h,
                                                      child: Column(
                                                        children: [
                                                          Stack(
                                                            alignment:
                                                            AlignmentDirectional
                                                                .bottomEnd,
                                                            clipBehavior: Clip.none,
                                                            children: [
                                                              Container(
                                                                alignment:
                                                                Alignment.topLeft,
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
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return getNoData(context);
                              }
                            } else {
                              // return getProgressDialog();
                              return ListView.builder(
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
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
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
                                              height: 140.h,
                                              margin:
                                              EdgeInsets.only(bottom: 20.h),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                                children: [
                                                  ConstantWidget.getVerSpace(
                                                      13.h),
                                                  Stack(
                                                    clipBehavior: Clip.none,
                                                    alignment:
                                                    Alignment.bottomRight,
                                                    children: [
                                                      Container(
                                                        height: 127.h,
                                                        decoration: BoxDecoration(
                                                            color: getCellColor(
                                                                index),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                22.h)),
                                                        padding: EdgeInsets.only(
                                                            left: 40.h),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: [
                                                            ConstantWidget
                                                                .getPaddingWidget(
                                                              EdgeInsets.only(
                                                                  right: 177.w),
                                                              ConstantWidget.getMultilineCustomFont(
                                                                  "_modelWorkoutList.category",
                                                                  20.sp,
                                                                  textColor,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                                  txtHeight:
                                                                  1.5.h),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                        Alignment.bottomRight,
                                                        child: ClipRRect(
                                                            borderRadius:
                                                            BorderRadius.only(
                                                                bottomRight: Radius
                                                                    .circular(22
                                                                    .h)),
                                                            child: getAssetImage(
                                                                "shape_category.png",
                                                                boxFit:
                                                                BoxFit.fill,
                                                                height: 59.h,
                                                                width: 190.h,
                                                                color:
                                                                getCellShapeColor(
                                                                    index))),
                                                      ),
                                                      Positioned(
                                                          right: 35.h,
                                                          height: 140.h,
                                                          width: 131.h,
                                                          child: Container(),)
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        );
                      }
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
