import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/routes/app_routes.dart';
import 'package:women_lose_weight_flutter/ui/home/controllers/home_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/utils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../google_ads/custom_ad.dart';
import '../../../utils/constant.dart';
import '../../../utils/sizer_utils.dart';
import '../../me/views/me_screen.dart';
import '../../plan/views/plan_screen.dart';
import '../../report/views/report_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final HomeController _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _homeController.onWillPop();
        return Future.value(false);
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          GetBuilder<HomeController>(
            id: Constant.idHomePage,
            builder: (logic) {
              return Scaffold(
                backgroundColor: AppColor.white,
                body: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _widgetTopBar(logic),
                            _widgetPageView(logic),
                          ],
                        ),
                      ),
                      const BannerAdClass(),
                    ],
                  ),
                ),
                bottomNavigationBar: _bottomNavigationBar(logic),
              );
            },
          ),
          GetBuilder<HomeController>(
            id: Constant.idIsShowLoading,
            builder: (logic) {
              if (logic.isShowLoading) {
                return Container(
                  color: AppColor.black.withOpacity(.2),
                  child: const UnconstrainedBox(
                    child: CircularProgressIndicator(
                      color: AppColor.primary,
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }

  _widgetTopBar(HomeController logic) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppSizes.width_5, vertical: AppSizes.height_1),
      child: Row(
        children: [
          Expanded(
            child: AutoSizeText(
              (logic.currentIndex == 0)
                  ? "txtAppName".tr
                  : (logic.currentIndex == 1)
                      ? "txtReports".tr
                      : "txtMe".tr,
              // textAlign: TextAlign.left,
              maxLines: 1,
              style: TextStyle(
                color: AppColor.black,
                fontSize: AppFontSize.size_16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            width: AppSizes.width_1,
          ),
          if (logic.currentIndex == 0) ...{
            GetBuilder<HomeController>(
                id: Constant.idCurrentWaterGlass,
                builder: (logic) {
                  return InkWell(
                    onTap: () {
                      if (Utils.isWaterTrackerOn()) {
                        Get.toNamed(AppRoutes.waterTracker,
                            arguments: [logic.currentGlass]);
                        logic.currentWaterGlass();
                      } else {
                        Get.toNamed(AppRoutes.turnOnWater,
                            arguments: [logic.currentGlass]);
                      }
                    },
                    child: Badge(
                      shape: BadgeShape.circle,
                      padding: EdgeInsets.all(AppSizes.width_2),
                      animationType: BadgeAnimationType.scale,
                      animationDuration: const Duration(milliseconds: 200),
                      badgeColor: AppColor.commonBlueColor,
                      badgeContent: Text(
                        logic.currentGlass.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColor.white,
                          fontSize: AppFontSize.size_9,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      child: SizedBox(
                        height: AppSizes.height_5_5,
                        width: AppSizes.height_5,
                        child: Stack(
                          alignment: Alignment.center,
                          fit: StackFit.expand,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(top: AppSizes.height_0_5),
                              child: CircularProgressIndicator(
                                backgroundColor: AppColor.commonBlueLightColor,
                                value: logic.currentGlass! / 8,
                                valueColor: const AlwaysStoppedAnimation(
                                    AppColor.commonBlueColor),
                                strokeWidth: AppSizes.width_1_2,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: AppSizes.width_2_5,
                                  right: AppSizes.width_2_5,
                                  bottom: AppSizes.width_2_5,
                                  top: AppSizes.width_3_5),
                              child: Image.asset(
                                Constant.getAssetIcons() +
                                    "ic_homepage_drink.webp",
                                alignment: Alignment.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          } else ...{
            SizedBox(
              height: AppSizes.height_5_5,
              width: AppSizes.height_5,
            ),
          },
        ],
      ),
    );
  }

  _widgetPageView(HomeController logic) {
    return Expanded(
      child: PageView(
        controller: logic.pageController,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        onPageChanged: (int page) {},
        children: [
          PlanScreen(),
          ReportScreen(),
          MeScreen(),
        ],
      ),
    );
  }

  _bottomNavigationBar(HomeController logic) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(
          color: AppColor.txtColor999,
          thickness: AppSizes.height_0_1,
          height: 0,
        ),
        BottomNavigationBar(
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          unselectedItemColor: AppColor.txtColor666,
          selectedItemColor: AppColor.primary,
          onTap: logic.changePage,
          currentIndex: logic.currentIndex,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColor.transparent,
          selectedLabelStyle: TextStyle(
            color: AppColor.primary,
            fontSize: AppFontSize.size_12,
            fontWeight: FontWeight.w400,
          ),
          unselectedLabelStyle: TextStyle(
            color: AppColor.txtColor666,
            fontSize: AppFontSize.size_12,
            fontWeight: FontWeight.w400,
          ),
          elevation: 0,
          items: [
            _bottomNavigationBarItem(
              icon: Constant.getAssetIcons() + "ic_plan.webp",
              label: 'txtPlan'.tr,
              index: 0,
            ),
            _bottomNavigationBarItem(
              icon: Constant.getAssetIcons() + "ic_report.webp",
              label: 'txtReports'.tr,
              index: 1,
            ),
            _bottomNavigationBarItem(
              icon: Constant.getAssetIcons() + "ic_me.webp",
              label: 'txtMe'.tr,
              index: 2,
            ),
          ],
        ),
      ],
    );
  }

  _bottomNavigationBarItem({String? icon, String? label, int? index}) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        icon!,
        height: AppSizes.height_3_3,
        color: (_homeController.currentIndex == index)
            ? AppColor.primary
            : AppColor.txtColor999,
      ),
      label: label,
    );
  }
}
