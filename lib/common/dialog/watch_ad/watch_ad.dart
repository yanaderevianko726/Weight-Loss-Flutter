import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/routes/app_routes.dart';
import 'package:women_lose_weight_flutter/ui/exercise_list/controllers/exercise_list_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';
import 'package:auto_size_text/auto_size_text.dart';

class WatchAdDialog extends StatelessWidget {
  WatchAdDialog({Key? key}) : super(key: key);

  final ExerciseListController _exerciseListController = Get.find<ExerciseListController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.back();
        Get.back();
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: AppColor.transparentBlack80,
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                    Get.back();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColor.white,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: AppSizes.height_1_5),
                        child: Image.asset(
                          Constant.getAssetIcons() + "icon_unlock.webp",
                          height: AppSizes.height_6,
                          color: AppColor.white,
                        ),
                      ),
                      Text(
                        'txtWatchVideoToUnlock'.tr
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                            color: AppColor.white,
                            fontWeight: FontWeight.w600,
                            fontSize: AppFontSize.size_14),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: AppSizes.height_1_5, right: AppSizes.width_15, left: AppSizes.width_15),
                        child: Text(
                          'txtWatchVideoToUnlockDesc'.tr,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColor.white,
                              fontWeight: FontWeight.w300,
                              fontSize: AppFontSize.size_12),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: AppSizes.width_12),
                        margin: EdgeInsets.only(left: AppSizes.width_10, right: AppSizes.width_10, top: AppSizes.height_3, bottom: AppSizes.height_0_5),
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: TextButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.play_circle_fill_rounded,
                                color: AppColor.white,
                                size: AppSizes.height_3_5,
                              ),
                              SizedBox(width: AppSizes.width_1,),
                              Expanded(
                                child: AutoSizeText(
                                  'txtUnlockOnce'.tr
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: AppFontSize.size_14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            _exerciseListController.onClickUnlockOnce();
                          },
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: AppSizes.width_10, vertical: AppSizes.height_1),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: AppColor.grayUnlock),
                        child: TextButton(
                          child: Text(
                            'txtRemoveAds'.tr
                                .toUpperCase(),
                            style: TextStyle(
                              color: AppColor.white,
                              fontWeight: FontWeight.w500,
                              fontSize: AppFontSize.size_14,
                            ),
                          ),
                          onPressed: () {
                            Get.toNamed(AppRoutes.accessAllFeature);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
