import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shimmer/shimmer.dart';
import 'package:women_workout/view/custom_workout/selected_list.dart';
import '../../data/data_file.dart';
import '../../data/dummy_data.dart';
import '../../models/modal_select_workout.dart';
import '../../models/model_add_custom_plan_exercise.dart';
import '../../models/model_all_workout_category.dart';
import '../../models/model_detail_exercise_list.dart';
import '../../models/model_dummy_send.dart';
import '../../models/model_edit_custom_plan_exercise.dart';
import '../../models/model_get_custom_plan_exercise.dart';
import '../../util/color_category.dart';
import '../../util/constant_url.dart';
import '../../util/constant_widget.dart';
import '../../util/constants.dart';
import '../../util/pref_data.dart';
import '../../util/service_provider.dart';
import '../../util/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';

import '../controller/controller.dart';

class SelectWorkout extends StatefulWidget {
  final List<String> exerciseIdList;

  SelectWorkout(this.exerciseIdList);

  @override
  State<SelectWorkout> createState() => _SelectWorkoutState();
}

class _SelectWorkoutState extends State<SelectWorkout>
    with TickerProviderStateMixin {
  Future<bool> _requestPop() {
    Get.delete<SelectWorkoutController>();

    DummyData.removeAllData();

    Get.back();

    return new Future.value(false);
  }

  List<String> workoutcategoryList = [
    "Warm up",
    "ABS Workout",
    "Butt Workout",
    "Arm & shoulder Workout"
  ];
  List<ModalSelectWorkout> selectWorkoutList = DataFile.selectWorkoutLists;
  var count = 0;

  ScrollController? _scrollViewController;
  bool isScrollingDown = false;

  AnimationController? animationController;
  Animation<double>? animation;

  SelectWorkoutController controller = Get.put(SelectWorkoutController());
  List<Exercise>? exerciseList;
  List<Exercise> allExerciseList = [];
  List<Customplanexercise>? customPlanExerciseList;

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

    Future.delayed(Duration.zero, () {
      controller.onChangeIdList(RxList<String>.from(widget.exerciseIdList));
      controller.onOldIdList(RxList<String>.from(widget.exerciseIdList));
    });

    getYogaWorkout(context).then((value) {
      controller.onChange(value!.data.category[0].categoryId.obs);

      getExerciseList(context, controller.categoryId.value).then((value) {
        setState(() {
          exerciseList = value!.data.exercise;
        });
        getCustomPlanExercise(context).then((value) {
          setState(() {
            customPlanExerciseList = value?.data.customplanexercise;
          });
        });
      });
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
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstantWidget.getVerSpace(20.h),
              buildAppBar(),
              ConstantWidget.getVerSpace(27.h),
              buildCategoryList(),
              ConstantWidget.getVerSpace(27.h),
              buildSelectWidget(),
              ConstantWidget.getVerSpace(20.h),
              buildSelectWorkoutList(),
              buildDoneButton(context),
              ConstantWidget.getVerSpace(40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return ConstantWidget.getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      Row(
        children: [
          InkWell(
              child: getSvgImage("arrow_left.svg", width: 24.h, height: 24.h),
              onTap: () {
                _requestPop().then((value) {
                  setState(() {});
                });
              }),
          ConstantWidget.getHorSpace(12.sp),
          getCustomText("Select Workout", textColor, 1, TextAlign.start,
              FontWeight.w700, 22.sp)
        ],
      ),
    );
  }

  Widget buildDoneButton(BuildContext context) {
    return ConstantWidget.getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      getButton(context, accentColor, "Done", Colors.white, () async {
        await deletePlan().then((value) async {
          await addPlan().then((value) async {
            String customPlanId = await PrefData.getCustomPlanId();
            String customPlanDescription =
                await PrefData.getCustomPlanDescription();
            String customPlanName = await PrefData.getCustomPlanName();
            DummyData.removeAllData();
            Get.to(SelectedList(ModelDummySend(
                customPlanId,
                customPlanName,
                ConstantUrl.urlGetWorkoutExercise,
                ConstantUrl.varCatId,
                getCellColor(0),
                "ssds",
                true,
                customPlanDescription,
                CUSTOM_WORKOUT)));
          });
        });
      }, 20.sp,
          weight: FontWeight.w700,
          buttonHeight: 60.h,
          borderRadius: BorderRadius.circular(22.h)),
    );
  }

  Future<void> deletePlan() async {
    List l1 = controller.idList;
    List l2 = widget.exerciseIdList;
    l2.removeWhere((element) => l1.contains(element));
    l2.forEach((element) async {
      String customExerciseId = await DummyData.getCustomPlanId(element);
      ConstantUrl.deleteExercise(context, () {
        print("customExerciseId===$customExerciseId");
      }, customExerciseId, element);
    });
  }

  Future<void> addPlan() async {
    controller.exerciseIdList.forEach((element) async {
      int time = await DummyData.getDuration(element);

      String customPlanId = await PrefData.getCustomPlanId();

      Map data = await ConstantUrl.getCommonParams();
      data[ConstantUrl.paramCustomPlanId] = customPlanId;
      data[ConstantUrl.paramExerciseId] = element;
      data[ConstantUrl.paramExerciseTime] = time.toString();

      print(
          "dataAdd====true===${widget.exerciseIdList.contains(element)}======${widget.exerciseIdList.toString()}=====$element");
      if (!controller.idList.contains(element)) {
        final response = await http
            .post(Uri.parse(ConstantUrl.urlAddCustomPlanExercise), body: data);

        var value =
            ModelAddCustomPlanExercise.fromJson(jsonDecode(response.body));

        ConstantUrl.showToast(value.data.error, context);
        checkLoginError(context, value.data.error);
        if (value.data.success == 1) {
          print("data=====ADd===true");
        }
        //
      } else {
        String customExerciseId = await DummyData.getCustomPlanId(element);

        data[ConstantUrl.paramCustomPlanExerciseId] = customExerciseId;

        final response = await http
            .post(Uri.parse(ConstantUrl.urlEditCustomPlanExercise), body: data);

        var value =
            ModelEditCustomPlanExercise.fromJson(jsonDecode(response.body));

        if (value.data.success == 1) {
          print("data=====Edit===true");
        }
      }
    });
  }

  Widget buildSelectWorkoutList() {
    if (exerciseList == null) {
      return Expanded(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          primary: true,
          shrinkWrap: true,
          itemCount: 10,
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
                            left: 20.h, right: 20.h, bottom: 20.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.h, vertical: 12.h),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: containerShadow,
                                  blurRadius: 32,
                                  offset: Offset(-2, 5))
                            ],
                            borderRadius: BorderRadius.circular(22.h)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            " _modelExerciseList.exerciseName",
                                            textColor,
                                            1,
                                            TextAlign.start,
                                            FontWeight.w700,
                                            17.sp),
                                        ConstantWidget.getVerSpace(6.h),
                                        Container(
                                          width: 105.w,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 6.h,
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12.h),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: containerShadow,
                                                    blurRadius: 32,
                                                    offset: Offset(-2, 5))
                                              ]),
                                          child: FutureBuilder<int>(
                                            future:
                                                DummyData.getDuration("key"),
                                            builder: (context, snapshot) {
                                              int time = 0;

                                              if (snapshot.data != null) {
                                                time = snapshot.data!;
                                              }

                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      controller.addDuration(
                                                          index, "key", time);
                                                    },
                                                    child: getSvgImage(
                                                        "add.svg",
                                                        color: accentColor,
                                                        width: 24.h,
                                                        height: 24.h),
                                                  ),
                                                  ConstantWidget.getHorSpace(
                                                      8.h),
                                                  getCustomText(
                                                      "${time}s",
                                                      // "${controller.duration[index]}s",
                                                      textColor,
                                                      1,
                                                      TextAlign.center,
                                                      FontWeight.w700,
                                                      17.sp),
                                                  ConstantWidget.getHorSpace(
                                                      8.h),
                                                  InkWell(
                                                    onTap: () {
                                                      controller.minusDuration(
                                                          index, "key", time);
                                                    },
                                                    child: getSvgImage(
                                                        "minus.svg",
                                                        color: accentColor,
                                                        width: 24.h,
                                                        height: 24.h),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ConstantWidget.getPaddingWidget(
                                EdgeInsets.only(top: 6.h, right: 8.h),
                                Container(width: 16.h, height: 16.h))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    } else {
      return Expanded(
          flex: 1,
          child: GetBuilder<SelectWorkoutController>(
            init: SelectWorkoutController(),
            builder: (controller) => ListView.builder(
              physics: BouncingScrollPhysics(),
              primary: true,
              shrinkWrap: true,
              itemCount: exerciseList?.length,
              itemBuilder: (context, index) {
                Exercise? _modelExerciseList = exerciseList?[index];
                final Animation<double> animation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animationController!,
                    curve: Curves.easeInOut,
                  ),
                );
                animationController!.forward();

                String key = _modelExerciseList!.exerciseId;
                return AnimatedBuilder(
                  animation: animationController!,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: Transform(
                        transform: Matrix4.translationValues(
                            0.0, 50 * (1.0 - animation.value), 0.0),
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 20.h, right: 20.h, bottom: 20.h),
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.h, vertical: 12.h),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: containerShadow,
                                    blurRadius: 32,
                                    offset: Offset(-2, 5))
                              ],
                              borderRadius: BorderRadius.circular(22.h)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                              _modelExerciseList.image),
                                    ),
                                    ConstantWidget.getHorSpace(12.h),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          getCustomText(
                                              _modelExerciseList.exerciseName,
                                              textColor,
                                              1,
                                              TextAlign.start,
                                              FontWeight.w700,
                                              17.sp),
                                          ConstantWidget.getVerSpace(6.h),
                                          Container(
                                            width: 105.w,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 6.h,
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(12.h),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: containerShadow,
                                                      blurRadius: 32,
                                                      offset: Offset(-2, 5))
                                                ]),
                                            child: FutureBuilder<int>(
                                              future:
                                                  DummyData.getDuration(key),
                                              builder: (context, snapshot) {
                                                int time = 0;

                                                if (snapshot.data != null) {
                                                  time = snapshot.data!;
                                                }

                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        controller.addDuration(
                                                            index, key, time);
                                                      },
                                                      child: getSvgImage(
                                                          "add.svg",
                                                          color: accentColor,
                                                          width: 24.h,
                                                          height: 24.h),
                                                    ),
                                                    ConstantWidget.getHorSpace(
                                                        8.h),
                                                    getCustomText(
                                                        "${time}s",
                                                        // "${controller.duration[index]}s",
                                                        textColor,
                                                        1,
                                                        TextAlign.center,
                                                        FontWeight.w700,
                                                        17.sp),
                                                    ConstantWidget.getHorSpace(
                                                        8.h),
                                                    InkWell(
                                                      onTap: () {
                                                        controller
                                                            .minusDuration(
                                                                index,
                                                                key,
                                                                time);
                                                      },
                                                      child: getSvgImage(
                                                          "minus.svg",
                                                          color: accentColor,
                                                          width: 24.h,
                                                          height: 24.h),
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              ConstantWidget.getPaddingWidget(
                                  EdgeInsets.only(top: 6.h, right: 8.h),
                                  InkWell(
                                    onTap: () async {
                                      // if (controller.idList.value.contains(
                                      //     _modelExerciseList.exerciseId)) {
                                      //   print("alredy added");
                                      //   print(
                                      //       "idList----${customPlanExerciseList?[index].customPlanExerciseId}----Exercise_id----${_modelExerciseList.exerciseId}");
                                      //   Map data =
                                      //       await ConstantUrl.getCommonParams();
                                      //   data[ConstantUrl
                                      //           .paramCustomPlanExerciseId] =
                                      //       customPlanExerciseList?[index]
                                      //           .customPlanExerciseId;
                                      //
                                      //   final response = await http.post(
                                      //       Uri.parse(ConstantUrl
                                      //           .urlDeleteCustomPlanExercise),
                                      //       body: data);
                                      //
                                      //   var value =
                                      //       ModelDeleteCustomPlanExercise
                                      //           .fromJson(
                                      //               jsonDecode(response.body));
                                      //
                                      //   ConstantUrl.showToast(
                                      //       value.data.error, context);
                                      //   checkLoginError(
                                      //       context, value.data.error);
                                      //   if (value.data.success == 1) {
                                      //     // getCustomPlanExercise(context)
                                      //     //     .then((value) {
                                      //     //   // idList.value = value!.data.idList;
                                      //     //   // idList.refresh();
                                      //     //   controller.onListChange(
                                      //     //       value!.data.idList);
                                      //     // });
                                      //   }
                                      // } else {
                                      //   String customPlanId =
                                      //       await PrefData.getCustomPlanId();
                                      //   Map data =
                                      //       await ConstantUrl.getCommonParams();
                                      //   data[ConstantUrl.paramCustomPlanId] =
                                      //       customPlanId;
                                      //   data[ConstantUrl.paramExerciseId] =
                                      //       _modelExerciseList.exerciseId;
                                      //   data[ConstantUrl.paramExerciseTime] =
                                      //       controller.duration[index]
                                      //           .toString();
                                      //
                                      //   final response = await http.post(
                                      //       Uri.parse(ConstantUrl
                                      //           .urlAddCustomPlanExercise),
                                      //       body: data);
                                      //
                                      //   var value =
                                      //       ModelAddCustomPlanExercise.fromJson(
                                      //           jsonDecode(response.body));
                                      //
                                      //   ConstantUrl.showToast(
                                      //       value.data.error, context);
                                      //   checkLoginError(
                                      //       context, value.data.error);
                                      //   if (value.data.success == 1) {
                                      //     getCustomPlanExercise(context)
                                      //         .then((value) {
                                      //       controller.onListChange(
                                      //           value!.data.idList);
                                      //     });
                                      //   }
                                      // }
                                      if (controller.exerciseIdList.contains(
                                          _modelExerciseList.exerciseId)) {
                                        // controller.idList.value.add(_modelExerciseList.exerciseId);
                                        // controller.onAddValue(
                                        //     _modelExerciseList.exerciseId);
                                        controller.onRemoveValue(
                                            _modelExerciseList.exerciseId);
                                      } else {
                                        // controller.idList.value.remove(_modelExerciseList.exerciseId);
                                        // controller.onRemoveValue(
                                        //     _modelExerciseList.exerciseId);
                                        controller.onAddValue(
                                            _modelExerciseList.exerciseId);
                                      }

                                      print(
                                          "controller===${controller.exerciseIdList.length}");
                                    },
                                    child: getSvgImage(
                                        controller.exerciseIdList.contains(
                                                _modelExerciseList.exerciseId)
                                            ? "check_orange.svg"
                                            : "uncheck_orange.svg",
                                        width: 16.h,
                                        height: 16.h),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ));
    }
  }

  RxBool isSelect = false.obs;

  Future<void> onSelectFunction() async {
    if (exerciseList != null && exerciseList!.length > 0) {
      exerciseList!.forEach((element) {
        Exercise? _modelExerciseList = element;

        if (!isSelect.value) {
          controller.onAddValue(_modelExerciseList.exerciseId);
        }
      });
    }
  }

  Future<void> onRemoveSelectFunction() async {
    if (exerciseList != null && exerciseList!.length > 0) {
      exerciseList!.forEach((element) {
        Exercise? _modelExerciseList = element;

        if (isSelect.value) {
          controller.onRemoveValue(_modelExerciseList.exerciseId);
        }
      });
    }
  }

  Widget buildSelectWidget() {
    if (exerciseList == null) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ConstantWidget.getPaddingWidget(
          EdgeInsets.symmetric(horizontal: 20.h),
          Container(
            height: 20.h,
            color: Colors.black,
          ),
        ),
      );
    } else {
      return ConstantWidget.getPaddingWidget(
        EdgeInsets.symmetric(horizontal: 20.h),
        GetBuilder<SelectWorkoutController>(
          init: SelectWorkoutController(),
          builder: (controller) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Row(
                    children: [
                      getCustomText("Select All", textColor, 1, TextAlign.start,
                          FontWeight.w600, 14.sp),
                      ConstantWidget.getHorSpace(12.h),
                      InkWell(
                        onTap: () {
                          onSelectFunction().then((value) {
                            if (!isSelect.value) {
                              isSelect(true);
                            }
                          });
                        },
                        child: getSvgImage(
                            isSelect.value
                                ? "check_orange.svg"
                                : "uncheck_orange.svg",
                            height: 16.h,
                            width: 16.h),
                      )
                    ],
                  )),
              getCustomText(
                  "${controller.exerciseIdList.length}/${allExerciseList.length}",
                  textColor,
                  1,
                  TextAlign.center,
                  FontWeight.w600,
                  14.sp),
              InkWell(
                onTap: () {
                  onRemoveSelectFunction().then((value) {
                    if (isSelect.value) {
                      isSelect(false);
                    }
                  });
                },
                child: getCustomText("Cancel", textColor, 1, TextAlign.center,
                    FontWeight.w600, 14.sp),
              )
            ],
          ),
        ),
      );
    }
  }

  Container buildCategoryList() {
    return Container(
      height: 36.h,
      child: FutureBuilder<ModelAllWorkout?>(
        future: getYogaWorkout(context),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            ModelAllWorkout? modelWorkout = snapshot.data;

            if (modelWorkout!.data.success == 1) {
              List<Category>? workoutList = modelWorkout.data.category;
              return GetBuilder<SelectWorkoutController>(
                init: SelectWorkoutController(),
                builder: (controller) => ListView.builder(
                  primary: true,
                  shrinkWrap: true,
                  itemCount: workoutList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    Category _modelWorkoutList = workoutList[index];
                    return Wrap(
                      children: [
                        InkWell(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.h),
                            alignment: Alignment.center,
                            height: 36.h,
                            decoration: index ==
                                    (int.parse(controller.categoryId.value) - 1)
                                ? BoxDecoration(
                                    color: accentColor,
                                    borderRadius: BorderRadius.circular(12.h))
                                : null,
                            child: getCustomText(
                                _modelWorkoutList.category,
                                index ==
                                        (int.parse(
                                                controller.categoryId.value) -
                                            1)
                                    ? Colors.white
                                    : descriptionColor,
                                1,
                                TextAlign.center,
                                FontWeight.w600,
                                14.sp),
                            margin: EdgeInsets.only(
                                right: 12.h, left: index == 0 ? 20.h : 0),
                          ),
                          onTap: () {
                            controller
                                .onChange(_modelWorkoutList.categoryId.obs);
                            getExerciseList(
                                    context, controller.categoryId.value)
                                .then((value) {
                              setState(() {
                                exerciseList = value!.data.exercise;
                              });
                              getCustomPlanExercise(context).then((value) {
                                setState(() {
                                  customPlanExerciseList =
                                      value?.data.customplanexercise;
                                });
                              });
                            });
                          },
                        )
                      ],
                    );
                  },
                ),
              );
            } else {
              return getNoData(context);
            }
          } else {
            return ListView.builder(
              primary: true,
              shrinkWrap: true,
              itemCount: 8,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Wrap(
                  children: [
                    InkWell(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.h),
                          alignment: Alignment.center,
                          height: 36.h,
                          decoration: index ==
                                  (int.parse(controller.categoryId.value) - 1)
                              ? BoxDecoration(
                                  color: accentColor,
                                  borderRadius: BorderRadius.circular(12.h))
                              : null,
                          child: getCustomText(
                              "",
                              index ==
                                      (int.parse(controller.categoryId.value) -
                                          1)
                                  ? Colors.white
                                  : descriptionColor,
                              1,
                              TextAlign.center,
                              FontWeight.w600,
                              14.sp),
                          margin: EdgeInsets.only(
                              right: 12.h, left: index == 0 ? 20.h : 0),
                        ),
                      ),
                      onTap: () {
                        getExerciseList(context, controller.categoryId.value)
                            .then((value) {
                          setState(() {
                            exerciseList = value!.data.exercise;
                          });
                          getCustomPlanExercise(context).then((value) {
                            setState(() {
                              customPlanExerciseList =
                                  value?.data.customplanexercise;
                            });
                          });
                        });
                      },
                    )
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
