
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'package:shimmer/shimmer.dart';
import 'package:women_workout/view/custom_workout/select_workout.dart';
import 'package:women_workout/view/custom_workout/workout_custom.dart';
import '../../ads/ads_file.dart';
import '../../data/dummy_data.dart';
import '../../dialog/bottom_dialog.dart';
import '../../models/model_dummy_send.dart';
import '../../models/model_get_custom_plan_exercise.dart';
import '../../routes/app_routes.dart';
import '../../util/color_category.dart';
import '../../util/constant_url.dart';
import '../../util/constant_widget.dart';
import '../../util/constants.dart';
import '../../util/service_provider.dart';
import '../../util/widgets.dart';

import 'package:get/get.dart';

class SelectedList extends StatefulWidget {
  final ModelDummySend _modelCustomList;

  SelectedList(this._modelCustomList);

  @override
  State<SelectedList> createState() => _SelectedListState();
}

class _SelectedListState extends State<SelectedList>
    with TickerProviderStateMixin {
  Future<bool> _requestPop() {
    Get.toNamed(Routes.homeScreenRoute);

    return new Future.value(false);
  }

  ScrollController? _scrollViewController;
  bool isScrollingDown = false;

  AnimationController? animationController;
  Animation<double>? animation;
  double getCal = 0;
  int getTime = 0;
  AdsFile? adsFile;

  @override
  void initState() {
    DummyData.removeAllData();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    super.initState();
    Future.delayed(Duration.zero, () {
      adsFile = new AdsFile(context);
      adsFile!.getFacebookBanner(setState);
      adsFile!.createAnchoredBanner(context, setState);
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
    disposeInterstitialAd(adsFile);
    disposeBannerAd(adsFile);
    _scrollViewController!.removeListener(() {});
    _scrollViewController!.dispose();
    try {
      if (animationController != null) {
        animationController!.dispose();
      }
    } catch (e) {
      print(e);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              ConstantWidget.getVerSpace(20.h),
              buildAppBar(),
              ConstantWidget.getVerSpace(20.h),
              buildSelectedList(),
              buildDoneButton(context),
              ConstantWidget.getVerSpace(20.h),
              showBanner(adsFile),
              ConstantWidget.getVerSpace(10.h),
            ],
          ),
        ),
      ),
    );
  }

  void showBottomDialog(Exercisedetail exercisedetail) {
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
                "${ConstantUrl.uploadUrl}${exercisedetail.image}",
                height: 332.h,
                width: 233.h,
                fit: BoxFit.fill,
              ),
              ConstantWidget.getVerSpace(16.h),
              getCustomText("How to perform?", textColor, 1, TextAlign.start,
                  FontWeight.w700, 20.sp),
              ConstantWidget.getVerSpace(13.h),
              HtmlWidget(
                Constants.decode(exercisedetail.description),
                textStyle: TextStyle(
                    color: descriptionColor,
                    fontSize: 17.sp,
                    fontFamily: Constants.fontsFamily,
                    fontWeight: FontWeight.w500,
                    height: 1.41.h),
              ),
              ConstantWidget.getVerSpace(34.h),
            ],
          ),
        );
      },
    );
  }

  List<Exercisedetail>? list;
  List<Customplanexercise>? customPlanExerciseList;
  ModelGetCustomPlanExercise? modelGetCustomPlanExercise;

  Expanded buildSelectedList() {
    return Expanded(
      flex: 1,
      child: FutureBuilder<ModelGetCustomPlanExercise?>(
        future: getCustomPlanExercise(context),
        builder: (context, snapshot) {
          getCal = 0;
          getTime = 0;
          if (snapshot.hasData && snapshot.data != null) {
            modelGetCustomPlanExercise = snapshot.data;

            print(
                "refresh===true====${modelGetCustomPlanExercise!.data.idList.length}");

            if (modelGetCustomPlanExercise!.data.success == 1) {
              customPlanExerciseList =
                  modelGetCustomPlanExercise?.data.customplanexercise;

              customPlanExerciseList!.forEach((price) {
                getTime = getTime + int.parse(price.exerciseTime!);
              });

              getCal = Constants.calDefaultCalculation * getTime;
              return ListView.builder(
                padding: EdgeInsets.only(left: 20.h, right: 20.h),
                primary: true,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: customPlanExerciseList?.length,
                itemBuilder: (context, index) {
                  Customplanexercise customplanexercise =
                      customPlanExerciseList![index];

                  // list = customPlanExerciseList[index].exercisedetail.;

                  Exercisedetail exercisedetail =
                      customplanexercise.exercisedetail;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController!,
                      curve: Curves.fastOutSlowIn,
                    ),
                  );
                  animationController!.forward();
                  return GestureDetector(
                    onTap: () {
                      showBottomDialog(exercisedetail);
                    },
                    child: AnimatedBuilder(
                      animation: animationController!,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: Transform(
                            transform: Matrix4.translationValues(
                                0.0, 50 * (1.0 - animation.value), 0.0),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20.h),
                              padding: EdgeInsets.only(
                                  left: 12.h,
                                  top: 12.h,
                                  bottom: 12.h,
                                  right: 20.h),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22.h),
                                  boxShadow: [
                                    BoxShadow(
                                        color: containerShadow,
                                        blurRadius: 32,
                                        offset: Offset(-2, 5))
                                  ]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 78.h,
                                          width: 78.h,
                                          decoration: BoxDecoration(
                                              color: lightOrange,
                                              borderRadius:
                                                  BorderRadius.circular(12.h)),
                                          child: Image.network(
                                              ConstantUrl.uploadUrl +
                                                  exercisedetail.image),
                                        ),
                                        ConstantWidget.getHorSpace(12.h),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              getCustomText(
                                                  exercisedetail.exerciseName,
                                                  textColor,
                                                  1,
                                                  TextAlign.start,
                                                  FontWeight.w700,
                                                  17.sp),
                                              ConstantWidget.getVerSpace(12.h),
                                              Row(
                                                children: [
                                                  getSvgImage("Clock.svg",
                                                      width: 15.h,
                                                      height: 15.h),
                                                  ConstantWidget.getHorSpace(
                                                      7.h),
                                                  getCustomText(
                                                      "${customplanexercise.exerciseTime}s",
                                                      descriptionColor,
                                                      1,
                                                      TextAlign.start,
                                                      FontWeight.w600,
                                                      14.sp)
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton(
                                    position: PopupMenuPosition.under,
                                    offset: Offset(20, 10),
                                    child: Container(
                                      child: getSvgImage("more.svg",
                                          height: 24.h, width: 24.h),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(22.h)),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context) {
                                      return [
                                        PopupMenuItem(
                                          height: 50.h,
                                          padding: EdgeInsets.only(
                                              right: 60.h, left: 20.h),
                                          value: "edit",
                                          child: getCustomText(
                                              "Edit",
                                              textColor,
                                              1,
                                              TextAlign.center,
                                              FontWeight.w500,
                                              17.sp),
                                        ),
                                        PopupMenuItem(
                                          padding: EdgeInsets.only(
                                              right: 60.h, left: 20.h),
                                          value: "delete",
                                          child: getCustomText(
                                              "Delete",
                                              textColor,
                                              1,
                                              TextAlign.center,
                                              FontWeight.w500,
                                              17.sp),
                                          height: 50.h,
                                        ),
                                      ];
                                    },
                                    onSelected: (value) async {
                                      if (value == "edit") {
                                        showModalBottomSheet(
                                                isScrollControlled: true,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    22.h))),
                                                builder: (context) {
                                                  return BottomDialog(
                                                      customPlanExerciseList![
                                                          index]);
                                                },
                                                context: context)
                                            .then((value) {
                                          setState(() {});
                                        });
                                      } else if (value == "delete") {
                                        ConstantUrl.deleteExercise(context, () {
                                          setState(() {});
                                        },
                                            customplanexercise
                                                .customPlanExerciseId,
                                            customplanexercise
                                                .exercisedetail.exerciseId);
                                      }
                                    },
                                  )
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
            return ListView.builder(
              padding: EdgeInsets.only(left: 20.h, right: 20.h),
              primary: true,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: 10,
              itemBuilder: (context, index) {
                final Animation<double> animation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animationController!,
                    curve: Curves.fastOutSlowIn,
                  ),
                );
                animationController!.forward();
                return AnimatedBuilder(
                  animation: animationController!,
                  builder: (context, child) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: FadeTransition(
                        opacity: animation,
                        child: Transform(
                          transform: Matrix4.translationValues(
                              0.0, 50 * (1.0 - animation.value), 0.0),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20.h),
                            padding: EdgeInsets.only(
                                left: 12.h,
                                top: 12.h,
                                bottom: 12.h,
                                right: 20.h),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22.h),
                                boxShadow: [
                                  BoxShadow(
                                      color: containerShadow,
                                      blurRadius: 32,
                                      offset: Offset(-2, 5))
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 78.h,
                                        width: 78.h,
                                        decoration: BoxDecoration(
                                            color: lightOrange,
                                            borderRadius:
                                                BorderRadius.circular(12.h)),
                                      ),
                                      ConstantWidget.getHorSpace(12.h),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            getCustomText(
                                                "exercisedetail.exerciseName",
                                                textColor,
                                                1,
                                                TextAlign.start,
                                                FontWeight.w700,
                                                17.sp),
                                            ConstantWidget.getVerSpace(12.h),
                                            Row(
                                              children: [
                                                getSvgImage("Clock.svg",
                                                    width: 15.h, height: 15.h),
                                                ConstantWidget.getHorSpace(7.h),
                                                getCustomText(
                                                    "s",
                                                    descriptionColor,
                                                    1,
                                                    TextAlign.start,
                                                    FontWeight.w600,
                                                    14.sp)
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                PopupMenuButton(
                                  position: PopupMenuPosition.under,
                                  offset: Offset(20, 10),
                                  child: Container(
                                    child: getSvgImage("more.svg",
                                        height: 24.h, width: 24.h),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(22.h)),
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        height: 50.h,
                                        padding: EdgeInsets.only(
                                            right: 60.h, left: 20.h),
                                        value: "edit",
                                        child: getCustomText(
                                            "Edit",
                                            textColor,
                                            1,
                                            TextAlign.center,
                                            FontWeight.w500,
                                            17.sp),
                                      ),
                                      PopupMenuItem(
                                        padding: EdgeInsets.only(
                                            right: 60.h, left: 20.h),
                                        value: "delete",
                                        child: getCustomText(
                                            "Delete",
                                            textColor,
                                            1,
                                            TextAlign.center,
                                            FontWeight.w500,
                                            17.sp),
                                        height: 50.h,
                                      ),
                                    ];
                                  },
                                  onSelected: (value) async {
                                    if (value == "edit") {
                                    } else if (value == "delete") {}
                                  },
                                )
                              ],
                            ),
                          ),
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
                    _requestPop();
                  }),
              ConstantWidget.getHorSpace(12.sp),
              getCustomText("Custom Workout", textColor, 1, TextAlign.start,
                  FontWeight.w700, 22.sp)
            ],
          ),
          GestureDetector(
              onTap: () {
                if (modelGetCustomPlanExercise != null) {
                  Get.to(() =>
                      SelectWorkout(modelGetCustomPlanExercise!.data.idList));
                }
              },
              child: getSvgImage("add.svg",
                  height: 30.h, width: 30.h, color: textColor))
        ],
      ),
    );
  }

  Widget buildDoneButton(BuildContext context) {
    return ConstantWidget.getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      getButton(context, accentColor, "Start", Colors.white, () {
        if (customPlanExerciseList == null) {
          customPlanExerciseList = [];
        }
        Get.to(() => WorkoutCustom(
            customPlanExerciseList!, widget._modelCustomList, getCal, getTime));
      }, 20.sp,
          weight: FontWeight.w700,
          buttonHeight: 60.h,
          borderRadius: BorderRadius.circular(22.h)),
    );
  }
}
