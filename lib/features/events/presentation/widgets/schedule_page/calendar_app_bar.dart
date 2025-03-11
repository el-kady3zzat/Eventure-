import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CalendarAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(
        SizeConfig.size(p: 50.h, l: 95.h),
      );

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;
    double mainHeight = SizeConfig.size(p: 50.h, l: 95.h);
    double mainRadius = SizeConfig.size(p: 20, l: 15);

    return Card(
      elevation: 10,
      shadowColor: kPrimaryLight,
      margin: REdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(mainRadius),
          bottomRight: Radius.circular(mainRadius),
        ),
      ),
      child: AppBar(
        backgroundColor: kPrimaryDark,
        toolbarHeight: mainHeight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(mainRadius),
            bottomRight: Radius.circular(mainRadius),
          ),
        ),
        centerTitle: true,
        title: Text(
          'events.calendar'.tr(),
          style: TextStyle(
            fontSize: SizeConfig.size(p: 18.sp, l: 8.sp),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
