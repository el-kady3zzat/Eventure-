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
    return SizedBox(
      height: SizeConfig.size(p: 45.h, l: 80.h),
      width: SizeConfig.size(p: 50.h, l: 85.h),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        color: kPrimaryLight,
        child: IconButton(
          icon: Icon(
            icon,
            color: Colors.white,
            size: SizeConfig.size(p: 15.h, l: 30.h),
          ),
          onPressed: onPress,
        ),
      ),
    );
  }
}
