import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/database/helper/db_helper.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/debug.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';
import 'package:women_lose_weight_flutter/utils/utils.dart';

import '../../../common/dialog/multi_selection_days/multiselect_dialog.dart';
import '../../../database/table/reminder_table.dart';
import '../../../utils/constant.dart';

class ReminderController extends GetxController {
  List<MultiSelectDialogItem> daysList = Utils.daysList();

  List selectedDays = [];
  TimeOfDay? selectedTime;

  String? repeatDays = "";
  String? repeatNo = "";

  List<ReminderTable> reminderList = [];

  TextEditingController timeController = TextEditingController();
  TextEditingController repeatController = TextEditingController();
  @override
  void onInit() {
    _getDataFromDatabase();
    super.onInit();
  }

  _getDataFromDatabase() async {
    reminderList = await DBHelper.dbHelper.getReminderData();
    update([Constant.idReminderList]);
  }

  onReminderTimeClick(BuildContext context, int index) async {
    await showTimePickerDialog(context, index: index);
    await DBHelper.dbHelper
        .updateReminderTime(reminderList[index].rid!, timeController.text)
        .then((value) async {
      await _getDataFromDatabase();
    });

    await Utils.setNotificationReminder(reminderList: reminderList);
  }

  onRepeatDaysClick(BuildContext context, int index) async {
    await showDaySelectionDialog(context, index: index);

    await DBHelper.dbHelper
        .updateReminderDays(
            reminderList[index].rid!, repeatController.text, repeatNo!)
        .then((value) async {
      await _getDataFromDatabase();
    });

    await Utils.setNotificationReminder(reminderList: reminderList);
  }

  onChangeReminderOnOrOff(bool value, ReminderTable reminderList) async {
    await DBHelper.dbHelper
        .updateReminderStatus(reminderList.rid!,
            ((value) ? Constant.valueOne : Constant.valueZero))
        .then((value) async {
      await _getDataFromDatabase();
    });

    await Utils.setNotificationReminder(reminderList: this.reminderList);
  }

  showTimePickerDialog(BuildContext context, {int? index}) async {
    if (index != null) {
      var hr = int.parse(reminderList[index].remindTime!.split(":")[0]);
      var min = int.parse(reminderList[index].remindTime!.split(":")[1]);
      selectedTime = TimeOfDay(hour: hr, minute: min);
    }

    final TimeOfDay? picked = await showRoundedTimePicker(
      context: context,
      initialTime: index != null ? selectedTime! : TimeOfDay.now(),
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: AppColor.primary,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColor.primary,
        ),
      ),
    );

    if (picked != null) {
      selectedTime = picked;
      timeController.text =
          "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";
      if (index == null) {
        await showDaySelectionDialog(context);
      }
    }
  }

  showDaySelectionDialog(BuildContext context, {int? index}) async {
    List? selectedValues = await showDialog<List>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          title: Text(
            "txtRepeat".tr,
            style: TextStyle(
              color: AppColor.black,
              fontSize: AppFontSize.size_14,
              fontWeight: FontWeight.w500,
            ),
          ),
          okButtonLabel: "txtOk".tr.toUpperCase(),
          cancelButtonLabel: "txtCancel".tr.toUpperCase(),
          items: daysList,
          initialSelectedValues:
              index != null ? reminderList[index].repeatNo!.split(", ") : [],
          labelStyle: TextStyle(
            color: AppColor.black,
            fontSize: AppFontSize.size_14,
            fontWeight: FontWeight.w400,
          ),
          dialogShapeBorder: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
          ),
          checkBoxActiveColor: AppColor.primary,
          minimumSelection: 1,
        );
      },
    );

    if (selectedValues != null) {
      selectedDays.clear();
      selectedDays = selectedValues;
      repeatController.text = "";
      repeatNo = "";
      selectedDays.sort(
          (a, b) => int.parse(a as String).compareTo(int.parse(b as String)));
      List<String> temp = [];
      for (var element in selectedDays) {
        temp.add(
            daysList[int.parse(element as String) - 1].label!.substring(0, 3));
      }

      repeatController.text = temp.join(", ");
      repeatNo = selectedDays.join(", ");
      Debug.printLog("values ===> $selectedValues ===> $repeatNo");

      if (index == null) {
        await DBHelper.dbHelper
            .insertReminderData(ReminderTable(
          rid: null,
          remindTime: timeController.text,
          days: repeatController.text,
          repeatNo: repeatNo,
          isActive: Constant.valueOne,
        ))
            .then(
          (value) async {
            await _getDataFromDatabase();
            await Utils.setNotificationReminder(reminderList: reminderList);
          },
        );
      }
    } else {
      if (index != null) {
        repeatController.text = reminderList[index].days!;
        repeatNo = reminderList[index].repeatNo!;
      }
    }

    update([Constant.idReminderList]);
  }

  confirmDeleteReminderDialog(ReminderTable reminderList) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) => Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: AppSizes.width_6),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: AppSizes.height_3,
                      horizontal: AppSizes.width_6),
                  child: Text(
                    "txtTip".tr,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppFontSize.size_15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      bottom: AppSizes.height_3,
                      left: AppSizes.width_6,
                      right: AppSizes.width_6),
                  child: Text(
                    "txtDeleteDes".tr + "?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColor.black,
                      fontSize: AppFontSize.size_13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
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
                    "txtOk".tr.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColor.primary,
                      fontSize: AppFontSize.size_11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () async {
                    await DBHelper.dbHelper.deleteReminder(reminderList.rid!);
                    Get.back();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ).then(
      (value) async => await _getDataFromDatabase(),
    );
  }

  getReminderListDays(int index){
    var numList = reminderList[index].repeatNo!.split(", ");
    var strList = [];
    if(numList.contains("1")){
      strList.add("txtMon".tr);
    }
    if(numList.contains("2")){
      strList.add("txtTue".tr);
    }
    if(numList.contains("3")){
      strList.add("txtWed".tr);
    }
    if(numList.contains("4")){
      strList.add("txtThu".tr);
    }
    if(numList.contains("5")){
      strList.add("txtFri".tr);
    }
    if(numList.contains("6")){
      strList.add("txtSat".tr);
    }
    if(numList.contains("7")){
      strList.add("txtSun".tr);
    }

    var str = strList.join(", ");
    return str.toString();
  }
}
