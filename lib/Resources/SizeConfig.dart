import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double textScaleFactor;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);

    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    textScaleFactor = _mediaQueryData.textScaleFactor;
  }

  // Reference Design Size (iPhone X)
  static const double designWidth = 375;
  static const double designHeight = 812;

  static double getWidth(double width) {
    return (width / designWidth) * screenWidth;
  }

  static double getHeight(double height) {
    return (height / designHeight) * screenHeight;
  }

  static double getFont(double fontSize) {
    return (fontSize / designWidth) * screenWidth;
  }

  static double getRadius(double radius) {
    return (radius / designWidth) * screenWidth;
  }

  static EdgeInsets getPadding({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: getWidth(left),
      top: getHeight(top),
      right: getWidth(right),
      bottom: getHeight(bottom),
    );
  }
}