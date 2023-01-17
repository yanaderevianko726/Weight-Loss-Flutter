import 'package:in_app_purchase/in_app_purchase.dart';

class IAPCallback {
  void onLoaded(bool initialized) {}

  void onPending(PurchaseDetails product) {}

  void onSuccessPurchase(PurchaseDetails product) {
    // var productdetails =
    //     InAppPurchaseHelper().getProductDetail(product.productID);
    // print("product ---- $productdetails ${product.productID}");

    // if (productdetails != null && product != null) {
    //   SubscriptionController controller = Get.find<SubscriptionController>();
    //   controller.postSubscriptionPlan(productdetails, product);
    // }
  }

  void onBillingError(dynamic error) {}
  void onPrefValChange() {}
}
