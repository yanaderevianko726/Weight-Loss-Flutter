import 'dart:convert';

IapReceiptData iapReceiptDataFromJson(String str) =>
    IapReceiptData.fromJson(json.decode(str));

String iapReceiptDataToJson(IapReceiptData data) => json.encode(data.toJson());

class IapReceiptData {
  IapReceiptData({
    this.environment,
    this.receipt,
    this.latestReceiptInfo,
    this.latestReceipt,
    this.pendingRenewalInfo,
    this.status,
  });

  String? environment;
  Receipt? receipt;
  List<LatestReceiptInfo>? latestReceiptInfo;
  String? latestReceipt;
  List<PendingRenewalInfo>? pendingRenewalInfo;
  int? status;

  factory IapReceiptData.fromJson(Map<String, dynamic> json) => IapReceiptData(
        environment: json["environment"],
        receipt: (json["receipt"] != null)
            ? Receipt.fromJson(json["receipt"])
            : null,
        latestReceiptInfo: (json["latest_receipt_info"] != null)
            ? List<LatestReceiptInfo>.from(json["latest_receipt_info"]
                .map((x) => LatestReceiptInfo.fromJson(x)))
            : null,
        latestReceipt: json["latest_receipt"],
        pendingRenewalInfo: (json["pending_renewal_info"] != null)
            ? List<PendingRenewalInfo>.from(json["pending_renewal_info"]
                .map((x) => PendingRenewalInfo.fromJson(x)))
            : null,
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "environment": environment,
        "receipt": receipt != null ? receipt!.toJson() : null,
        "latest_receipt_info": latestReceiptInfo != null
            ? List<dynamic>.from(latestReceiptInfo!.map((x) => x.toJson()))
            : null,
        "latest_receipt": latestReceipt,
        "pending_renewal_info": pendingRenewalInfo != null
            ? List<dynamic>.from(pendingRenewalInfo!.map((x) => x.toJson()))
            : null,
        "status": status,
      };
}

class LatestReceiptInfo {
  LatestReceiptInfo({
    this.quantity,
    this.productId,
    this.transactionId,
    this.originalTransactionId,
    this.purchaseDate,
    this.purchaseDateMs,
    this.purchaseDatePst,
    this.originalPurchaseDate,
    this.originalPurchaseDateMs,
    this.originalPurchaseDatePst,
    this.expiresDate,
    this.expiresDateMs,
    this.expiresDatePst,
    this.webOrderLineItemId,
    this.isTrialPeriod,
    this.isInIntroOfferPeriod,
    this.subscriptionGroupIdentifier,
  });

  String? quantity;
  String? productId;
  String? transactionId;
  String? originalTransactionId;
  String? purchaseDate;
  String? purchaseDateMs;
  String? purchaseDatePst;
  String? originalPurchaseDate;
  String? originalPurchaseDateMs;
  String? originalPurchaseDatePst;
  String? expiresDate;
  String? expiresDateMs;
  String? expiresDatePst;
  String? webOrderLineItemId;
  String? isTrialPeriod;
  String? isInIntroOfferPeriod;
  String? subscriptionGroupIdentifier;

  factory LatestReceiptInfo.fromJson(Map<String, dynamic> json) =>
      LatestReceiptInfo(
        quantity: json["quantity"],
        productId: json["product_id"],
        transactionId: json["transaction_id"],
        originalTransactionId: json["original_transaction_id"],
        purchaseDate: json["purchase_date"],
        purchaseDateMs: json["purchase_date_ms"],
        purchaseDatePst: json["purchase_date_pst"],
        originalPurchaseDate: json["original_purchase_date"],
        originalPurchaseDateMs: json["original_purchase_date_ms"],
        originalPurchaseDatePst: json["original_purchase_date_pst"],
        expiresDate: json["expires_date"],
        expiresDateMs: json["expires_date_ms"],
        expiresDatePst: json["expires_date_pst"],
        webOrderLineItemId: json["web_order_line_item_id"],
        isTrialPeriod: json["is_trial_period"],
        isInIntroOfferPeriod: json["is_in_intro_offer_period"],
        subscriptionGroupIdentifier:
            json["subscription_group_identifier"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "product_id": productId,
        "transaction_id": transactionId,
        "original_transaction_id": originalTransactionId,
        "purchase_date": purchaseDate,
        "purchase_date_ms": purchaseDateMs,
        "purchase_date_pst": purchaseDatePst,
        "original_purchase_date": originalPurchaseDate,
        "original_purchase_date_ms": originalPurchaseDateMs,
        "original_purchase_date_pst": originalPurchaseDatePst,
        "expires_date": expiresDate,
        "expires_date_ms": expiresDateMs,
        "expires_date_pst": expiresDatePst,
        "web_order_line_item_id": webOrderLineItemId,
        "is_trial_period": isTrialPeriod,
        "is_in_intro_offer_period": isInIntroOfferPeriod,
        "subscription_group_identifier": subscriptionGroupIdentifier,
      };
}

class PendingRenewalInfo {
  PendingRenewalInfo({
    this.expirationIntent,
    this.autoRenewProductId,
    this.isInBillingRetryPeriod,
    this.productId,
    this.originalTransactionId,
    this.autoRenewStatus,
  });

