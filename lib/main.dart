import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as time_zone;
import 'package:women_lose_weight_flutter/inapppurchase/in_app_purchase_helper.dart';
import 'package:women_lose_weight_flutter/routes/app_routes.dart';
import 'package:women_lose_weight_flutter/utils/utils.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'localization/locale_constant.dart';
import 'localization/localizations_delegate.dart';
import 'routes/app_pages.dart';
import 'themes/app_theme.dart';
import 'utils/color.dart';
import 'utils/constant.dart';
import 'utils/debug.dart';
import 'utils/preference.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

Future<void> initPlugin() async {
  try {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      var _authStatus =
          await AppTrackingTransparency.requestTrackingAuthorization();
      Preference.shared
          .setString(Preference.trackStatus, _authStatus.toString());
    }
  } on PlatformException {
    Debug.printLog("Platform Exception");
  }

  final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  Debug.printLog("UUID:" + uuid);
}

String? selectedNotificationPayload;

Future<void> main() async {
  /// Initialize  Widgets binding use in the firebase core or etc...
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Shared Preference
  await Preference().instance();

  /// Initialize app tracking transparency
  await initPlugin();

  /// Initialize Firebase
  await Firebase.initializeApp();

  ///ignore: deprecated_member_use
  InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();

  if (Platform.isIOS) {
    final transactions = await SKPaymentQueueWrapper().transactions();

    for (SKPaymentTransactionWrapper element in transactions) {
      await SKPaymentQueueWrapper().finishTransaction(element);
      await SKPaymentQueueWrapper()
          .finishTransaction(element.originalTransaction!);
    }
  }
  await InAppPurchaseHelper().initStoreInfo();

  /// Initialize Notification
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_notification');

  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationSubject.add(ReceivedNotification(
          id: id, title: title, body: body, payload: payload));
    },
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse? notificationResponse) async {
    if (notificationResponse!.payload != null && notificationResponse.payload == Constant.strExerciseReminder) {
    } else if (notificationResponse.payload != null && notificationResponse.payload == Constant.strWaterReminder) {}

    selectedNotificationPayload = notificationResponse.payload;
    selectNotificationSubject.add(notificationResponse.payload);
  });

  /// Initialize Local TimeZone
  _configureLocalTimeZone();

  /// Call Main App
  runApp(const MyApp());
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  time_zone.setLocalLocation(time_zone.getLocation(timeZoneName!));
}

Future<InitializationStatus> _initGoogleMobileAds() {
  return MobileAds.instance.initialize();
}

class MyApp extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final FlutterTts flutterTts = FlutterTts();
  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static final StreamController purchaseStreamController =
  StreamController<PurchaseDetails>.broadcast();

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _initGoogleMobileAds();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        Debug.printLog(
            "didChangeDependencies Preference Revoked ===>> ${locale.languageCode}");
        Get.updateLocale(locale);
        Debug.printLog(
            "didChangeDependencies GET LOCALE Revoked ===>> ${Get.locale!.languageCode}");
        initializeDateFormatting(
            "${locale.languageCode}_${locale.countryCode}", null);
      });
    });
    _rescheduleWaterTrackerNotifications();
    super.didChangeDependencies();
  }

  _rescheduleWaterTrackerNotifications() {
    bool isTurnOnWaterTracker =
        Preference.shared.getBool(Preference.turnOnWaterTracker) ??
            Constant.boolValueTrue;
    if (isTurnOnWaterTracker) {
      Utils.setWaterReminderNotifications();
    } else {
      Utils.cancelWaterReminderNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: MyApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      color: AppColor.white,
      translations: AppLanguages(),
      fallbackLocale: const Locale(Constant.languageEn, Constant.countryCodeEn),
      themeMode: ThemeMode.light,
      theme: AppTheme.light,
      darkTheme: AppTheme.light,
      locale: const Locale("en"),
      getPages: AppPages.list,
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 200),
      initialRoute:
          (Utils.isFirstTimeOpenApp()) ? AppRoutes.initial : AppRoutes.home,
    );
  }
}
