import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/table/reminder_table.dart';
import 'package:women_lose_weight_flutter/google_ads/custom_ad.dart';
import 'package:women_lose_weight_flutter/ui/reminder/controllers/reminder_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';
import 'package:intl/intl.dart';
import '../../../utils/utils.dart';

class ReminderScreen extends StatelessWidget {
  final ReminderController _reminderController = Get.find<ReminderController>();

  ReminderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      child: Column(
        children: [
          Expanded(
            child: Scaffold(
              backgroundColor: AppColor.white,
              body: SafeArea(
                bottom: Constant.boolValueFalse,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _widgetBack(),
                    _reminderList(),
                  ],
                ),
              ),
              floatingActionButton: Container(
                margin: EdgeInsets.only(
                    bottom: AppSizes.height_2, right: AppSizes.width_2),
                child: FloatingActionButton(
                  onPressed: () async {
                    await _reminderController.showTimePickerDialog(context);
                  },
                  backgroundColor: AppColor.floatingButtonColor,
                  child: const Icon(Icons.add, color: AppColor.white),
                ),
              ),
            ),
          ),
          const BannerAdClass(),
        ],
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
              "\t\t\t\t" + "txtReminder".tr,
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

  _reminderList() {
    return Expanded(
      child: GetBuilder<ReminderController>(
        id: Constant.idReminderList,
        builder: (logic) {
          if (logic.reminderList.isNotEmpty) {
            return ListView.builder(
              itemCount: logic.reminderList.length,
              shrinkWrap: Constant.boolValueTrue,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.only(
                  top: AppSizes.height_3_5,
                  bottom: AppSizes.height_12,
                  left: AppSizes.width_3,
                  right: AppSizes.width_3),
              itemBuilder: (BuildContext context, int index) {
                return _itemReminderList(index, logic.reminderList, context);
              },
            );
          } else {
            return _emptyReminderListWidget();
          }
        },
      ),
    );
  }

  _itemReminderList(
      int index, List<ReminderTable> reminderList, BuildContext context) {
    var hr = int.parse(reminderList[index].remindTime!.split(":")[0]);
    var min = int.parse(reminderList[index].remindTime!.split(":")[1]);
    var reminderTime = DateFormat.jm().format(DateTime(DateTime.now().year,
        DateTime.now().month, DateTime.now().day, hr, min));
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.height_1_5),
      padding: EdgeInsets.only(
          top: AppSizes.height_3,
          bottom: AppSizes.height_2_5,
          right: AppSizes.width_4,
          left: AppSizes.width_4),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: kElevationToShadow[1],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    _reminderController.onReminderTimeClick(context, index);
                  },
                  child: Text(
                    reminderTime,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppFontSize.size_15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Container(
                height: AppSizes.height_1,
                width: AppSizes.height_5,
                margin: EdgeInsets.only(right: AppSizes.width_1_2),
                child: Switch(
                  value: reminderList[index].isActive == Constant.valueOne,
                  onChanged: (value) {
                    _reminderController.onChangeReminderOnOrOff(
                        value, reminderList[index]);
                  },
                  activeColor: AppColor.switchActivate,
                  activeTrackColor: AppColor.switchActivateTrack,
                  inactiveThumbColor: AppColor.switchInactive,
                  inactiveTrackColor: AppColor.switchInactiveTrack,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSizes.height_3_5),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    _reminderController.onRepeatDaysClick(Get.context!, index);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "txtRepeat".tr,
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: AppFontSize.size_14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: AppSizes.height_0_5),
                        child: Text(
                          _reminderController.getReminderListDays(index),
                          style: TextStyle(
                            color: AppColor.txtColor999,
                            fontSize: AppFontSize.size_11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: AppSizes.width_1,
              ),
              InkWell(
                onTap: () {
                  _reminderController
                      .confirmDeleteReminderDialog(reminderList[index]);
                },
                child: Container(
                  margin: EdgeInsets.only(right: AppSizes.width_2_5),
                  child: Image.asset(
                    Constant.getAssetIcons() + "ic_delete.webp",
                    color: AppColor.txtColor999,
                    height: AppSizes.height_3_1,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  _emptyReminderListWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.notifications_none_outlined,
          color: AppColor.bellColor,
          size: AppSizes.height_9_5,
        ),
        SizedBox(height: AppSizes.height_1_5),
        Text(
          "txtPleaseSetYourReminder".tr,
          style: TextStyle(
            color: AppColor.txtColor666,
            fontSize: AppFontSize.size_10,
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }
}
