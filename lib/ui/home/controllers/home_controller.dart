import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/inapppurchase/iap_callback.dart';
import 'package:women_lose_weight_flutter/inapppurchase/in_app_purchase_helper.dart';
import 'package:women_lose_weight_flutter/main.dart';
import 'package:women_lose_weight_flutter/utils/preference.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../../utils/constant.dart';
import '../../../utils/debug.dart';
import '../../../utils/utils.dart';

class HomeController extends GetxController implements IAPCallback{
  PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;
  int? currentGlass;
  DateTime? currentBackPressTime;
  bool isShowPremiumBtn = true;
  bool isShowLoading = Constant.boolValueFalse;
  @override
  void onInit() {
    getInAppPurchase();
    getCurrentGlassFromPref();
    super.onInit();
  }

  void getInAppPurchase() {
    MyApp.purchaseStreamController.stream.listen((product) {
      try {
        if (product.productID == InAppPurchaseHelper.monthlySubscriptionId || product.productID == InAppPurchaseHelper.yearlySubscriptionId) {
          Preference.shared.setBool(Preference.isPurchased, Constant.boolValueTrue);
        } else {
          Preference.shared.setBool(Preference.isPurchased, Constant.boolValueFalse);
        }
      } on Exception catch (e) {
        Preference.shared.setBool(Preference.isPurchased, Constant.boolValueTrue);
        Debug.printLog(e.toString());
      }
    });
    InAppPurchaseHelper().getAlreadyPurchaseItems(this);
  }

  onChangeIsShowLoading(bool value) {
    isShowLoading = value;
    update([Constant.idIsShowLoading]);
  }

  void getCurrentGlassFromPref() {
    currentGlass = Utils.getCurrentWaterGlass();
    update([Constant.idCurrentWaterGlass]);
  }

  void changePage(int index, {int? catIndex = 0}) {
    currentIndex = index;
    pageController.animateToPage(currentIndex,
        duration: const Duration(milliseconds: 200), curve: Curves.ease);
    isPurchase();
    update([Constant.idHomePage]);
  }

  isPurchase() {
    if(Utils.isPurchased()) {
      isShowPremiumBtn = false;
    } else {
      isShowPremiumBtn = true;
    }
    update([Constant.idMeGoPremiumBtn]);
  }

  currentWaterGlass() {
    Future.delayed(const Duration(milliseconds: 300), () {
      Preference.shared.setString(
          Preference.prefWaterTrackerDate, Utils.getDate(DateTime.now()).toString());
      currentGlass = currentGlass! + 1;
      Preference.shared.setInt(Preference.prefCurrentWaterGlass, currentGlass!);
      update([Constant.idCurrentWaterGlass]);
    });
  }

  onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 3)) {
      currentBackPressTime = now;
      Utils.showToast(Get.context!, "txtExitMessage".tr);
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  void onBillingError(error) {
  }

  @override
  void onLoaded(bool initialized) {
  }

  @override
  void onPending(PurchaseDetails product) {
  }

  @override
  void onSuccessPurchase(PurchaseDetails product) {
  }
}
