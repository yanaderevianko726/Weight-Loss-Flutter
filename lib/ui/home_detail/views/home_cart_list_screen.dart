import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

import '../../../utils/constant.dart';
import '../../../utils/utils.dart';
import '../controllers/home_cart_list_controller.dart';

class HomeCartListScreen extends StatelessWidget {
  HomeCartListScreen({Key? key}) : super(key: key);
  final HomeCartListController _cartListController =
      Get.find<HomeCartListController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgGrayScreen,
      body: SizedBox(
        width: AppSizes.fullWidth,
        height: AppSizes.fullHeight,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _widgetTopBar(),
              _cartListGrid(),
            ],
          ),
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
              "txtCartList".tr,
              maxLines: 1,
              style: TextStyle(
                color: AppColor.black,
                fontSize: AppFontSize.size_16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  _cartListGrid() {
    return GetBuilder<HomeCartListController>(
      id: Constant.idCartsList,
      builder: (logic) {
        return ListView.builder(
          itemCount: logic.cartsList.length,
          shrinkWrap: Constant.boolValueTrue,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
              horizontal: AppSizes.width_5_5, vertical: AppSizes.height_3_5),
          itemBuilder: (BuildContext context, int index) {
            return _itemCartsList(
                index, logic.cartsList[index]);
          },
        );
      },
    );
  }

  _itemCartsList(index, cart) {
    return InkWell(
      onTap: () {
        _cartListController.onCartItemClick(cart.detailId);
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
                  child: Container(
                    width: AppSizes.height_6,
                    height: AppSizes.height_6,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          cart.detailImage,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.width_4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Utils.getMultiLanguageString(cart.detailTitle),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: AppFontSize.size_12_5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: AppSizes.height_0_8),
                        Text(
                          cart.calories + "   •  Kcal",
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
            if (index != _cartListController.cartsList.length - 1) ...{
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
