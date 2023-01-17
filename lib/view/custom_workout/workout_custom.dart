import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../ads/ads_file.dart';
import '../../models/model_dummy_send.dart';
import '../../models/model_get_custom_plan_exercise.dart';
import '../../routes/app_routes.dart';
import '../../util/constant_url.dart';
import '../../util/service_provider.dart';
import '../../util/slider/slider.dart';
import '../../util/slider/slider_shapes.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:percent_indicator/percent_indicator.dart';

import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../util/color_category.dart';
import '../../util/constant_widget.dart';
import '../../util/constants.dart';

import '../../util/widgets.dart';
import '../controller/controller.dart';

class WorkoutCustom extends StatefulWidget {
  final ModelDummySend _modelDummySend;
  final List<Customplanexercise> _modelExerciseList;

  final double totalCal;
  final int time;

  WorkoutCustom(
      this._modelExerciseList, this._modelDummySend, this.totalCal, this.time);

  @override
  _WorkoutCustom createState() => _WorkoutCustom();
}

class WidgetSkipData extends StatefulWidget {
  final Customplanexercise _modelExerciseDetail;
  final Function _functionSkip;
  final Function _functionSkipTick;

  final int totalPos;
  final int currentPos;

  WidgetSkipData(this._modelExerciseDetail, this._functionSkip, this.currentPos,
      this.totalPos, this._functionSkipTick);

  @override
  _WidgetSkipData createState() => _WidgetSkipData();
}

