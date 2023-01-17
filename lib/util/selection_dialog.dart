import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:women_workout/util/color_category.dart';

import 'constant_widget.dart';

/// selection dialog used for selection of the country code
class SelectionDialog extends StatefulWidget {
  final List<CountryCode> elements;
  final bool? showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle? searchStyle;
  final TextStyle? textStyle;
  final BoxDecoration? boxDecoration;
  final WidgetBuilder? emptySearchBuilder;
  final bool? showFlag;
  final double flagWidth;
  final Decoration? flagDecoration;
  final Size? size;
  final bool hideSearch;
  final Icon? closeIcon;

  /// Background color of SelectionDialog
  final Color? backgroundColor;

  /// Boxshaow color of SelectionDialog that matches CountryCodePicker barrier color
  final Color? barrierColor;

  /// elements passed as favorite
  final List<CountryCode> favoriteElements;

  SelectionDialog(
    this.elements,
    this.favoriteElements, {
    Key? key,
    this.showCountryOnly,
    this.emptySearchBuilder,
    InputDecoration searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.textStyle,
    this.boxDecoration,
    this.showFlag,
    this.flagDecoration,
    this.flagWidth = 32,
    this.size,
    this.backgroundColor,
    this.barrierColor,
    this.hideSearch = false,
    this.closeIcon,
  })  : searchDecoration = searchDecoration.prefixIcon == null
            ? searchDecoration.copyWith(prefixIcon: const Icon(Icons.search))
            : searchDecoration,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  /// this is useful for filtering purpose
  late List<CountryCode> filteredElements;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: ListView(
            children: [
              ConstantWidget.getVerSpace(20.h),
              Stack(alignment: Alignment.center, children: [
                ConstantWidget.getTextWidget("Select Country", Colors.black,
                    TextAlign.start, FontWeight.w700, 26.sp),
                Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: getSvgImage("arrow_left.svg",
                            width: 24.h, height: 24.h)))
              ]).paddingSymmetric(horizontal: 20.h),
              ConstantWidget.getVerSpace(20.h),
              ConstantWidget.getDefaultTextFiledWithLabel(
                      context, "Search", searchController,
                      isEnable: false,
                      height: 50.h,
                      withprefix: true,
                      image: "search.svg",
                      onChanged: _filterElements)
                  .paddingSymmetric(horizontal: 20.h),
              ConstantWidget.getVerSpace(20.h),
              widget.favoriteElements.isEmpty
                  ? const DecoratedBox(decoration: BoxDecoration())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...widget.favoriteElements.map(
                          (f) => SimpleDialogOption(
                            child: _buildOption(f),
                            onPressed: () {
                              _selectItem(f);
                            },
                          ),
                        ),
                        // const Divider(),
                      ],
                    ),
              if (filteredElements.isEmpty)
                _buildEmptySearchWidget(context)
              else
                ...filteredElements.map(
                  (e) => SimpleDialogOption(
                    child: _buildOption(e),
                    onPressed: () {
                      _selectItem(e);
                    },
                  ),
                )
            ],
          ),
        ),
      );

  Widget _buildOption(CountryCode e) {
    return Container(
      // margin: EdgeInsets.only(bottom: 10.h),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
         Row(
           children: [
             if (widget.showFlag!)
               Container(
                 height: 28.h,
                 width: 40.h,
                 margin: const EdgeInsets.only(right: 16.0),
                 decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(4.h),
                     image: DecorationImage(
                         image: AssetImage(
                           e.flagUri!,
                           package: 'country_code_picker',
                         ),
                         fit: BoxFit.fill)),
               ),
             ConstantWidget.getTextWidget(e.toCountryStringOnly(),
                 Colors.black, TextAlign.start, FontWeight.w400, 16.sp),
           ],
         ),
          ConstantWidget.getTextWidget(e.dialCode ?? "", Colors.black,
              TextAlign.start, FontWeight.w400, 16.sp)
        ],
      ),
    );
  }

  Widget _buildEmptySearchWidget(BuildContext context) {
    if (widget.emptySearchBuilder != null) {
      return widget.emptySearchBuilder!(context);
    }

    return Center(
      child: Text(CountryLocalizations.of(context)?.translate("no country") ??
          "no country found"),
    );
  }

  @override
  void initState() {
    filteredElements = widget.elements;
    super.initState();
  }

  void _filterElements(String s) {
    s = s.toUpperCase();
    setState(() {
      filteredElements = widget.elements
          .where((e) =>
              e.code!.contains(s) ||
              e.dialCode!.contains(s) ||
              e.name!.toUpperCase().contains(s))
          .toList();
    });
  }

  void _selectItem(CountryCode e) {
    Get.back(result: e);
  }
}
