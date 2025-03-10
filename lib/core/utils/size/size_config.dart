import 'package:flutter/material.dart';

class SizeConfig {
  static late BuildContext mContext;
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    orientation = MediaQuery.of(context).orientation;

    defaultSize = orientation == Orientation.landscape
        ? screenHeight! * .024
        : screenWidth! * .024;
  }

  static double size({required double p, required double l}) {
    var orientation = MediaQuery.of(mContext).orientation;
    return orientation == Orientation.portrait ? p : l;
  }

  static bool isPortrait() {
    return orientation == Orientation.portrait;
  }
}
