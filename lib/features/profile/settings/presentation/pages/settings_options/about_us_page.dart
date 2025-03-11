import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? kPrimaryDark : kWhite;
    final textColor = isDarkMode ? kWhite : kPrimaryDark;
    final detailsColor = isDarkMode ? kLightGrey : kPrimaryDark;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                                Orientation.landscape
                            ? 15.w
                            : 21.w,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Spacer(),
                    Text('about.title'.tr(),
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).orientation ==
                                    Orientation.landscape
                                ? 12.sp
                                : 17.sp,
                            fontWeight: FontWeight.bold,
                            color: textColor)),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 25.h),
                _illustration(context),
                SizedBox(height: 30.h),
                Text(
                  'about.content'.tr(),
                  textAlign: TextAlign.justify,
                  //softWrap: false,
                  style: TextStyle(
                    color: detailsColor,
                    fontSize: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? 10.sp
                        : 14.sp,
                    // height: 1.6,
                  ),
                ),
                SizedBox(height: 30.h),
                _appName(context),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _illustration(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).orientation == Orientation.landscape
            ? 300.w
            : 260.w,
        height: MediaQuery.of(context).orientation == Orientation.landscape
            ? 250.h
            : 200.h,
        child: SvgPicture.asset(
          'assets/images/about.svg',
          fit: BoxFit.contain, // Adjust fit
        ),
      ),
    );
  }

  Widget _appName(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? kWhite : kPrimaryDark;
    return Text(
      'about.name'.tr(),
      style: TextStyle(
        fontSize: MediaQuery.of(context).orientation == Orientation.landscape
            ? 20.sp
            : 25.sp,
        fontWeight: FontWeight.bold,
        color: textColor,
        //  fontFamily: "Poppins",
      ),
    );
  }
}
