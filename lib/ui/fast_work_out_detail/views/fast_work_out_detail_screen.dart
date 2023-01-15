import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/table/home_plan_table.dart';
import 'package:women_lose_weight_flutter/google_ads/custom_ad.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

import '../../../utils/utils.dart';
import '../controllers/fast_work_out_detail_controller.dart';

class FastWorkOutDetailScreen extends StatelessWidget {
  FastWorkOutDetailScreen({Key? key}) : super(key: key);

  final FastWorkOutDetailController _fastWorkOutDetailController =
      Get.find<FastWorkOutDetailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        top: Constant.boolValueFalse,
        bottom:
            (Platform.isIOS) ? Constant.boolValueFalse : Constant.boolValueTrue,
        child: Column(
          children: [
            Expanded(
              child: NestedScrollView(
                controller: _fastWorkOutDetailController.scrollController,
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    _sliverAppBarWidget(),
                  ];
                },
                body: _fastWorkOutDetailsExerciseList(),
              ),
            ),
            const BannerAdClass(),
          ],
        ),
      ),
    );
  }

  _sliverAppBarWidget() {
    return GetBuilder<FastWorkOutDetailController>(
      id: Constant.idFastWorkOutDetailSliverAppBar,
      builder: (logic) {
        return SliverAppBar(
          elevation: 0.8,
          expandedHeight: AppSizes.height_25_5,
          floating: Constant.boolValueFalse,
          pinned: Constant.boolValueTrue,
          backgroundColor: AppColor.white,
          centerTitle: Constant.boolValueFalse,
          automaticallyImplyLeading: Constant.boolValueFalse,
          titleSpacing: AppSizes.width_1_5,
          title: (logic.isShrink)
              ? Text(
                  Utils.getMultiLanguageString(logic.fastWorkoutItem!.planName!)
                      .toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.w700,
                    fontSize: AppFontSize.size_15,
                  ),
                )
              : Container(),
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Icon(
                Icons.arrow_back_sharp,
                color: (logic.isShrink) ? AppColor.black : AppColor.white,
                size: AppSizes.height_3,
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: Constant.boolValueFalse,
            background: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  left: AppSizes.width_6,
                  right: AppSizes.width_6,
                  bottom: AppSizes.height_3_5),
              decoration: BoxDecoration(
                color: AppColor.transparent,
                image: DecorationImage(
                  image: AssetImage(Constant.getAssetImage() +
                      logic.fastWorkoutItem!.planImage +
                      ".webp"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utils.getMultiLanguageString(
                        logic.fastWorkoutItem!.planName!),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.white,
                      fontWeight: FontWeight.w700,
                      fontSize: AppFontSize.size_18,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: AppSizes.height_0_3, bottom: AppSizes.height_1),
                    child: AutoSizeText(
                      Utils.getMultiLanguageString(
                          logic.fastWorkoutItem!.shortDes!),
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      style: TextStyle(
                        color: AppColor.white,
                        fontWeight: FontWeight.w400,
                        fontSize: AppFontSize.size_11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _fastWorkOutDetailsExerciseList() {
    return GetBuilder<FastWorkOutDetailController>(
      id: Constant.idSubFastWorkoutList,
      builder: (logic) {
        return ListView.builder(
          itemCount: logic.fastWorkoutSubPlanList.length,
          shrinkWrap: Constant.boolValueTrue,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
              horizontal: AppSizes.width_5_5, vertical: AppSizes.height_4),
          itemBuilder: (BuildContext context, int index) {
            return _itemFastWorkOutDetailsExerciseList(
                index, logic.fastWorkoutSubPlanList[index]);
          },
        );
      },
    );
  }

  _itemFastWorkOutDetailsExerciseList(
      int index, HomePlanTable fastWorkoutSubPlanList) {
    return InkWell(
      onTap: () {
        _fastWorkOutDetailController
            .onItemFastWorkOutDetailsExerciseClick(fastWorkoutSubPlanList);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.height_4),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                Constant.getAssetImage() +
                    fastWorkoutSubPlanList.planThumbnail +
                    ".webp",
                height: AppSizes.height_6,
                width: AppSizes.height_6,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.width_4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // fastWorkoutSubPlanList.planName!,
                      (index == 0)
                          ? "txtBeginner".tr
                          : (index == 1)
                              ? "txtIntermediate".tr
                              : "txtAdvanced".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AppColor.black,
                        fontSize: AppFontSize.size_12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: AppSizes.height_0_8),
                    Text(
                      fastWorkoutSubPlanList.planMinutes! + " " + "txtMins".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: AppColor.txtColor666,
                        fontSize: AppFontSize.size_9,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
