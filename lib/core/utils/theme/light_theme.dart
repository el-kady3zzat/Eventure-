import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LightTheme {
  static ThemeData theme() {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: kWhite,
      appBarTheme: AppBarTheme(
        backgroundColor: kPrimaryLight,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: kPrimaryLight,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
    );
  }
}
