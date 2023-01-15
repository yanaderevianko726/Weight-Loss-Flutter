import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/ui/home_detail/controllers/home_diet_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';
import '../../../utils/utils.dart';
import '../controllers/diet_adjust_controller.dart';

class DietAdjustDetailsScreen extends StatelessWidget {
  DietAdjustDetailsScreen({Key? key}) : super(key: key);
  final DietAdjustController _dietAdjustController =
      Get.find<DietAdjustController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgGrayScreen,
      body: SafeArea(
        child: GetBuilder<DietAdjustController>(
        id: Constant.idDietAdjustList,
          builder: (controller) {
            return Stack(
              children: [
                Column(
                  children: [
                    _widgetTopBar(),
                    if(_dietAdjustController.isLoading)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    if(!_dietAdjustController.isLoading && _dietAdjustController.dietList.isEmpty)
                      const Expanded(
                        child: Center(child: Text("There is no any diet plans.")),
                      ),
                    if(!_dietAdjustController.isLoading && _dietAdjustController.dietList.isNotEmpty)
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
          SizedBox(
            width: AppSizes.width_1,
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
    return GetBuilder<DietAdjustController>(
        id: Constant.idDietAdjustList,
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
        _dietAdjustController.onDietItemClick(_dietPlan);
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
