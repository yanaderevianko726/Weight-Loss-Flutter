import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/table/home_plan_table.dart';
import 'package:women_lose_weight_flutter/google_ads/custom_ad.dart';
import 'package:women_lose_weight_flutter/ui/home_detail/controllers/home_detail_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/utils.dart';

class HomeDetailScreen extends StatelessWidget {
  HomeDetailScreen({Key? key}) : super(key: key);
  final HomeDetailController _homeDetailController =
      Get.find<HomeDetailController>();

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
                controller: _homeDetailController.scrollController,
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    _sliverAppBarWidget(),
                  ];
                },
                body: _homeDetailsExerciseList(),
              ),
            ),
            const BannerAdClass(),
          ],
        ),
      ),
    );
  }

  _sliverAppBarWidget() {
    return GetBuilder<HomeDetailController>(
      id: Constant.idHomeDetailSliverAppBar,
      builder: (logic) {
        return SliverAppBar(
          elevation: 0.8,
          expandedHeight: AppSizes.height_24,
          floating: Constant.boolValueFalse,
          pinned: Constant.boolValueTrue,
          backgroundColor: AppColor.white,
          centerTitle: Constant.boolValueFalse,
          automaticallyImplyLeading: Constant.boolValueFalse,
          titleSpacing: AppSizes.width_1_5,
          title: (logic.isShrink)
              ? Text(
                  Utils.getMultiLanguageString(logic.bodyFocusItem!.planName!)
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
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.width_6, vertical: 0.0),
              decoration: BoxDecoration(
                color: AppColor.transparent,
                image: DecorationImage(
                  image: AssetImage(Constant.getAssetImage() +
                      logic.bodyFocusItem!.planImage!),
                  colorFilter: ColorFilter.mode(
                      AppColor.black.withOpacity(.13), BlendMode.darken),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utils.getMultiLanguageString(
                        logic.bodyFocusItem!.planName!),
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
                          logic.bodyFocusItem!.shortDes!),
                      textAlign: TextAlign.left,
                      maxLines: 4,
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

  _homeDetailsExerciseList() {
    return GetBuilder<HomeDetailController>(
      id: Constant.idBodyFocusSubList,
      builder: (logic) {
        return ListView.builder(
          itemCount: logic.bodyFocusSubPlanList.length,
          shrinkWrap: Constant.boolValueTrue,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
              horizontal: AppSizes.width_5_5, vertical: AppSizes.height_3_5),
          itemBuilder: (BuildContext context, int index) {
            return _itemHomeDetailsExerciseList(
                index, logic.bodyFocusSubPlanList[index]);
          },
        );
      },
    );
  }

  _itemHomeDetailsExerciseList(int index, HomePlanTable bodyFocus) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.exerciseList,
            arguments: [bodyFocus, null, null]);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: AppSizes.height_3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    Constant.getAssetImage() +
                        bodyFocus.planThumbnail +
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
                          Utils.getMultiLanguageString(
                              bodyFocus.planName!),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: AppFontSize.size_12_5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: AppSizes.height_0_8),
                        Text(
                          bodyFocus.planMinutes! +
                              " ${"txtMins".tr}  •  " +
                              Utils.getExerciseLevelString(bodyFocus.planLvl!),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppColor.txtColor666,
                            fontSize: AppFontSize.size_10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (index !=
                _homeDetailController.bodyFocusSubPlanList.length - 1) ...{
              Container(
                color: AppColor.grayDivider,
                height: AppSizes.height_0_05,
                margin: EdgeInsets.only(top: AppSizes.height_1_5),
                child: null,
              ),
            },
          ],
        ),
      ),
    );
  }
}
