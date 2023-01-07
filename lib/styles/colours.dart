import 'package:flutter/material.dart';

colourConvert(String color) {
  color = color.replaceAll("#", "");
  if (color.length == 6) {
    return Color(int.parse("0xFF$color"));
  } else if (color.length == 8) {
    return Color(int.parse("0x$color"));
  }
}

/*Color backgroundColour = Color.fromRGBO(25, 27, 31, 1);*/
/*Color background = colourConvert("#f4f5f9");*/
Color cardColour = const Color.fromRGBO(75, 74, 77, 1);
Color card = const Color.fromRGBO(37, 37, 37, 1);
Color blue = colourConvert("#5468ff");
Color instagramOne = colourConvert("#DD2A7B");
Color instagramTwo = colourConvert("#feda77");
Color instagramThree = colourConvert("#f58529");
Color instagramFour = colourConvert("#8134af");
Color facebook = colourConvert("#515bd4");
final Color firstCircleColor = Colors.white.withOpacity(0.4);
final Color secondCircleColor = Colors.white.withOpacity(0.6);
const Color backgroundColor = Color(0xFF9E9E9E);
Color backgroundDark = const Color.fromRGBO(26, 26, 26, 1.0);
Color backgroundLight = const Color.fromRGBO(244, 245, 249, 1.0);
/*Color backgroundLight = const Color.fromRGBO(252, 252, 252, 1.0);*/

/*Colours*/
Color backgroundColour = colourConvert("#f5f5f9");
Color backgroundContainer = colourConvert("#f3f5f9");
Color white = Colors.white;
Color black = Colors.black;
Color amber = Colors.amber;
Color red = Colors.red;
Color green = Colors.green;
Color grey = Colors.grey;
Color transparent = Colors.transparent;
Color muted = grey.withOpacity(0.8);
Color secondary = const Color.fromRGBO(67, 154, 199, 1);
Color primary = black;
/*Color primary = Color.fromRGBO(42, 59, 87, 1);*/
Color info = colourConvert("#8645ff");
Color success = colourConvert("#00f2c3");
Color warning = colourConvert("#ffca00");
Color danger = const Color.fromRGBO(176, 66, 69, 1);
Color greyColor = const Color(0xFFE6E6E6);
Color darkGreyColor = const Color(0xFFB8B2CB);

Color exercise = const Color.fromRGBO(255, 202, 0, 1);
Color sleepColor = const Color.fromRGBO(0, 242, 195, 1);
Color waterColor = const Color.fromRGBO(134, 69, 200, 1);
Color darkBackground = const Color.fromRGBO(50, 50, 50, 1);
/*Color darkCard = colourConvert("#27293d");*/
/*Color darkCard = colourConvert("#1f2251");*/
Color darkCard = const Color.fromRGBO(37, 37, 37, 1);
/*Color darkCard = Color.fromRGBO(57, 57, 57, 1);*/

class ThemeVar {
  final Color? white;
  final Color? background;
  final Color? primary;
  final Color? card;
  final Color? secondary;

  ThemeVar(
      {this.background, this.primary, this.card, this.secondary, this.white});
}
