import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/common/dialog/sound_option/dialog_sound_option.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/localization/localizations_delegate.dart';
import 'package:women_lose_weight_flutter/routes/app_routes.dart';
import 'package:women_lose_weight_flutter/ui/me/controllers/me_controller.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';
import 'package:women_lose_weight_flutter/utils/utils.dart';

import '../../../utils/color.dart';
import '../../report/controllers/report_controller.dart';

class MeScreen extends StatelessWidget {
  MeScreen({Key? key}) : super(key: key);
  final MeController _meController = Get.find<MeController>();
  final ReportController _reportController = Get.find<ReportController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: AppSizes.height_3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _backupAndRestoreWidget(),
          _dividerWidget(),
          _spaceWidget(h: AppSizes.height_2_5),
          _commonTitleText("txtWorkout".tr),
          _spaceWidget(h: AppSizes.height_3_3),
          InkWell(
            onTap: () {
              Get.toNamed(AppRoutes.reminder);
            },
            child: Row(
              children: [
                Expanded(
                  child: _commonFieldText(
                    "txtReminder".tr,
                    "",
                    Icons.alarm,
                    Constant.boolValueFalse,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    right: AppSizes.width_5,
                    left: AppSizes.width_5,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColor.primary,
                  ),
                ),
              ],
            ),
          ),
          _spaceWidget(h: AppSizes.height_3),
          _commonFieldText(
            "txtSoundOptions".tr,
            "icon_setting_tts_voice.webp",
            null,
            Constant.boolValueTrue,
            onTap: () {
              _soundOptionsDialog();
            },
          ),
          if(_meController.isAdmin)            
            _spaceWidget(h: AppSizes.height_3),
          if(_meController.isAdmin) 
            _commonFieldText(
              "txtAdjustDiets".tr,
              "ic_homepage_drink.webp",
              null,
              Constant.boolValueTrue,
              onTap: () {
                _meController.onClickAdjustDiet();
              },
            ),
          _spaceWidget(),
          _dividerWidget(),
          _spaceWidget(),
          _commonTitleText("txtGeneralSettings".tr),
          _spaceWidget(h: AppSizes.height_3_3),
          Row(
            children: [
              Expanded(
                child: _commonFieldText(
                  "txtTurnOnWaterTracker".tr,
                  "ic_set_water.webp",
                  null,
                  Constant.boolValueTrue,
                  onTap: () {},
                ),
              ),
              GetBuilder<MeController>(
                id: Constant.idMeTurnOnWaterTrackerSwitch,
                builder: (logic) {
                  return Container(
                    height: AppSizes.height_1,
                    width: AppSizes.height_3,
                    margin: EdgeInsets.only(
                        right: AppSizes.width_5, left: AppSizes.width_5),
                    child: Switch(
                      onChanged: (value) {
                        logic.onTurnOnWaterTrackerToggleSwitchChange(value);
                      },
                      value: logic.isTurnOnWaterTracker,
                      activeColor: AppColor.switchActivate,
                      activeTrackColor: AppColor.switchActivateTrack,
                      inactiveThumbColor: AppColor.switchInactive,
                      inactiveTrackColor: AppColor.switchInactiveTrack,
                    ),
                  );
                },
              ),
            ],
          ),
          _spaceWidget(h: AppSizes.height_3),
          _commonFieldText(
            "txtMyProfile".tr,
            "",
            Icons.add_box_outlined,
            Constant.boolValueFalse,
            onTap: () {
              Get.toNamed(AppRoutes.myProfile)!
                  .then((value) => _reportController.refreshWeightData());
            },
          ),
          _spaceWidget(h: AppSizes.height_3),
          _commonFieldText(
            "txtRestartProgress".tr,
            "",
            Icons.refresh,
            Constant.boolValueFalse,
            onTap: () {
              _dialogResetProgress();
            },
          ),
          _spaceWidget(h: AppSizes.height_3),
          _commonFieldText(
            "txtVoiceOptionsTTS".tr,
            "",
            Icons.mic_none_outlined,
            Constant.boolValueFalse,
            onTap: () {
              Get.toNamed(AppRoutes.voiceOptions);
            },
          ),
          _spaceWidget(),
          Row(
            children: [
              Expanded(
                child: _commonFieldText(
                  "txtLanguageOptions".tr,
                  "",
                  Icons.translate,
                  Constant.boolValueFalse,
                ),
              ),
              GetBuilder<MeController>(
                  id: Constant.idMeChangeLanguage,
                  builder: (logic) {
                    return Container(
                      margin: EdgeInsets.only(right: AppSizes.width_2),
                      child: DropdownButton<LanguageModel>(
                        value: logic.languagesChosenValue,
                        elevation: 2,
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: AppFontSize.size_12_5,
                          fontWeight: FontWeight.w400,
                        ),
                        iconEnabledColor: AppColor.black,
                        iconDisabledColor: AppColor.black,
                        dropdownColor: AppColor.white,
                        underline: Container(
                          color: AppColor.transparent,
                        ),
                        isDense: true,
                        items: languages
                            .map<DropdownMenuItem<LanguageModel>>(
                              (e) => DropdownMenuItem<LanguageModel>(
                                value: e,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      e.symbol,
                                      style: TextStyle(
                                        fontSize: AppFontSize.size_12_5,
                                      ),
                                    ),
                                    Text(
                                      " " + e.language,
                                      style: TextStyle(
                                        fontSize: AppFontSize.size_12_5,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (LanguageModel? value) {
                          logic.onLanguageChange(value);
                        },
                      ),
                    );
                  }),
            ],
          ),
          _spaceWidget(),
          _dividerWidget(),
          _spaceWidget(),
          _commonTitleText("txtSupportUs".tr),
          _spaceWidget(h: AppSizes.height_3_3),
          _commonFieldText(
            "txtShareWithFriends".tr,
            "",
            Icons.share,
            Constant.boolValueFalse,
            onTap: () {
              _meController.share();
            },
          ),
          _spaceWidget(h: AppSizes.height_3),
          _commonFieldText(
            "txtRateUs".tr,
            "",
            Icons.star,
            Constant.boolValueFalse,
            onTap: () {
              _meController.rateMyApp!.showRateDialog(Get.context!);
            },
          ),
          _spaceWidget(h: AppSizes.height_3),
          _commonFieldText(
            "txtCommonQuestions".tr,
            "ic_bulb.webp",
            null,
            Constant.boolValueTrue,
            onTap: () {
              Get.toNamed(AppRoutes.commonQuestions);
            },
          ),
          _spaceWidget(h: AppSizes.height_3),
          _commonFieldText(
            "txtFeedback".tr,
            "",
            Icons.edit_outlined,
            Constant.boolValueFalse,
            onTap: () {
              Utils().sendFeedback();
            },
          ),
          _spaceWidget(h: AppSizes.height_3),
          _commonFieldText(
            "txtPrivacyPolicy".tr,
            "",
            Icons.visibility_outlined,
            Constant.boolValueFalse,
            onTap: () {
              _meController.loadPrivacyPolicy();
            },
          ),
          _spaceWidget(h: AppSizes.height_3),
          GetBuilder<MeController>(
            id: Constant.idLoginInfo,
            builder: (logic) {
              if (_meController.firebaseAuth.currentUser != null &&
                  _meController.firebaseAuth.currentUser!.photoURL != null) {
                return _commonFieldText(
                  "txtAccountDelete".tr,
                  "",
                  Icons.delete_forever,
                  Constant.boolValueFalse,
                  onTap: () {
                    showDeleteAccountDialog();
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  _commonTitleText(String title) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.width_3),
      child: Text(
        title.toUpperCase(),
        textAlign: TextAlign.left,
        style: TextStyle(
          color: AppColor.primary,
          fontSize: AppFontSize.size_13,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  _backupAndRestoreWidget() {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.height_2),
      padding: EdgeInsets.symmetric(horizontal: AppSizes.width_5),
      child: Row(
        children: [
          GetBuilder<MeController>(
            id: Constant.idLoginInfo,
            builder: (logic) {
              return Expanded(
                child: InkWell(
                  onTap: () {
                    _meController.onSignInButtonClick();
                  },
                  child: Row(
                    children: [
                      if (_meController.firebaseAuth.currentUser != null &&
                          _meController.firebaseAuth.currentUser!.photoURL !=
                              null) ...{
                        Padding(
                          padding: EdgeInsets.only(right: AppSizes.width_4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              color: AppColor.primary,
                              height: AppSizes.height_8,
                              width: AppSizes.height_8,
                              child: Image.network(
                                _meController.firebaseAuth.currentUser!.photoURL
                                    .toString(),
                                errorBuilder:
                                    (buildContext, object, stackTrace) {
                                  return Center(
                                    child: Text(
                                      (_meController.firebaseAuth.currentUser !=
                                                  null &&
                                              _meController
                                                      .firebaseAuth
                                                      .currentUser!
                                                      .displayName !=
                                                  null)
                                          ? _meController.firebaseAuth
                                              .currentUser!.displayName![0]
                                              .toUpperCase()
                                          : "",
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: AppColor.white,
                                        fontSize: AppFontSize.size_25,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      },
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              text: TextSpan(
                                  text:
                                      (_meController.firebaseAuth.currentUser !=
                                                  null &&
                                              _meController
                                                      .firebaseAuth
                                                      .currentUser!
                                                      .displayName !=
                                                  null)
                                          ? _meController.firebaseAuth
                                              .currentUser!.displayName
                                          : "txtBackupAndRestore".tr,
                                  style: TextStyle(
                                    color: AppColor.black,
                                    fontSize: AppFontSize.size_13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  children: [
                                    WidgetSpan(
                                      child: SizedBox(
                                        width: AppSizes.width_1,
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: Image.asset(
                                        Constant.getAssetIcons() +
                                            "ic_google_sync.webp",
                                        height: AppSizes.height_2_5,
                                        width: AppSizes.height_2_5,
                                      ),
                                    )
                                  ]),
                            ),
                            SizedBox(height: AppSizes.height_0_5),
                            Text(
                              (logic.lastSyncDate == "")
                                  ? "txtSignInAndSynchronizeYourData".tr
                                  : "txtLastSync".tr +
                                      ": " +
                                      logic.lastSyncDate!,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: AppColor.txtColor666,
                                fontSize: AppFontSize.size_10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          InkWell(
            onTap: () {
              _meController.onSyncButtonClick();
            },
            child: Icon(
              Icons.sync,
              size: AppSizes.height_3,
              color: AppColor.primary,
            ),
          ),
        ],
      ),
    );
  }

  _commonFieldText(String title, String asset, IconData? icon, bool isAsset,
      {Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: AppSizes.width_5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: AppSizes.height_3,
              width: AppSizes.height_3,
              child: (isAsset)
                  ? Image.asset(
                      Constant.getAssetIcons() + asset,
                      color: AppColor.txtColor999,
                    )
                  : Icon(
                      icon,
                      color: AppColor.txtColor999,
                    ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.width_4),
                child: AutoSizeText(
                  title,
                  // textAlign: TextAlign.left,
                  maxLines: 1,
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: AppFontSize.size_12_5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _dividerWidget() {
    return Container(
      height: AppSizes.height_1_2,
      color: AppColor.grayLight,
      child: null,
    );
  }

  _spaceWidget({double? h}) {
    return SizedBox(
      height: h ?? AppSizes.height_2_5,
    );
  }

  _soundOptionsDialog() {
    return showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "txtSoundOptions".tr,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColor.black,
              fontSize: AppFontSize.size_15,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: const DialogSoundOption(),
          buttonPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          actions: [
            Container(
              margin: EdgeInsets.only(
                  right: AppSizes.width_5, bottom: AppSizes.height_1_5),
              child: TextButton(
                child: Text(
                  "txtOk".tr.toUpperCase(),
                  style: TextStyle(
                    color: AppColor.primary,
                    fontSize: AppFontSize.size_12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  _dialogResetProgress() {
    return showDialog<void>(
      context: Get.context!,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          content: Text(
            "txtAreYouSure".tr,
            style: TextStyle(
              color: AppColor.black,
              fontSize: AppFontSize.size_12,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "txtCancel".tr.toUpperCase(),
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: AppFontSize.size_11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                "txtRestart".tr.toUpperCase(),
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: AppFontSize.size_11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () async {
                await DBHelper.dbHelper
                    .restartProgress()
                    .then((value) => _reportController.refreshData());
                Get.back();
                Get.offAllNamed(AppRoutes.home);
              },
            ),
          ],
        );
      },
    );
  }

  showLogoutDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: AppSizes.width_6),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: AppSizes.height_3, horizontal: AppSizes.width_6),
              child: Text(
                "txtAreYouSureWantToLogout".tr,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: AppFontSize.size_13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  child: Text(
                    "txtCancel".tr.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: AppFontSize.size_11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
                TextButton(
                  child: Text(
                    "txtLogout".tr.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: AppFontSize.size_11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    _meController.signOutFromGoogle();
                  },
                ),
                SizedBox(width: AppSizes.width_3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showDeleteAccountDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: AppSizes.width_6),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: AppSizes.height_3, horizontal: AppSizes.width_6),
              child: Text(
                "txtAreSureWantDeleteYourAccount".tr,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: AppFontSize.size_13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  child: Text(
                    "txtCancel".tr.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: AppFontSize.size_11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
                TextButton(
                  child: Text(
                    "txtDeleteDes".tr.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: AppFontSize.size_11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    _meController.deleteAccountFromGoogle();
                  },
                ),
                SizedBox(width: AppSizes.width_3),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
