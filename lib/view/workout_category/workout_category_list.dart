import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shimmer/shimmer.dart';
import 'package:women_workout/view/workout_category/workout_category_exercise_list.dart';
import '../../ads/ads_file.dart';
import '../../iapurchase/prefrence.dart';
import '../../models/model_all_workout_category.dart';
import '../../models/model_dummy_send.dart';
import '../../util/color_category.dart';
import '../../util/constant_url.dart';
import '../../util/constant_widget.dart';
import '../../util/constants.dart';
import '../../util/service_provider.dart';
import '../../util/widgets.dart';

import 'package:get/get.dart';

class WorkoutCategoryList extends StatefulWidget {
  const WorkoutCategoryList({Key? key}) : super(key: key);

  @override
  State<WorkoutCategoryList> createState() => _WorkoutCategoryListState();
}

class _WorkoutCategoryListState extends State<WorkoutCategoryList>
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
                    child: FutureBuilder<ModelAllWorkout?>(
                      future: getYogaWorkout(context),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          ModelAllWorkout? modelWorkout = snapshot.data;

                          if (modelWorkout!.data.success == 1) {
                            List<Category>? workoutList =
                                modelWorkout.data.category;
                            return ListView.builder(
                              primary: true,
                              shrinkWrap: true,
                              itemCount: workoutList.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                Category _modelWorkoutList = workoutList[index];

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



                                    checkIsProPlan(
                                        context: context,
                                        adsFile: adsFile!,
                                        isActive:
                                        _modelWorkoutList.isActive,
                                        function: () {



                                          Get.to(() =>
                                              WorkoutCategoryExerciseList(dummySend));

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
                                            height: 140.h,
                                            margin:
                                                EdgeInsets.only(bottom: 20.h),
                                            child: Stack(
                                              children: [
                                                Column(
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
                                                          width: double.infinity,
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

                                                              getProWidget(isActive:  _modelWorkoutList.isActive, context: context,horSpace: 0,verSpace: 0)
                                                              ,

                                                              FutureBuilder<bool>(
                                                                future: Preferences.preferences
                                                                    .getBool(key: PrefernceKey.isProUser, defValue: false),
                                                                builder: (context, snapshot) {

                                                                  if(snapshot.data !=null && snapshot.data!){
                                                                    return ConstantWidget.getVerSpace(20.h);
                                                                  }else{
                                                                    return Container(
                                                                      height: 0,
                                                                      width: 0,
                                                                    );
                                                                  }

                                                                },
                                                              ),

                                                              ConstantWidget
                                                                  .getPaddingWidget(
                                                                EdgeInsets.only(
                                                                    right: 177.w),
                                                                ConstantWidget.getMultilineCustomFont(
                                                                    _modelWorkoutList
                                                                        .category,
                                                                    20.sp,
                                                                    textColor,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                    txtHeight:
                                                                    1.5.h),
                                                              ),



//                                                               getProWidget(isActive:  _modelWorkoutList.isActive, context: context,horSpace: 0)
// ,
//
//                                                               ConstantWidget
//                                                                   .getPaddingWidget(
//                                                                 EdgeInsets.only(
//                                                                     right: 177.w),
//                                                                 ConstantWidget.getMultilineCustomFont(
//                                                                     _modelWorkoutList
//                                                                         .category,
//                                                                     20.sp,
//                                                                     textColor,
//                                                                     fontWeight:
//                                                                         FontWeight
//                                                                             .w700,
//                                                                     txtHeight:
//                                                                         1.5.h),
//                                                               ),
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
                                                            child: Image.network(
                                                              ConstantUrl
                                                                      .uploadUrl +
                                                                  _modelWorkoutList
                                                                      .image,
                                                              fit: BoxFit.fill,
                                                            ))
                                                      ],
                                                    ),
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
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
