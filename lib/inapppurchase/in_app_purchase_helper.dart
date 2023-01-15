import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
/// ignore: implementation_imports
import 'package:in_app_purchase_android/src/billing_client_wrappers/billing_client_wrapper.dart';
import 'package:women_lose_weight_flutter/inapppurchase/iap_callback.dart';
import 'package:women_lose_weight_flutter/inapppurchase/iap_receipt_data.dart';
import '../main.dart';
import '../utils/constant.dart';
import '../utils/debug.dart';
import '../utils/preference.dart';

class InAppPurchaseHelper {
  static final InAppPurchaseHelper _inAppPurchaseHelper =
  InAppPurchaseHelper._internal();

  InAppPurchaseHelper._internal();

  factory InAppPurchaseHelper() {
    return _inAppPurchaseHelper;
  }

  static String monthlySubscriptionId = Constant.monthlySubscriptionId;
  static String yearlySubscriptionId = Constant.yearlySubscriptionId;

  static final List<String> _kProductIds = <String>[
    monthlySubscriptionId,
    yearlySubscriptionId,
  ];

  final InAppPurchase _connection = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];

  IAPCallback? _iapCallback;

  initialize() {
    if (Platform.isAndroid) {
      ///ignore: deprecated_member_use
      InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
    } else {
      SKPaymentQueueWrapper().restoreTransactions();
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
    }, cancelOnError: true ,onDone: () {
      _subscription?.cancel();
    }, onError: (error) {
      Debug.printLog(error);
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

    ProductDetailsResponse productDetailResponse =
    await _connection.queryProductDetails(_kProductIds.toSet());

    if(productDetailResponse.error == null) {
      _products = productDetailResponse.productDetails;
    }

    if (productDetailResponse.error != null) {
      _products = productDetailResponse.productDetails;
      _purchases = [];
      return;
    }


    if (productDetailResponse.productDetails.isEmpty) {
      _products = productDetailResponse.productDetails;
      _purchases = [];
      return;
    } else {
      _products = productDetailResponse.productDetails;
      _purchases = [];
    }
    await _connection.restorePurchases();
  }

  Future<void> getPastPurchases(List<PurchaseDetails> verifiedPurchases) async {
    verifiedPurchases
        .sort((a, b) => a.transactionDate!.compareTo(b.transactionDate!));

    if (Platform.isIOS) {
      Map.fromEntries(verifiedPurchases.map((PurchaseDetails purchase) {
        if (purchase.pendingCompletePurchase) {
          _connection.completePurchase(purchase);
        }
        return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
      }));

      if (verifiedPurchases.isNotEmpty) {
        await _verifyProductReceipts(verifiedPurchases);
      } else {
        Debug.printLog("You have not Purchased :::::::::::::::::::=>");
        Preference.shared.setBool(Preference.isPurchased, false);
        _iapCallback?.onBillingError(
            "You haven't purchase our product, so we can't restore.");
      }
    }

    if (verifiedPurchases.isNotEmpty) {
      if (verifiedPurchases != [] && verifiedPurchases.isNotEmpty) {
        _purchases = verifiedPurchases;
        Debug.printLog("You have already Purchased :::::::::::::::::::=>");
        Preference.shared.setBool(Preference.isPurchased, true);

        for (var element in _purchases) {
          MyApp.purchaseStreamController.add(element);
          _iapCallback?.onSuccessPurchase(element);
        }
      } else {
        Debug.printLog("You have not Purchased :::::::::::::::::::=>");
        _iapCallback?.onBillingError(
            "You haven't purchase our product, so we can't restore.");
        Preference.shared.setBool(Preference.isPurchased, false);
        _iapCallback?.onBillingError("");
      }
    } else {
      Debug.printLog("You have not Purchased :::::::::::::::::::=>");
      _iapCallback?.onBillingError(
          "You haven't purchase our product, so we can't restore.");
      Preference.shared.setBool(Preference.isPurchased, false);
      _iapCallback?.onBillingError("");
    }
  }

  _verifyProductReceipts(List<PurchaseDetails> verifiedPurchases) async {
    var dio = Dio(
      BaseOptions(
        connectTimeout: 5000,
        receiveTimeout: 5000,
      ),
    );

    Map<String, String> data = {};
    data.putIfAbsent("receipt-data",
            () => verifiedPurchases[0].verificationData.localVerificationData);

    try {
      String verifyReceiptUrl;

      if (Debug.sandboxVerifyRecieptUrl) {
        verifyReceiptUrl = 'https://sandbox.itunes.apple.com/verifyReceipt';
      } else {
        verifyReceiptUrl = 'https://buy.itunes.apple.com/verifyReceipt';
      }

      final graphResponse =
      await dio.post<String>(verifyReceiptUrl, data: data);
      Map<String, dynamic> profile = jsonDecode(graphResponse.data!);

      var receiptData = IapReceiptData.fromJson(profile);

      if (receiptData.latestReceiptInfo != null) {
        receiptData.latestReceiptInfo!
            .sort((a, b) => b.expiresDateMs!.compareTo(a.expiresDateMs!));
        if (int.parse(receiptData.latestReceiptInfo![0].expiresDateMs!) >
            DateTime.now().millisecondsSinceEpoch) {
          for (PurchaseDetails data in verifiedPurchases) {
            if (data.productID == receiptData.latestReceiptInfo![0].productId) {
              _purchases.clear();
              _purchases.add(data);
              if (_purchases != [] && _purchases.isNotEmpty) {
                Preference.shared
                    .setBool(Preference.isPurchased, true);
                for (var element in _purchases) {
                  MyApp.purchaseStreamController.add(element);
                  _iapCallback?.onSuccessPurchase(element);
                }
              } else {
                Preference.shared
                    .setBool(Preference.isPurchased, false);
                _iapCallback?.onBillingError("");
              }
              Debug.printLog("Already Purchased =======>" +
                  receiptData.latestReceiptInfo![0].toJson().toString());

              return;
            } else {
              Preference.shared
                  .setBool(Preference.isPurchased, false);
              _iapCallback?.onBillingError("");
            }

            if (data.pendingCompletePurchase) {
              await _connection.completePurchase(data);
            }
          }
        } else {
          Preference.shared.setBool(Preference.isPurchased, false);
          _iapCallback?.onBillingError("");
        }
      }
    } on DioError catch (ex) {
      try {
        Preference.shared.setBool(Preference.isPurchased, false);
        _iapCallback?.onBillingError("");
        Debug.printLog("Verify Receipt =======> ${ex.response!.data}");
      } catch (e) {
        Preference.shared.setBool(Preference.isPurchased, false);
        _iapCallback?.onBillingError("");
        Debug.printLog(e.toString());
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

    if (transactions != []) {
      for (final transaction in transactions) {
        try {
          if (transaction.transactionState !=
              SKPaymentTransactionStateWrapper.purchasing) {
            await SKPaymentQueueWrapper().finishTransaction(transaction);
            await SKPaymentQueueWrapper()
                .finishTransaction(transaction.originalTransaction!);
          }
        } catch (e) {
          Debug.printLog(e.toString());
          _iapCallback?.onBillingError(e);
        }
      }
    }
  }

  buySubscription(ProductDetails productDetails,
      Map<String, PurchaseDetails> purchases) async {
    if (Platform.isIOS) {
      final transactions = await SKPaymentQueueWrapper().transactions();

      Debug.printLog(transactions.toString());

      for (final transaction in transactions) {
        try {
          if (transaction.transactionState !=
              SKPaymentTransactionStateWrapper.purchasing) {
            await SKPaymentQueueWrapper().finishTransaction(transaction);
            await SKPaymentQueueWrapper()
                .finishTransaction(transaction.originalTransaction!);
          }
        } catch (e) {
          _iapCallback?.onBillingError(e);
          Debug.printLog(e.toString());
        }
      }

      final _transactions = await SKPaymentQueueWrapper().transactions();

      Debug.printLog(_transactions.toString());

      for (final transaction in _transactions) {
        try {
          if (transaction.transactionState !=
              SKPaymentTransactionStateWrapper.purchasing) {
            await SKPaymentQueueWrapper().finishTransaction(transaction);
            await SKPaymentQueueWrapper()
                .finishTransaction(transaction.originalTransaction!);
          }
        } catch (e) {
          _iapCallback?.onBillingError(e);
          Debug.printLog(e.toString());
        }
      }
    } else {
      if (Platform.isIOS) {
        _iapCallback?.onBillingError("");
      }
    }

    PurchaseParam purchaseParam;

    if (Platform.isAndroid) {
      final oldSubscription = _getOldSubscription(productDetails, purchases);

      purchaseParam = GooglePlayPurchaseParam(
          productDetails: productDetails,
          applicationUserName: null,
          changeSubscriptionParam: (oldSubscription != null)
              ? ChangeSubscriptionParam(
            oldPurchaseDetails: oldSubscription,
            prorationMode: ProrationMode.immediateWithTimeProration,
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
          error.code == "storekit_duplicate_product_object") {
      }
      handleError(error);
      Debug.printLog(error.toString());
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
          _iapCallback?.onBillingError(e);
          Debug.printLog(e.toString());
        }
      }
    }
  }

  void deliverProduct(PurchaseDetails purchaseDetails) async {
    _purchases.add(purchaseDetails);
    MyApp.purchaseStreamController.add(purchaseDetails);
    _iapCallback?.onSuccessPurchase(purchaseDetails);
  }

  void handleError(dynamic error) {
    _iapCallback?.onBillingError(error);
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    return Future<bool>.value(true);
  }


  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList)  {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        _iapCallback?.onPending(purchaseDetails);
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.restored) {
          getPastPurchases(purchaseDetailsList);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          _iapCallback?.onBillingError(purchaseDetails.error);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            return;
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _connection.completePurchase(purchaseDetails);
          finishTransaction();
        }
      }
    }
    await clearTransactions();
  }

  GooglePlayPurchaseDetails? _getOldSubscription(
      ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    return purchases[productDetails.id] as GooglePlayPurchaseDetails?;
  }


}
