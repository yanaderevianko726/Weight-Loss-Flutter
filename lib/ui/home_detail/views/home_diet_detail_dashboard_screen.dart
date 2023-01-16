import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

import '../../../utils/utils.dart';
import '../controllers/home_diet_detail_dashboard_controller.dart';

class HomeDietDetailDashboard extends StatelessWidget {
  HomeDietDetailDashboard({Key? key}) : super(key: key);
  final HomeDietDetailDashboardController _dietDetailDashboardController =
      Get.find<HomeDietDetailDashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgGrayScreen,
      body: SafeArea(
        child: GetBuilder<HomeDietDetailDashboardController>(
          id: Constant.idDietDetailsDashboard,
          builder: (controller) {
            return Stack(
              children: [
                Column(
                  children: [
                    _widgetTopBar(),
                    _dashboardView(),
                  ],
                ),
                if(_dietDetailDashboardController.isLoading)
                  SizedBox(
                    width: AppSizes.fullWidth,
                    height: AppSizes.fullHeight,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
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
              _dietDetailDashboardController.dietDetail!.detailTitle,
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
  
  _dashboardView() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: AppSizes.fullWidth,
              height: 160,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppColor.transparent,
                image: DecorationImage(
                  image: NetworkImage(_dietDetailDashboardController.dietDetail!.detailImage),
                  colorFilter: ColorFilter.mode(
                      AppColor.black.withOpacity(.13), BlendMode.darken),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 18,),
            Container(
              width: AppSizes.fullWidth,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _dietDetailDashboardController.dietDetail!.detailTitle,
                style: TextStyle(
                  fontSize: AppFontSize.size_16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12,),
            Container(
              width: AppSizes.fullWidth,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${"txtDescription".tr}: ',
                style: TextStyle(
                  fontSize: AppFontSize.size_14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: AppSizes.fullWidth,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              child: Text(
                _dietDetailDashboardController.dietDetail!.detailDesc,
                style: TextStyle(
                  fontSize: AppFontSize.size_14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 12,),
            Container(
              width: AppSizes.fullWidth,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '${"txtCalories".tr}: ',
                style: TextStyle(
                  fontSize: AppFontSize.size_14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: AppSizes.fullWidth,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              child: Text(
                '${_dietDetailDashboardController.dietDetail!.calories} • kcal',
                style: TextStyle(
                  fontSize: AppFontSize.size_14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 18,),
            InkWell(
              onTap: () {
                _dietDetailDashboardController.onAddCart(_dietDetailDashboardController.dietDetail!);
              },
              child: Container(
                width: AppSizes.fullWidth,
                height: 44,
                margin: const EdgeInsets.only(left: 32, right: 34),
                child: Row(
                  children: [
                    const Spacer(),
                    const Icon(Icons.shopping_cart, size: 24, color: Colors.white,),
                    const SizedBox(width: 8,),
                    Text(
                      'Add to Cart'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  color: Colors.green
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
