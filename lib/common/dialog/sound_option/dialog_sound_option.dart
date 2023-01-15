import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/ui/me/controllers/me_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

class DialogSoundOption extends StatefulWidget {
  const DialogSoundOption({Key? key}) : super(key: key);

  @override
  _DialogSoundOptionState createState() => _DialogSoundOptionState();
}

class _DialogSoundOptionState extends State<DialogSoundOption> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.fullWidth,
      margin: EdgeInsets.only(
          top: AppSizes.height_1_8,
          bottom: AppSizes.height_1,
          left: AppSizes.width_5,
          right: AppSizes.width_5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                height: AppSizes.height_3_3,
                width: AppSizes.height_3_3,
                child: const Icon(
                  Icons.volume_up,
                  color: AppColor.txtColor666,
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppSizes.width_5),
                  child: Text(
                    "txtMute".tr,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppFontSize.size_13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              GetBuilder<MeController>(
                id: Constant.idSoundOptionMute,
                builder: (logic) {
                  return Switch(
                    value: logic.isMute,
                    onChanged: logic.onChangeValueOfMute,
                    activeColor: AppColor.switchActivate,
                    activeTrackColor: AppColor.switchActivateTrack,
                    inactiveThumbColor: AppColor.switchInactive,
                    inactiveTrackColor: AppColor.switchInactiveTrack,
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.height_0_8,
          ),
          Row(
            children: [
              SizedBox(
                height: AppSizes.height_3_3,
                width: AppSizes.height_3_3,
                child: const Icon(
                  Icons.record_voice_over_outlined,
                  color: AppColor.txtColor666,
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppSizes.width_5),
                  child: Text(
                    "txtVoiceGuide".tr,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppFontSize.size_13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              GetBuilder<MeController>(
                id: Constant.idSoundOptionVoiceGuide,
                builder: (logic) {
                  return Switch(
                    value: logic.isVoiceGuide,
                    onChanged: logic.onChangeValueOfVoiceGuide,
                    activeColor: AppColor.switchActivate,
                    activeTrackColor: AppColor.switchActivateTrack,
                    inactiveThumbColor: AppColor.switchInactive,
                    inactiveTrackColor: AppColor.switchInactiveTrack,
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: AppSizes.height_0_8,
          ),
          Row(
            children: [
              SizedBox(
                height: AppSizes.height_3_3,
                width: AppSizes.height_3_3,
                child: const Icon(
                  Icons.record_voice_over,
                  color: AppColor.txtColor666,
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: AppSizes.width_5),
                  child: Text(
                    "txtCoachTips".tr,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppFontSize.size_13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              GetBuilder<MeController>(
                id: Constant.idSoundOptionCoachTips,
                builder: (logic) {
                  return Switch(
                    value: logic.isCoachTips,
                    onChanged: logic.onChangeValueOfCoachTips,
                    activeColor: AppColor.switchActivate,
                    activeTrackColor: AppColor.switchActivateTrack,
                    inactiveThumbColor: AppColor.switchInactive,
                    inactiveTrackColor: AppColor.switchInactiveTrack,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
