import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DarkTheme {
  static ThemeData theme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: kPrimaryDark,
      appBarTheme: AppBarTheme(
        backgroundColor: kPrimaryDark,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: kPrimaryDark,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
    );
  }
}
