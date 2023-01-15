import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:women_lose_weight_flutter/ui/home_detail/controllers/home_diet_controller.dart';
import 'package:women_lose_weight_flutter/ui/report/controllers/report_controller.dart';
import 'package:women_lose_weight_flutter/utils/color.dart';
import 'package:women_lose_weight_flutter/utils/sizer_utils.dart';

import '../../../utils/constant.dart';

class AddDietDetailDialog extends StatefulWidget {
  final DietPlan dietPlan;
  const AddDietDetailDialog({Key? key, required this.dietPlan}) : super(key: key);
  @override
  _WeightHeightDialogState createState() => _WeightHeightDialogState();
}

class _WeightHeightDialogState extends State<AddDietDetailDialog> {
  TextEditingController caloryController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.transparent,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: Wrap(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: AppSizes.width_5),
                padding: const EdgeInsets.only(left: 6, top: 2, right: 6, bottom: 18),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: AppSizes.height_3,
                          bottom: AppSizes.height_1,
                          right: AppSizes.width_5,
                          left: AppSizes.width_5),
                      child: Text(
                        '${"txtAddCaloryValue".tr} (Cal)',
                        style: TextStyle(
                          color: AppColor.black,
                          fontSize: AppFontSize.size_16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GetBuilder<ReportController>(id: Constant.idBMIWeight, builder: (logic) {
                      return Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: AppSizes.width_5),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 12,),
                            Expanded(
                              child: TextFormField(
                                controller: caloryController,
                                maxLines: 1,
                                maxLength: 5,
                                textInputAction: TextInputAction.done,
                                keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,1}')),
                                ],
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontSize: AppFontSize.size_12,
                                  fontWeight: FontWeight.w400,
                                ),
                                cursorColor: AppColor.primary,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(0.0),
                                  hintText: "0.0",
                                  hintStyle: TextStyle(
                                    color: AppColor.black,
                                    fontSize: AppFontSize.size_14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  counterText: "",
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColor.transparent),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: AppColor.primary),
                                  ),
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColor.transparent),
                                  ),
                                ),
                                onEditingComplete: () {
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if(caloryController.text.isNotEmpty){
                                  
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: AppSizes.width_3),
                                height: AppSizes.height_4_3,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColor.primary,
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Text(
                                  "txtSet".tr.toUpperCase(),
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: AppFontSize.size_11,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
