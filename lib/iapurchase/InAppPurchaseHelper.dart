import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:dio/dio.dart';
import 'package:women_workout/iapurchase/prefrence.dart';

import 'IAPCallback.dart';
import 'IAPReceiptData.dart';

class InAppPurchaseHelper {
  static final InAppPurchaseHelper _inAppPurchaseHelper =
      InAppPurchaseHelper._internal();

  InAppPurchaseHelper._internal();

  factory InAppPurchaseHelper() {
    return _inAppPurchaseHelper;
  }

  List<String> getProductIds() {
    String monthlySubscriptionId = "";
    String yearlySubscriptionId = "";
    if (Platform.isAndroid) {
      // monthlySubscriptionId = "com.test.onemonth";
      // yearlySubscriptionId = "com.test.yearly";

      monthlySubscriptionId = "monthly_plan";
      yearlySubscriptionId = "android.test.purchased";
    } else {
      monthlySubscriptionId = "com.test.onemonth";
      yearlySubscriptionId = "com.test.yearlyplan";
    }
    return [monthlySubscriptionId, yearlySubscriptionId];
  }

  final InAppPurchase _connection = InAppPurchase.instance;

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];

  IAPCallback? _iapCallback;

  initialize() {
    if (Platform.isAndroid) {
      // ignore: deprecated_member_use
      InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
    }
  }

  ProductDetails? getProductDetail(String productID) {
    for (ProductDetails item in _products) {
      if (item.id == productID) {
        return item;
      }
    }
    return null;
  }

  getAlreadyPurchaseItems(IAPCallback iapCallback) {
    _iapCallback = iapCallback;
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _connection.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      if (purchaseDetailsList != [] && purchaseDetailsList.isNotEmpty) {
        purchaseDetailsList
            .sort((a, b) => a.transactionDate!.compareTo(b.transactionDate!));

        if (purchaseDetailsList[0].status == PurchaseStatus.restored) {
          getPastPurchases(purchaseDetailsList);
        } else {
          _listenToPurchaseUpdated(purchaseDetailsList);
        }
      }
    }, onDone: () {
      _subscription!.cancel();
    }, onError: (error) {
      print(error);
      handleError(error);
    });
    initStoreInfo();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _connection.isAvailable();
    if (!isAvailable) {
      _products = [];
      _purchases = [];
      return;
    }
    final List<String> _kProductIds = getProductIds();
    ProductDetailsResponse productDetailResponse =
        await _connection.queryProductDetails(_kProductIds.toSet());
    // print()
    if (productDetailResponse.error != null) {
      _products = productDetailResponse.productDetails;
      print("getproducts=====${_products.asMap().toString()}");
      _purchases = [];
      return;
    }
    print("getproducts=111====${productDetailResponse.notFoundIDs.asMap()}");
    print("getproducts=111====${productDetailResponse.productDetails}");

    if (productDetailResponse.productDetails.isEmpty) {
      _products = productDetailResponse.productDetails;
      _purchases = [];
      return;
    } else {
      _products = productDetailResponse.productDetails;
      _purchases = [];
    }
    print("getproducts===detail==${_products.asMap().toString()}");
    print("getproducts=====${_products[0].id}");

    await _connection.restorePurchases();
  }

  Future<void> getPastPurchases(List<PurchaseDetails> verifiedPurchases) async {
    print("purchase==past");
    verifiedPurchases
        .sort((a, b) => a.transactionDate!.compareTo(b.transactionDate!));

    if (Platform.isIOS) {
      if (verifiedPurchases.isNotEmpty)
        await _verifyReceipts(verifiedPurchases);
      else {
        print("You have not Purchased :::::::::::::::::::=>");
        await Preferences.preferences
            .saveBool(key: PrefernceKey.isProUser, value: false);
        await Preferences.preferences
            .clearPrefValue(PrefernceKey.currentProPlan);

        _iapCallback!.onPrefValChange();
      }
    } else {
      // // if (verifiedPurchases.isNotEmpty) {
      //   if (verifiedPurchases != [] && verifiedPurchases.isNotEmpty ) {
      if (verifiedPurchases != [] &&
          verifiedPurchases.isNotEmpty &&
          verifiedPurchases[0].status != PurchaseStatus.canceled) {
        _purchases = verifiedPurchases;

        print("You have already Purchased :::::::::::::::::::=>");
        await Preferences.preferences
            .saveBool(key: PrefernceKey.isProUser, value: true);
        await Preferences.preferences.saveString(
            key: PrefernceKey.currentProPlan, value: _purchases[0].productID);

        _iapCallback!.onPrefValChange();
        // purchaseStreamController.add(_purchases[0]);
      } else {
        print("You have not Purchased :::::::::::::::::::=>");
        await Preferences.preferences
            .saveBool(key: PrefernceKey.isProUser, value: false);
        await Preferences.preferences
            .clearPrefValue(PrefernceKey.currentProPlan);
        _iapCallback!.onPrefValChange();
      }
      // } else {
      //   print("You have not Purchased :::::::::::::::::::=>");
      //   await Preferences.preferences
      //       .saveBool(key: PrefernceKey.isProUser, value: false);
      //   await Preferences.preferences
      //       .clearPrefValue(PrefernceKey.currentProPlan);
      //   _iapCallback!.onPrefValChange();
      // }
    }
  }

  bool SANDBOX_VERIFY_RECEIPT_URL = true;

  _verifyReceipts(List<PurchaseDetails> verifiedPurchases) async {
    var dio = Dio(
      BaseOptions(
        connectTimeout: 5000,
        receiveTimeout: 5000,
      ),
    );

    Map<String, String> data = {};
    data.putIfAbsent("receipt-data",
        () => verifiedPurchases[0].verificationData.localVerificationData);
    data.putIfAbsent("password", () => '89526516ead7470b9f82ebbc3b406ea2');

    try {
      String verifyReceiptUrl;

      if (SANDBOX_VERIFY_RECEIPT_URL)
        verifyReceiptUrl = 'https://sandbox.itunes.apple.com/verifyReceipt';
      else
        verifyReceiptUrl = 'https://buy.itunes.apple.com/verifyReceipt';

      final graphResponse =
          await dio.post<String>(verifyReceiptUrl, data: data);
      Map<String, dynamic> profile = jsonDecode(graphResponse.data!);

      var receiptData = IapReceiptData.fromJson(profile);

      receiptData.latestReceiptInfo!
          .sort((a, b) => b.expiresDateMs!.compareTo(a.expiresDateMs!));
      if (int.parse(receiptData.latestReceiptInfo![0].expiresDateMs!) >
          DateTime.now().millisecondsSinceEpoch) {
        for (PurchaseDetails data in verifiedPurchases) {
          if (data.productID == receiptData.latestReceiptInfo![0].productId) {
            _purchases.clear();
            _purchases.add(data);
            if (_purchases != [] && _purchases.isNotEmpty) {
              await Preferences.preferences
                  .saveBool(key: PrefernceKey.isProUser, value: true);
              await Preferences.preferences.saveString(
                  key: PrefernceKey.currentProPlan,
                  value: _purchases[0].productID);
              _iapCallback!.onPrefValChange();
              // MyApp.purchaseStreamController.add(_purchases[0]);
            } else {
              await Preferences.preferences
                  .saveBool(key: PrefernceKey.isProUser, value: false);
              await Preferences.preferences
                  .clearPrefValue(PrefernceKey.currentProPlan);
              _iapCallback!.onPrefValChange();
            }
            print("Already Purchased =======>" +
                receiptData.latestReceiptInfo![0].toJson().toString());

            return;
          } else {
            await Preferences.preferences
                .saveBool(key: PrefernceKey.isProUser, value: false);
            await Preferences.preferences
                .clearPrefValue(PrefernceKey.currentProPlan);
            _iapCallback!.onPrefValChange();
          }

          if (data.pendingCompletePurchase) {
            await _connection.completePurchase(data);
          }
        }
      } else {
        // Preference.shared.setBool(Preference.IS_PURCHASED, false);
        await Preferences.preferences
            .saveBool(key: PrefernceKey.isProUser, value: false);
        await Preferences.preferences
            .clearPrefValue(PrefernceKey.currentProPlan);
        _iapCallback!.onPrefValChange();
      }
    } on DioError catch (ex) {
      try {
        await Preferences.preferences
            .saveBool(key: PrefernceKey.isProUser, value: false);
        await Preferences.preferences
            .clearPrefValue(PrefernceKey.currentProPlan);
        _iapCallback!.onPrefValChange();
        // Preference.shared.setBool(Preference.IS_PURCHASED, false);
        print("Verify Receipt =======> ${ex.response!.data}");
      } catch (e) {
        await Preferences.preferences
            .saveBool(key: PrefernceKey.isProUser, value: false);
        await Preferences.preferences
            .clearPrefValue(PrefernceKey.currentProPlan);
        _iapCallback!.onPrefValChange();

        // Preference.shared.setBool(Preference.IS_PURCHASED, false);
        print(e);
      }
    }
  }

  Map<String, PurchaseDetails> getPurchases() {
    Map<String, PurchaseDetails> purchases =
        Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        _connection.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    return purchases;
  }

  finishTransaction() async {
    final transactions = await SKPaymentQueueWrapper().transactions();

    for (final transaction in transactions) {
      try {
        if (transaction.transactionState !=
            SKPaymentTransactionStateWrapper.purchasing) {
          await SKPaymentQueueWrapper().finishTransaction(transaction);
          await SKPaymentQueueWrapper()
              .finishTransaction(transaction.originalTransaction!);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  buySubscription(ProductDetails productDetails,
      Map<String, PurchaseDetails> purchases) async {
    if (Platform.isIOS) {
      final transactions = await SKPaymentQueueWrapper().transactions();

      print(transactions);

      for (final transaction in transactions) {
        try {
          if (transaction.transactionState !=
              SKPaymentTransactionStateWrapper.purchasing) {
            await SKPaymentQueueWrapper().finishTransaction(transaction);
            await SKPaymentQueueWrapper()
                .finishTransaction(transaction.originalTransaction!);
          }
        } catch (e) {
          print(e);
        }
      }

      final _transactions = await SKPaymentQueueWrapper().transactions();

      print(_transactions);

      for (final transaction in _transactions) {
        try {
          if (transaction.transactionState !=
              SKPaymentTransactionStateWrapper.purchasing) {
            await SKPaymentQueueWrapper().finishTransaction(transaction);
            await SKPaymentQueueWrapper()
                .finishTransaction(transaction.originalTransaction!);
          }
        } catch (e) {
          print(e);
        }
      }
    }

    PurchaseParam purchaseParam;

    if (Platform.isAndroid) {
      final oldSubscription = _getOldSubscription(productDetails, purchases);
      print("isclicked222--$oldSubscription");
      purchaseParam = GooglePlayPurchaseParam(
          productDetails: productDetails,
          applicationUserName: null,
          changeSubscriptionParam: (oldSubscription != null)
              ? ChangeSubscriptionParam(
                  oldPurchaseDetails: oldSubscription,
                )
              : null);
    } else {
      purchaseParam = PurchaseParam(
        productDetails: productDetails,
        applicationUserName: null,
      );
    }

    _connection
        .buyNonConsumable(purchaseParam: purchaseParam)
        .catchError((error) async {
      if (error is PlatformException &&
          error.code == "storekit_duplicate_product_object") {}
      // handleError(error);
      print(error);
    });
  }

  Future<void> clearTransactions() async {
    if (Platform.isIOS) {
      final transactions = await SKPaymentQueueWrapper().transactions();
      for (final transaction in transactions) {
        try {
          if (transaction.transactionState !=
              SKPaymentTransactionStateWrapper.purchasing) {
            await SKPaymentQueueWrapper().finishTransaction(transaction);
            await SKPaymentQueueWrapper()
                .finishTransaction(transaction.originalTransaction!);
          }
        } catch (e) {
          print(e);
        }
      }
    }
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    _purchases.add(purchaseDetails);
    // MyApp.purchaseStreamController.add(purchaseDetails);
    await Preferences.preferences.saveString(
        key: PrefernceKey.currentProPlan, value: purchaseDetails.productID);
    _iapCallback!.onSuccessPurchase(purchaseDetails);
  }

  void handleError(dynamic error) {
    if (_iapCallback != null) {
      _iapCallback!.onBillingError(error);
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {}

  _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      print(
          "status ${purchaseDetails.status.name} ${purchaseDetails.productID}");
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _iapCallback!.onPending(purchaseDetails);
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error);
          return;
        } else if (purchaseDetails.status == PurchaseStatus.restored) {
          getPastPurchases(purchaseDetailsList);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          print(
              "it is called purchaseDetails.pendingCompletePurchase ${purchaseDetails.pendingCompletePurchase}");
          _connection.completePurchase(purchaseDetails).then((value) async {
            // print("then block");
            // var productdetails = InAppPurchaseHelper()
            //     .getProductDetail(purchaseDetails.productID);
            // print("product ---- $productdetails ${purchaseDetails.productID}");
            //
            // if (productdetails != null && purchaseDetails != null) {
            //   SubscriptionController controller =
            //       Get.find<SubscriptionController>();
            //   await controller.postSubscriptionPlan(
            //       productdetails, purchaseDetails);
            // }
            // await Preferences.preferences.saveString(
            //     key: PrefernceKey.currentProPlan, value: purchaseDetails.productID);

            _iapCallback!.onSuccessPurchase(purchaseDetails);
          });
        }

        finishTransaction();
      }
    });
    await clearTransactions();
  }

  GooglePlayPurchaseDetails? _getOldSubscription(
      ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    GooglePlayPurchaseDetails? oldSubscription;
    // if (productDetails.id == monthlySubscriptionId && purchases[monthlySubscriptionId] != null) {
    //   oldSubscription=purchases[monthlySubscriptionId] as GooglePlayPurchaseDetails;
    // }
    // // if (productDetails.id == yearlySubscriptionId && purchases[monthlySubscriptionId] != null) {
    // //   oldSubscription = purchases[yearlySubscriptionId] as GooglePlayPurchaseDetails;
    // // } else {
    // //   if (productDetails.id == monthlySubscriptionId && purchases[yearlySubscriptionId] != null) {
    // //     oldSubscription = purchases[monthlySubscriptionId] as GooglePlayPurchaseDetails;
    // //   }
    // // }
    return oldSubscription;
  }
}
