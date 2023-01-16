import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart';
import 'package:women_lose_weight_flutter/ui/home_detail/controllers/home_diet_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';
import '../../../utils/utils.dart';

class DietsScreen extends StatelessWidget {
  DietsScreen({Key? key}) : super(key: key);
  final HomeDietController _homedietController =
      Get.find<HomeDietController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgGrayScreen,
      body: SafeArea(
        child: GetBuilder<HomeDietController>(
        id: Constant.idDietPlanList,
          builder: (controller) {
            return Column(
              children: [
                _widgetTopBar(),
                if(_homedietController.isLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if(!_homedietController.isLoading && _homedietController.dietList.isEmpty)
                  const Expanded(
                    child: Center(child: Text("There is no any diet plans.")),
                  ),
                if(!_homedietController.isLoading && _homedietController.dietList.isNotEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        vertical: AppSizes.height_3,
                        horizontal: AppSizes.width_5,
                      ),
                      child: Column(
                        children: [
                          _textDietPlan(),
                          _dietsGrid(),
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
              "plan_name_81".tr,
              maxLines: 1,
              style: TextStyle(
                color: AppColor.black,
                fontSize: AppFontSize.size_16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Spacer(),
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: (){

              },
              child: GetBuilder<HomeDietController>(
                id: Constant.idCartsInDietList,
                builder: (controller) {
                  return Badge(
                    shape: BadgeShape.circle,
                    padding: const EdgeInsets.all(8),
                    animationType: BadgeAnimationType.scale,
                    animationDuration: const Duration(milliseconds: 200),
                    badgeColor: Colors.red,
                    badgeContent: Text(
                      '${controller.carrtsList.length}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: AppColor.white,
                        fontSize: AppFontSize.size_9,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    child: SizedBox(
                      height: AppSizes.height_5,
                      width: AppSizes.height_5,
                      child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.expand,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 1),
                            child: CircularProgressIndicator(
                              backgroundColor: AppColor.commonBlueLightColor,
                              value: 1,
                              valueColor: const AlwaysStoppedAnimation(
                                  AppColor.commonBlueColor),
                              strokeWidth: AppSizes.width_1_2,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: AppSizes.width_2,
                                right: AppSizes.width_2_5,
                                bottom: AppSizes.width_2_5,
                                top: AppSizes.width_2),
                            child: const Icon(Icons.shopping_cart,
                              color: AppColor.commonBlueColor,),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }

  _textDietPlan() {
    return Container(
      margin: const EdgeInsets.only(top: 4.0),
      width: AppSizes.fullWidth,
      child: AutoSizeText(
        '${"plan_name_81".tr}s',
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

  _dietsGrid() {
    return GetBuilder<HomeDietController>(
        id: Constant.idDietPlanList,
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
              itemCount: logic.dietList.length,
              shrinkWrap: Constant.boolValueTrue,
              padding: EdgeInsets.only(bottom: AppSizes.width_4),
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _itemDietGrid(logic.dietList[index]);
              },
            ),
          );
        });
  }

  _itemDietGrid(DietPlan _dietPlan) {
    return InkWell(
      onTap: () {
        _homedietController.onDietItemClick(_dietPlan);
      },
      child: Card(
        margin: const EdgeInsets.all(0.0),
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(_dietPlan.dietImage),
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
              Utils.getMultiLanguageString(_dietPlan.dietTitle),
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
}
