import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'color_category.dart';
import 'constant_widget.dart';
import 'constants.dart';

class CustomAnimatedBottomBar extends StatelessWidget {
  CustomAnimatedBottomBar({
    Key? key,
    this.selectedIndex = 0,
    this.showElevation = true,
    this.iconSize = 24,
    this.backgroundColor,
    this.itemCornerRadius = 50,
    this.containerHeight = 56,
    this.animationDuration = const Duration(milliseconds: 270),
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    required this.items,
    required this.onItemSelected,
    this.curve = Curves.linear,
  })  : assert(items.length >= 2 && items.length <= 5),
        super(key: key);

  final int selectedIndex;
  final double iconSize;
  final Color? backgroundColor;
  final bool showElevation;
  final Duration animationDuration;
  final List<BottomNavyBarItem> items;
  final ValueChanged<int> onItemSelected;
  final MainAxisAlignment mainAxisAlignment;
  final double itemCornerRadius;
  final double containerHeight;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Theme.of(context).bottomAppBarColor;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          if (showElevation)
            BoxShadow(
              color: cellColor.withOpacity(0.5),
              offset: const Offset(
                5.0,
                5.0,
              ),
              blurRadius: 0.7,
              spreadRadius: 5.0,
            ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: containerHeight,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: items.map((item) {
              var index = items.indexOf(item);
              return GestureDetector(
                onTap: () => onItemSelected(index),
                child: _ItemWidget(
                  item: item,
                  containerHeight: containerHeight,
                  iconSize: iconSize,
                  isSelected: index == selectedIndex,
                  backgroundColor: bgColor,
                  itemCornerRadius: itemCornerRadius,
                  animationDuration: animationDuration,
                  curve: curve,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final double iconSize;
  final bool isSelected;
  final BottomNavyBarItem item;
  final Color backgroundColor;
  final double itemCornerRadius;
  final double containerHeight;
  final Duration animationDuration;
  final Curve curve;

  const _ItemWidget({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.backgroundColor,
    required this.animationDuration,
    required this.itemCornerRadius,
    required this.containerHeight,
    required this.iconSize,
    this.curve = Curves.linear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = (ConstantWidget.getWidthPercentSize(context, 100) / 4);
    return Semantics(
      container: true,
      selected: isSelected,
      child: AnimatedContainer(
        height: double.maxFinite,
        duration: animationDuration,
        curve: curve,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            width: width,
            color: backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: ConstantWidget.getPercentSize(width, 40),
                  width: ConstantWidget.getPercentSize(width, 40),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: isSelected
                                ? primaryColor.withOpacity(0.1)
                                : Colors.transparent,
                            blurRadius: 3,
                            spreadRadius: 2,
                            offset: Offset(0, 6))
                      ],
                      color:
                          isSelected ? item.activeColor : Colors.transparent),
                  child: Center(
                    child: SvgPicture.asset(
                      Constants.assetsImagePath + item.imageName!,
                      height: isSelected
                          ? (item.iconSize! * 1.3)
                          : (item.iconSize! * 1.3),
                      color: isSelected ? Colors.white : item.inactiveColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavyBarItem {
  BottomNavyBarItem({
    this.activeColor = Colors.blue,
    this.textAlign,
    this.inactiveColor,
    this.imageName,
    this.iconSize,
    this.title,
  });

  final Color activeColor;
  final Color? inactiveColor;
  final TextAlign? textAlign;
  final String? imageName;
  final String? title;
  final double? iconSize;
}
