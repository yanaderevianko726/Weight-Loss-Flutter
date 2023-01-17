import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:women_workout/data/dummy_data.dart';
import 'package:hive/hive.dart';

import 'package:rxdart/rxdart.dart';
import 'package:women_workout/util/color_category.dart';
import 'package:women_workout/util/constant_url.dart';
import '../routes/app_pages.dart';
import 'package:get/get.dart';

import 'package:path_provider/path_provider.dart' as path_provider;

import 'generated/l10n.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

const MethodChannel platform = MethodChannel('dexterx.dev/Women workout');

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

class ReceivedNotification {
  ReceivedNotification({
    this.id,
    this.title,
    this.body,
    this.payload,
  });

  final int? id;
  final String? title;
  final String? body;
  final String? payload;
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('backgroundFirebase=message ${message.notification!.body}');

  _showNotification(message);
  print('Handling a background message ${message.messageId}');
}

Future _showNotification(RemoteMessage message) async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:   'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  print(message.data);
  Map<String, dynamic> data = message.data;
  AndroidNotification android = message.notification!.android!;
  flutterLocalNotificationsPlugin.show(
    0,
    data['title'],
    data['body'],
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription:   channel.description,
        icon: android.smallIcon,
        // other properties...
      ),
      iOS: IOSNotificationDetails(presentAlert: true, presentSound: true),
    ),
    payload: 'Default_Sound',
  );
}


String? selectedNotificationPayload;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  String deviceId = await ConstantUrl.getDeviceId();

  FacebookAudienceNetwork.init(
    testingId: deviceId,
    iOSAdvertiserTrackingEnabled: true,
  );


  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAp24rP8bkGvA5YvDYH9lqGkS6WN-E13wY",
            appId: "1:1038325347416:android:775d14bae8753f5786062d",
            messagingSenderId: "1038325347416",
            projectId: "women-workout-29937"));
  } else {
    await Firebase.initializeApp();
  }


  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );



  await _configureLocalTimeZone();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
          onDidReceiveLocalNotification:
              (int id, String? title, String? body, String? payload) async {
            didReceiveLocalNotificationSubject.add(ReceivedNotification(
                id: id, title: title, body: body, payload: payload));
          });
  const MacOSInitializationSettings initializationSettingsMacOS =
      MacOSInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false);
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    selectedNotificationPayload = payload;
    selectNotificationSubject.add(payload!);
  });

  if (!kIsWeb) {
    var appDocumentDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);

    await  Hive.openBox(DummyData.exercise_key);
    await  Hive.openBox(DummyData.loginBox);


  }

  runApp(
    MyApp(),
  );
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();

  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();

  try {
    Location getlocal =
        tz.getLocation(timeZoneName!.replaceAll("Calcutta", "Kolkata"));
    tz.setLocalLocation(getlocal);
  } catch (e) {
    print(e);
    Location getlocal = tz.getLocation("Calcutta");
    tz.setLocalLocation(getlocal);
  }
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  ThemeData themeData = new ThemeData(
      primaryColor: primaryColor,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      primaryColorDark: primaryColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: accentColor));

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject(BuildContext context) {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {});
  }

  @override
  Widget build(BuildContext context) {
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject(context);
    _configureSelectNotificationSubject();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        S.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: 'Simply Fit Me',
      theme: themeData,
      initialRoute: "/",
      routes: AppPages.routes,
    );
  }
}
