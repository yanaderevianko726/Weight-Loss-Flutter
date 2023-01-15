import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:women_lose_weight_flutter/google_ads/custom_ad.dart';
import 'package:women_lose_weight_flutter/ui/common_questions/controllers/common_questions_controller.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';

import '../../../utils/color.dart';
import '../../../utils/sizer_utils.dart';
import '../../../utils/utils.dart';

class CommonQuestionsScreen extends StatelessWidget {
  CommonQuestionsScreen({Key? key}) : super(key: key);

  final CommonQuestionsController _commonQuestionsController =
      Get.find<CommonQuestionsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        bottom: Constant.boolValueFalse,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _widgetBack(),
            _queCategory(),
            _questionsWidget(
              appQue: _commonQuestionsController.appQueList,
              appAns: _commonQuestionsController.appAnsList,
              workoutQue: _commonQuestionsController.workoutQueList,
              workoutAns: _commonQuestionsController.workoutAnsList,
              paymentQue: _commonQuestionsController.paymentQueList,
              paymentAns: _commonQuestionsController.paymentAnsList,
            ),
            const BannerAdClass(),
          ],
        ),
      ),
    );
  }

  _widgetBack() {
    return Container(
      width: AppSizes.fullWidth,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
          left: AppSizes.width_5,
          right: AppSizes.width_5,
          top: AppSizes.height_2,
          bottom: AppSizes.height_3),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Utils.backWidget(iconColor: AppColor.black),
          ),
          Expanded(
            child: Text(
              "\t\t\t\t" + "txtCommonQuestions".tr,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColor.black,
                fontSize: AppFontSize.size_15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _queCategory() {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.height_2),
      height: AppSizes.height_5_8,
      child: ListView(
        padding:
            EdgeInsets.only(left: AppSizes.width_5, right: AppSizes.width_5),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          _itemChip("txtApp".tr, Constant.app),
          _itemChip("txtWorkout".tr, Constant.workOut),
          _itemChip("txtPayment".tr, Constant.payment),
        ],
      ),
    );
  }

  _itemChip(String title, String type) {
    return GetBuilder<CommonQuestionsController>(
      id: Constant.idCommonQuestionsChip,
      builder: (logic) {
        return InkWell(
          onTap: () {
            logic.onItemChip(type);
          },
          child: Container(
            margin: EdgeInsets.only(right: AppSizes.width_2),
            padding: EdgeInsets.symmetric(
                vertical: AppSizes.height_1_5, horizontal: AppSizes.width_5_5),
            decoration: BoxDecoration(
              color: (logic.selectedTab == type)
                  ? AppColor.primary
                  : AppColor.transparent,
              border: Border.all(
                  color: (logic.selectedTab == type)
                      ? AppColor.primary
                      : AppColor.txtColor999),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: (logic.selectedTab == type)
                      ? AppColor.white
                      : AppColor.txtColor999,
                  fontSize: AppFontSize.size_14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _questionsWidget(
      {List? appQue,
      List? workoutQue,
      List? paymentQue,
      List? appAns,
      List? workoutAns,
      List? paymentAns}) {
    return Expanded(
      child: Column(
        children: [
          GetBuilder<CommonQuestionsController>(
            id: Constant.idChangeCommonQuestionList,
            builder: (logic) {
              return Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.width_4),
                  child: ScrollablePositionedList.builder(
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.only(bottom: AppSizes.height_50),
                    itemScrollController:
                        _commonQuestionsController.itemScrollController,
                    itemPositionsListener:
                        _commonQuestionsController.itemPositionsListener,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(top: AppSizes.height_2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: AppSizes.width_3_5,
                                  bottom: AppSizes.height_0_8),
                              child: Text(
                                ((index == 0)
                                        ? "txtAboutApp".tr
                                        : (index == 1)
                                            ? "txtAboutWorkout".tr
                                            : (index == 2)
                                                ? "txtAboutPayment".tr
                                                : "")
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: AppFontSize.size_15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: (index == 0)
                                  ? appQue!.length
                                  : (index == 1)
                                      ? workoutQue!.length
                                      : (index == 2)
                                          ? paymentQue!.length
                                          : 0,
                              itemBuilder: (context, i) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: AppSizes.height_0_5),
                                  decoration: const BoxDecoration(
                                    color: AppColor.bgExpandedTile,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                        dividerColor: AppColor.bgExpandedTile),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8)),
                                      child: ExpansionTile(
                                        title: Text(
                                          (index == 0)
                                              ? appQue![i]
                                              : (index == 1)
                                                  ? workoutQue![i]
                                                  : (index == 2)
                                                      ? paymentQue![i]
                                                      : "",
                                          style: TextStyle(
                                            color: AppColor.black,
                                            fontSize: AppFontSize.size_13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        collapsedIconColor: AppColor.black,
                                        iconColor: AppColor.black,
                                        expandedCrossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        backgroundColor:
                                            AppColor.bgExpandedTile,
                                        childrenPadding: EdgeInsets.only(
                                            left: AppSizes.width_3_5,
                                            bottom: AppSizes.width_3_5,
                                            right: AppSizes.height_1),
                                        children: [
                                          Text(
                                            (index == 0)
                                                ? appAns![i]
                                                : (index == 1)
                                                    ? workoutAns![i]
                                                    : (index == 2)
                                                        ? paymentAns![i]
                                                        : "",
                                            style: TextStyle(
                                              fontSize: AppFontSize.size_13,
                                              color: AppColor.txtColor666,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          _buttonSendFeedback(),
        ],
      ),
    );
  }

  _buttonSendFeedback() {
    return Container(
      width: AppSizes.fullWidth,
      margin: EdgeInsets.only(
          left: AppSizes.width_14,
          right: AppSizes.width_14,
          bottom: AppSizes.height_2,
          top: AppSizes.height_3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColor.greenGradualStartColor,
            AppColor.greenGradualEndColor,
          ],
        ),
      ),
      child: TextButton(
        onPressed: () {
          Utils().sendFeedback();
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
              side: const BorderSide(
                color: AppColor.transparent,
                width: 0.7,
              ),
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSizes.height_1),
          child: Text(
            "txtSendFeedback".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.white,
              fontSize: AppFontSize.size_14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
