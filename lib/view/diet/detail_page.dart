
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/DayModel.dart';
import '../../util/color_category.dart';
import '../../util/constant_widget.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../util/constants.dart';


class DetailPage extends StatefulWidget {


  final Dietcategorydetail? dayModel;

  DetailPage(this.dayModel);

  @override
  _DetailPage createState() {
    return _DetailPage();
  }
}

class _DetailPage extends State<DetailPage> {
  void onBackClick() {
    Get.back();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double margin = getScreenPercentSize(context, 1.5);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: Container(
            color: Colors.grey.shade100,
            child: Column(
              children: [


                AppBar(
                  title: getPrimaryAppBarText(
                      context, ''),
                  // backgroundColor: primaryColor,
                  backgroundColor: Colors.transparent,
                  centerTitle: false,
                  elevation: 0,
                  leading: Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: getPrimaryAppBarIcon(),
                        onPressed: onBackClick,
                      );
                    },
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: ListView(
                    children: [


                      Container(
                        margin: EdgeInsets.symmetric(horizontal: margin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: getTitle(widget.dayModel!.dishesName!),
                              margin: EdgeInsets.symmetric(horizontal: margin),
                            ),
                            Html(

                              data:   Constants.decode(widget.dayModel!.description!),

                              // data:ConstantUrl.parseHtmlString(widget.dayModel!.description!.trim()) ,
                              // data:ConstantUrl.parseHtmlString(widget.dayModel!.description!.trim()) ,

                            ),

                            // getList(ingredientsList),
                          ],
                        ),
                      ),



                      SizedBox(
                        height: margin,
                      )

                      // Stack(
                      //   children: [
                      //
                      //     Column(
                      //       children: [
                      //
                      //         Container(
                      //           height: height,
                      //           decoration: BoxDecoration(
                      //             color: bgDarkWhite,
                      //
                      //           ),
                      //           child: Stack(
                      //             children: [
                      //               buildNetworkImage(widget.dayModel!.image!,imageWidth: double.infinity,imageHeight: double.infinity,fit: BoxFit.cover),
                      //
                      //               AppBar(
                      //                 title: getPrimaryAppBarText(
                      //                     context, ''),
                      //                 // backgroundColor: primaryColor,
                      //                 backgroundColor: Colors.transparent,
                      //                 centerTitle: false,
                      //                 elevation: 0,
                      //                 leading: Builder(
                      //                   builder: (BuildContext context) {
                      //                     return IconButton(
                      //                       icon: getPrimaryAppBarIcon(),
                      //                       onPressed: onBackClick,
                      //                     );
                      //                   },
                      //                 ),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     Container(
                      //       margin: EdgeInsets.only(top: getPercentSize(height, 88)),
                      //       decoration: BoxDecoration(
                      //           color: Colors.grey.shade100,
                      //           borderRadius: BorderRadius.only(
                      //               topLeft: Radius.circular(
                      //                   getScreenPercentSize(context, 4)),
                      //               topRight: Radius.circular(
                      //                   getScreenPercentSize(context, 4)))),
                      //       child: Column(
                      //         children: [
                      //           SizedBox(
                      //             height: viewHeight / 2,
                      //           ),
                      //           Container(
                      //             margin: EdgeInsets.all(margin),
                      //             child: Column(
                      //               crossAxisAlignment: CrossAxisAlignment.start,
                      //               children: [
                      //                 getTitle(widget.dayModel!.dishesName!),
                      //                 Html(
                      //
                      //                data:   Constants.decode(widget.dayModel!.description!),
                      //
                      //                   // data:ConstantUrl.parseHtmlString(widget.dayModel!.description!.trim()) ,
                      //                   // data:ConstantUrl.parseHtmlString(widget.dayModel!.description!.trim()) ,
                      //
                      //                 ),
                      //
                      //                 // getList(ingredientsList),
                      //               ],
                      //             ),
                      //           ),
                      //
                      //           // Container(
                      //           //   margin: EdgeInsets.all(margin),
                      //           //
                      //           //
                      //           //
                      //           //   child: Column(
                      //           //     crossAxisAlignment: CrossAxisAlignment.start,
                      //           //     children: [
                      //           //
                      //           //       getTitle("Steps"),
                      //           //
                      //           //       getRobotoTextWidget(
                      //           //           "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.",
                      //           //           subTextColor,
                      //           //           TextAlign.start,
                      //           //           FontWeight.w500,
                      //           //           getScreenPercentSize(context, 1.8))
                      //           //
                      //           //       // getTextWidget(
                      //           //       //     "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.",
                      //           //       //     subTextColor,
                      //           //       //     TextAlign.start,
                      //           //       //     FontWeight.w400,
                      //           //       //     getScreenPercentSize(context, 1.8)),
                      //           //     ],
                      //           //   ),
                      //           // ),
                      //           //
                      //           //
                      //
                      //           SizedBox(
                      //             height: margin,
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //     // Container(
                      //     //   height: viewHeight,
                      //     //
                      //     //   // decoration: BoxDecoration(
                      //     //   //   color: cellColor,
                      //     //   //   // color: "#E9F3EA".toColor(),
                      //     //   //
                      //     //   // ),
                      //     //   margin: EdgeInsets.only(
                      //     //       top: getPercentSize(height, 70),
                      //     //       right: horizontalMargin,
                      //     //       left: horizontalMargin),
                      //     //
                      //     //   child: Card(
                      //     //     color: cellColor,
                      //     //     shape: RoundedRectangleBorder(
                      //     //         borderRadius: BorderRadius.all(Radius.circular(
                      //     //             getPercentSize(viewHeight, 8)))),
                      //     //     child: Container(
                      //     //       padding: EdgeInsets.symmetric(
                      //     //           horizontal: getPercentSize(viewHeight, 5),
                      //     //           vertical: getPercentSize(viewHeight, 3)),
                      //     //       child: Row(
                      //     //         mainAxisAlignment: MainAxisAlignment.center,
                      //     //         crossAxisAlignment: CrossAxisAlignment.center,
                      //     //         children: [
                      //     //           // getCell(viewHeight, primaryColor, "Protein",
                      //     //           //     widget.dayModel!.protein ?? ""),
                      //     //           // Container(
                      //     //           //   height: getPercentSize(viewHeight, 35),
                      //     //           //   color: textColor,
                      //     //           //   width: 1,
                      //     //           // ),
                      //     //           // getCell(viewHeight, Colors.red, "Fat",
                      //     //           //     widget.dayModel!.fat ?? ""),
                      //     //           // Container(
                      //     //           //   height: getPercentSize(viewHeight, 35),
                      //     //           //   color: textColor,
                      //     //           //   width: 1,
                      //     //           // ),
                      //     //           // getCell(viewHeight, Colors.orange, "Carbs",
                      //     //           //     widget.dayModel!.carbs ?? ""),
                      //     //         ],
                      //     //       ),
                      //     //     ),
                      //     //   ),
                      //     // )
                      //   ],
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ),
          // body: SafeArea(
          //   child: Container(
          //     color: cellColor,
          //     child: Stack(
          //       children: [
          //         Stack(
          //           children: [
          //             Container(
          //               height: height,
          //               width: double.infinity,
          //               decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   image: DecorationImage(
          //                     image: NetworkImage(
          //                       ConstantUrl.uploadUrl + widget.dayModel!.image!,
          //                     ),
          //                     fit: BoxFit.fitWidth,
          //                   )),
          //             ),
          //             Container(
          //               margin: EdgeInsets.only(
          //                 left: getWidthPercentSize(context, 5),
          //                 top: getWidthPercentSize(context, 2),
          //               ),
          //               child: InkWell(
          //                 child: Image.asset(
          //                   ConstantData.assetsPath + "back_btn.png",
          //                   color: Colors.white,
          //                   height: getPercentSize(height, 12),
          //                 ),
          //                 onTap: () {
          //                   print("click--12true");
          //                   onBackClick();
          //                 },
          //               ),
          //             )
          //           ],
          //         ),
          //
          //         Container(
          //           margin: EdgeInsets.only(top: getPercentSize(height, 88)),
          //           padding: EdgeInsets.all(getScreenPercentSize(context, 1.6)),
          //           decoration: BoxDecoration(
          //               color:cellColor,
          //               borderRadius: BorderRadius.only(
          //                   topLeft: Radius.circular(
          //                       getScreenPercentSize(context, 4)),
          //                   topRight: Radius.circular(
          //                       getScreenPercentSize(context, 4)))),
          //           child: ListView(
          //             padding:
          //                 EdgeInsets.only(top: getPercentSize(viewHeight, 10)),
          //             children: [
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   getCell(viewHeight, Colors.green, "Protein",
          //                       widget.dayModel!.protein!),
          //                   Container(
          //                     height: getScreenPercentSize(context, 2.5),
          //                     width: 1,
          //                     color: primaryColor,
          //                   ),
          //                   getCell(viewHeight, Colors.red, "Fat",
          //                       widget.dayModel!.fat!),
          //                   Container(
          //                       height: getScreenPercentSize(context, 2.5),
          //                       width: 1,
          //                       color: primaryColor),
          //                   getCell(viewHeight, Colors.orange, "Carbs",
          //                       widget.dayModel!.carbs!),
          //                 ],
          //               ),
          //               SizedBox(
          //                 height: margin,
          //               ),
          //               Html(
          //                   data: "<div style='color: ${ConstantData.fontColors};'>" +
          //                       ConstantUrl.parseHtmlString(
          //                           widget.dayModel!.description!.trim())
          //                   // ConstantUrl.parseHtmlString(
          //                   //     widget.dayModel!.description!.trim()),
          //                   ),
          //             ],
          //           ),
          //         ),
          //
          //         // Container(
          //         //
          //         //   margin:
          //         //       EdgeInsets.only(top: ConstantWidget.getPercentSize(height, 88)),
          //         //   decoration: BoxDecoration(
          //         //       color: Colors.white,
          //         //       borderRadius: BorderRadius.only(
          //         //           topLeft: Radius.circular(
          //         //               getScreenPercentSize(context, 4)),
          //         //           topRight: Radius.circular(getScreenPercentSize(context, 4)))),
          //         //
          //         //
          //         //   child: Container(
          //         //     margin: EdgeInsets.all(margin),
          //         //     child: Html(
          //         //       data: ConstantUrl.parseHtmlString(widget.dayModel!.description!),
          //         //     ),
          //         //   ),
          //         //   // child: WebView(
          //         //   //   initialUrl: 'https://flutter.dev',
          //         //   // ),
          //         // )
          //       ],
          //     ),
          //   ),
          // ),
        ),
        onWillPop: () async {
          onBackClick();
          return false;
        });
  }
  getTitle(String s) {
    double margin = getScreenPercentSize(context, 1.5);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: margin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: getScreenPercentSize(context, 0.5)),
            child: Text(
              s,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: getScreenPercentSize(context, 2.5),
                  color: textColor,
                  fontFamily: Constants.fontsFamily,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            height: getScreenPercentSize(context, 0.5),
            width: getWidthPercentSize(context, 10),
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(
                    Radius.circular(getScreenPercentSize(context, 0.5)))),
          )
        ],
      ),
    );
  }



  getCell(double height, Color color, String s, String s1) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.circle,
                color: color,
                size: getPercentSize(height, 10),
              ),
              SizedBox(
                width: getWidthPercentSize(context, 1),
              ),
              getTextWidget(s, subTextColor, TextAlign.start,
                  FontWeight.w600, getPercentSize(height, 14)),
            ],
          ),
          SizedBox(
            height: getScreenPercentSize(context, 0.5),
          ),
          getTextWidget(s1, textColor, TextAlign.center, FontWeight.bold,
              getPercentSize(height, 16)),
        ],
      ),
      flex: 1,
    );
  }


  // image lib uses uses KML color format, convert #AABBGGRR to regular #AARRGGBB
  int abgrToArgb(int argbColor) {
    print("abgrToArgb");
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

}
