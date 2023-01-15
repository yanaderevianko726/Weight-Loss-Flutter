import 'package:flutter/material.dart';
import 'package:women_lose_weight_flutter/ui/reminder/controllers/reminder_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/utils.dart';
import 'package:get/get.dart';

class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String? label;
}

class MultiSelectDialog<V> extends StatefulWidget {
  final List<MultiSelectDialogItem<V>>? items;
  final List<V>? initialSelectedValues;
  final Widget? title;
  final String? okButtonLabel;
  final String? cancelButtonLabel;
  final TextStyle labelStyle;
  final ShapeBorder? dialogShapeBorder;
  final Color? checkBoxCheckColor;
  final Color? checkBoxActiveColor;
  final int minimumSelection;

  const MultiSelectDialog({
    Key? key,
    this.items,
    this.initialSelectedValues,
    this.title,
    this.okButtonLabel,
    this.cancelButtonLabel,
    this.labelStyle = const TextStyle(),
    this.dialogShapeBorder,
    this.checkBoxActiveColor,
    this.checkBoxCheckColor,
    this.minimumSelection = 1,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final ReminderController _reminderController = Get.find<ReminderController>();
  final _selectedValues = <V>[];
  bool? isDisable;

  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues!);
    }
    isDisable = _selectedValues.isEmpty;
  }

  void _onItemCheckedChange(V itemValue, bool? checked) {
    if (checked!) {
      _selectedValues.add(itemValue);
    } else {
      _selectedValues.remove(itemValue);
    }
    isDisable = (_selectedValues.length < widget.minimumSelection);
    _reminderController.update([Constant.idReminderDayCheck]);
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    if (!isDisable!) {
      Navigator.pop(context, _selectedValues);
    } else {
      Utils.showToast(context, "txtSelectDayToast".tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReminderController>(id: Constant.idReminderDayCheck, builder: (logic) {
      return AlertDialog(
        title: widget.title,
        shape: widget.dialogShapeBorder,
        contentPadding: const EdgeInsets.only(top: 12.0),
        content: SingleChildScrollView(
          child: ListTileTheme(
            contentPadding: const EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
            child: ListBody(
              children: widget.items!.map(_buildItem).toList(),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              widget.cancelButtonLabel!,
              style: const TextStyle(color: AppColor.primary),
            ),
            onPressed: _onCancelTap,
          ),
          TextButton(
            child: Text(
              widget.okButtonLabel!,
              style: TextStyle(
                  color: isDisable!
                      ? AppColor.primary.withOpacity(0.5)
                      : AppColor.primary),
            ),
            onPressed: _onSubmitTap,
          )
        ],
      );
    });
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);

          return CheckboxListTile(
            value: checked,
            checkColor: widget.checkBoxCheckColor,
            activeColor: widget.checkBoxActiveColor,
            title: Text(
              item.label!,
              style: widget.labelStyle,
            ),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (checked) =>
                _onItemCheckedChange(item.value, checked),
          );
  }
}
