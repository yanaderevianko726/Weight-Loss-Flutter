import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/custom_classes/custom_classes.dart';
import 'package:women_lose_weight_flutter/ui/edit_plan/controllers/edit_plan_controller.dart';

import '../../../utils/color.dart';
import '../../../utils/constant.dart';
import '../../../utils/sizer_utils.dart';
import '../../../utils/utils.dart';

class EditPlanScreen extends StatelessWidget {
  EditPlanScreen({Key? key}) : super(key: key);

  final EditPlanController _editPlanController = Get.find<EditPlanController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _showSaveChangeDialog();
      },
      child: Scaffold(
        backgroundColor: AppColor.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _widgetBack(),
              _exerciseList(),
              _saveButton(),
            ],
          ),
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
          top: AppSizes.height_2),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              _showSaveChangeDialog();
            },
            child: Utils.backWidget(iconColor: AppColor.black),
          ),
          Expanded(
            child: Text(
              "\t\t\t\t" + "txtEditPlan".tr,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColor.black,
                fontSize: AppFontSize.size_15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          InkWell(
            onTap: () async{
              await _editPlanController.onResetClick();
              Get.back();
            },
            child: Text(
              "txtReset".tr,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColor.primary,
                fontSize: AppFontSize.size_11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _exerciseList() {
    return GetBuilder<EditPlanController>(id: Constant.idEditPlanExerciseList,builder: (logic) {
      return Expanded(
        child: SlidableAutoCloseBehavior(
          child: ReorderableListView(
            padding: EdgeInsets.zero,
            onReorder: (int oldIndex, int newIndex) {
              logic.onReorder(oldIndex, newIndex);
            },
            children: [
              for (int index = 0; index < logic.exerciseList.length; index++) ...{
                ListTile(
                  key: Key('$index'),
                  title: _itemExerciseList(index, logic.exerciseList[index], logic),
                  contentPadding: EdgeInsets.zero,
                ),
              }
            ],
          ),
        ),
      );
    });
  }

  _itemExerciseList(int index, HomeExTableClass exerciseList, EditPlanController logic) {
    return InkWell(
      onTap: () {
        logic.onExerciseItemClick(index);
      },
      child: Slidable(
        key: const ValueKey(0),
        groupTag: '0',
        endActionPane: ActionPane(
          extentRatio: 0.30,
          motion: const ScrollMotion(),
          children: [
            CustomSlidableAction(
              onPressed: (_) {
                logic.onDeleteExercise(index);
              },
              autoClose: true,
              backgroundColor: AppColor.primary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.only(bottom: 5.0),
                      child: const Icon(
                        Icons.delete_forever_rounded,
                        color: AppColor.white,
                      )),
                  Text(
                    "txtDelete".tr,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: AppFontSize.size_14,
                        color: AppColor.white),
                  )
                ],
              ),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.width_4),
              child: Row(
                children: [
                  const Icon(
                    Icons.menu_rounded,
                    color: AppColor.txtColor666,
                  ),
                  SizedBox(
                    height: AppSizes.height_12,
                    width: AppSizes.height_14,
                    child: logic.listOfAnimation.isNotEmpty ? AnimatedBuilder(
                      animation: logic.listOfAnimation[index],
                      builder: (BuildContext context, Widget? child) {
                        String frame = logic
                            .listOfAnimation[index].value
                            .toString();
                        return Image.asset(
                          'assets/${exerciseList.exPath}/$frame.webp',
                          gaplessPlayback: true,
                          height: AppSizes.height_12,
                          width: AppSizes.height_14,
                        );
                      },
                    ) : const SizedBox(),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: AppSizes.width_2_5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.getMultiLanguageString(exerciseList.exName!),
                            style: TextStyle(
                              color: AppColor.black,
                              fontSize: AppFontSize.size_13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: AppSizes.height_1),
                          Row(
                            children: [
                              Text(
                                (exerciseList.exUnit == Constant.workoutTypeStep)
                                    ? "X " + exerciseList.exTime.toString()
                                    : Utils.secToString(int.parse(exerciseList.exTime!)),
                                style: TextStyle(
                                  color: AppColor.txtColor666,
                                  fontSize: AppFontSize.size_11,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  logic.onReplaceClick(index);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "txtReplace".tr.toUpperCase(),
                                      style: TextStyle(
                                        color: AppColor.txtColor666,
                                        fontSize: AppFontSize.size_11,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Image.asset(
                                      Constant.getAssetIcons() +
                                          "icon_general_replace.png",
                                      height: AppSizes.height_1_4,
                                      width: AppSizes.height_3_3,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: AppColor.grayDivider,
              height: 0,
            ),
          ],
        ),
      ),
    );
  }

  _saveButton() {
    return Container(
      width: AppSizes.fullWidth,
      margin: EdgeInsets.only(
          right: AppSizes.width_4,
          left: AppSizes.width_4,
          bottom: AppSizes.height_1_5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        gradient: const LinearGradient(
          begin: Alignment.center,
          end: Alignment.center,
          colors: [
            AppColor.primary,
            AppColor.primary,
          ],
        ),
      ),
      child: TextButton(
        onPressed: () {
          _editPlanController.onSave();
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
            "txtSave".tr.toUpperCase(),
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

  _showSaveChangeDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) =>
          Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: AppSizes.width_6),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: AppSizes.height_3,
                      horizontal: AppSizes.width_6),
                  child: Text(
                    "txtSaveChanges".tr + "?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppFontSize.size_13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                      child: Text(
                        "txtCancel".tr.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColor.primary,
                          fontSize: AppFontSize.size_11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {
                        Get.back();
                        Get.back();
                      },
                    ),
                    TextButton(
                      child: Text(
                        "txtOk".tr.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColor.primary,
                          fontSize: AppFontSize.size_11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () async {
                        _editPlanController.onSave().then((value) => Get.back());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
    );
  }
}
