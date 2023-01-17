import 'package:flutter/material.dart';

Color bgDarkWhite = "#FFFFFF".toColor();
Color primaryColor = Color(0xFFF6F6F6);
// Color accentColor = "#CBC3E3".toColor();
Color accentColor = "#614d9e".toColor();
// Color accentColor = "#FF5D23".toColor();
Color subTextColor = "#B3B3B3".toColor();
Color descriptionColor = "#525252".toColor();
Color greyWhite = Color(0xFFEBEAEF);
Color darkGrey = Color(0xFFEBEAEF);
Color greenButton = Color(0xFF37BD4D);
Color blueButton = Color(0xFF0078FF);
Color quickSvgColor = Color(0xFF283182);
Color bmiBgColor = "#2C698D".toColor();
Color bmiDarkBgColor = Color(0xFF134B6D);
Color lightPink = Color(0xFFFBE8EA);
Color itemBgColor = Color(0xFFF2F1F4);
Color textColor = Colors.black;
Color borderColor = "#DFDFDF".toColor();
Color shadowColor = "#1423408F".toColor();
Color lightOrange = "#E8E5FF".toColor();
// Color lightOrange = "#FFF0EA".toColor();
Color containerShadow = "#33ACB6B5".toColor();
Color grayLight = "#DDDDDD".toColor();
Color orangeLight = "#FFF6F3".toColor();
Color dividerColor = "#E6E6E6".toColor();

Color cellColor = "#F9F9F9".toColor();
Color bgColor = "#F4F4F4".toColor();
Color category1 = "#D5F7E4".toColor();
Color category2 = "#E8E5FF".toColor();
Color category3 = "#CFE5FF".toColor();
Color category4 = "#FBD9FF".toColor();
Color category5 = "#D6F4FF".toColor();
Color category6 = "#FFECDB".toColor();
Color category7 = "#D6F4FF".toColor();

Color workout1 = "#CCE7FF".toColor();
Color workout2 = "#FFF2CA".toColor();
Color workout3 = "#FFDAD7".toColor();

Color shapeColor1 = "#B3E2C8".toColor();
Color shapeColor2 = "#D1CBFF".toColor();
Color shapeColor3 = "#AED2FF".toColor();
Color shapeColor4 = "#F9C7FF".toColor();
Color shapeColor5 = "#B0E9FE".toColor();
Color shapeColor6 = "#FFD8B6".toColor();

// getCellColor(int index) {
//   if (index % 7 == 0) {
//     return category1;
//   } else if (index % 7 == 1) {
//     return category2;
//   } else if (index % 7 == 2) {
//     return category3;
//   } else if (index % 7 == 3) {
//     return category4;
//   } else if (index % 7 == 4) {
//     return category5;
//   } else if (index % 7 == 5) {
//     return category6;
//   } else if (index % 7 == 6) {
//     return category7;
//   } else {
//     return category1;
//   }
// }

getCellColor(int index) {
  if (index % 2 == 1) {
    return category2;
  } else {
    return category4;
  }
  // else if (index % 7 == 2) {
  //   return category2;
  // } else if (index % 7 == 3) {
  //   return category4;
  // } else if (index % 7 == 4) {
  //   return category2;
  // } else if (index % 7 == 5) {
  //   return category4;
  // } else if (index % 7 == 6) {
  //   return category2;
  // } else {
  //   return category2;
  // }
}


getCellShapeColor(int index) {
  // if (index % 7 == 0) {
  //   return shapeColor2;
  // } else if (index % 7 == 1) {
  //   return shapeColor4;
  // } else if (index % 7 == 2) {
  //   return shapeColor2;
  // } else if (index % 7 == 3) {
  //   return shapeColor4;
  // } else if (index % 7 == 4) {
  //   return shapeColor2;
  // } else if (index % 7 == 5) {
  //   return shapeColor4;
  // } else {
  //   return shapeColor2;
  // }


  if (index % 2 == 1) {
    return shapeColor2;
  } else {
    return shapeColor4;
  }

}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}




getWorkoutColor(int index) {
  if (index % 2 == 1) {
    return category2;
  } else {
    return category4;
  }
}
getRandomColor(int index) {
  if (index % 2 == 0) {
    return category2;
  } else {
    return category4;
  }
}


// getRandomColor(int index) {
//   if (index % 3 == 0) {
//     return workout1;
//   } else if (index % 2  == 1) {
//     return workout2;
//   } else if (index  % 3 == 2) {
//     return workout3;
//   }
//   return workout1;
// }


getDiscoverWorkoutColor(int index) {
  // if (index == 0) {
  //   return "#FFE7FB".toColor();
  // } else if (index == 1) {
  //   return "#D4FFF8".toColor();
  // } else if (index == 2) {
  //   return "#FFC2DD".toColor();
  // }
  if (index % 2 == 1) {
    return category2;
  } else {
    return category4;
  }
}

getDiscoverWorkoutShape(int index) {
  // if (index == 0) {
  //   return "discover_shape1.png";
  // } else if (index == 1) {
  //   return "discover_shape2.png";
  // } else if (index == 2) {
  //   return "discover_shape3.png";
  // }

  if (index % 2 == 1) {
    return "discover_shape4.png";
  } else {
    return "discover_shape1.png";
  }

}



getQuickWorkoutColor(int index) {
  if (index % 2 == 0) {
    return category2;
  } else {
    return category4;
  }
}


getQuickWorkoutShapeColor(int index) {
  if (index % 2 == 0) {
    return darken(category2,0.05);
  } else {
    return darken(category4,0.05);
  }
}


// getQuickWorkoutColor(int index) {
//   if (index == 0) {
//     return "#DFE6FF".toColor();
//   } else if (index == 1) {
//     return "#FFDED1".toColor();
//   } else if (index == 2) {
//     return "#FFF0D4".toColor();
//   }
// }

// getQuickWorkoutShapeColor(int index) {
//   if (index == 0) {
//     return "#B7C5FE".toColor();
//   } else if (index == 1) {
//     return "#FFC4AE".toColor();
//   } else if (index == 2) {
//     return "#F2D9AA".toColor();
//   }
// }

getStretchesColor(int index) {
  if (index % 2 == 0) {
    return category2;
  } else {
    return category4;
  }


  // if (index == 0) {
  //   return "#FFF0F0".toColor();
  // } else if (index == 1) {
  //   return "#FBF0FF".toColor();
  // } else if (index == 2) {
  //   return "#FFF0E2".toColor();
  // } else if (index == 3) {
  //   return "#E7F5FF".toColor();
  // } else if (index == 4) {
  //   return "#EDF1FF".toColor();
  // } else if (index == 5) {
  //   return "#EAFFFA".toColor();
  // } else if (index == 6) {
  //   return "#E1F2FF".toColor();
  // }
}

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
