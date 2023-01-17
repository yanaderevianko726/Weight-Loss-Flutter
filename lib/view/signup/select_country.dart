import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/data_file.dart';
import '../../models/model_country.dart';
import '../../util/color_category.dart';
import '../../util/constant_widget.dart';

import 'package:get/get.dart';

import '../controller/controller.dart';

class SelectCountry extends StatefulWidget {
  const SelectCountry({Key? key}) : super(key: key);

  @override
  State<SelectCountry> createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  Future<void> _requestPop() async {
    Get.back();
  }

  TextEditingController searchController = TextEditingController();
  List<ModelCountry> newCountryList = List.from(DataFile.countryList);

  onItemChanged(String value) {
    setState(() {
      newCountryList = DataFile.countryList
          .where((string) =>
              string.name!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  SignUpController controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                ConstantWidget.getVerSpace(26.h),
                ConstantWidget.getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 20.h),
                  gettoolbarMenu(context, "arrow_left.svg", () {
                    _requestPop();
                  },
                      istext: true,
                      title: "Select Country",
                      weight: FontWeight.w700,
                      fontsize: 24,
                      textColor: Colors.black),
                ),
                ConstantWidget.getVerSpace(18.h),
                ConstantWidget.getPaddingWidget(
                  EdgeInsets.symmetric(horizontal: 20.h),
                  getSearchWidget(
                      context, searchController, () {}, onItemChanged,
                      withPrefix: true),
                ),
                ConstantWidget.getVerSpace(32.h),
                Expanded(
                  flex: 1,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.h),
                    scrollDirection: Axis.vertical,
                    itemCount: newCountryList.length,
                    itemBuilder: (context, index) {
                      ModelCountry modelCountry = newCountryList[index];
                      return GestureDetector(
                        onTap: () {
                          controller.getImage(modelCountry.image ?? "");
                          _requestPop();
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20.h),
                          height: 60.h,
                          padding: EdgeInsets.symmetric(horizontal: 16.h),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: "#33ACB6B5".toColor(),
                                    blurRadius: 32,
                                    offset: const Offset(-2, 5)),
                              ],
                              borderRadius: BorderRadius.circular(22.h)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  getAssetImage(modelCountry.image ?? '',
                                      height: 28.h, width: 40.h),
                                  ConstantWidget.getHorSpace(12.h),
                                  ConstantWidget.getTextWidget(
                                      modelCountry.name ?? "",
                                      textColor,
                                      TextAlign.start,
                                      FontWeight.w500,
                                      15.sp)
                                ],
                              ),
                              Row(
                                children: [
                                  ConstantWidget.getTextWidget(
                                      modelCountry.code ?? "",
                                      textColor,
                                      TextAlign.start,
                                      FontWeight.w500,
                                      15.sp)
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        onWillPop: () async {
          _requestPop();
          return false;
        });
  }
}
