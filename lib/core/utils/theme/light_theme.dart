import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class LightTheme {
  static ThemeData theme() {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: kWhite,
      appBarTheme: AppBarTheme(backgroundColor: kPrimaryLight),
    );
  }
}
