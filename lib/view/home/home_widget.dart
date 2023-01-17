import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rate_my_app/rate_my_app.dart';
import '../../util/appBar/bar.dart';

import '../../util/appBar/item.dart';

import 'package:get/get.dart';

import '../../util/color_category.dart';
import '../../util/constant_widget.dart';

import '../controller/controller.dart';
import '../custom_workout/custom_workout.dart';
import 'tab/tab_activity.dart';
import 'tab/tab_discover.dart';
import 'tab/tab_home.dart';
import 'tab/tab_setting.dart';

const MethodChannel platform = MethodChannel('dexterx.dev/workout');

class HomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeWidget();
}

List<String> ringTone = ['Meters and kilograms', 'Pounds,Feet and inches'];
HomeController controller = Get.put(HomeController());

class _HomeWidget extends State<HomeWidget> {
  static List<Widget> _widgetOptions = <Widget>[
    TabHome(),
    TabDiscover(),
    CustomWorkoutScreen(),
    TabActivity(),
    // TabDiet(),
    TabSettings()
  ];

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 0, // Show rate popup on first day of install.
    minLaunches:
        5, // Show rate popup after 5 launches of app after minDays is passed.
  );

  @override
  void initState() {
    super.initState();
    setStatusBarColor(bgDarkWhite);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await rateMyApp.init();
      if (mounted && rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    setStatusBarColor(bgDarkWhite);

    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Obx(() {
              return _widgetOptions[controller.index.value];
            }),
            // child: GetX<HomeController>(
            //   init: HomeController(),
            //   builder: (controller) => _widgetOptions[controller.index.value],
            // ),
          ),
          bottomNavigationBar: _buildBottomBar(),
          backgroundColor: bgDarkWhite,
        ),
        onWillPop: () async {
          if (controller.index.value != 0) {
            controller.onChange(0.obs);
          } else {
            Future.delayed(const Duration(milliseconds: 100), () {
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            });
          }
          return false;
        });
  }

  Widget _buildBottomBar() {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) {
        return ConvexAppBar(
          items: [
            TabItem(
              icon: getSvgImage(
                  controller.index.value == 0 ? "home_bold.svg" : "Home.svg",
                  height: 24.h,
                  width: 24.h),
            ),
            TabItem(
              icon: getSvgImage(
                  controller.index.value == 1
                      ? "discover_bold.svg"
                      : "discover.svg",
                  height: 24.h,
                  width: 24.h),
            ),
            TabItem(
              icon: getSvgImage("add.svg", height: 24.h, width: 24.h),
            ),
            TabItem(
              icon: getSvgImage(
                  controller.index.value == 3
                      ? "calendar_bold.svg"
                      : "calendar.svg",
                  height: 24.h,
                  width: 24.h),
            ),
            TabItem(
              icon: getSvgImage(
                  controller.index.value == 4
                      ? "Setting_bold.svg"
                      : "Setting.svg",
                  height: 24.h,
                  width: 24.h),
            )
          ],
          height: 60.h,
          elevation: 5,
          color: accentColor,
          top: -33.h,
          curveSize: 85.h,
          initialActiveIndex: controller.index.value,
          activeColor: accentColor,
          style: TabStyle.fixedCircle,
          backgroundColor: Colors.white,
          onTap: (count) {
            controller.onChange(count.obs);
          },
        );
      },
    );
  }
}
