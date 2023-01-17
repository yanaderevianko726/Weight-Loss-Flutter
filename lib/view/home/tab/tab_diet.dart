import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../iapurchase/prefrence.dart';
import '../../../models/DietCategoryModel.dart';

import '../../../routes/app_routes.dart';
import '../../../util/category_cont.dart';
import '../../../util/color_category.dart';
import '../../../util/constant_url.dart';
import '../../../util/constant_widget.dart';

import '../../../util/constants.dart';
import '../../../util/net_check_cont.dart';
import '../../../util/widgets.dart';

import 'package:get/get.dart';

import '../../controller/controller.dart';
import '../../diet/diet_sub_cateogory.dart';
import '../../in_app_purchase.dart';

class TabDiet extends StatefulWidget {
  @override
  _TabDiet createState() => _TabDiet();
}

class _TabDiet extends State<TabDiet> with TickerProviderStateMixin {
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
      catController.loadDietCategory(context);
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

  @override
  void dispose() {
    super.dispose();
  }

  void onBackClicked() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onBackClicked();
        return false;
      },
       child: Scaffold(
         backgroundColor: Colors.white,
         resizeToAvoidBottomInset: false,
         body: SafeArea(
           child: Container(
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
                    children: [
                      buildDiet(),
                      buildDietPlan(),
                    ],
                  ),
                ),
              ],
            ),
      ),
         ),
       ),
    );
  }

  GetXNetworkManager _networkManager = Get.find<GetXNetworkManager>();
  CategoryController catController = Get.put(CategoryController());

  buildDietPlan() {
    return GetBuilder<SettingController>(
      init: SettingController(),
      builder: (controller) => Container(
        height: 169.h,
        margin: EdgeInsets.only(bottom: 5.h),
        child: InkWell(
          onTap: () async {
            if (!i) {
              Get.to(InAppPurchase())!.then((value) => setState);
            } else {
              if (await ConstantUrl.isLogin()) {
                Get.toNamed(Routes.CustomDietPlanRoute);
              } else {
                ConstantUrl.sendLoginPage(context, function: () {
                  if (controller.isLogin.value) {
                    Get.toNamed(Routes.CustomDietPlanRoute);
                  }
                }, name: () {
                  Get.back();
                });
              }
            }
          },
          child: Container(
            margin: EdgeInsetsDirectional.only(end: 20.h, start: 20.h),
            width: double.infinity,
            child: Column(
              children: [
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
                              getCustomText("Custom Diet Plan", textColor, 1,
                                  TextAlign.start, FontWeight.w700, 22.sp),
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
                                  getCustomText("Let’s Start", textColor, 1,
                                      TextAlign.start, FontWeight.w600, 16.sp),
                                  ConstantWidget.getHorSpace(6.h),
                                  getSvgImage("arrow_right.svg",
                                      height: 24.h,
                                      width: 24.h,
                                      color: textColor)
                                ],
                              ),
                              !i
                                  ? Container(
                                      margin: EdgeInsets.only(top: 10.h),
                                      width: 85.h,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.h, vertical: 2.h),
                                      decoration: BoxDecoration(
                                          color: bgDarkWhite,
                                          borderRadius:
                                              BorderRadius.circular(20.h)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          getAssetImage("crown.png",
                                              height: 20.h, width: 20.h),
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

  Widget buildDiet() {
    return GetBuilder<GetXNetworkManager>(
      init: GetXNetworkManager(),
      builder: (GetxController controller) {
        if (_networkManager.isNetwork == true) {
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
                      ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: dietCategory.length,
                          primary: false,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Dietcategory _modelWorkoutList =
                                dietCategory[index];

                            return GetBuilder<SettingController>(
                              init: SettingController(),
                              builder: (settingController) => Container(
                                height: 194.h,
                                margin: EdgeInsets.symmetric(horizontal: 20.h),
                                child: Column(
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          if (await ConstantUrl.isLogin()) {
                                            Constants.sendToScreen1(
                                                context,
                                                SubDietCategory(
                                                    _modelWorkoutList
                                                        .dietCategoryId!,
                                                    _modelWorkoutList));
                                          } else {
                                            ConstantUrl.sendLoginPage(context,
                                                function: () {
                                              if (settingController
                                                  .isLogin.value) {
                                                Constants.sendToScreen1(
                                                    context,
                                                    SubDietCategory(
                                                        _modelWorkoutList
                                                            .dietCategoryId!,
                                                        _modelWorkoutList));
                                              }
                                            }, name: () {
                                              Get.back();
                                            });
                                          }
                                        },
                                        child: Stack(
                                          alignment:
                                              AlignmentDirectional.centerEnd,
                                          clipBehavior: Clip.none,
                                          children: [
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              width: double.infinity,
                                              height: 150.h,
                                              decoration: BoxDecoration(
                                                  color: getRandomColor(index),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          22.h)),
                                              child: getCustomText(
                                                      _modelWorkoutList
                                                          .category!,
                                                      textColor,
                                                      3,
                                                      TextAlign.start,
                                                      FontWeight.w700,
                                                      20.sp)
                                                  .marginOnly(
                                                      left: 17.h, right: 200.h),
                                            ),
                                            Positioned(
                                                height: 130.h,
                                                width: 130.h,
                                                // bottom: -3.h,
                                                // right: 19.h,
                                                child: Hero(
                                                  tag: _modelWorkoutList.image!,
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
                                        )),
                                  ],
                                ),
                              ),
                            );
                          }),
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
        } else {
          return getProgressDialog();
        }
      },
    );
  }

  HomeController homeController = Get.find();

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
                    onBackClicked();
                  }),
              ConstantWidget.getHorSpace(12.h),
              getCustomText("Diet Plans", textColor, 1, TextAlign.start,
                  FontWeight.w700, 22.sp)
            ],
          ),
        ],
      ),
    );
  }
}
