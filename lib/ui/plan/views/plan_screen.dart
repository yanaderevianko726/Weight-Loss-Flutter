import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/table/home_plan_table.dart';
import 'package:women_lose_weight_flutter/routes/app_routes.dart';
import 'package:women_lose_weight_flutter/ui/plan/controllers/plan_controller.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

import '../../../utils/color.dart';
import '../../../utils/constant.dart';
import '../../../utils/utils.dart';
import '../../home/controllers/home_controller.dart';

class PlanScreen extends StatelessWidget {
  PlanScreen({Key? key}) : super(key: key);
  final PlanController _planController = Get.find<PlanController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        vertical: AppSizes.height_3,
        horizontal: AppSizes.width_5,
      ),
      child: Column(
        children: [
          _textHomePlan(),
          _homPlanGrid(),
          _textDaily(),
          _widgetWaterTracker(),
        ],
      ),
    );
  }

  _textHomePlan() {
    return Container(
      margin: EdgeInsets.only(top: AppSizes.height_3),
      width: AppSizes.fullWidth,
      child: AutoSizeText(
        "txtBodyFocus".tr,
        textAlign: TextAlign.left,
        maxLines: 1,
        style: TextStyle(
          color: AppColor.black,
          fontSize: AppFontSize.size_14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _homPlanGrid() {
    return GetBuilder<PlanController>(
        id: Constant.idHomePlansList,
        builder: (logic) {
          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: AppSizes.height_1_5),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: AppSizes.height_40,
                  childAspectRatio: 3 / 2.55,
                  crossAxisSpacing: AppSizes.width_2,
                  mainAxisSpacing: AppSizes.height_1),
              itemCount: logic.homePlansList.length,
              shrinkWrap: Constant.boolValueTrue,
              padding: EdgeInsets.only(bottom: AppSizes.width_4),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemHomePlansGrid(logic.homePlansList[index]);
              },
            ),
          );
        });
  }

  _itemHomePlansGrid(HomePlanTable homePlanList) {
    return InkWell(
      onTap: () {
        if(homePlanList.planId == 80){  // exerciases
          _planController.onExerciseItemClick(homePlanList);
        }else{  // Diets
          _planController.onDietItemClick(homePlanList);
        }        
      },
      child: Card(
        margin: const EdgeInsets.all(0.0),
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  Constant.getAssetImage() + homePlanList.planImage + ".webp"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10.0),
            shape: BoxShape.rectangle,
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: AppSizes.height_3, horizontal: AppSizes.width_5),
            alignment: Alignment.topLeft,
            child: Text(
              Utils.getMultiLanguageString(homePlanList.planName!),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: AppFontSize.size_14,
                color: AppColor.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _textDaily() {
    return Container(
      margin:
          EdgeInsets.only(top: AppSizes.height_3, bottom: AppSizes.height_1_5),
      width: AppSizes.fullWidth,
      child: AutoSizeText(
        "txtDaily".tr,
        textAlign: TextAlign.left,
        maxLines: 1,
        style: TextStyle(
          color: AppColor.black,
          fontSize: AppFontSize.size_14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _widgetWaterTracker() {
    return GetBuilder<HomeController>(
        id: Constant.idCurrentWaterGlass,
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
                          "txtWaterTracker".tr,
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
                                  logic.currentGlass.toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: AppFontSize.size_21,
                                    color: AppColor.commonBlueColor,
                                  ),
                                ),
                                Text(
                                  "\t" + "txt8Cups".tr,
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
                        if (!Utils.isWaterTrackerOn()) ...{
                          Container(
                            margin: EdgeInsets.only(
                                top: AppSizes.height_1_3,
                                bottom: AppSizes.height_2_5),
                            child: Text(
                              "txtWaterOffMessage".tr,
                              textAlign: TextAlign.left,
                              maxLines: 2,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: AppFontSize.size_12_5,
                                color: AppColor.txtColor666,
                              ),
                            ),
                          )
                        },
                        SizedBox(
                          width: AppSizes.fullWidth,
                          child: TextButton(
                            onPressed: () {
                              if (Utils.isWaterTrackerOn()) {
                                Get.toNamed(AppRoutes.waterTracker,
                                    arguments: [logic.currentGlass]);
                                logic.currentWaterGlass();
                              } else {
                                Get.toNamed(AppRoutes.turnOnWater,
                                    arguments: [logic.currentGlass]);
                              }
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
                                "txtDrink".tr.toUpperCase(),
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
                          value: logic.currentGlass! / 8,
                          valueColor: const AlwaysStoppedAnimation(
                              AppColor.commonBlueColor),
                          strokeWidth: AppSizes.width_1_7,
                        ),
                        Padding(
                          padding: EdgeInsets.all(AppSizes.width_7_2),
                          child: Image.asset(
                            Constant.getAssetIcons() + "ic_homepage_drink.webp",
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
