import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/utils/utils.dart';

import '../../utils/color.dart';
import '../../utils/sizer_utils.dart';

class BottomSheetResetConfirmation extends StatelessWidget {
  const BottomSheetResetConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.fullHeight / 2.7,
      padding: EdgeInsets.only(
          left: AppSizes.width_4,
          right: AppSizes.width_4,
          top: AppSizes.height_1_5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.close,
                color: AppColor.txtColor666,
              ),
            ),
          ),
          Text(
            "txtRestart".tr,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: AppColor.black,
              fontSize: AppFontSize.size_16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSizes.height_2_2),
          Text(
            "txtWouldYouLikeToClearYourProgress".tr,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: AppColor.txtColor666,
              fontSize: AppFontSize.size_11,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          _cancelAndOkButton(),
          const Spacer(),
        ],
      ),
    );
  }

  _cancelAndOkButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.width_5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                border: Border.all(color: AppColor.txtColor999),
                gradient: const LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.center,
                  colors: [
                    AppColor.white,
                    AppColor.white,
                  ],
                ),
              ),
              child: TextButton(
                onPressed: () {
                  Get.back();
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
                  padding: EdgeInsets.symmetric(vertical: AppSizes.height_0_8),
                  child: Text(
                    "txtCancel".tr.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppFontSize.size_14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSizes.width_5),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                border: Border.all(color: AppColor.transparent),
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
                  Utils.setLastCompletedDay(Utils.getPlanId(), 0);
                  Utils.setResetCompletedDay(Utils.getPlanId());
                  DBHelper.dbHelper.restartDayPlan(Utils.getPlanId());
                  Get.back(result: true);
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
                  padding: EdgeInsets.symmetric(vertical: AppSizes.height_0_8),
                  child: Text(
                    "txtOk".tr.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: AppFontSize.size_14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
