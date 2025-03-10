import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UI {
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
}
