import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:women_workout/view/diet/detail_page.dart';

import '../../../models/DietCategoryModel.dart';
import '../../../util/SizeConfig.dart';
import '../../../util/color_category.dart';
import '../../../util/constant_widget.dart';

import '../../../util/constants.dart';
import '../../../util/net_check_cont.dart';
import '../../../util/widgets.dart';

import 'package:get/get.dart';

import '../../models/DayModel.dart';
import '../controller/diet_day_list_cont.dart';


class SubDietCategory extends StatefulWidget {

  final String catId;
  final Dietcategory categoryModel;


  SubDietCategory(this.catId,this.categoryModel);

  @override
  _SubDietCategory createState() => _SubDietCategory();
}

class _SubDietCategory extends State<SubDietCategory> with TickerProviderStateMixin {

  @override
  void initState() {

    super.initState();
    Future.delayed(Duration.zero, () {

      dayListController.loadDietDayList(context,widget.catId);

    });
  }


  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: bgDarkWhite,
          child: Column(
            children: [
              ConstantWidget.getVerSpace(20.h),
              buildAppBar(widget.categoryModel.category!),
              ConstantWidget.getVerSpace(30.h),
              Expanded(
                flex: 1,
                child:getCategoryList(),
              ),
            ],
          ),
        ),
      ),
    ), onWillPop: ()async {

      Get.back();
      return false;
    },);
  }  GetXNetworkManager _networkManager = Get.find<GetXNetworkManager>();





  DietDayListController dayListController = Get.put(DietDayListController());
  double getScreenPercentSize(BuildContext context, double percent) {
    return (MediaQuery.of(context).size.height * percent) / 100;
  }

  getCategoryList() {
    SizeConfig().init(context);
    return   GetBuilder(
      init: GetXNetworkManager(),
      builder: (controller) {
        if(_networkManager.isNetwork.value){
          return GetBuilder(
            init: DietDayListController(),
            builder: (controller) {
              if (!dayListController.isLoading && dayListController.dietDayList != null) {
                DayModel? dayModel = dayListController.dietDayList;
                if (dayModel != null && dayModel.data!.success == 1) {
                  List<Dietcategorydetail> dietCatList =
                      dayModel.data!.dietcategorydetails ?? [];
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: dietCatList.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      Dietcategorydetail dayModel = dietCatList[index];

                      return InkWell(
                        onTap: () {
                          Constants.sendToScreen1(context, DetailPage(dayModel));

                        },
                        // child: Container(
                        //   margin: EdgeInsets.symmetric(
                        //       horizontal: getScreenPercentSize(context, 2),
                        //       vertical: getScreenPercentSize(context, 1)),
                        //   height: height,
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.all(Radius.circular(7)),
                        //     child: Stack(
                        //       children: [
                        //         buildNetworkImage(dayModel.image!,imageWidth: double.infinity,imageHeight: double.infinity,fit: BoxFit.cover),
                        //         // Image.network(
                        //         //   ConstantUrl.uploadUrl + dayModel.image!,
                        //         //   width: double.infinity,
                        //         //   height: double.infinity,
                        //         //   fit: BoxFit.cover,
                        //         // ),
                        //         Positioned(
                        //           bottom: 0.0,
                        //           left: 0.0,
                        //           right: 0.0,
                        //           child: Container(
                        //             decoration: BoxDecoration(
                        //               gradient: LinearGradient(
                        //                 colors: [
                        //                   // List: [
                        //                   Color.fromARGB(200, 0, 0, 0),
                        //                   Color.fromARGB(0, 0, 0, 0)
                        //                 ],
                        //                 begin: Alignment.bottomCenter,
                        //                 end: Alignment.topCenter,
                        //               ),
                        //             ),
                        //             padding: EdgeInsets.symmetric(
                        //                 vertical: 10, horizontal: 10),
                        //             child: Text(
                        //               dayModel.dishesName!,
                        //               // 'No. ${imgList.indexOf(item)} image',
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: height * 0.090,
                        //                 // fontSize: 20.0,
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        child: Container(

                          margin: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 20.h),

                          padding: EdgeInsets.symmetric(
                              vertical: 22.h, horizontal: 20.h),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.h),
                              boxShadow: [
                                BoxShadow(
                                    color: "#0F000000".toColor(),
                                    blurRadius: 28,
                                    offset: Offset(0, 6))
                              ]),

                          child:  getCustomText(  '${index+1}.  ${dayModel.dishesName!}', textColor, 1,
                              TextAlign.start, FontWeight.w500, 18.sp),

                        ),
                      )
                      // Container(
                      //   child: ClipRRect(
                      //       borderRadius: BorderRadius.all(Radius.circular(7)),
                      //       child: Stack(
                      //         children: <Widget>[
                      //           Image.asset(
                      //             ConstantData.assetsPath + list[index].image!,
                      //             width: SizeConfig.safeBlockHorizontal! * 90,
                      //             height: double.infinity,
                      //             fit: BoxFit.cover,
                      //           ),
                      //           // Image.asset("assets/" + item.img,
                      //           //     fit: BoxFit.cover,
                      //           //     width: SizeConfig.safeBlockHorizontal * 90),
                      //           Positioned(
                      //             bottom: 0.0,
                      //             left: 0.0,
                      //             right: 0.0,
                      //             child: Container(
                      //               decoration: BoxDecoration(
                      //                 gradient: LinearGradient(
                      //                   colors: [
                      //                     // List: [
                      //                     Color.fromARGB(200, 0, 0, 0),
                      //                     Color.fromARGB(0, 0, 0, 0)
                      //                   ],
                      //                   begin: Alignment.bottomCenter,
                      //                   end: Alignment.topCenter,
                      //                 ),
                      //               ),
                      //               padding: EdgeInsets.symmetric(
                      //                   vertical: 10.0, horizontal: 20.0),
                      //               child: Text(
                      //                 list[index].name!,
                      //                 style: TextStyle(
                      //                   color: Colors.white,
                      //                   fontSize: sliderHeight * 0.090,
                      //                   // fontSize: 20.0,
                      //                   fontWeight: FontWeight.bold,
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       )),
                      // )
                          ;
                    },
                  );
                } else {
                  return getNoData(context);
                }
              } else {
                return getProgressDialog();
              }
            },);
        }else{
          return getProgressDialog();
        }
      },
    );

  }



  Widget buildAppBar(String title) {
    return ConstantWidget.getPaddingWidget(
      EdgeInsets.symmetric(horizontal: 20.h),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                  child:
                      getSvgImage("arrow_left.svg", width: 24.h, height: 24.h),
                  onTap: () {
                    Get.back();
                  }),
              ConstantWidget.getHorSpace(12.h),
              getCustomText(title, textColor, 1, TextAlign.start,
                  FontWeight.w700, 22.sp)
            ],
          ),
        ],
      ),
    );
  }
}
