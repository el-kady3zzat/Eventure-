import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UI {
  static BuildContext? context;

  static successSnack(BuildContext context, String msg) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.success(message: msg),
    );
  }

  static errorSnack(BuildContext context, String msg) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(message: msg),
    );
  }

  static infoSnack(BuildContext context, String msg) {
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.info(message: msg),
    );
  }

  static bool isDarkMode() {
    return Theme.of(context!).brightness == Brightness.dark;
  }

  static AlignmentGeometry uiAlign(context) {
    return EasyLocalization.of(context)!.currentLocale == Locale('ar')
        ? Alignment.centerRight
        : Alignment.centerLeft;
  }

  static double uiDir({required double en, required double ar}) {
    return EasyLocalization.of(context!)!.currentLocale == Locale('ar')
        ? ar
        : en;
  }
}
