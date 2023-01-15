import 'package:align_positioned/align_positioned.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/google_ads/custom_ad.dart';
import 'package:women_lose_weight_flutter/routes/app_routes.dart';
import 'package:women_lose_weight_flutter/ui/completed/controllers/completed_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';

import '../../../common/dialog/weight_height/weight_height.dart';
import '../../../utils/color.dart';
import '../../../utils/sizer_utils.dart';
import '../../../utils/utils.dart';

class CompletedScreen extends StatelessWidget {
  CompletedScreen({Key? key}) : super(key: key);

  final CompletedController _completedController =
      Get.find<CompletedController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _completedController.onNextButtonClick();
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: AppSizes.fullWidth,
                padding: EdgeInsets.only(
                    left: AppSizes.width_5,
                    right: AppSizes.width_5,
                    top: AppSizes.height_3,
                    bottom: AppSizes.height_4),
                decoration: BoxDecoration(
                  color: AppColor.black,
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.6), BlendMode.dstATop),
                    image:
                        AssetImage(Constant.getAssetImage() + "splash_bg.webp"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _widgetBack(),
                      SizedBox(height: AppSizes.height_2_5),
                      _textYouRock(),
                      SizedBox(height: AppSizes.height_0_5),
                      _textOfficeWorkout(),
                      SizedBox(height: AppSizes.height_3_5),
                      _exKDCountWidget(),
                      SizedBox(height: AppSizes.height_3_5),
                      _doItAgainAndShareButton(),
                    ],
                  ),
                ),
              ),
              Container(
                width: AppSizes.fullWidth,
                color: AppColor.bgPurple,
                padding: EdgeInsets.symmetric(
                    vertical: AppSizes.height_1,
                    horizontal: AppSizes.width_2_5),
                child: Column(
                  children: [
                    _reminderWidget(),
                    SizedBox(height: AppSizes.height_1_2),
                    _weightWidget(),
                    SizedBox(height: AppSizes.height_1_2),
                    _bmiWidget(),
                    SizedBox(height: AppSizes.height_1_2),
                    _iFeelWidget(),
                    SizedBox(height: AppSizes.height_1_2),
                    _howOftenShouldWidget(),
                    SizedBox(height: AppSizes.height_1_8),
                    _nextButton(),
                  ],
                ),
              ),
              const BannerAdClass(),
            ],
          ),
        ),
      ),
    );
  }

  _widgetBack() {
    return InkWell(
      onTap: () {
        _completedController.onNextButtonClick();
      },
      child: Utils.backWidget(iconColor: AppColor.white),
    );
  }

  _textYouRock() {
    return Text(
      ("txtYouRock".tr + "!").toUpperCase(),
      textAlign: TextAlign.left,
      style: TextStyle(
        color: AppColor.white,
        fontSize: AppFontSize.size_24,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  _textOfficeWorkout() {
    return Text(
      "txtOfficeWorkoutBeginner".tr.toUpperCase(),
      textAlign: TextAlign.left,
      style: TextStyle(
        color: AppColor.white.withOpacity(.6),
        fontSize: AppFontSize.size_11_5,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  _exKDCountWidget() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                _completedController.exerciseList.length.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: AppFontSize.size_15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "txtExercise".tr,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColor.white.withOpacity(.6),
                  fontSize: AppFontSize.size_11_5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                Utils.getCalorieFromSec(_completedController.totalExTime)
                    .toStringAsFixed(2),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: AppFontSize.size_15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "txtKcal".tr,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColor.white.withOpacity(.6),
                  fontSize: AppFontSize.size_11_5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                Utils.secToString(_completedController.totalExTime),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: AppFontSize.size_15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              AutoSizeText(
                "txtDuration".tr,
                textAlign: TextAlign.left,
                maxLines: 1,
                style: TextStyle(
                  color: AppColor.white.withOpacity(.6),
                  fontSize: AppFontSize.size_11_5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _doItAgainAndShareButton() {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              _completedController.onDoItAgainButtonClick();
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(AppColor.white.withOpacity(.6)),
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                  side:
                      const BorderSide(color: AppColor.transparent, width: 0.7),
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSizes.height_1),
              child: AutoSizeText(
                "txtDoItAgain".tr.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  color: AppColor.white,
                  fontSize: AppFontSize.size_13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSizes.width_7),
        Expanded(
          child: TextButton(
            onPressed: () {
              _completedController.onShareButtonClick();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColor.white),
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                  side:
                      const BorderSide(color: AppColor.transparent, width: 0.7),
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: AppSizes.height_0_8, horizontal: AppSizes.width_6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.share, color: AppColor.primary),
                  Expanded(
                    child: AutoSizeText(
                      "txtShare".tr.toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        color: AppColor.primary,
                        fontSize: AppFontSize.size_13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _reminderWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: AppSizes.height_2, horizontal: AppSizes.width_6),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "txtReminder".tr + ":",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: AppFontSize.size_12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  _completedController.onEditReminderClick();
                },
                child: Icon(
                  Icons.edit,
                  color: AppColor.primary,
                  size: AppSizes.height_3_5,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height_1_5),
          GetBuilder<CompletedController>(
            id: Constant.idReminderTimes,
            builder: (logic) {
              return Text(
                _completedController.reminderTimers,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: AppFontSize.size_12,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  _weightWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: AppSizes.height_2, horizontal: AppSizes.width_6),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "txtWeight".tr + ":",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.black,
              fontSize: AppFontSize.size_12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _completedController.weightController,
                  maxLines: 1,
                  maxLength: 5,
                  textInputAction: TextInputAction.done,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,1}')),
                  ],
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: AppFontSize.size_12,
                    fontWeight: FontWeight.w500,
                  ),
                  onFieldSubmitted: (String? value) {
                    _completedController.onWeightFieldSubmitted(value!);
                  },
                  cursorColor: AppColor.primary,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(0.0),
                    hintText: "0.0",
                    hintStyle: TextStyle(
                      color: AppColor.primary,
                      fontSize: AppFontSize.size_12,
                      fontWeight: FontWeight.w500,
                    ),
                    counterText: "",
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColor.primary),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColor.primary),
                    ),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColor.primary),
                    ),
                  ),
                ),
              ),
              GetBuilder<CompletedController>(
                id: Constant.idWeightCompleted,
                builder: (logic) {
                  return Row(
                    children: [
                      InkWell(
                        onTap: () {
                          logic.changeWeightKgLsb(Constant.boolValueTrue);
                        },
                        child: Container(
                          height: AppSizes.height_4_3,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.width_5),
                          margin: EdgeInsets.only(
                              left: AppSizes.width_3,
                              right: AppSizes.width_1_5),
                          decoration: BoxDecoration(
                            color: (_completedController.isSelectedWeightKg)
                                ? AppColor.primary
                                : AppColor.grayBox,
                            border: Border.all(
                              color: (_completedController.isSelectedWeightKg)
                                  ? AppColor.primary
                                  : AppColor.grayBox,
                            ),
                          ),
                          child: Text(
                            "KG",
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: AppFontSize.size_12_5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          logic.changeWeightKgLsb(Constant.boolValueFalse);
                        },
                        child: Container(
                          height: AppSizes.height_4_3,
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSizes.width_5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: (!_completedController.isSelectedWeightKg)
                                ? AppColor.primary
                                : AppColor.grayBox,
                            border: Border.all(
                              color: (!_completedController.isSelectedWeightKg)
                                  ? AppColor.primary
                                  : AppColor.grayBox,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              "LB",
                              style: TextStyle(
                                color: AppColor.white,
                                fontSize: AppFontSize.size_12_5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  _bmiWidget() {
    return GetBuilder<CompletedController>(
        id: Constant.idReportBmiChart,
        builder: (logic) {
          return Container(
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Theme(
              data:
                  Theme.of(Get.context!).copyWith(dividerColor: AppColor.white),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                child: ExpansionTile(
                  title: Row(
                    children: [
                      Text(
                        ("txtBMI".tr + ":").toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: AppFontSize.size_12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Visibility(
                        visible: logic.bmi! != 0,
                        child: Text(
                          logic.bmi!.toStringAsFixed(2) + "txtKgm".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.txtColor666,
                            fontSize: AppFontSize.size_12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                  collapsedIconColor: AppColor.primary,
                  iconColor: AppColor.primary,
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  backgroundColor: AppColor.white,
                  childrenPadding: EdgeInsets.only(
                      right: AppSizes.height_1, bottom: AppSizes.height_1),
                  children: [
                    if (logic.bmi != 0) ...{
                      Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: AppSizes.width_1_5,
                                    right: AppSizes.width_1_5,
                                    top: AppSizes.height_4_1),
                                height: AppSizes.height_5_5,
                                child: Row(
                                  children: [
                                    Container(
                                      width: AppSizes.fullWidth * 0.09,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: AppSizes.width_0_6),
                                      color: AppColor.bmiFirstColor,
                                    ),
                                    Container(
                                      width: AppSizes.fullWidth * 0.16,
                                      color: AppColor.bmiSecondColor,
                                    ),
                                    Container(
                                      width: AppSizes.fullWidth * 0.22,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: AppSizes.width_0_6),
                                      color: AppColor.bmiThirdColor,
                                    ),
                                    Container(
                                      width: AppSizes.fullWidth * 0.16,
                                      color: AppColor.bmiFourColor,
                                    ),
                                    Container(
                                      width: AppSizes.fullWidth * 0.11,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: AppSizes.width_0_6),
                                      color: AppColor.bmiFiveColor,
                                    ),
                                    Container(
                                      width: AppSizes.fullWidth * 0.12,
                                      color: AppColor.bmiSixColor,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: AppSizes.width_1_5,
                                    vertical: AppSizes.height_0_5),
                                child: Row(
                                  children: const [
                                    Text("15"),
                                    Expanded(flex: 1, child: Text(" ")),
                                    Text("16"),
                                    Expanded(flex: 3, child: Text(" ")),
                                    Text("18.5"),
                                    Expanded(flex: 5, child: Text(" ")),
                                    Text("25"),
                                    Expanded(flex: 3, child: Text(" ")),
                                    Text("30"),
                                    Expanded(flex: 2, child: Text(" ")),
                                    Text("35"),
                                    Expanded(flex: 2, child: Text(" ")),
                                    Text("40"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: AppSizes.height_9_5,
                            child: AlignPositioned(
                              dx: logic.bmiValuePosition(AppSizes.fullWidth),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    logic.bmi!.toStringAsFixed(2),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: AppColor.black,
                                      fontSize: AppFontSize.size_12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: AppSizes.width_4),
                                    height: AppSizes.height_6,
                                    child: const VerticalDivider(
                                      thickness: 5,
                                      color: AppColor.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: AppSizes.height_0_5),
                        child: Text(
                          logic.bmiCategory!,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: logic.bmiColor!,
                            fontSize: AppFontSize.size_11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    },
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: logic.bmi! == 0,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: AppSizes.width_20,
                            ),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: Get.context!,
                                  builder: (context) =>
                                      const WeightHeightDialog(),
                                ).then((value) {
                                  logic.getBmiData();
                                  logic.setWeightValues();
                                });
                              },
                              child: Text(
                                "txtTapToInputHeight".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColor.primary,
                                  fontSize: AppFontSize.size_13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: logic.bmi != 0,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              alignment: Alignment.center,
                              iconSize: AppSizes.height_3_5,
                              onPressed: () {
                                showDialog(
                                  context: Get.context!,
                                  builder: (context) =>
                                      const WeightHeightDialog(),
                                ).then((value) {
                                  logic.getBmiData();
                                  logic.setWeightValues();
                                });
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: AppColor.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _iFeelWidget() {
    return Container(
      width: AppSizes.fullWidth,
      padding: EdgeInsets.symmetric(
          vertical: AppSizes.height_2, horizontal: AppSizes.width_6),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "txtIFeel".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.black,
              fontSize: AppFontSize.size_14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSizes.height_1_8),
          Row(
            children: [
              Text(
                "txtEasy".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.txtColor999,
                  fontSize: AppFontSize.size_12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Text(
                "txtExhausted".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.txtColor999,
                  fontSize: AppFontSize.size_12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          GetBuilder<CompletedController>(
            id: Constant.idIFeelListCompleted,
            builder: (logic) {
              return Container(
                height: AppSizes.height_10,
                width: AppSizes.fullWidth,
                alignment: Alignment.center,
                child: ListView.builder(
                  shrinkWrap: Constant.boolValueTrue,
                  padding: EdgeInsets.zero,
                  itemCount: 5,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Radio(
                      activeColor: AppColor.primary,
                      value: index,
                      groupValue: logic.currentSelectedRadioButtonValue,
                      onChanged: (int? value) {
                        logic.changeIFeelRadioValue(value!);
                      },
                    );
                  },
                ),
              );
            },
          ),
          Container(
            margin: EdgeInsets.only(top: AppSizes.height_1),
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Utils().sendFeedback();
              },
              child: Text(
                "txtFeedback".tr.toUpperCase(),
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: AppFontSize.size_12_5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _howOftenShouldWidget() {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.commonQuestions);
      },
      child: Container(
        width: AppSizes.fullWidth,
        padding: EdgeInsets.symmetric(
            vertical: AppSizes.height_2, horizontal: AppSizes.width_6),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  Constant.getAssetIcons() + "ic_finish_faq.webp",
                  height: AppSizes.height_5,
                  width: AppSizes.height_5,
                ),
                SizedBox(width: AppSizes.width_5),
                Expanded(
                  child: Text(
                    "txtHowOftenShould".tr,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppFontSize.size_14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.height_1_5),
            Text(
              "txtAboutAppAns1".tr,
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColor.txtColor666,
                fontSize: AppFontSize.size_10_5,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _nextButton() {
    return Container(
      width: AppSizes.fullWidth,
      margin: EdgeInsets.only(
          left: AppSizes.width_8,
          right: AppSizes.width_8,
          bottom: AppSizes.height_1_5),
      child: TextButton(
        onPressed: () {
          _completedController.onNextButtonClick();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColor.primary),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              side: BorderSide(color: AppColor.transparent, width: 0.7),
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSizes.height_1),
          child: Text(
            "txtNext".tr.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.white,
              fontSize: AppFontSize.size_13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
