import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../util/color_category.dart';
import '../../util/constant_widget.dart';
import '../routes/app_routes.dart';
import 'package:get/get.dart';

class PasswordChangeDialog extends StatefulWidget {
  const PasswordChangeDialog({Key? key}) : super(key: key);

  @override
  State<PasswordChangeDialog> createState() => _PasswordChangeDialogState();
}

class _PasswordChangeDialogState extends State<PasswordChangeDialog> {
  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);
    return Dialog(
      backgroundColor: bgDarkWhite,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.h)),
      child: ConstantWidget.getPaddingWidget(
        EdgeInsets.symmetric(horizontal: 20.h),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 50.h,
            ),
            getAssetImage("password.png", height: 132.h, width: 114.h),
            SizedBox(
              height: 30.h,
            ),
            ConstantWidget.getTextWidget("Password changed", textColor,
                TextAlign.center, FontWeight.w700, 28.sp),
            SizedBox(
              height: 6.h,
            ),
            ConstantWidget.getMultilineCustomFont(
                "Your password has been successfully changed!",
                17.sp,
                textColor,
                fontWeight: FontWeight.w500,
                txtHeight: 1.41.h,
                textAlign: TextAlign.center),
            SizedBox(
              height: 29.h,
            ),
            ConstantWidget.getButtonWidget(context, "Go To Home", accentColor,
                () {
              // Get.toNamed(Routes.signInRoute);
              Get.until((route) => route.settings.name == Routes.signInRoute);
            }),
            SizedBox(
              height: 50.h,
            ),
          ],
        ),
      ),
    );
  }
}
