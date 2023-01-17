import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import 'color_category.dart';
import 'constant_url.dart';
import 'constant_widget.dart';
import 'constants.dart';

double smallTextSize = 17;
double extraSmallTextSize = 15;
double mediumTextSize = 21;
double largeTextSize = 40;

Widget getSmallBoldTextWithMaxLine(String text, Color color, int maxLine) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: smallTextSize,
        color: color,
        fontFamily: Constants.fontsFamily,
        fontWeight: FontWeight.bold),
    maxLines: maxLine,
    textAlign: TextAlign.center,
  );
}

void showCustomToast(String texts, BuildContext context) {
  ConstantUrl.showToast(texts,context);
}

Widget getSmallNormalTextWithMaxLine(String text, Color color, int maxLine,{double? font}) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: font ==null?smallTextSize:font,
        color: color,
        fontFamily: Constants.fontsFamily,
        fontWeight: FontWeight.normal),
    maxLines: maxLine,
    textAlign: TextAlign.start,
  );
}

Widget getExtraSmallNormalTextWithMaxLine(
    String text, Color color, int maxLine, TextAlign textAlign) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: extraSmallTextSize,
        color: color,
        fontFamily: Constants.fontsFamily,
        fontWeight: FontWeight.normal),
    maxLines: maxLine,
    textAlign: textAlign,
  );
}

Widget getCustomText(String text, Color color, int maxLine, TextAlign textAlign,
    FontWeight fontWeight, double textSizes) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: textSizes,
        color: color,
        fontFamily: Constants.fontsFamily,
        fontWeight: fontWeight),
    maxLines: maxLine,
    textAlign: textAlign,
  );
}

Widget getMediumBoldTextWithMaxLine(String text, Color color, int maxLine) {
  return Text(
    text,
    style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: mediumTextSize,
        color: color,
        fontFamily: Constants.fontsFamily,
        fontWeight: FontWeight.bold),
    maxLines: maxLine,
    textAlign: TextAlign.center,
    overflow: TextOverflow.ellipsis,
  );
}

Widget getMediumTextWithWeight(
    String text, Color color, int maxLine, FontWeight fontWeight) {
  return Text(
    text,
    style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: mediumTextSize,
        color: color,
        fontFamily: Constants.fontsFamily,
        fontWeight: fontWeight),
    maxLines: maxLine,
    textAlign: TextAlign.center,
    overflow: TextOverflow.ellipsis,
  );
}

Widget getSettingTabTitle(BuildContext context, String text) {
  return Text(
    text,
    style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: ConstantWidget.getScreenPercentSize(context, 1.8),
        color: subTextColor,
        fontFamily: Constants.fontsFamily,
        fontWeight: FontWeight.w600),
    maxLines: 1,
    textAlign: TextAlign.start,
    overflow: TextOverflow.ellipsis,
  );
}

Widget getSettingSingleLineText(
    BuildContext context, String icon, String string,
    {String? content,bool? isSubContent}) {
  double size = ConstantWidget.getScreenPercentSize(context, 5.5);
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        height: size,
        width: size,
        decoration: getDefaultDecoration(
            bgColor: cellColor,
            radius: ConstantWidget.getPercentSize(size, 25)),
        child: Center(
          child: SvgPicture.asset(
            Constants.assetsImagePath + icon,
            height: ConstantWidget.getPercentSize(size, 50),
            color: textColor,
          ),
        ),
      ),

      SizedBox(
        width: ConstantWidget.getWidthPercentSize(context, 2),
      ),

      // Icon(icon, color: Colors.black, size: 25),

      Expanded(
        child: Text(string,
            style: TextStyle(
                decoration: TextDecoration.none,
                color: textColor,
                fontFamily: Constants.fontsFamily,
                fontSize: ConstantWidget.getScreenPercentSize(context, 1.8),
                fontWeight: FontWeight.w500)),
     flex: 1, ),

      Container(

        width: content==null?0:ConstantWidget.getWidthPercentSize(context, 20),
        child: Text(content==null?'':content,
            textAlign: TextAlign.end,
            style: TextStyle(
                decoration: TextDecoration.none,
                color: subTextColor,

                fontFamily: Constants.fontsFamily,
                fontSize: ConstantWidget.getScreenPercentSize(context, 1.8),
                fontWeight: FontWeight.w500)),
      ),

      Visibility(child: Icon(Icons.navigate_next,color: textColor,
      size: ConstantWidget.getScreenPercentSize(context, 3),),visible: content==null && isSubContent==null)
    ],
  );
}

