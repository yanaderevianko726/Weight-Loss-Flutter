import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

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
      body: SizedBox(
        width: AppSizes.fullWidth,
        height: AppSizes.fullHeight,
        child: Expanded(
          child: NestedScrollView(
            controller: _dietDetailController.scrollController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                _sliverAppBarWidget(),
              ];
            },
            body: _homeDietDetailsList(),
          ),
        ),
      ),      
    );
  }

  _sliverAppBarWidget() {
    return GetBuilder<HomeDietDetailController>(
      id: Constant.idDietDetailSliverAppBar,
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
                Utils.getMultiLanguageString(logic.dietPlan!.dietTitle).toUpperCase(),
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
                  image: NetworkImage(logic.dietPlan!.dietImage),
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
                        logic.dietPlan!.dietTitle),
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
                          logic.dietPlan!.dietDescription),
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

  _itemDietDetailsList(int index, DietDetail detailItem){    
    return InkWell(
      onTap: () {
        _dietDetailController.onDietDetailClick(detailItem);
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
                          detailItem.detailImage,
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
                          Utils.getMultiLanguageString(detailItem.detailTitle),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: AppFontSize.size_12_5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: AppSizes.height_0_8),
                        Text(
                          detailItem.calories + "   •  Kcal",
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
            if (index != _dietDetailController.dietDetailsList.length - 1) ...{
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
