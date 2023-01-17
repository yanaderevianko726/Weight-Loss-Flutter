import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../data/data_file.dart';
import '../models/modal_chart.dart';
import '../util/constant_widget.dart';
import '../util/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../util/color_category.dart';

class WeightDialog extends StatefulWidget {
  const WeightDialog({Key? key}) : super(key: key);

  @override
  State<WeightDialog> createState() => _WeightDialogState();
}

class _WeightDialogState extends State<WeightDialog> {
  TextEditingController weightController = TextEditingController();
  DateTime now = new DateTime.now();

  @override
  Widget build(BuildContext context) {
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
          children: [
            ConstantWidget.getVerSpace(30.h),
            getCustomText("Weight", Colors.black, 1, TextAlign.center,
                FontWeight.w700, 20.sp),
            ConstantWidget.getVerSpace(12.h),
            ConstantWidget.getDefaultTextFiledWithLabel(
              context,
              "Weight",
              weightController,
              isEnable: false,
              height: 50.h,
              withprefix: false,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
              ],
              keyboardType: TextInputType.number
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
                  DataFile.salesLists.add(SalesData(
                      DateFormat("d MMM").format(now),
                      double.parse(weightController.text)));
                  Get.back();
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
}