  String? expirationIntent;
  String? autoRenewProductId;
  String? isInBillingRetryPeriod;
  String? productId;
  String? originalTransactionId;
  String? autoRenewStatus;

  factory PendingRenewalInfo.fromJson(Map<String, dynamic> json) =>
      PendingRenewalInfo(
        expirationIntent: json["expiration_intent"],
        autoRenewProductId: json["auto_renew_product_id"],
        isInBillingRetryPeriod: json["is_in_billing_retry_period"],
        productId: json["product_id"],
        originalTransactionId: json["original_transaction_id"],
        autoRenewStatus: json["auto_renew_status"],
      );

  Map<String, dynamic> toJson() => {
        "expiration_intent": expirationIntent,
        "auto_renew_product_id": autoRenewProductId,
        "is_in_billing_retry_period": isInBillingRetryPeriod,
        "product_id": productId,
        "original_transaction_id": originalTransactionId,
        "auto_renew_status": autoRenewStatus,
      };
}

class Receipt {
  Receipt({
    this.receiptType,
    this.adamId,
    this.appItemId,
    this.bundleId,
    this.applicationVersion,
    this.downloadId,
    this.versionExternalIdentifier,
    this.receiptCreationDate,
    this.receiptCreationDateMs,
    this.receiptCreationDatePst,
    this.requestDate,
    this.requestDateMs,
    this.requestDatePst,
    this.originalPurchaseDate,
    this.originalPurchaseDateMs,
    this.originalPurchaseDatePst,
    this.originalApplicationVersion,
    this.inApp,
  });

  String? receiptType;
  int? adamId;
  int? appItemId;
  String? bundleId;
  String? applicationVersion;
  int? downloadId;
  int? versionExternalIdentifier;
  String? receiptCreationDate;
  String? receiptCreationDateMs;
  String? receiptCreationDatePst;
  String? requestDate;
  String? requestDateMs;
  String? requestDatePst;
  String? originalPurchaseDate;
  String? originalPurchaseDateMs;
  String? originalPurchaseDatePst;
  String? originalApplicationVersion;
  List<LatestReceiptInfo>? inApp;

  factory Receipt.fromJson(Map<String, dynamic> json) => Receipt(
        receiptType: json["receipt_type"],
        adamId: json["adam_id"],
        appItemId: json["app_item_id"],
        bundleId: json["bundle_id"],
        applicationVersion: json["application_version"],
        downloadId: json["download_id"],
        versionExternalIdentifier: json["version_external_identifier"],
        receiptCreationDate: json["receipt_creation_date"],
        receiptCreationDateMs: json["receipt_creation_date_ms"],
        receiptCreationDatePst: json["receipt_creation_date_pst"],
        requestDate: json["request_date"],
        requestDateMs: json["request_date_ms"],
        requestDatePst: json["request_date_pst"],
        originalPurchaseDate: json["original_purchase_date"],
        originalPurchaseDateMs: json["original_purchase_date_ms"],
        originalPurchaseDatePst: json["original_purchase_date_pst"],
        originalApplicationVersion: json["original_application_version"],
        inApp: List<LatestReceiptInfo>.from(
            json["in_app"].map((x) => LatestReceiptInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "receipt_type": receiptType,
        "adam_id": adamId,
        "app_item_id": appItemId,
        "bundle_id": bundleId,
        "application_version": applicationVersion,
        "download_id": downloadId,
        "version_external_identifier": versionExternalIdentifier,
        "receipt_creation_date": receiptCreationDate,
        "receipt_creation_date_ms": receiptCreationDateMs,
        "receipt_creation_date_pst": receiptCreationDatePst,
        "request_date": requestDate,
        "request_date_ms": requestDateMs,
        "request_date_pst": requestDatePst,
        "original_purchase_date": originalPurchaseDate,
        "original_purchase_date_ms": originalPurchaseDateMs,
        "original_purchase_date_pst": originalPurchaseDatePst,
        "original_application_version": originalApplicationVersion,
        "in_app": inApp != null
            ? List<dynamic>.from(inApp!.map((x) => x.toJson()))
            : null,
      };
}

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null && map != null) {
      reverseMap = map!.map((k, v) =>  MapEntry(v, k));
    }
    return reverseMap;
  }
}
