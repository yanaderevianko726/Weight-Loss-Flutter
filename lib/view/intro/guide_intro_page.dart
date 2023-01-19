import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../util/color_category.dart';
import '../../util/constant_widget.dart';

import '../../data/data_file.dart';
import '../../models/intro_model.dart';
import '../../util/pref_data.dart';
import '../controller/controller.dart';

class GuideIntroPage extends StatefulWidget {
  @override
  _GuideIntroPage createState() {
    return _GuideIntroPage();
  }
}

class _GuideIntroPage extends State<GuideIntroPage> {
  GuideIntroController controller = Get.put(GuideIntroController());

  Future<bool> _requestPop() {
    if (Platform.isIOS) {
      exit(0);
    } else {
      SystemNavigator.pop();
    }
    return new Future.value(false);
  }

  List<IntroModel> introModelList = [];

  void skip() {
    PrefData.setIsIntro(false);
    Get.toNamed(Routes.homeScreenRoute);
  }

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    introModelList = DataFile.getIntroModel(context);
    return WillPopScope(
        child: Scaffold(
          backgroundColor: introModelList[controller.position].color!,
          resizeToAvoidBottomInset: false,
          appBar: getNoneAppBar(context,
              color: introModelList[controller.position].color!),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: PageView.builder(
                      controller: controller.pageController,
                      itemBuilder: (context, position) {
                        return Container(
                          child: Column(
                            children: [
                              getAssetImage(introModelList[position].image!,
                                  height: 510.h,
                                  width: double.infinity,
                                  boxFit: BoxFit.fill),
                              SizedBox(
                                height: 40.h,
                              ),
                              ConstantWidget.getCustomText(
                                  introModelList[position].name!,
                                  Colors.black,
                                  2,
                                  TextAlign.center,
                                  FontWeight.w700,
                                  28.sp).paddingSymmetric(horizontal: 25.w),
                              // SizedBox(
                              //   height: 12.h,
                              // ),
                              // ConstantWidget.getMultilineCustomFont(
                              //     introModelList[position].desc!,
                              //     15.sp,
                              //     descriptionColor,
                              //     fontWeight: FontWeight.w500,
                              //     textAlign: TextAlign.center,
                              //     txtHeight: 1.46.h),
                              SizedBox(
                                height: 30.h,
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: introModelList.length,
                      onPageChanged: _onPageViewChange,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 8.h,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: introModelList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return (index == controller.position)
                                  ? Center(
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10.h),
                                        height: 8.h,
                                        width: 17.h,
                                        decoration: BoxDecoration(
                                            color: accentColor,
                                            borderRadius:
                                                BorderRadius.circular(13.h)),
                                      ),
                                    )
                                  : Container(
                                      height: 8.h,
                                      width: 8.h,
                                      margin: EdgeInsets.only(right: 10.h),
                                      decoration: BoxDecoration(
                                        color: accentColor.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                    );
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                ConstantWidget.getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 20.h),
                  ConstantWidget.getButtonWidget(
                      context,
                      (controller.position == (introModelList.length - 1))
                          ? 'Get Started'
                          : 'Next',
                      accentColor, () {
                    onNext();
                  }),
                ),
                SizedBox(height: 20.h),
                InkWell(
                  onTap: () {
                    skip();
                  },
                  child: ConstantWidget.getCustomText("Skip", Colors.black, 1,
                      TextAlign.center, FontWeight.w500, 17.sp),
                ),
                SizedBox(
                  height: 36.h,
                )
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  onNext() {
    if (controller.position < (introModelList.length - 1)) {
      controller.position++;
      controller.pageController.jumpToPage(controller.position);
    } else {
      skip();
    }
  }

  _onPageViewChange(int page) {
    controller.position = page;
    setState(() {});
  }
}
