import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../data/dummy_data.dart';
import '../generated/l10n.dart';
import '../models/model_add_custom_plan.dart';
import '../models/model_edit_custom_plan.dart';
import '../models/model_get_custom_plan.dart';
import '../../util/color_category.dart';
import '../../util/constant_widget.dart';
import '../../util/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../util/constant_url.dart';
import '../util/pref_data.dart';
import '../util/service_provider.dart';
import '../view/custom_workout/select_workout.dart';

class AddWorkoutDialog extends StatefulWidget {
  final String customPlanId;
  final String name;
  final String description;
  final bool edit;

  AddWorkoutDialog(this.customPlanId, this.name, this.description, this.edit);

  @override
  State<AddWorkoutDialog> createState() => _AddWorkoutDialogState();
}

class _AddWorkoutDialogState extends State<AddWorkoutDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("edit---${widget.edit}");
    if (widget.edit == false) {
      setState(() {
        titleController.text = "";
        descriptionController.text = "";
      });
    } else {
      setState(() {
        titleController.text = widget.name;
        descriptionController.text = widget.description;
      });
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.h),
      ),
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.h),
      child: ConstantWidget.getPaddingWidget(
        EdgeInsets.symmetric(horizontal: 20.h),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstantWidget.getVerSpace(30.h),
            getCustomText("Workout title", textColor, 1, TextAlign.start,
                FontWeight.w700, 20.sp),
            ConstantWidget.getVerSpace(12.h),
            ConstantWidget.getDefaultTextFiledWithLabel(
              context,
              "Workout title",
              titleController,
              isEnable: false,
              height: 50.h,
              withprefix: false,
            ),
            ConstantWidget.getVerSpace(20.h),
            getCustomText("Description", textColor, 1, TextAlign.start,
                FontWeight.w700, 20.sp),
            ConstantWidget.getVerSpace(12.h),
            ConstantWidget.getDefaultTextFiledWithLabel(
              context,
              "Description",
              descriptionController,
              isEnable: false,
              height: 50.h,
              withprefix: false,
            ),
            ConstantWidget.getVerSpace(30.h),
            Row(
              children: [
                Expanded(
                    child: getButton(context, Colors.white, "Cancel", textColor,
                        () {
                  Get.back();
                }, 14.sp,
                        weight: FontWeight.w600,
                        isBorder: true,
                        buttonHeight: 40.h,
                        borderColor: accentColor,
                        borderWidth: 1.h,
                        borderRadius: BorderRadius.circular(12.h))),
                ConstantWidget.getHorSpace(12.h),
                Expanded(
                    child: getButton(context, accentColor, "Done", Colors.white,
                        () {
                  checkValidation();
                }, 14.sp,
                        weight: FontWeight.w600,
                        buttonHeight: 40.h,
                        borderRadius: BorderRadius.circular(12.h)))
              ],
            ),
            ConstantWidget.getVerSpace(30.h),
          ],
        ),
      ),
    );
  }

  void checkValidation() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    if (ConstantUrl.isNotEmpty(titleController.text) &&
        ConstantUrl.isNotEmpty(descriptionController.text)) {
      checkNetwork();
    } else {
      ConstantUrl.showToast(S.of(context).fillDetails, context);
    }
  }

  checkNetwork() async {
    bool isNetwork = await ConstantUrl.getNetwork();
    if (isNetwork) {
      addCustomPlan();
    } else {
      getNoInternet(context);
    }
  }

  Future<void> addCustomPlan() async {
    if (widget.edit == false) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }

      if (ConstantUrl.isNotEmpty(titleController.text) &&
          ConstantUrl.isNotEmpty(descriptionController.text)) {
        Map data = await ConstantUrl.getCommonParams();
        data[ConstantUrl.paramName] = titleController.text;
        data[ConstantUrl.paramDescription] = descriptionController.text;

        final response = await http
            .post(Uri.parse(ConstantUrl.urlAddCustomPlan), body: data);

        print("checkResponse==${response.body}");
        var value = ModelAddCustomPlan.fromJson(jsonDecode(response.body));

        ConstantUrl.showToast(value.data.error, context);
        checkLoginError(context, value.data.error);
        if (value.data.success == 1) {
          getCustomPlan(context).then((value) {
            DummyData.removeAllData();
            List<Customplan>? customPlanList = value?.data.customplan;
            customPlanList?.forEach((element) {
              PrefData.setCustomPlanId(element.customPlanId);
              PrefData.setCustomPlanDescription(element.description);
              PrefData.setCustomPlanName(element.name);
              Get.back();
              Get.to(() => SelectWorkout([]))!.then((value) {
                setState(() {});
              });
            });
          });
        }
      } else {
        ConstantUrl.showToast(S.of(context).fillDetails, context);
      }
    } else {
      Map data = await ConstantUrl.getCommonParams();
      data[ConstantUrl.paramCustomPlanId] = widget.customPlanId;
      data[ConstantUrl.paramName] = titleController.text;
      data[ConstantUrl.paramDescription] = descriptionController.text;

      final response =
          await http.post(Uri.parse(ConstantUrl.urlEditCustomPlan), body: data);

      print("edit--response---------------${response.body}");
      var value = ModelEditCustomPlan.fromJson(jsonDecode(response.body));

      if (value.data.success == 1) {
        Get.back();
      }
    }
  }
}
