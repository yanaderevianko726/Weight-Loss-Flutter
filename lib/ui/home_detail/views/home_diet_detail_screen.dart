import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

import '../../../routes/app_routes.dart';
import '../../../utils/utils.dart';
import '../controllers/home_diet_detail_controller.dart';

class HomeDietDetailScreen extends StatelessWidget {
  HomeDietDetailScreen({Key? key}) : super(key: key);
  final HomeDietDetailController _dietDetailController =
      Get.find<HomeDietDetailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgGrayScreen,
      body: SafeArea(
        bottom:
            (Platform.isIOS) ? Constant.boolValueFalse : Constant.boolValueTrue,
        child: GetBuilder<HomeDietDetailController>(
          builder: (controller) {
            return Column(
              children: [
                _widgetTopBar(),                
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      vertical: AppSizes.height_3,
                      horizontal: AppSizes.width_5,
                    ),
                    child: Column(
                      children: [
                        _widgetCaloriesTracker(),
                        _homeDietDetailsList(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),      
    );
  }

  _widgetBack() {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Utils.backWidget(iconColor: AppColor.black),
    );
  }

  _widgetTopBar() {
    return Padding(
      padding: EdgeInsets.only(left: AppSizes.width_3, bottom: 4.0, top: AppSizes.height_2_5),
      child: Row(
        children: [
          _widgetBack(),
          Padding(
            padding: EdgeInsets.only(left: AppSizes.width_5),
            child: AutoSizeText(
              _dietDetailController.dietPlan!.dietTitle,
              maxLines: 1,
              style: TextStyle(
                color: AppColor.black,
                fontSize: AppFontSize.size_16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            width: AppSizes.width_1,
          ),
        ],
      ),
    );
  }

  _homeDietDetailsList() {
    return GetBuilder<HomeDietDetailController>(
      id: Constant.idDietDetailsList,
      builder: (logic) {
        return ListView.builder(
          itemCount: logic.dietDetailsList.length,
          shrinkWrap: Constant.boolValueTrue,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
              horizontal: AppSizes.width_5_5, vertical: AppSizes.height_3_5),
          itemBuilder: (BuildContext context, int index) {
            return _itemDietDetailsList(
                index, logic.dietDetailsList[index]);
          },
        );
      },
    );
  }

  _itemDietDetailsList(int index, DietDetail dietDetail){    
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.exerciseList,
            arguments: [dietDetail, null, null]);
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
                    Constant.getAssetIcons() + "ic_homepage_drink.webp",
                    height: AppSizes.height_5,
                    width: AppSizes.height_5,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.width_4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dietDetail.caolries,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: AppFontSize.size_12_5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            "  •  Cal",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: AppColor.txtColor666,
                              fontSize: AppFontSize.size_10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Spacer(),                        
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            dietDetail.day,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: AppColor.txtColor666,
                              fontSize: AppFontSize.size_10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (index !=
                _dietDetailController.dietDetailsList.length - 1) ...{
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

  _widgetCaloriesTracker(){
    return GetBuilder<HomeDietDetailController>(
        id: Constant.idDietDetailsList,
        builder: (logic) {
          return Card(
            margin: const EdgeInsets.all(0.0),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              width: AppSizes.fullWidth,
              decoration: BoxDecoration(
                color: AppColor.cardBackgroundColor,
                borderRadius: BorderRadius.circular(12.0),
                shape: BoxShape.rectangle,
              ),
              padding: EdgeInsets.symmetric(
                  vertical: AppSizes.height_3, horizontal: AppSizes.width_5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          logic.dietPlan!.dietTitle,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: AppFontSize.size_14,
                            color: AppColor.black,
                          ),
                        ),
                        if (Utils.isWaterTrackerOn()) ...{
                          Container(
                            margin: EdgeInsets.only(
                                top: AppSizes.height_1_3,
                                bottom: AppSizes.height_2_5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  logic.dietDetailsList.isNotEmpty ? logic.dietDetailsList.last.caolries : '0',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: AppFontSize.size_21,
                                    color: AppColor.commonBlueColor,
                                  ),
                                ),
                                Text(
                                  ' / ${logic.dietPlan!.dietCalories} • Cal',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: AppFontSize.size_14,
                                    color: AppColor.txtColor666,
                                  ),
                                ),
                              ],
                            ),
                          )
                        },
                        SizedBox(
                          width: AppSizes.fullWidth,
                          child: TextButton(
                            onPressed: () {
                              logic.onAddNewCalory();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  AppColor.commonBlueColor),
                              elevation: MaterialStateProperty.all(2),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0),
                                  side: const BorderSide(
                                      color: AppColor.transparent, width: 0.7),
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: AppSizes.height_0_6),
                              child: Text(
                                "txtSet".tr.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: AppFontSize.size_14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: AppSizes.height_13,
                    width: AppSizes.height_13,
                    margin: EdgeInsets.only(left: AppSizes.width_7),
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          backgroundColor: AppColor.commonBlueLightColor,
                          value: logic.dietDetailsList.isNotEmpty ? int.parse(logic.dietDetailsList.last.caolries) / int.parse(logic.dietPlan!.dietCalories) : 0,
                          valueColor: const AlwaysStoppedAnimation(
                              AppColor.commonBlueColor),
                          strokeWidth: AppSizes.width_1_7,
                        ),
                        Padding(
                          padding: EdgeInsets.all(AppSizes.width_7_2),
                          child: Image.asset(
                            Constant.getAssetIcons() + "ic_finish_faq.webp",
                            alignment: Alignment.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
