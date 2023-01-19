import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../models/DietCategoryModel.dart';
import '../../util/category_cont.dart';
import '../../util/color_category.dart';
import '../../util/constant_url.dart';
import '../../util/constant_widget.dart';
import '../../util/constants.dart';
import '../../util/net_check_cont.dart';
import '../../util/widgets.dart';
import '../controller/controller.dart';
import 'diet_sub_cateogory.dart';

class DietListScreen extends StatefulWidget {
  const DietListScreen({Key? key}) : super(key: key);

  @override
  State<DietListScreen> createState() => _DietListScreenState();
}

class _DietListScreenState extends State<DietListScreen> {
  Future<bool> _requestPop() {
    Get.back();

    return new Future.value(false);
  }

  CategoryController catController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
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
                    getCustomText("Diet Plan", textColor, 1, TextAlign.start,
                        FontWeight.w700, 22.sp)
                  ],
                ),
                ConstantWidget.getVerSpace(30.h),
                Expanded(child: buildDiet())
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
                          Dietcategory _modelWorkoutList = dietCategory[index];

                          return GetBuilder<SettingController>(
                            init: SettingController(),
                            builder: (settingController) => Container(
                              height: 194.h,
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      Constants.sendToScreen1(
                                            context,
                                            SubDietCategory(
                                                _modelWorkoutList
                                                    .dietCategoryId!,
                                                _modelWorkoutList));
                                      // if (await ConstantUrl.isLogin()) {
                                      //   Constants.sendToScreen1(
                                      //       context,
                                      //       SubDietCategory(
                                      //           _modelWorkoutList
                                      //               .dietCategoryId!,
                                      //           _modelWorkoutList));
                                      // } else {
                                      //   // if (await PrefData.getFirstSignUp() ==
                                      //   //     true) {
                                      //   //   Get.toNamed(Routes.introRoute,arguments: (){
                                      //   //     Constants.sendToScreen1(
                                      //   //         context,
                                      //   //         SubDietCategory(
                                      //   //             _modelWorkoutList
                                      //   //                 .dietCategoryId!,
                                      //   //             _modelWorkoutList));
                                      //   //   });
                                      //   // }
                                      //   // else {
                                      //     ConstantUrl.sendLoginPage(context,
                                      //         function: () {
                                      //       if (settingController
                                      //           .isLogin.value) {
                                      //         Constants.sendToScreen1(
                                      //             context,
                                      //             SubDietCategory(
                                      //                 _modelWorkoutList
                                      //                     .dietCategoryId!,
                                      //                 _modelWorkoutList));
                                      //       }
                                      //     }, name: () {
                                      //       Get.back();
                                      //     });
                                      //   // }
                                      // }
                                    },
                                    child: Stack(
                                      alignment: AlignmentDirectional.bottomEnd,
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          height: 182.h,
                                          decoration: BoxDecoration(
                                              color: getRandomColor(index),
                                              borderRadius:
                                                  BorderRadius.circular(22.h)),
                                          padding: EdgeInsetsDirectional.only(
                                              start: 20.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ConstantWidget.getVerSpace(20.h),
                                              getCustomText(
                                                      _modelWorkoutList
                                                          .category!,
                                                      textColor,
                                                      3,
                                                      TextAlign.start,
                                                      FontWeight.w700,
                                                      20.sp)
                                                  .marginOnly(right: 110.h),
                                              ConstantWidget.getVerSpace(10.h),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                            height: 200.h,
                                            width: 160.h,
                                            child: Hero(
                                              tag: _modelWorkoutList.image!,
                                              child: Padding(
                                                padding:
                                                    EdgeInsetsDirectional.only(
                                                        end: 19.h),
                                                child: CachedNetworkImage(
                                                  imageUrl: ConstantUrl
                                                          .uploadUrl +
                                                      _modelWorkoutList.image!,
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
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
      },
    );
  }
}
