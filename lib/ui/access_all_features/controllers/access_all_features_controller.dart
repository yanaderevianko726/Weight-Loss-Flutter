import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/inapppurchase/iap_callback.dart';
import 'package:women_lose_weight_flutter/inapppurchase/in_app_purchase_helper.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:women_lose_weight_flutter/utils/preference.dart';

class AccessAllFeaturesController extends GetxController implements IAPCallback{
  bool isSelected = Constant.boolValueTrue; /// isSelected true for monthly and false for yearly
  Map<String, PurchaseDetails>? purchases;
  bool isShowProgress = false;

  @override
  void onInit() {
    InAppPurchaseHelper().getAlreadyPurchaseItems(this);
    purchases = InAppPurchaseHelper().getPurchases();
    InAppPurchaseHelper().clearTransactions();
    super.onInit();
  }

  onChangePlanSelection(value) {
    isSelected = value;
    update([Constant.idAccessAllFeaturesButtons]);
  }

  void onPurchaseClick() {
    isShowProgress = true;
    update([Constant.idAccessFeatureProgress]);
    if (!isSelected) {
      ProductDetails? product = InAppPurchaseHelper()
          .getProductDetail(InAppPurchaseHelper.yearlySubscriptionId);
      if (product != null) {
        InAppPurchaseHelper().buySubscription(product, purchases!);
      } else {
        isShowProgress = false;
        update([Constant.idAccessFeatureProgress]);
      }
    } else {
      ProductDetails? product = InAppPurchaseHelper()
          .getProductDetail(InAppPurchaseHelper.monthlySubscriptionId);
      if (product != null) {
        InAppPurchaseHelper().buySubscription(product, purchases!);
      } else {
        isShowProgress = false;
        update([Constant.idAccessFeatureProgress]);
      }
    }
  }

  @override
  void onBillingError(error) {
    isShowProgress = false;
    update([Constant.idAccessFeatureProgress]);
  }

  @override
  void onLoaded(bool initialized) {
  }

  @override
  void onPending(PurchaseDetails product) {
  }

  @override
  void onSuccessPurchase(PurchaseDetails product) {
    Preference.shared.setBool(Preference.isPurchased, Constant.boolValueTrue);
    isShowProgress = false;
    update([Constant.idAccessFeatureProgress]);
    Get.back(result: true);
  }
}
