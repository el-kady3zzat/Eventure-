// widgets/custom_snack_bar.dart
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSnackBar {
  // Helper method to get responsive padding
  static EdgeInsets _getResponsivePadding() {
    return REdgeInsets.symmetric(
      horizontal: 16.w,
      vertical: 12.h,
    );
  }

  // Helper method to get responsive border radius
  static double _getResponsiveBorderRadius() {
    return 16.r;
  }

  // Success SnackBar
  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    AnimatedSnackBar.material(
      message,
      type: AnimatedSnackBarType.success,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
      duration: duration,
      borderRadius: BorderRadius.circular(_getResponsiveBorderRadius()),
    ).show(context);
  }

  // Error SnackBar
  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    AnimatedSnackBar.material(
      message,
      type: AnimatedSnackBarType.error,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
      duration: duration,
      borderRadius: BorderRadius.circular(_getResponsiveBorderRadius()),
    ).show(context);
  }

  // Warning SnackBar
  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    AnimatedSnackBar.material(
      message,
      type: AnimatedSnackBarType.warning,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
      duration: duration,
      borderRadius: BorderRadius.circular(_getResponsiveBorderRadius()),
    ).show(context);
  }

  // Info SnackBar
  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    AnimatedSnackBar.material(
      message,
      type: AnimatedSnackBarType.info,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
      duration: duration,
      borderRadius: BorderRadius.circular(_getResponsiveBorderRadius()),
    ).show(context);
  }

  // Custom SnackBar with more customization options
  static void showCustom({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration duration = const Duration(seconds: 3),
    Color textColor = Colors.white,
    double? fontSize,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    final responsiveFontSize = fontSize?.sp ?? 16.sp;
    final responsivePadding = _getResponsivePadding();
    final borderRadius = _getResponsiveBorderRadius();
    final iconSize = 24.w; // Base icon size
    final containerWidth = 351.w; // 90% of 390

    AnimatedSnackBar(
      builder: (context) {
        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: containerWidth,
              minWidth: containerWidth * 0.5,
            ),
            padding: responsivePadding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: textColor,
                  size: iconSize,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: textColor,
                      fontSize: responsiveFontSize,
                      fontWeight: fontWeight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      duration: duration,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      desktopSnackBarPosition: DesktopSnackBarPosition.topRight,
    ).show(context);
  }
}