class _WidgetSkipData extends State<WidgetSkipData>
    with WidgetsBindingObserver {
  int skipTime = 10;
  Timer? _timer;

  SettingController settingController = Get.put(SettingController());
  String currentTime = "0";

  _getRestTimes() async {
    skipTime = settingController.dropDownValue.value;
    totalTime = settingController.dropDownValue.value;
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _getRestTimes();
    super.initState();
  }

  void cancelSkipTimer() {
    _timer!.cancel();
    _timer = null;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      pauseSkip();
    } else if (state == AppLifecycleState.resumed) {
      if (!isSkipDialogOpen) {
        resumeSkip();
      }
    }
  }

  void setSkipTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => {
              if (mounted)
                {
                  setState(
                    () {
                      if (skipTime < 1) {
                        cancelSkipTimer();
                        widget._functionSkip();
                      } else {
                        skipTime = skipTime - 1;
                      }
                      if (skipTime < Constants.maxTime &&
                          skipTime > Constants.minTime) {
                        widget._functionSkipTick(skipTime.toString());
                      }
                      currentTime = skipTime.toString();
                    },
                  ),
                }
            });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timer != null) {
      cancelSkipTimer();
    }
    super.dispose();
  }

  PageController controller = PageController();
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  bool isSkipDialogOpen = false;
  int totalTime = 10;

  @override
  Widget build(BuildContext context) {
    if (_timer == null) {
      setSkipTimer();
    }

    return Container(
      key: scaffoldState,
      width: double.infinity,
      height: double.infinity,
      color: bgDarkWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstantWidget.getVerSpace(23.h),
          ConstantWidget.getPaddingWidget(
            EdgeInsets.symmetric(horizontal: 20.h),
            Row(
              children: [
                InkWell(
                  child:
                      getSvgImage("arrow_left.svg", width: 24.h, height: 24.h),
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext contexts) {
                        return WillPopScope(
                          onWillPop: () async => false,
                          child: AlertDialog(
                            title: Text('Exit'),
                            content: Text('Do you really want to quite?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(contexts).pop();
                                  Navigator.of(context).pop();
                                },
                                child: getSmallNormalText(
                                    "YES", Colors.red, TextAlign.start),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(contexts).pop();
                                },
                                child: getSmallNormalText(
                                    "N0", Colors.red, TextAlign.start),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                ConstantWidget.getHorSpace(12.h),
                ConstantWidget.getTextWidget(
                    "Rest", textColor, TextAlign.start, FontWeight.w700, 20.sp),
              ],
            ),
          ),
          ConstantWidget.getVerSpace(70.h),
          Center(
            child: Container(
              height: 210.h,
              width: 216.h,
              child: SfRadialGauge(axes: <RadialAxis>[
                RadialAxis(
                  minimum: 0,
                  maximum: 1,
                  showLabels: false,
                  showTicks: false,
                  startAngle: 270,
                  endAngle: 270,
                  annotations: [
                    GaugeAnnotation(
                      positionFactor: 0.1,
                      angle: 90,
                      widget: getCustomText("${currentTime}", textColor, 1,
                          TextAlign.center, FontWeight.w700, 36.sp),
                    )
                  ],
                  axisLineStyle: AxisLineStyle(
                    thickness: 0.08.h,
                    color: "#E6E6E6".toColor(),
                    thicknessUnit: GaugeSizeUnit.factor,
                  ),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: (double.parse(currentTime) / totalTime),
                      width: 0.10.h,
                      sizeUnit: GaugeSizeUnit.factor,
                      cornerStyle: CornerStyle.bothFlat,
                      color: accentColor,
                    ),
                    MarkerPointer(
                      markerHeight: 25.h,
                      markerWidth: 25.h,
                      value: (double.parse(currentTime) / totalTime),
                      markerType: MarkerType.circle,
                      color: accentColor,
                    )
                  ],
                )
              ]),
            ),
          ),
          ConstantWidget.getVerSpace(20.h),
          getCustomText("${totalTime} Seconds", textColor, 1, TextAlign.center,
              FontWeight.w700, 20.sp),
          ConstantWidget.getVerSpace(60.h),
          ConstantWidget.getPaddingWidget(
            EdgeInsets.symmetric(horizontal: 20.h),
            StepProgressIndicator(
              totalSteps: widget.totalPos,
              currentStep: widget.currentPos,
              size: 4.h,
              padding: 0,
              selectedColor: accentColor,
              unselectedColor: lightOrange,
              roundedEdges: Radius.circular(12.h),
            ),
          ),
          ConstantWidget.getVerSpace(60.h),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstantWidget.getTextWidget("Coming Up", textColor,
                      TextAlign.start, FontWeight.w700, 22.sp),
                  ConstantWidget.getVerSpace(12.h),
                  GestureDetector(
                    onTap: () {
                      showBottomDialog(widget._modelExerciseDetail, false);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 11.h, bottom: 11.h, left: 14.h, right: 16.h),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: containerShadow,
                                blurRadius: 32,
                                offset: Offset(-2, 5)),
                          ],
                          borderRadius: BorderRadius.circular(22.h)),
                      child: Row(
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
                                      "${ConstantUrl.uploadUrl}${widget._modelExerciseDetail.exercisedetail.image}"),
                                ),
                                ConstantWidget.getHorSpace(12.h),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getCustomText(
                                          widget._modelExerciseDetail
                                              .exercisedetail.exerciseName,
                                          textColor,
                                          1,
                                          TextAlign.start,
                                          FontWeight.w700,
                                          17.sp),
                                      ConstantWidget.getVerSpace(6.h),
                                      Row(
                                        children: [
                                          getSvgImage("Clock.svg",
                                              width: 14.h, height: 14.h),
                                          ConstantWidget.getHorSpace(6.h),
                                          getCustomText(
                                              "${widget._modelExerciseDetail.exerciseTime} Second",
                                              descriptionColor,
                                              1,
                                              TextAlign.start,
                                              FontWeight.w600,
                                              13.sp)
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          getAssetImage("play.png", height: 40.h, width: 40.h)
                        ],
                      ),
                    ),
                  ),
                  ConstantWidget.getVerSpace(20.h),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ConstantWidget.getPaddingWidget(
                        EdgeInsets.only(bottom: 40.h),
                        getButton(context, Colors.white, "Skip", textColor, () {
                          widget._functionSkip();
                        }, 20.sp,
                            weight: FontWeight.w700,
                            isBorder: true,
                            borderColor: accentColor,
                            borderWidth: 1.5.h,
                            buttonHeight: 60.h,
                            borderRadius: BorderRadius.circular(22.h)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showBottomDialog(Customplanexercise exerciseDetail, bool isVideo) {
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
                "${ConstantUrl.uploadUrl}${exerciseDetail.exercisedetail.image}",
                height: 332.h,
                width: 233.h,
                fit: BoxFit.fill,
              ),
              ConstantWidget.getVerSpace(16.h),
              getCustomText("How to perform?", textColor, 1, TextAlign.start,
                  FontWeight.w700, 20.sp),
              ConstantWidget.getVerSpace(13.h),
              HtmlWidget(
                Constants.decode(exerciseDetail.exercisedetail.description),
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

  void pauseSkip() {
    if (_timer != null) {
      cancelSkipTimer();
    }
  }

  void resumeSkip() {
    if (_timer == null) {
      setSkipTimer();
    }
  }
}

// ignore: must_be_immutable
class WidgetDetailData extends StatefulWidget {
  Customplanexercise _modelExerciseList;
  Customplanexercise _modelExerciseDetail;
  bool fromFirst;
  Function muteOverCallback;
  Function timerOverCallback;
  Function timerPreOverCallback;
  final int readyDuration;
  final bool isReady;
  Function setReadyFunction;
  Function backClick;
  Function _functionSkipTick;
  FlutterTts flutterTts;
  AdsFile? adsFile;

  WidgetDetailData(
      this._modelExerciseList,
      this._modelExerciseDetail,
      this.timerOverCallback,
      this.timerPreOverCallback,
      this.fromFirst,
      this.isReady,
      this.readyDuration,
      this.setReadyFunction,
      this.muteOverCallback,
      this._functionSkipTick,
      this.backClick,
      this.flutterTts,
      this.adsFile);

  @override
  State<StatefulWidget> createState() => _WidgetDetailData();
}

class _WidgetDetailData extends State<WidgetDetailData>
    with WidgetsBindingObserver {
  int totalTimerTime = 0;
  String currentTime = "";
  Timer? _timer;

  @override
  void initState() {
    _timer = null;
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  void showSoundDialog() async {
    double margin = ConstantWidget.getWidthPercentSize(context, 4);
    SettingController controller = Get.put(SettingController());

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
          child: StatefulBuilder(builder: (context, setState) {
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: margin),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              primary: false,
              children: [
                ConstantWidget.getVerSpace(40.h),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ConstantWidget.getCustomTextWidget(
                          'Sound',
                          Colors.black,
                          22.h,
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
                ConstantWidget.getVerSpace(30.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.h, vertical: 14.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.h),
                      boxShadow: [
                        BoxShadow(
                            color: containerShadow,
                            blurRadius: 32,
                            offset: Offset(-2, 5))
                      ]),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              getSvgImage("volume.svg",
                                  height: 24.h, width: 24.h),
                              ConstantWidget.getHorSpace(14.h),
                              getCustomText("Sound", textColor, 1,
                                  TextAlign.start, FontWeight.w500, 17.sp)
                            ],
                          ),
                          GetBuilder<SettingController>(
                            init: SettingController(),
                            builder: (controller) => Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: controller.sound.value,
                                onChanged: (value) {
                                  controller.changeSound();
                                },
                                trackColor: bgColor,
                                thumbColor: Colors.white,
                                activeColor: accentColor,
                              ),
                            ),
                          )
                        ],
                      ),
                      GetBuilder<SettingController>(
                        init: SettingController(),
                        builder: (controller) => Column(
                          children: [
                            ConstantWidget.getVerSpace(10.h),
                            SfSlider(
                              min: 0.0,
                              max: 1.0,
                              thumbIcon: getSvgImage("box.svg",
                                  width: 14.h, height: 14.h),
                              value: controller.volume.value,
                              onChanged: (dynamic newValue) {
                                controller.changeVolume(newValue);
                                // controller.fullVolume();
                              },
                              activeColor: accentColor,
                              inactiveColor: borderColor,
                              overlayShape: SfOverlayShape(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ConstantWidget.getVerSpace(12.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.h),
                      boxShadow: [
                        BoxShadow(
                            color: containerShadow,
                            blurRadius: 32,
                            offset: Offset(-2, 5))
                      ]),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              getSvgImage("volume.svg",
                                  height: 24.h, width: 24.h),
                              ConstantWidget.getHorSpace(14.h),
                              getCustomText("TTS Voice", textColor, 1,
                                  TextAlign.start, FontWeight.w500, 17.sp)
                            ],
                          ),
                          GetBuilder<SettingController>(
                            init: SettingController(),
                            builder: (controller) => Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: controller.ttsSpeak.value,
                                onChanged: (value) {
                                  controller.changeTtsSpeak();
                                },
                                trackColor: bgColor,
                                thumbColor: Colors.white,
                                activeColor: accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      GetBuilder<SettingController>(
                        init: SettingController(),
                        builder: (controller) => Column(
                          children: [
                            ConstantWidget.getVerSpace(10.h),
                            SfSlider(
                              min: 0.1,
                              max: 1.0,
                              thumbIcon: getSvgImage("box.svg",
                                  width: 14.h, height: 14.h),
                              value: controller.tts_speed.value,
                              onChanged: (dynamic newValue) {
                                controller.changeTtsSpeed(newValue);
                              },
                              activeColor: accentColor,
                              inactiveColor: borderColor,
                              overlayShape: SfOverlayShape(),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ConstantWidget.getVerSpace(30.h),
                ConstantWidget.getButtonWidget(context, 'Save', blueButton,
                    () async {
                  widget.muteOverCallback();
                  Navigator.pop(context);
                }),
                ConstantWidget.getVerSpace(54.h),
              ],
            );
          }),
        );
      },
    ).then((value) async {
      pauseTimer();
      Get.put(SettingController());
      await widget.flutterTts.setSpeechRate(controller.tts_speed.value);
      await widget.flutterTts.setVolume(controller.volume.value);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    if (state == AppLifecycleState.paused) {
      if (_timer != null) {
        pauseTimer();
      }
    } else if (state == AppLifecycleState.resumed) {
      pauseTimer();
    }
  }

  IconData getPlayPauseIcon() {
    if (_timer == null) {
      return Icons.play_arrow_rounded;
    } else {
      return Icons.pause_rounded;
    }
  }

  void cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => {
              if (mounted)
                {
                  setState(
                    () {
                      if (totalTimerTime < 1) {
                        if (!widget.isReady) {
                          widget.setReadyFunction();
                        } else {
                          cancelTimer();
                          widget.timerOverCallback(widget._modelExerciseDetail);
                        }
                      } else {
                        totalTimerTime = totalTimerTime - 1;
                      }
                      if (!widget.isReady) {
                        if (totalTimerTime < Constants.maxTime &&
                            totalTimerTime > Constants.minTime) {
                          widget._functionSkipTick(totalTimerTime.toString());
                        }
                      }

                      currentTime = totalTimerTime.toString();
                    },
                  ),
                }
            });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cancelTimer();
    super.dispose();
  }

  void showBottomDialog(Customplanexercise exerciseDetail, bool isVideo) {
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
                "${ConstantUrl.uploadUrl}${exerciseDetail.exercisedetail.image}",
                height: 332.h,
                width: 233.h,
                fit: BoxFit.fill,
              ),
              ConstantWidget.getVerSpace(16.h),
              getCustomText("How to perform?", textColor, 1, TextAlign.start,
                  FontWeight.w700, 20.sp),
              ConstantWidget.getVerSpace(13.h),
              HtmlWidget(
                Constants.decode(exerciseDetail.exercisedetail.description),
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
    ).then((value) => pauseTimer());
  }

  bool isShowVideo = false;
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    if (!widget.isReady) {
      if (_timer == null) {
        currentTime = widget.readyDuration.toString();
        totalTimerTime = widget.readyDuration;
        startTimer();
      }
    } else {
      if (widget.fromFirst) {
        widget.fromFirst = false;

        if (widget._modelExerciseList.exerciseTime!.isEmpty) {
          currentTime = "0";
          totalTimerTime = 0;
        } else {
          currentTime = widget._modelExerciseList.exerciseTime!;
          totalTimerTime = int.parse(widget._modelExerciseList.exerciseTime!);
        }

        if (_timer == null) {
          startTimer();
        }
      }
    }

    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          ConstantWidget.getVerSpace(20.h),
          ConstantWidget.getPaddingWidget(
            EdgeInsets.symmetric(horizontal: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      InkWell(
                          child: getSvgImage("arrow_left.svg",
                              width: 24.h, height: 24.h),
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext contexts) {
                                return WillPopScope(
                                  onWillPop: () async => false,
                                  child: AlertDialog(
                                    title: Text('Exit'),
                                    content:
                                        Text('Do you really want to quite?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(contexts).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: getSmallNormalText(
                                            "YES", Colors.red, TextAlign.start),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(contexts).pop();
                                        },
                                        child: getSmallNormalText(
                                            "N0", Colors.red, TextAlign.start),
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                      ConstantWidget.getHorSpace(12.h),
                      Expanded(
                        child: getCustomText(
                            widget._modelExerciseDetail.exercisedetail
                                .exerciseName,
                            textColor,
                            1,
                            TextAlign.start,
                            FontWeight.w700,
                            20.sp),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          pauseTimer();
                          showSoundDialog();
                        },
                        child: getSvgImage("volume.svg",
                            height: 24.h, width: 24.h)),
                    ConstantWidget.getHorSpace(14.h),
                    InkWell(
                        onTap: () {
                          pauseTimer();
                          showBottomDialog(widget._modelExerciseDetail, false);
                        },
                        child:
                            getSvgImage("Info.svg", height: 24.h, width: 24.h)),
                  ],
                )
              ],
            ),
          ),
          ConstantWidget.getVerSpace(40.h),
          Visibility(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.h),
                  color: Colors.white,
                  child: Transform.rotate(
                    angle: math.pi,
                    child: SizedBox(
                      height: 485.h,
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
                        floatingActionButton: InkWell(
                          onTap: () {},
                          child: Container(
                            width: 75.h,
                            height: 75.h,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.h, vertical: 15.h),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: "#1A000000".toColor(),
                                      blurRadius: 18,
                                      offset: Offset(0, 9))
                                ],
                                color: accentColor,
                                borderRadius: BorderRadius.circular(50.h)),
                            child: Transform.rotate(
                                angle: math.pi,
                                child: getCustomText(
                                    currentTime,
                                    Colors.white,
                                    1,
                                    TextAlign.center,
                                    FontWeight.w700,
                                    36.sp)),
                          ),
                        ),
                        bottomNavigationBar: Container(
                          child: ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.all(
                              Radius.circular(22.h),
                            ),
                            child: BottomAppBar(
                              color: lightOrange,
                              elevation: 0,
                              shape: CircularNotchedRectangle(),
                              notchMargin: (10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Center(
                                      child: Transform.rotate(
                                        angle: math.pi,
                                        child: Image.network(
                                          "${ConstantUrl.uploadUrl}${widget._modelExerciseDetail.exercisedetail.image}",
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ConstantWidget.getVerSpace(80.h),
                getCustomText("Ready to go!", descriptionColor, 1,
                    TextAlign.center, FontWeight.w700, 22.sp),
                ConstantWidget.getVerSpace(43.h),
                ConstantWidget.getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 20.h),
                  getButton(context, Colors.white, "Skip", textColor, () {
                    setState(() {
                      cancelTimer();
                      widget.setReadyFunction();
                    });
                  }, 20.sp,
                      weight: FontWeight.w700,
                      buttonHeight: 60.h,
                      isBorder: true,
                      borderRadius: BorderRadius.circular(22.h),
                      borderWidth: 1.5.h,
                      borderColor: accentColor),
                ),
                // ConstantWidget.getVerSpace(20.h),
                // Container(
                //   alignment: Alignment.center,
                //   child: AdWidget(ad: widget.myBanner),
                //   width: widget.myBanner.size.width.toDouble(),
                //   height: widget.myBanner.size.height.toDouble(),
                // ),
                // ConstantWidget.getVerSpace(10.h),
              ],
            ),
            visible: !widget.isReady,
          ),
          Visibility(
              visible: widget.isReady,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.h),
                    color: Colors.white,
                    child: Transform.rotate(
                      angle: math.pi,
                      child: SizedBox(
                        height: 485.h,
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
                          floatingActionButton: Transform.rotate(
                            angle: math.pi,
                            child: InkWell(
                              onTap: () {
                                pauseTimer();
                              },
                              child: CircularPercentIndicator(
                                radius: 42.h,
                                lineWidth: 5.h,
                                circularStrokeCap: CircularStrokeCap.round,
                                percent: (double.parse(currentTime) /
                                    double.parse((widget
                                        ._modelExerciseList.exerciseTime!))),
                                center: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15.h, horizontal: 16.h),
                                  height: 55.h,
                                  width: 55.h,
                                  decoration: BoxDecoration(
                                      color: accentColor,
                                      borderRadius:
                                          BorderRadius.circular(50.h)),
                                  child: getSvgImage(_timer == null
                                      ? "play.svg"
                                      : "pause.svg"),
                                ),
                                progressColor: accentColor,
                                backgroundColor: bgColor,
                              ),
                            ),
                          ),
                          bottomNavigationBar: Container(
                            child: ClipRRect(
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.all(
                                Radius.circular(22.h),
                              ),
                              child: BottomAppBar(
                                color: lightOrange,
                                elevation: 0,
                                shape: CircularNotchedRectangle(),
                                notchMargin: (10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Center(
                                        child: Transform.rotate(
                                          angle: math.pi,
                                          child: Image.network(
                                            "${ConstantUrl.uploadUrl}${widget._modelExerciseDetail.exercisedetail.image}",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ConstantWidget.getVerSpace(21.h),
                  ConstantWidget.getPaddingWidget(
                    EdgeInsets.symmetric(horizontal: 76.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: getSvgImage("arrow_left.svg",
                              width: 24.h, height: 24.h),
                          onTap: () {
                            cancelTimer();
                            widget.timerPreOverCallback();
                          },
                        ),
                        InkWell(
                          onTap: () {
                            cancelTimer();
                            widget
                                .timerOverCallback(widget._modelExerciseDetail);
                          },
                          child: getSvgImage("arrow_right.svg",
                              width: 24.h, height: 24.h),
                        )
                      ],
                    ),
                  ),
                  ConstantWidget.getVerSpace(50.h),
                  getCustomText(currentTime, textColor, 1, TextAlign.center,
                      FontWeight.w300, 60.sp),
                  ConstantWidget.getVerSpace(10.h),
                  getCustomText("Second", descriptionColor, 1, TextAlign.center,
                      FontWeight.w500, 17.sp),
                  ConstantWidget.getVerSpace(10.h),
                  showBanner(widget.adsFile),
                ],
              ))
        ],
      ),
    );
  }

  // getActionWidget({bool? isActive}) {
  //   double subHeight = ConstantWidget.getScreenPercentSize(context, 4.2);
  //   double circleSize = ConstantWidget.getScreenPercentSize(context, 6);
  //   return Container(
  //     padding:
  //         EdgeInsets.only(top: ConstantWidget.getScreenPercentSize(context, 5)),
  //     child: Column(
  //       children: [
  //         SizedBox(
  //           height: ConstantWidget.getScreenPercentSize(context, 13),
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             InkWell(
  //               onTap: () {
  //                 if (isActive != null) {
  //                   cancelTimer();
  //                   widget.timerPreOverCallback();
  //                 }
  //               },
  //               child: Container(
  //                 height: subHeight,
  //                 width: subHeight,
  //                 decoration: BoxDecoration(
  //                     border: Border.all(
  //                         color: Colors.grey.shade500,
  //                         width: ConstantWidget.getPercentSize(subHeight, 6)),
  //                     borderRadius: BorderRadius.all(Radius.circular(
  //                         ConstantWidget.getPercentSize(subHeight, 44)))),
  //                 child: Center(
  //                   child: Icon(
  //                     Icons.keyboard_backspace,
  //                     color: Colors.grey.shade500,
  //                     size: ConstantWidget.getPercentSize(subHeight, 70),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               width: ConstantWidget.getWidthPercentSize(context, 15),
  //             ),
  //             InkWell(
  //               onTap: () {
  //                 if (isActive != null) {
  //                   pauseTimer();
  //                 }
  //               },
  //               child: Container(
  //                 height: circleSize,
  //                 width: circleSize,
  //                 decoration: BoxDecoration(
  //                     color: textColor,
  //                     border: Border.all(
  //                         color: textColor,
  //                         width: ConstantWidget.getPercentSize(circleSize, 6)),
  //                     borderRadius: BorderRadius.all(Radius.circular(
  //                         ConstantWidget.getPercentSize(circleSize, 40)))),
  //                 child: Center(
  //                   child: Icon(
  //                     getPlayPauseIcon(),
  //                     color: Colors.white,
  //                     size: ConstantWidget.getPercentSize(circleSize, 70),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(
  //               width: ConstantWidget.getWidthPercentSize(context, 15),
  //             ),
  //             InkWell(
  //               onTap: () {
  //                 if (isActive != null) {
  //                   cancelTimer();
  //                   widget.timerOverCallback();
  //                 }
  //               },
  //               child: Container(
  //                 height: subHeight,
  //                 width: subHeight,
  //                 decoration: BoxDecoration(
  //                     border: Border.all(
  //                         color: textColor,
  //                         width: ConstantWidget.getPercentSize(subHeight, 6)),
  //                     borderRadius: BorderRadius.all(Radius.circular(
  //                         ConstantWidget.getPercentSize(subHeight, 44)))),
  //                 child: Center(
  //                   child: Transform.rotate(
  //                     angle: math.pi,
  //                     child: Icon(
  //                       Icons.keyboard_backspace,
  //                       color: textColor,
  //                       size: ConstantWidget.getPercentSize(subHeight, 70),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  void pauseTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    } else {
      startTimer();
    }
    setState(() {});
  }
}

