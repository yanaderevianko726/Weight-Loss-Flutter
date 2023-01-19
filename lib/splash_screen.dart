import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:women_workout/util/color_category.dart';
import 'package:women_workout/util/constant_widget.dart';
import 'package:women_workout/util/net_check_cont.dart';
import 'package:women_workout/util/pref_data.dart';
import 'package:women_workout/view/controller/controller.dart';
import '../routes/app_routes.dart';
import 'package:get/get.dart';

import 'ads/app_openad_manager.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> with TickerProviderStateMixin {
  late AppOpenAdManager appOpenAdManager;

  // AnimationController? _animationController;

  @override
  void initState() {
    appOpenAdManager = AppOpenAdManager()..loadAd();
    super.initState();

    controller = VideoPlayerController.asset('assets/splash_video.mp4');
    controller.initialize().then((value) {
      setState(() {
        controller.play();
      });
    });

    controller.addListener(() {});

    Get.put(SettingController());
    _getIsFirst();
  }

  GetXNetworkManager networkManager = Get.put(GetXNetworkManager());

  _getIsFirst() async {
    bool isFirst = await PrefData.getIsIntro();
    print('_isSignedUp: $isFirst');
    if(isFirst){
      Timer(Duration(seconds: 7), () {
        appOpenAdManager.showAdIfAvailable();
        Get.toNamed(Routes.introRoute, arguments: () async {
          PrefData.setIsIntro(false);
        });
      });
    }else{
      _checkSignIn();
    }
  }

  _checkSignIn() async {
    bool _isSignIn = await PrefData.getIsSignIn();
    print("sign==${_isSignIn}");

    if(_isSignIn){
      Timer(Duration(seconds: 7), () {
        appOpenAdManager.showAdIfAvailable();
        Get.toNamed(Routes.homeScreenRoute, arguments: 0);
      });
    }else{
      Timer(Duration(seconds: 7), () {
        appOpenAdManager.showAdIfAvailable();
        Get.toNamed(Routes.signInRoute, arguments: 0);
      });
    }
  }

  double position = 0;

  @override
  void dispose() {
    controller.dispose();

    // _animationController!.dispose();
    super.dispose();
  }

  ThemeData themeData = new ThemeData(
      primaryColor: primaryColor,
      primaryColorDark: primaryColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor));
  late VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    initializeScreenSize(context);

    // SystemChrome.setEnabledSystemUIOverlays([]);
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: VideoPlayer(controller),
      ),
      //     child: Center(
      //       child:_animationController==null?Container():ScaleTransition(
      //
      //           scale: _animationController!,
      //           child: Text( 'Simply Fit Me',
      // style: TextStyle(
      //             color: textColor,
      //             fontSize: 45.sp,
      //             fontWeight: FontWeight.w600,
      //             fontFamily: "Qwigley",
      //           )
      //
      //           )),
      //     ),
    );
  }
}
