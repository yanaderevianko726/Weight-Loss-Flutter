import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

import '../../../ui/perform_exercise/controllers/perform_exercise_controller.dart';

class QuiteWorkout extends StatelessWidget {
  QuiteWorkout({Key? key}) : super(key: key);


  final PerformExerciseController _performExerciseController =
  Get.find<PerformExerciseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.transparent,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: Wrap(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: AppSizes.width_2),
                width: AppSizes.fullWidth,
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.asset(
                            Constant.getAssetImage() + "bg_exit_dialog.webp",
                            width: AppSizes.fullWidth,
                            height: AppSizes.height_27,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            margin: EdgeInsets.all(AppSizes.height_1_8),
                            child: IconButton(
                              onPressed: () {
                                Get.back(result: [true]);
                              },
                              padding: EdgeInsets.zero,
                              icon: Image.asset(
                                Constant.getAssetIcons() +
                                    "wp_ic_info_close.webp",
                                height: AppSizes.height_5,
                                width: AppSizes.height_5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: AppSizes.height_2_5, bottom: AppSizes.height_5),
                        child: Text(
                          "txtQuitExMsg".tr.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColor.black,
                            fontSize: AppFontSize.size_16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        width: AppSizes.fullWidth,
                        margin: EdgeInsets.only(
                            right: AppSizes.width_22,
                            left: AppSizes.width_22,
                            bottom: AppSizes.height_2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          border: Border.all(color: AppColor.primary),
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
                            _performExerciseController.onQuiteButtonClick();
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                            padding: EdgeInsets.symmetric(
                                vertical: AppSizes.height_0_8),
                            child: Text(
                              "txtQuit".tr.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColor.primary,
                                fontSize: AppFontSize.size_14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: AppSizes.fullWidth,
                        margin: EdgeInsets.only(
                            right: AppSizes.width_22,
                            left: AppSizes.width_22,
                            bottom: AppSizes.height_4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          border: Border.all(color: AppColor.primary),
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
                            Get.back(result: [true]);
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                            padding: EdgeInsets.symmetric(
                                vertical: AppSizes.height_0_8),
                            child: Text(
                              "txtContinue".tr.toUpperCase(),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