class _WorkoutCustom extends State<WorkoutCustom> with WidgetsBindingObserver {
  int pos = 0;
  bool isSkip = false;
  double getCal = 0;
  int getTotalWorkout = 0;
  int getTime = 0;
  int totalLength = 7;

  double ttsSpeed = 0.5;
  double volume = 1.0;

  int totalDuration = 0;
  double totalCal = 0;
  int exerciseDuration = 0;
  String startTime = "";

  bool isTtsOn = true;
  bool isReady = false;
  late ConfettiController controllerTopCenter;
  late FlutterTts flutterTts;
  SettingController settingController = Get.find();
  AdsFile? adsFile;
  
  void _showInterstitialAd() {
    showInterstitialAd(adsFile, () {
      Get.toNamed(Routes.homeScreenRoute, arguments: 0);
    }, setState);
  }

  void initController() {
    controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  getMutes() async {
    isTtsOn = settingController.ttsSpeak.value;
    setState(() {});
  }

  getTtsSpeed() async {
    ttsSpeed = settingController.tts_speed.value;
  }

  getVolume() {
    volume = settingController.volume.value;
  }

  getMutesNoRefresh() async {
    isTtsOn = settingController.ttsSpeak.value;
  }

  void _calcTotal() async {
    setState(() {
      getCal = 15 + getCal;
      getTime = 10 + getTime;
    });
  }

  void setDataByPos(Customplanexercise detail) {
    if (pos < widget._modelExerciseList.length) {
      pos++;
      isSkip = true;
    } else {
      isSkip = false;
    }
    exerciseDuration = 0;

    playSound(false);

    setState(() {});
  }

  void setPrevDataByPos() {
    if (pos > 0) {
      pos--;
      isSkip = false;
    }
    setState(() {});
  }

  void setAfterSkip() {
    isSkip = false;
    playSound(true);

    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    try {
      periodicAlDuration!.cancel();
    } catch (e) {
      print(e);
    }
    disposeBannerAd(adsFile);
    super.dispose();
  }

  Timer? periodicAlDuration;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
    } else if (state == AppLifecycleState.resumed) {
      getMutesNoRefresh();
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      adsFile = new AdsFile(context);
      adsFile!.createInterstitialAd(setState, () {
        Get.toNamed(Routes.homeScreenRoute, arguments: 0);
      });
      adsFile!.getFacebookBanner(setState);
      adsFile!.createAnchoredBanner(context, setState);
    });
    WidgetsBinding.instance.addObserver(this);
    startTime = Constants.addDateFormat.format(new DateTime.now());
    getMutes();
    getTtsSpeed();
    getVolume();

    _calcTotal();
    setState(() {
      initController();
    });
    controllerTopCenter.play();
    super.initState();

    periodicAlDuration = Timer.periodic(Duration(seconds: 1), (timer) {
      totalDuration++;
      exerciseDuration++;
    });
    initTts();
  }

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  iosTTs() async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setSharedInstance(true);
    await flutterTts
        .setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord, [
      IosTextToSpeechAudioCategoryOptions.allowBluetooth,
      IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
      IosTextToSpeechAudioCategoryOptions.mixWithOthers
    ]);
  }

  initTts() async {
    flutterTts = FlutterTts();

    iosTTs();
    await flutterTts.setLanguage("en-US");

    await flutterTts.setSpeechRate(ttsSpeed);

    await flutterTts.setVolume(volume);

    await flutterTts.setPitch(1.0);

    await flutterTts.isLanguageAvailable("en-US");

    await flutterTts.setSharedInstance(true);

    await flutterTts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.ambient,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers
        ],
        IosTextToSpeechAudioMode.voicePrompt);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.awaitSynthCompletion(true);

    await flutterTts.setSharedInstance(true);

    if (isAndroid) {
      _getDefaultEngine();
      await flutterTts.setSilence(2);

      await flutterTts.getEngines;

      await flutterTts.isLanguageInstalled("en-AU");

      await flutterTts.areLanguagesInstalled(["en-AU", "en-US"]);

      await flutterTts.setQueueMode(1);

      await flutterTts.getMaxSpeechInputLength;
    }
  }

  playSound(bool isSkip) async {}

  playBgSound(String isSkip) async {}

  void playSoundTicks(String val) {
    playTickSound();
    _speak(val);
  }

  playTickSound() async {}

  Future _speak(String txt) async {
    isTtsOn = settingController.ttsSpeak.value;
    if (isTtsOn) {
      if (prevSpeak != txt) {
        prevSpeak = txt;
        await flutterTts.speak(txt);
      }
    }
  }

  String prevSpeak = "";

  void setReady() {
    isReady = true;
    setState(() {});
  }

  int readyDuration = 10;

  getDetailWidget() {
    Customplanexercise _modelExerciseDetail = widget._modelExerciseList[pos];
    if (isSkip) {
      _speak("Take a rest");
      playBgSound("audio3.mp3");

      return WidgetSkipData(_modelExerciseDetail, setAfterSkip, pos,
          widget._modelExerciseList.length, playSoundTicks);
    } else {
      if (!isReady) {
        _speak(
            "Ready to go start with ${_modelExerciseDetail.exercisedetail.exerciseName}");
        playBgSound("audio1.mp3");
      } else {
        _speak(_modelExerciseDetail.exercisedetail.exerciseName);
        playBgSound("audio2.mp3");
      }

      return WidgetDetailData(
          widget._modelExerciseList[pos],
          _modelExerciseDetail,
          setDataByPos,
          setPrevDataByPos,
          true,
          isReady,
          readyDuration,
          setReady,
          getMutesNoRefresh,
          playSoundTicks,
          backDialog,
          flutterTts,
          adsFile);
    }
  }

  double margin = 0;

  Container buildConfettiWidget(controller, double blastDirection) {
    return Container(
      height: 379.h,
      width: double.infinity,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: controller,
          blastDirection: pi / 2,
          particleDrag: 0.05,
          maxBlastForce: 5,
          minBlastForce: 1,
          emissionFrequency: 0.01,
          numberOfParticles: 15,
          gravity: 0.05,
          shouldLoop: true,
          colors: const [
            Colors.green,
            Colors.yellow,
            Colors.pink,
            Colors.orange,
            Colors.blue
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    margin = ConstantWidget.getScreenPercentSize(context, 2);

    return WillPopScope(
      child: Scaffold(
          appBar: getColorStatusBar(
              (pos < widget._modelExerciseList.length) ? bgColor : lightOrange),
          body: SafeArea(
              child: (pos < widget._modelExerciseList.length)
                  ? getDetailWidget()
                  : FutureBuilder(
                      future: null,
                      builder: (context, snapshot) {
                        print("addHistory");
                        addWholeHistory(
                            context,
                            widget.totalCal,
                            totalDuration,
                            widget._modelDummySend.type,
                            widget._modelDummySend.id);

                        addHistoryData(
                            context,
                            "${widget._modelDummySend.name}",
                            startTime,
                            totalDuration,
                            widget.totalCal,
                            widget._modelDummySend.id,
                            Constants.addDateFormat.format(new DateTime.now()));
                        return Stack(
                          children: [
                            Container(
                              height: double.infinity,
                              width: double.infinity,
                              color: bgDarkWhite,
                              child: Column(
                                children: [
                                  Container(
                                    height: 379.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: category2,
                                        borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(40.h))),
                                    padding: EdgeInsets.only(
                                        bottom: 40.h,
                                        right: 60.h,
                                        left: 68.h,
                                        top: 77.h),
                                    child: getAssetImage("scroe_trophy.png",
                                        height: 218.h, width: 286.h),
                                  ),
                                  ConstantWidget.getVerSpace(54.h),
                                  ConstantWidget.getPaddingWidget(
                                    EdgeInsets.symmetric(horizontal: 20.h),
                                    ConstantWidget.getMultilineCustomFont(
                                        "Congratulation You have Compeleted Workout Series",
                                        17.sp,
                                        textColor,
                                        fontWeight: FontWeight.w500,
                                        txtHeight: 1.41.h,
                                        textAlign: TextAlign.center),
                                  ),
                                  ConstantWidget.getVerSpace(35.h),
                                  Container(
                                    alignment: Alignment.center,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 13.h),
                                    height: 61.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/text_bg.png"),
                                            fit: BoxFit.fill)),
                                    child: getCustomText(
                                        widget._modelDummySend.name,
                                        accentColor,
                                        1,
                                        TextAlign.center,
                                        FontWeight.w700,
                                        22.sp),
                                  ),
                                  ConstantWidget.getVerSpace(35.h),
                                  ConstantWidget.getPaddingWidget(
                                    EdgeInsets.symmetric(horizontal: 20.h),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 19.h, horizontal: 15.h),
                                          decoration: BoxDecoration(
                                              color: '#C9EAFF'.toColor(),
                                              borderRadius:
                                                  BorderRadius.circular(12.h)),
                                          child: Column(
                                            children: [
                                              getAssetImage("dumbell_1.png",
                                                  width: 30.h, height: 30.h),
                                              ConstantWidget.getVerSpace(6.h),
                                              getCustomText(
                                                  "${widget._modelExerciseList.length} Exercise",
                                                  textColor,
                                                  1,
                                                  TextAlign.center,
                                                  FontWeight.w500,
                                                  15.sp)
                                            ],
                                          ),
                                        )),
                                        ConstantWidget.getHorSpace(20.h),
                                        Expanded(
                                            child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 19.h, horizontal: 15.h),
                                          decoration: BoxDecoration(
                                              color: '#E5FFFD'.toColor(),
                                              borderRadius:
                                                  BorderRadius.circular(12.h)),
                                          child: Column(
                                            children: [
                                              getAssetImage("clock1.png",
                                                  width: 30.h, height: 30.h),
                                              ConstantWidget.getVerSpace(6.h),
                                              getCustomText(
                                                  Constants.getTimeFromSec(
                                                      widget.time),
                                                  textColor,
                                                  1,
                                                  TextAlign.center,
                                                  FontWeight.w500,
                                                  15.sp)
                                            ],
                                          ),
                                        )),
                                        ConstantWidget.getHorSpace(20.h),
                                        Expanded(
                                            child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 19.h, horizontal: 15.h),
                                          decoration: BoxDecoration(
                                              color: '#FFF6E3'.toColor(),
                                              borderRadius:
                                                  BorderRadius.circular(12.h)),
                                          child: Column(
                                            children: [
                                              getAssetImage("calories.png",
                                                  width: 30.h, height: 30.h),
                                              ConstantWidget.getVerSpace(6.h),
                                              getCustomText(
                                                  "${Constants.calFormatter.format(widget.totalCal)} Calories",
                                                  textColor,
                                                  1,
                                                  TextAlign.center,
                                                  FontWeight.w500,
                                                  15.sp)
                                            ],
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: ConstantWidget.getPaddingWidget(
                                          EdgeInsets.only(
                                              bottom: 40.h,
                                              right: 20.h,
                                              left: 20.h),
                                          getButton(context, accentColor,
                                              "Continue", Colors.white, () {
                                            // Get.off(()=> HomeWidget(),
                                            //     arguments: 2);
                                            _showInterstitialAd();
                                          }, 20.sp,
                                              weight: FontWeight.w700,
                                              buttonHeight: 60.h,
                                              borderRadius:
                                                  BorderRadius.circular(22.h)),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            Container(
                              child: buildConfettiWidget(
                                  controllerTopCenter, pi / 1),
                              height: 379.h,
                              width: double.infinity,
                            ),
                          ],
                        );
                      },
                    ))),
      onWillPop: () async {
        backDialog();
        return false;
      },
    );
  }

  getCompleteContent(String s, String s1, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: ConstantWidget.getScreenPercentSize(context, 2)),
        margin: EdgeInsets.symmetric(horizontal: (margin / 2)),
        decoration: getDefaultDecoration(
            radius: ConstantWidget.getScreenPercentSize(context, 1.8),
            bgColor: color),
        child: Column(
          children: [
            ConstantWidget.getTextWidget(
                s,
                textColor,
                TextAlign.start,
                FontWeight.w700,
                ConstantWidget.getScreenPercentSize(context, 2.2)),
            SizedBox(
              height: ConstantWidget.getScreenPercentSize(context, 0.3),
            ),
            ConstantWidget.getTextWidget(
                s1,
                textColor,
                TextAlign.start,
                FontWeight.w500,
                ConstantWidget.getScreenPercentSize(context, 1.8)),
          ],
        ),
      ),
      flex: 1,
    );
  }

  void backDialog() {
    if (pos < widget._modelExerciseList.length) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext contexts) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text('Exit'),
              content: Text('Do you really want to quite?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(contexts).pop();
                    Navigator.of(context).pop();
                  },
                  child: getSmallNormalText("YES", Colors.red, TextAlign.start),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(contexts).pop();
                  },
                  child: getSmallNormalText("N0", Colors.red, TextAlign.start),
                )
              ],
            ),
          );
        },
      );
    } else {
      Get.toNamed(Routes.homeScreenRoute, arguments: 0);
    }
  }
}
