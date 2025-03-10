import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AuthenticationLoadingDialog extends StatelessWidget {
  const AuthenticationLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: REdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? kMainDark : kMainLight,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                isDarkMode ? kMainLight : kMainDark,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Authenticating...',
              style: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode ? kMainLight : kMainDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
