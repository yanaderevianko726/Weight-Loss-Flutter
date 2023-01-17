// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Home Workouts`
  String get homeWorkouts {
    return Intl.message(
      'Home Workouts',
      name: 'homeWorkouts',
      desc: '',
      args: [],
    );
  }

  /// `Discover`
  String get discover {
    return Intl.message(
      'Discover',
      name: 'discover',
      desc: '',
      args: [],
    );
  }

  /// `Activity`
  String get activity {
    return Intl.message(
      'Activity',
      name: 'activity',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Transformation`
  String get transformation {
    return Intl.message(
      'Transformation',
      name: 'transformation',
      desc: '',
      args: [],
    );
  }

  /// `Beginner`
  String get beginner {
    return Intl.message(
      'Beginner',
      name: 'beginner',
      desc: '',
      args: [],
    );
  }

  /// `Challenges`
  String get challenges {
    return Intl.message(
      'Challenges',
      name: 'challenges',
      desc: '',
      args: [],
    );
  }

  /// `Minutes`
  String get minutes {
    return Intl.message(
      'Minutes',
      name: 'minutes',
      desc: '',
      args: [],
    );
  }

  /// `Kcal`
  String get kcal {
    return Intl.message(
      'Kcal',
      name: 'kcal',
      desc: '',
      args: [],
    );
  }

  /// `Workouts`
  String get workouts {
    return Intl.message(
      'Workouts',
      name: 'workouts',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get week {
    return Intl.message(
      'Week',
      name: 'week',
      desc: '',
      args: [],
    );
  }

  /// `video not loaded.please check network..`
  String get videoError {
    return Intl.message(
      'video not loaded.please check network..',
      name: 'videoError',
      desc: '',
      args: [],
    );
  }

  /// `Intermediate`
  String get intermediate {
    return Intl.message(
      'Intermediate',
      name: 'intermediate',
      desc: '',
      args: [],
    );
  }

  /// `Advanced`
  String get advanced {
    return Intl.message(
      'Advanced',
      name: 'advanced',
      desc: '',
      args: [],
    );
  }

  /// `Calories`
  String get calories {
    return Intl.message(
      'Calories',
      name: 'calories',
      desc: '',
      args: [],
    );
  }

  /// `Seconds`
  String get seconds {
    return Intl.message(
      'Seconds',
      name: 'seconds',
      desc: '',
      args: [],
    );
  }

  /// `Quick Workouts`
  String get quickWorkouts {
    return Intl.message(
      'Quick Workouts',
      name: 'quickWorkouts',
      desc: '',
      args: [],
    );
  }

  /// `Popular Workouts`
  String get popularWorkouts {
    return Intl.message(
      'Popular Workouts',
      name: 'popularWorkouts',
      desc: '',
      args: [],
    );
  }

  /// `Top Picks`
  String get topPicks {
    return Intl.message(
      'Top Picks',
      name: 'topPicks',
      desc: '',
      args: [],
    );
  }

  /// `Stretches`
  String get stretches {
    return Intl.message(
      'Stretches',
      name: 'stretches',
      desc: '',
      args: [],
    );
  }

  /// `GO`
  String get go {
    return Intl.message(
      'GO',
      name: 'go',
      desc: '',
      args: [],
    );
  }

  /// `Exercises`
  String get exercises {
    return Intl.message(
      'Exercises',
      name: 'exercises',
      desc: '',
      args: [],
    );
  }

  /// `WORKOUT`
  String get workout {
    return Intl.message(
      'WORKOUT',
      name: 'workout',
      desc: '',
      args: [],
    );
  }

  /// `Workout`
  String get app_name {
    return Intl.message(
      'Workout',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Workout`
  String get workout_small {
    return Intl.message(
      'Workout',
      name: 'workout_small',
      desc: '',
      args: [],
    );
  }

  /// `Shape Your Body`
  String get shapeYourBody {
    return Intl.message(
      'Shape Your Body',
      name: 'shapeYourBody',
      desc: '',
      args: [],
    );
  }

  /// `build muscle, get toned, achive an athlet's body`
  String get buildMuscleGetTonedAchiveAnAthletsBody {
    return Intl.message(
      'build muscle, get toned, achive an athlet\'s body',
      name: 'buildMuscleGetTonedAchiveAnAthletsBody',
      desc: '',
      args: [],
    );
  }

  /// `SAVE`
  String get save {
    return Intl.message(
      'SAVE',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message(
      'Duration',
      name: 'duration',
      desc: '',
      args: [],
    );
  }

  /// `TTS Voice`
  String get ttsVoice {
    return Intl.message(
      'TTS Voice',
      name: 'ttsVoice',
      desc: '',
      args: [],
    );
  }

  /// `Sound`
  String get sound {
    return Intl.message(
      'Sound',
      name: 'sound',
      desc: '',
      args: [],
    );
  }

  /// `Yoga`
  String get yoga {
    return Intl.message(
      'Yoga',
      name: 'yoga',
      desc: '',
      args: [],
    );
  }

  /// `Seasonal Yoga`
  String get seasonalYoga {
    return Intl.message(
      'Seasonal Yoga',
      name: 'seasonalYoga',
      desc: '',
      args: [],
    );
  }

  /// `Yoga Styles`
  String get yogaStyles {
    return Intl.message(
      'Yoga Styles',
      name: 'yogaStyles',
      desc: '',
      args: [],
    );
  }

  /// `Body Fitness`
  String get bodyFitness {
    return Intl.message(
      'Body Fitness',
      name: 'bodyFitness',
      desc: '',
      args: [],
    );
  }

  /// `Yoga Workout`
  String get yogaWorkout {
    return Intl.message(
      'Yoga Workout',
      name: 'yogaWorkout',
      desc: '',
      args: [],
    );
  }

  /// `See All`
  String get seeAll {
    return Intl.message(
      'See All',
      name: 'seeAll',
      desc: '',
      args: [],
    );
  }

  /// `Please Wait`
  String get pleaseWait {
    return Intl.message(
      'Please Wait',
      name: 'pleaseWait',
      desc: '',
      args: [],
    );
  }

  /// `Remember me`
  String get rememberMe {
    return Intl.message(
      'Remember me',
      name: 'rememberMe',
      desc: '',
      args: [],
    );
  }

  /// `You must have 6 characters in your password`
  String get passwordError {
    return Intl.message(
      'You must have 6 characters in your password',
      name: 'passwordError',
      desc: '',
      args: [],
    );
  }

  /// `Enter valid mail..`
  String get fillEmail {
    return Intl.message(
      'Enter valid mail..',
      name: 'fillEmail',
      desc: '',
      args: [],
    );
  }

  /// `Fill details...`
  String get fillDetails {
    return Intl.message(
      'Fill details...',
      name: 'fillDetails',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection`
  String get noInternetConnection {
    return Intl.message(
      'No internet connection',
      name: 'noInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Sign up and\nstaring workout`
  String get signUpAndnstaringWorkout {
    return Intl.message(
      'Sign up and\nstaring workout',
      name: 'signUpAndnstaringWorkout',
      desc: '',
      args: [],
    );
  }

  /// `Glad to meet\nyou again!`
  String get gladToMeetnyouAgain {
    return Intl.message(
      'Glad to meet\nyou again!',
      name: 'gladToMeetnyouAgain',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message(
      'Resend',
      name: 'resend',
      desc: '',
      args: [],
    );
  }

  /// `Resend in`
  String get resendSms {
    return Intl.message(
      'Resend in',
      name: 'resendSms',
      desc: '',
      args: [],
    );
  }

  /// `You have an already account?`
  String get youHaveAnAlreadyAccount {
    return Intl.message(
      'You have an already account?',
      name: 'youHaveAnAlreadyAccount',
      desc: '',
      args: [],
    );
  }

  /// `password`
  String get password {
    return Intl.message(
      'password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Yoga Fitness`
  String get yogaFitness {
    return Intl.message(
      'Yoga Fitness',
      name: 'yogaFitness',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up Now`
  String get signUpNow {
    return Intl.message(
      'Sign Up Now',
      name: 'signUpNow',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Old Password`
  String get oldPassword {
    return Intl.message(
      'Old Password',
      name: 'oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Fill OTP..`
  String get fillOtp {
    return Intl.message(
      'Fill OTP..',
      name: 'fillOtp',
      desc: '',
      args: [],
    );
  }

  /// `User not available..`
  String get userError {
    return Intl.message(
      'User not available..',
      name: 'userError',
      desc: '',
      args: [],
    );
  }

  /// `sec`
  String get sec {
    return Intl.message(
      'sec',
      name: 'sec',
      desc: '',
      args: [],
    );
  }

  /// `Verify Code`
  String get verifyCode {
    return Intl.message(
      'Verify Code',
      name: 'verifyCode',
      desc: '',
      args: [],
    );
  }

  /// `We will send you a OTP sms.`
  String get verifyMsg {
    return Intl.message(
      'We will send you a OTP sms.',
      name: 'verifyMsg',
      desc: '',
      args: [],
    );
  }

  /// `Please select your gender`
  String get pleaseSelectYourGender {
    return Intl.message(
      'Please select your gender',
      name: 'pleaseSelectYourGender',
      desc: '',
      args: [],
    );
  }

  /// `Select Gender`
  String get selectGender {
    return Intl.message(
      'Select Gender',
      name: 'selectGender',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `What is your weight?`
  String get whatIsYourWeight {
    return Intl.message(
      'What is your weight?',
      name: 'whatIsYourWeight',
      desc: '',
      args: [],
    );
  }

  /// `To give you a better experience we need to know your weight.`
  String get toGiveYouABetterExperienceNweNeedToKnow {
    return Intl.message(
      'To give you a better experience we need to know your weight.',
      name: 'toGiveYouABetterExperienceNweNeedToKnow',
      desc: '',
      args: [],
    );
  }

  /// `To give you a better experience we need to know your height.`
  String get toGiveYouABetterExperienceNweNeedToKnowHeight {
    return Intl.message(
      'To give you a better experience we need to know your height.',
      name: 'toGiveYouABetterExperienceNweNeedToKnowHeight',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Personal Info`
  String get personalInfo {
    return Intl.message(
      'Personal Info',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Manage Profile`
  String get manageProfile {
    return Intl.message(
      'Manage Profile',
      name: 'manageProfile',
      desc: '',
      args: [],
    );
  }

  /// `How tall are you?`
  String get howTallAreYou {
    return Intl.message(
      'How tall are you?',
      name: 'howTallAreYou',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid mail..`
  String get pleaseEnterValidMail {
    return Intl.message(
      'Please enter valid mail..',
      name: 'pleaseEnterValidMail',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Intensively`
  String get intensively {
    return Intl.message(
      'Intensively',
      name: 'intensively',
      desc: '',
      args: [],
    );
  }

  /// `Time In Week`
  String get timeInWeek {
    return Intl.message(
      'Time In Week',
      name: 'timeInWeek',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message(
      'Age',
      name: 'age',
      desc: '',
      args: [],
    );
  }

  /// `Height`
  String get height {
    return Intl.message(
      'Height',
      name: 'height',
      desc: '',
      args: [],
    );
  }

  /// `Weight`
  String get weight {
    return Intl.message(
      'Weight',
      name: 'weight',
      desc: '',
      args: [],
    );
  }

  /// `User not registered..`
  String get userNotRegistered {
    return Intl.message(
      'User not registered..',
      name: 'userNotRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Something wrong..`
  String get somethingWrong {
    return Intl.message(
      'Something wrong..',
      name: 'somethingWrong',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
