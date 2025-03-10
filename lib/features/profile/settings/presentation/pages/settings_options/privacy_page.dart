import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? kMainDark : kWhite;
    final textColor = isDarkMode ? kWhite : kMainDark;
    final detailsColor = isDarkMode ? kLightGrey : kMainDark;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: textColor,
                        size: MediaQuery.of(context).orientation ==
                          Orientation.landscape ? 15.w: 21.w,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Spacer(),
                    Text('privacy.title'.tr(),
                        style: TextStyle(
                            fontSize:MediaQuery.of(context).orientation ==
                          Orientation.landscape ? 12.sp: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: textColor)),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 25.h),
                Text(
                 'privacy.content'.tr(),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: detailsColor,
                    fontSize: MediaQuery.of(context).orientation ==
                          Orientation.landscape ? 12.sp: 14.sp,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

 
}
