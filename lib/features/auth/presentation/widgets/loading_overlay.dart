import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eventure/core/utils/theme/theme_cubit/theme_cubit.dart';

class LoadingOverlay extends StatelessWidget {
  final String message;

  const LoadingOverlay({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        return Container(
          color: isDarkMode
              ? Colors.black.withValues(alpha: 0.5)
              : kPreIcon.withValues(alpha: 0.5),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: isDarkMode ? Colors.white : kButton,
                ),
                SizedBox(height: 16.h),
                Text(
                  message,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : kMainLight,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}