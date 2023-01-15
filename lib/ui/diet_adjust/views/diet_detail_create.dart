import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/ui/diet_adjust/controllers/diet_adjust_detail_controller.dart';
import 'package:women_lose_weight_flutter/ui/home_detail/controllers/home_diet_detail_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/constant.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';
import '../../../utils/utils.dart';
import 'package:image_picker/image_picker.dart';

class DietDetailCreateScreen extends StatefulWidget {
  const DietDetailCreateScreen({Key? key}) : super(key: key);
  @override
  State<DietDetailCreateScreen> createState() => _DietDetailCreateScreenState();
}

class _DietDetailCreateScreenState extends State<DietDetailCreateScreen> {
  final DietAdjustDetailController _dietDetailController =
      Get.find<DietAdjustDetailController>();
  
  final ImagePicker imagePicker = ImagePicker();
  String pickedFilePath = '';

  TextEditingController dietTitleCtrl = TextEditingController();
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  TextEditingController caloryCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgGrayScreen,
      body: SafeArea(
        child: GetBuilder<DietAdjustDetailController>(
          id: Constant.idDietDetailAdjustCreate,
          builder: (controller) {
            return Stack(
              children: [
                Column(
                  children: [
                    _widgetTopBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          vertical: AppSizes.height_2,
                          horizontal: AppSizes.width_2,
                        ),
                        child: Column(
                          children: [
                            _textDietPlan(),
                            _dietWidgetsFields(),
                            SizedBox(
                              width: AppSizes.fullWidth,
                              height: 24,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if(controller.isLoading)
                  SizedBox(
                    width: AppSizes.fullWidth,
                    height: AppSizes.fullHeight,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
              ],
            );
          }
        ),
      ),
    );
  }

  _widgetBack() {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Utils.backWidget(iconColor: AppColor.black),
    );
  }

  _widgetTopBar() {
    return Padding(
      padding: EdgeInsets.only(left: AppSizes.width_3, bottom: 4.0, top: AppSizes.height_2_5),
      child: Row(
        children: [
          _widgetBack(),
          Padding(
            padding: EdgeInsets.only(left: AppSizes.width_5),
            child: AutoSizeText(
              "txtCreate".tr,
              maxLines: 1,
              style: TextStyle(
                color: AppColor.black,
                fontSize: AppFontSize.size_16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            width: AppSizes.width_1,
          ),
        ],
      ),
    );
  }

  _textDietPlan() {
    return Container(
      margin: const EdgeInsets.only(left: 12, top: 8.0),
      width: AppSizes.fullWidth,
      child: AutoSizeText(
        _dietDetailController.planItem!.dietTitle,
        textAlign: TextAlign.left,
        maxLines: 1,
        style: TextStyle(
          color: AppColor.black,
          fontSize: AppFontSize.size_14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  _dietWidgetsFields() {
    return Container(
      margin: EdgeInsets.only(
          left: AppSizes.width_2,
          right: AppSizes.width_2,
          top: AppSizes.height_3,
          bottom: AppSizes.height_2),
      padding: EdgeInsets.symmetric(
          vertical: AppSizes.height_3, horizontal: AppSizes.width_5),
      child: Column(
        children: [
          _textFieldWidget(titleCtrl, "Title".tr, 1),
          SizedBox(height: AppSizes.height_2),
          _textFieldWidget(descCtrl, "Description".tr, 5),
          SizedBox(height: AppSizes.height_2),
          _numberFieldWidget(caloryCtrl, "Calories".tr),
          SizedBox(height: AppSizes.height_2),
          _imageArea(),
          SizedBox(height: AppSizes.height_10),
          _createDietDetailBtn(),
        ],
      ),
    );
  }

  _textFieldWidget(TextEditingController ctrl, String title, int lines) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: TextFormField(
        controller: ctrl,
        maxLines: lines,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: TextStyle(
          color: AppColor.black,
          fontSize: AppFontSize.size_12,
          fontWeight: FontWeight.w500,
        ),
        cursorColor: AppColor.primary,
        decoration: InputDecoration(
          labelText: title,
          hintText: title,
          hintStyle: TextStyle(
            color: AppColor.txtColor999,
            fontSize: AppFontSize.size_12,
            fontWeight: FontWeight.w500,
          ),
          filled: Constant.boolValueTrue,
          fillColor: AppColor.white,
          counterText: "",
          border: InputBorder.none,
        ),
        onEditingComplete: () {
          FocusScope.of(Get.context!).unfocus();
        },
      ),
    );
  }

  _numberFieldWidget(TextEditingController ctrl, String title) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: TextFormField(
        controller: ctrl,
        maxLines: 1,
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        style: TextStyle(
          color: AppColor.black,
          fontSize: AppFontSize.size_12,
          fontWeight: FontWeight.w500,
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(
              RegExp(r'^(\d+)?\.?\d{0,1}')),
        ],
        cursorColor: AppColor.primary,
        decoration: InputDecoration(
          labelText: title,
          hintText: title,
          hintStyle: TextStyle(
            color: AppColor.txtColor999,
            fontSize: AppFontSize.size_12,
            fontWeight: FontWeight.w500,
          ),
          filled: Constant.boolValueTrue,
          fillColor: AppColor.white,
          counterText: "",
          border: InputBorder.none,
        ),
        onEditingComplete: () {
          FocusScope.of(Get.context!).unfocus();
        },
      ),
    );
  }

  _imageArea() {
    return InkWell(
      onTap: () {
        _getFromGallery();
      },
      child: SizedBox(
        width: AppSizes.fullWidth,
        height: 140,
        child: Stack(
          children: [
            Container(
              width: AppSizes.fullWidth,
              height: 140,
              child: Center(
                child: Text(
                  "Click here to pick image".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.txtColor999,
                    fontSize: AppFontSize.size_13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.all(Radius.circular(6))
              ),
            ),
            if(pickedFilePath.isNotEmpty)
              SizedBox(
                width: AppSizes.fullWidth,
                height: 140,
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(6),
                  child: Image.file(
                    File(pickedFilePath),
                    width: AppSizes.fullWidth,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
  
  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        pickedFilePath = pickedFile.path;  
        if (kDebugMode) {
          print('filepath: $pickedFilePath');
        }
      });
    }
}

  _createDietDetailBtn() {
    return InkWell(
      onTap: () {
        _createNewDietDetail();
      },
      child: Container(
        width: AppSizes.fullWidth,
        height: 48,
        padding: EdgeInsets.only(left: AppSizes.width_6),
        child: Center(
          child: Text(
            "txtCreate".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.white,
              fontSize: AppFontSize.size_15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        decoration: const BoxDecoration(
          color: AppColor.txtColorGreen,
          borderRadius: BorderRadius.all(Radius.circular(6))
        ),
      ),
    );
  }

  _createNewDietDetail() async {
    if(titleCtrl.text.isNotEmpty){
      if(descCtrl.text.isNotEmpty){
        if(caloryCtrl.text.isNotEmpty){
          if(pickedFilePath.isNotEmpty){
            DietDetail detail = DietDetail();
            detail.detailTitle = titleCtrl.text;
            detail.detailDesc = descCtrl.text;
            detail.calories = caloryCtrl.text;
            var imageUrl = await _dietDetailController.uploadImage(pickedFilePath, 'diets');
            if (imageUrl != null) {
              detail.detailImage = imageUrl;
              _dietDetailController.createDietDetail(detail);
            } else {
              
            }
          }
        }
      }
    }  
  }
}
