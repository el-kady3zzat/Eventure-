import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData theme() {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: kPrimaryDark,
      appBarTheme: AppBarTheme(backgroundColor: kPrimaryDark),
    );
  }
}
