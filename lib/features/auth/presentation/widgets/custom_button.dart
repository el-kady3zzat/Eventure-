// widgets/custom_button.dart
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double? fontSize;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.fontSize,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 20.w,
      height: height ?? 56.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isLoading ? Colors.grey : kButton, // Using kHeader color
          padding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 24.w,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(30.r), // More subtle rounded corners
          ),
          elevation: 0, // Flat design
          disabledBackgroundColor: Colors.grey.withValues(alpha: 0.5),
        ),
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Center(
                child: Text(
                  text.toUpperCase(), // Uppercase text like in the image
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize ?? 16.sp,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryDark,
                    letterSpacing:
                        1, // Slight letter spacing for better readability
                  ),
                ),
              ),
      ),
    );
  }
}
