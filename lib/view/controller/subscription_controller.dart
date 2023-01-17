import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../iapurchase/InAppPurchaseHelper.dart';
import '../../iapurchase/prefrence.dart';

class SubscriptionController extends GetxController {
  RxString isselected = "MONTH".obs;
  RxBool isuseralreadysunscription = false.obs;
  String? purchasedplan;

  RxBool isProUser = false.obs;

  @override
  void onInit() {
    refreshProValue();
    super.onInit();
  }

  Future<void> refreshProValue() async {
    isProUser.value = await Preferences.preferences
        .getBool(key: PrefernceKey.isProUser, defValue: false);
    String? plan = await Preferences.preferences
        .getString(key: PrefernceKey.currentProPlan);
    print("getplan==$plan");
    if (plan == null) {
      isselected.value = "MONTH";
    } else {
      List<String> purchaseIds=InAppPurchaseHelper().getProductIds();
      if (purchaseIds[0]==plan) {
        isselected.value = "MONTH";
      }
      else
      {
        isselected.value = "YEAR";
      }
    }
    print("getplan==${isselected.value}");
  }




}
