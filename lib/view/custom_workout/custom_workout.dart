import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shimmer/shimmer.dart';
import 'package:women_workout/view/custom_workout/selected_list.dart';

import '../../dialog/add_workout_dialog.dart';
import '../../models/model_delete_custom_plan.dart';
import '../../models/model_dummy_send.dart';
import '../../models/model_get_custom_plan.dart';
import '../../util/color_category.dart';
import '../../util/constant_url.dart';
import '../../util/constant_widget.dart';
import '../../util/constants.dart';
import '../../util/pref_data.dart';
import '../../util/service_provider.dart';
import '../../util/widgets.dart';

import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

import '../controller/controller.dart';

class CustomWorkoutScreen extends StatefulWidget {
  const CustomWorkoutScreen({Key? key}) : super(key: key);

  @override
  State<CustomWorkoutScreen> createState() => _CustomWorkoutScreenState();
}

class _CustomWorkoutScreenState extends State<CustomWorkoutScreen>
    with TickerProviderStateMixin {
  double appBarHeight = 200.h;

  var radius = 22.h;

  ScrollController? _scrollViewController;
  bool isScrollingDown = false;

  AnimationController? animationController;
  Animation<double>? animation;
  HomeController homeController1 = Get.put(HomeController());

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstantWidget.getVerSpace(20.h),
        buildAppBar(),
        ConstantWidget.getVerSpace(30.h),
        buildCreatePlan(context),
        ConstantWidget.getVerSpace(60.h),
        buildWorkoutList(),
      ],
    );
  }

  HomeController homeController = Get.find();

  Widget buildAppBar() {
    return ConstantWidget.getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      Row(
        children: [
          InkWell(
              child: getSvgImage("arrow_left.svg", width: 24.h, height: 24.h),
              onTap: () {
                homeController.onChange(0.obs);
              }),
          ConstantWidget.getHorSpace(12.sp),
          getCustomText("Custom Workout", textColor, 1, TextAlign.start,
              FontWeight.w700, 22.sp)
        ],
      ),
    );
  }

  Expanded buildWorkoutList() {
    return Expanded(
      flex: 1,
      child: FutureBuilder<ModelGetCustomPlan?>(
        future: getCustomPlan(context),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            ModelGetCustomPlan? modelGetCustomPlan = snapshot.data;

            if (modelGetCustomPlan!.data.success == 1) {
              List<Customplan>? customPlanList =
                  modelGetCustomPlan.data.customplan;
              return ListView.builder(
                padding: EdgeInsets.only(left: 20.h, right: 20.h),
                primary: true,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: customPlanList.length,
                itemBuilder: (context, index) {
                  Customplan customplan = customPlanList[index];

                  ModelDummySend dummySend = new ModelDummySend(
                      customplan.customPlanId,
                      customplan.name,
                      ConstantUrl.urlGetWorkoutExercise,
                      ConstantUrl.varCatId,
                      getCellColor(index),
                      "ssds",
                      true,
                      customplan.description,
                      CUSTOM_WORKOUT);

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
                      return FadeTransition(
                        opacity: animation,
                        child: Transform(
                          transform: Matrix4.translationValues(
                              0.0, 50 * (1.0 - animation.value), 0.0),
                          child: GestureDetector(
                            onTap: () {
                              PrefData.setCustomPlanId(customplan.customPlanId);

                              Get.to(() => SelectedList(dummySend))
                                  ?.then((value) {
                                setState(() {});
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  bottom: 20.h, top: index == 0 ? 10.h : 0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22.h),
                                  boxShadow: [
                                    BoxShadow(
                                        color: containerShadow,
                                        blurRadius: 32,
                                        offset: Offset(-2, 5))
                                  ]),
                              padding: EdgeInsets.symmetric(horizontal: 20.h),
                              child: Column(
                                children: [
                                  ConstantWidget.getVerSpace(15.h),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: 70.h,
                                            height: 70.h,
                                            decoration: BoxDecoration(
                                                color: lightOrange,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        22.h)),
                                            child: getCustomText(
                                                "${index + 1}",
                                                accentColor,
                                                1,
                                                TextAlign.center,
                                                FontWeight.w700,
                                                36.sp),
                                          ),
                                          ConstantWidget.getHorSpace(20.h),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              getCustomText(
                                                  customplan.name,
                                                  textColor,
                                                  1,
                                                  TextAlign.start,
                                                  FontWeight.w500,
                                                  17.sp),
                                              ConstantWidget.getVerSpace(7.h),
                                              Row(
                                                children: [
                                                  getSvgImage("dumble.svg",
                                                      height: 15.h,
                                                      width: 15.h),
                                                  ConstantWidget.getHorSpace(
                                                      7.h),
                                                  getCustomText(
                                                      "${customplan.totalexercise} exercise",
                                                      descriptionColor,
                                                      1,
                                                      TextAlign.start,
                                                      FontWeight.w600,
                                                      14.sp)
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      // getSvgImage("more.svg", height: 24.h, width: 24.h)
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
                                            showDialog(
                                                    builder: (context) {
                                                      return AddWorkoutDialog(
                                                          customplan
                                                              .customPlanId,
                                                          customplan.name,
                                                          customplan
                                                              .description,
                                                          true);
                                                    },
                                                    context: context)
                                                .then((value) {
                                              setState(() {});
                                            });
                                          } else if (value == "delete") {
                                            Map data = await ConstantUrl
                                                .getCommonParams();
                                            data[ConstantUrl
                                                    .paramCustomPlanId] =
                                                customplan.customPlanId;

                                            final response = await http.post(
                                                Uri.parse(ConstantUrl
                                                    .urlDeleteCustomPlan),
                                                body: data);

                                            var value =
                                                ModelDeleteCustomPlan.fromJson(
                                                    jsonDecode(response.body));

                                            ConstantUrl.showToast(
                                                value.data.error, context);
                                            checkLoginError(
                                                context, value.data.error);
                                            if (value.data.success == 1) {
                                              setState(() {});
                                            }
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                  ConstantWidget.getVerSpace(15.h),
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
            } else {
              return getNoData(context);
            }
          } else {
            return ListView.builder(
              padding: EdgeInsets.only(left: 20.h, right: 20.h),
              primary: true,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: 8,
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
                            margin: EdgeInsets.only(
                                bottom: 20.h, top: index == 0 ? 10.h : 0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22.h),
                                boxShadow: [
                                  BoxShadow(
                                      color: containerShadow,
                                      blurRadius: 32,
                                      offset: Offset(-2, 5))
                                ]),
                            padding: EdgeInsets.symmetric(horizontal: 20.h),
                            child: Column(
                              children: [
                                ConstantWidget.getVerSpace(15.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          width: 70.h,
                                          height: 70.h,
                                          decoration: BoxDecoration(
                                              color: lightOrange,
                                              borderRadius:
                                                  BorderRadius.circular(22.h)),
                                          child: getCustomText(
                                              "${index + 1}",
                                              accentColor,
                                              1,
                                              TextAlign.center,
                                              FontWeight.w700,
                                              36.sp),
                                        ),
                                        ConstantWidget.getHorSpace(20.h),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            getCustomText(
                                                "customplan.name",
                                                textColor,
                                                1,
                                                TextAlign.start,
                                                FontWeight.w500,
                                                17.sp),
                                            ConstantWidget.getVerSpace(7.h),
                                            Row(
                                              children: [
                                                getSvgImage("dumble.svg",
                                                    height: 15.h, width: 15.h),
                                                ConstantWidget.getHorSpace(7.h),
                                                getCustomText(
                                                    " exercise",
                                                    descriptionColor,
                                                    1,
                                                    TextAlign.start,
                                                    FontWeight.w600,
                                                    14.sp)
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    // getSvgImage("more.svg", height: 24.h, width: 24.h)
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
                                          // showDialog(
                                          //     builder: (context) {
                                          //       return AddWorkoutDialog(
                                          //           customplan
                                          //               .customPlanId,
                                          //           customplan.name,
                                          //           customplan
                                          //               .description,
                                          //           true);
                                          //     },
                                          //     context: context)
                                          //     .then((value) {
                                          //   setState(() {});
                                          // });
                                        } else if (value == "delete") {
                                          // Map data = await ConstantUrl
                                          //     .getCommonParams();
                                          // data[ConstantUrl
                                          //     .paramCustomPlanId] =
                                          //     customplan.customPlanId;
                                          //
                                          // final response = await http.post(
                                          //     Uri.parse(ConstantUrl
                                          //         .urlDeleteCustomPlan),
                                          //     body: data);
                                          //
                                          // var value =
                                          // ModelDeleteCustomPlan.fromJson(
                                          //     jsonDecode(response.body));
                                          //
                                          // ConstantUrl.showToast(
                                          //     value.data.error, context);
                                          // checkLoginError(
                                          //     context, value.data.error);
                                          // if (value.data.success == 1) {
                                          //   setState(() {});
                                          // }
                                        }
                                      },
                                    )
                                  ],
                                ),
                                ConstantWidget.getVerSpace(15.h),
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

  Container buildCreatePlan(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      color: Colors.white,
      child: Transform.rotate(
        angle: math.pi,
        child: SizedBox(
          height: 161.h,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            primary: false,
            appBar: AppBar(
              bottomOpacity: 0.0,
              title: const Text(''),
              toolbarHeight: 0,
              elevation: 0,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: GestureDetector(
              onTap: () {},
              child: GetBuilder<SettingController>(
                init: SettingController(),
                builder: (controller) => Container(
                  width: 60.h,
                  height: 60.h,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: "#1A000000".toColor(),
                            blurRadius: 18,
                            offset: Offset(0, 9))
                      ],
                      color: accentColor,
                      borderRadius: BorderRadius.circular(50.h)),
                  child: InkWell(
                      onTap: () async {
                        showDialog(
                                  builder: (context) {
                                    return AddWorkoutDialog("0", "", "", false);
                                  },
                                  context: context)
                              .then((value) {
                            setState(() {});
                          });
                        // if (await ConstantUrl.isLogin()) {
                        //   showDialog(
                        //           builder: (context) {
                        //             return AddWorkoutDialog("0", "", "", false);
                        //           },
                        //           context: context)
                        //       .then((value) {
                        //     setState(() {});
                        //   });
                        // } else {
                        //   // if (await PrefData.getFirstSignUp() == true) {
                        //   //   Get.toNamed(Routes.introRoute, arguments: () {
                        //   //     showDialog(
                        //   //             builder: (context) {
                        //   //               return AddWorkoutDialog(
                        //   //                   "0", "", "", false);
                        //   //             },
                        //   //             context: context)
                        //   //         .then((value) {
                        //   //       setState(() {});
                        //   //     });
                        //   //   });
                        //   // } else {
                        //   ConstantUrl.sendLoginPage(context, function: () {
                        //     Get.toNamed(Routes.homeScreenRoute);
                        //     homeController1.onChange(2.obs);
                        //     showDialog(
                        //             builder: (context) {
                        //               return AddWorkoutDialog(
                        //                   "0", "", "", false);
                        //             },
                        //             context: context)
                        //         .then((value) {
                        //       setState(() {});
                        //     });

                        //   }, name: () {
                        //     Get.back();
                        //     Get.toNamed(Routes.homeScreenRoute);
                        //     homeController1.onChange(2.obs);
                        //   });
                        //   // }
                        // }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.h, vertical: 15.h),
                        child: getSvgImage("add.svg"),
                      )),
                ),
              ),
            ),
            bottomNavigationBar: Container(
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.all(
                  Radius.circular(radius),
                ),
                child: BottomAppBar(
                  color: lightOrange,
                  elevation: 0,
                  shape: CircularNotchedRectangle(),
                  notchMargin: (10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Transform.rotate(
                          angle: math.pi,
                          child: ConstantWidget.getPaddingWidget(
                            EdgeInsets.symmetric(horizontal: 20.h),
                            Column(
                              children: [
                                ConstantWidget.getVerSpace(30.h),
                                getCustomText("Create a new plan", textColor, 1,
                                    TextAlign.center, FontWeight.w700, 22.sp),
                                ConstantWidget.getVerSpace(6.h),
                                ConstantWidget.getMultilineCustomFont(
                                    "You can create and edit your own workout by choosing from various exercise",
                                    17.sp,
                                    descriptionColor,
                                    fontWeight: FontWeight.w500,
                                    txtHeight: 1.41.h,
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