Widget getSettingMultiLineText(IconData icon, String string, String bottomTxt) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(icon, color: Colors.black87, size: 25),
      SizedBox(
        width: 10,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(string,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.black,
                  fontFamily: Constants.fontsFamily,
                  fontSize: 17,
                  fontWeight: FontWeight.normal)),
          SizedBox(
            height: 2,
          ),
          getCustomText(bottomTxt, Colors.black54, 1, TextAlign.start,
              FontWeight.w400, 14)
        ],
      ),
    ],
  );
}

Widget getMultiLineText(BuildContext context,String string, String bottomTxt, Function function) {
  return InkWell(
    child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: ConstantWidget.getScreenPercentSize(context, 1.5)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              child: Text(string,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: textColor,
                      fontFamily: Constants.fontsFamily,
                      fontSize: ConstantWidget.getScreenPercentSize(context, 1.8),
                      fontWeight: FontWeight.w500)),
              flex: 1, ),
            // Text(string,
            //     style: TextStyle(
            //         decoration: TextDecoration.none,
            //         color: Colors.black,
            //         fontFamily: Constants.fontsFamily,
            //         fontSize: 17,
            //         fontWeight: FontWeight.w400)),
            // SizedBox(
            //   height: 2,
            // ),

            getCustomText(bottomTxt, textColor, 1, TextAlign.start,
                FontWeight.bold, ConstantWidget.getScreenPercentSize(context, 1.8))
          ],
        )),
    onTap: () {
      function();
    },
  );
}

Widget getMediumNormalTextWithMaxLine(
    String text, Color color, int maxLine, TextAlign textAlign) {
  return Text(
    text,
    style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: mediumTextSize,
        color: color,
        fontFamily: Constants.fontsFamily,
        fontWeight: FontWeight.w500),
    maxLines: maxLine,
    textAlign: textAlign,
    overflow: TextOverflow.ellipsis,
  );
}

Widget getLargeBoldTextWithMaxLine(String text, Color color, int maxLine) {
  return Text(
    text,
    style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: largeTextSize,
        color: color,
        fontFamily: Constants.fontsFamily,
        fontWeight: FontWeight.bold),
    maxLines: maxLine,
    textAlign: TextAlign.center,
    overflow: TextOverflow.ellipsis,
  );
}

Widget getTitleTexts(BuildContext context, String txtTitle) {
  return getCustomText(txtTitle, textColor, 1, TextAlign.start, FontWeight.bold,
      ConstantWidget.getScreenPercentSize(context, 2.2));
}

Widget getSmallBoldText(String text, Color color) {
  return Text(
    text,
    style: TextStyle(
      decoration: TextDecoration.none,
      fontSize: smallTextSize,
      color: color,
      fontFamily: Constants.fontsFamily,
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.center,
  );
}

Widget getMediumBoldItalicText(String text, Color color) {
  return Text(
    text,
    style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: mediumTextSize,
        color: color,
        fontFamily: Constants.fontsFamily,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic),
    textAlign: TextAlign.center,
  );
}

Widget getSmallNormalText(String text, Color color, TextAlign textAlign) {
  return Text(
    text,
    style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: smallTextSize,
        color: color,
        fontFamily: Constants.fontsFamily,
        fontWeight: FontWeight.normal),
    textAlign: textAlign,
  );
}

Widget getMediumBoldText(String text, Color color, TextAlign textAlign) {
  return Text(text,
      style: TextStyle(
          decoration: TextDecoration.none,
          fontSize: mediumTextSize,
          color: color,
          fontFamily: Constants.fontsFamily,
          fontWeight: FontWeight.bold),
      textAlign: textAlign);
}

getProgressDialog({Color? color}) {
  return new Container(
      decoration:  BoxDecoration(
        color: color==null?CupertinoColors.white:color,
      ),
      child: color==null?new Center(child: CupertinoActivityIndicator()):new Center(child: CupertinoActivityIndicator(color: Colors.white,)));
}
