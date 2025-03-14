import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Arrow extends StatelessWidget {
  final IconData icon;
  final void Function() onPress;
  const Arrow({super.key, required this.icon, required this.onPress});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;
    UI.context = context;

    return SizedBox(
      height: SizeConfig.size(p: 40.h, l: 80.h),
      width: SizeConfig.size(p: 100.h, l: 200.h),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        color: UI.isDarkMode() ? kPrimaryLight : kButton,
        child: IconButton(
          icon: Icon(
            icon,
            color: kWhite,
            size: SizeConfig.size(p: 22.sp, l: 10.sp),
          ),
          onPressed: onPress,
        ),
      ),
    );
  }
}
