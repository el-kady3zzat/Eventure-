import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildHeader(BuildContext context) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  final textColor = isDarkMode ? kWhite : kPrimaryDark;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        icon: Icon(Icons.arrow_back_ios,
            color: textColor,
            size: MediaQuery.of(context).orientation == Orientation.landscape
                ? 16.w
                : 21.w),
        onPressed: () => Navigator.pop(context),
      ),
      Spacer(),
      Text('changepass_screen.change_password'.tr(),
          style: TextStyle(
              fontSize:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 12.sp
                      : 17.sp,
              fontWeight: FontWeight.bold,
              color: textColor)),
      Spacer(),
    ],
  );
}
