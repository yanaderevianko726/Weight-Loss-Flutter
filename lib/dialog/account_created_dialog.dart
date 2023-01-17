import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../util/color_category.dart';
import '../../util/constant_widget.dart';
import '../view/controller/controller.dart';

class AccountCreateDialog extends StatefulWidget {
  const AccountCreateDialog({Key? key}) : super(key: key);

  @override
  State<AccountCreateDialog> createState() => _AccountCreateDialogState();
}

class _AccountCreateDialogState extends State<AccountCreateDialog> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.h)),
      backgroundColor: bgDarkWhite,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.h),
      child: ConstantWidget.getPaddingWidget(
        EdgeInsets.symmetric(horizontal: 20.h),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConstantWidget.getVerSpace(50.h),
            getAssetImage("create.png", height: 132.h, width: 115.h),
            ConstantWidget.getVerSpace(30.h),
            ConstantWidget.getTextWidget("Account Created", textColor,
                TextAlign.center, FontWeight.w700, 28.sp),
            ConstantWidget.getVerSpace(6.h),
            ConstantWidget.getMultilineCustomFont(
                "Your account has been successfully Created!", 17.sp, textColor,
                fontWeight: FontWeight.w500,
                txtHeight: 1.41.h,
                textAlign: TextAlign.center),
            ConstantWidget.getVerSpace(29.h),
            ConstantWidget.getButtonWidget(context, "Ok", accentColor, () {

              Get.back();
              Get.back();

              // homeController.onChange(0.obs);
              // Get.toNamed(Routes.homeScreenRoute, arguments: 0);
            }),
            ConstantWidget.getVerSpace(50.h),
          ],
        ),
      ),
    );
  }
}
