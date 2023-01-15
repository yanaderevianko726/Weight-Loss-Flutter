import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/google_ads/custom_ad.dart';
import 'package:women_lose_weight_flutter/ui/voice_options/controllers/voice_options_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

import '../../../utils/utils.dart';

class VoiceOptionsScreen extends StatelessWidget {
  VoiceOptionsScreen({Key? key}) : super(key: key);

  final VoiceOptionsController _voiceOptionsController =
      Get.find<VoiceOptionsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SafeArea(
        bottom: Constant.boolValueFalse,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _widgetBack(),
                    _spaceWidget(h: AppSizes.height_4_5),
                    _commonFieldText(
                      "txtTestVoice".tr,
                      "",
                      Icons.surround_sound_outlined,
                      Constant.boolValueFalse,
                      onTap: () async {
                        _voiceOptionsController.testVoice().then((value) =>
                            _hearTestVoiceDialog("txtGoogleSpeechServices".tr));
                      },
                    ),
                    _spaceWidget(h: AppSizes.height_3),
                    _commonFieldText(
                        "txtSelectTTSEngine".tr,
                        "",
                        Icons.navigation_outlined,
                        Constant.boolValueFalse, onTap: () async {
                      await _selectTTSEngineDialog(
                          "txtGoogleSpeechServices".tr);
                    }),
                    _spaceWidget(h: AppSizes.height_3),
                    _commonFieldText(
                        "txtDownloadTTSEngine".tr,
                        "icon_download.webp",
                        null,
                        Constant.boolValueTrue, onTap: () {
                      _voiceOptionsController.downLoadTTS();
                    }),
                    _spaceWidget(h: AppSizes.height_3),
                    _commonFieldText(
                        "txtDeviceTTSSetting".tr,
                        "",
                        Icons.tune_outlined,
                        Constant.boolValueFalse, onTap: () {
                      _voiceOptionsController.openTtsSetting();
                    }),
                  ],
                ),
              ),
            ),
            const BannerAdClass(),
          ],
        ),
      ),
    );
  }

  _widgetBack() {
    return Container(
      width: AppSizes.fullWidth,
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
          left: AppSizes.width_5,
          right: AppSizes.width_5,
          top: AppSizes.height_2),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Utils.backWidget(iconColor: AppColor.black),
          ),
          Expanded(
            child: Text(
              "\t\t\t\t" + "txtVoiceOptionsTTS".tr,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColor.black,
                fontSize: AppFontSize.size_15,
                fontWeight: FontWeight.w600,
              ),
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
                      color: AppColor.txtColor666,
                    )
                  : Icon(
                      icon,
                      color: AppColor.txtColor666,
                    ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.width_5),
              child: Text(
                title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: AppFontSize.size_14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _spaceWidget({double? h}) {
    return SizedBox(
      height: h ?? AppSizes.height_2_5,
    );
  }

  Future<void> _hearTestVoiceDialog(String selectedEngine) {
    return showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          content: Text(
            "txtHearTestVoice".tr,
            style: TextStyle(
              color: AppColor.black,
              fontSize: AppFontSize.size_12_5,
              fontWeight: FontWeight.w400,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "txtNo".tr.toUpperCase(),
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: AppFontSize.size_11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () async {
                Get.back();
                await _noTestVoiceDialog(selectedEngine);
              },
            ),
            TextButton(
              child: Text(
                "txtYes".tr.toUpperCase(),
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
          ],
        );
      },
    );
  }

  Future<void> _noTestVoiceDialog(String? selectedEngine) {
    return showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          content: Wrap(
            children: [
              Text(
                "txtUnableToHearVoiceDesc".tr,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: AppFontSize.size_11,
                  fontWeight: FontWeight.w400,
                ),
              ),
              InkWell(
                onTap: () {
                  _voiceOptionsController.downLoadTTS();
                  Get.back();
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: AppSizes.height_3),
                  child: Text(
                    "txtDownloadTTSEngine".tr,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppFontSize.size_12_5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  Get.back();
                  await _selectTTSEngineDialog(selectedEngine!);
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: AppSizes.height_0_5),
                  child: Text(
                    "txtSelectTTSEngine".tr,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppFontSize.size_12_5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectTTSEngineDialog(String? selectedEngine) {
    return showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "txtChooseVoice".tr,
            style: TextStyle(
              color: AppColor.black,
              fontSize: AppFontSize.size_12_5,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Row(
            children: [
              GetBuilder<VoiceOptionsController>(
                id: Constant.idRadioGoogleTTSEngine,
                builder: (logic) {
                  return Container(
                    height: AppSizes.height_2,
                    width: AppSizes.height_2,
                    margin: EdgeInsets.only(right: AppSizes.width_5),
                    child: Radio<String>(
                      activeColor: AppColor.primary,
                      value: "",
                      groupValue: selectedEngine!,
                      onChanged: (value) {
                        Get.back();
                      },
                    ),
                  );
                },
              ),
              Expanded(
                child: Text(
                  "txtGoogleTextToSpeech".tr,
                  style: TextStyle(
                    color: AppColor.black,
                    fontSize: AppFontSize.size_12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
