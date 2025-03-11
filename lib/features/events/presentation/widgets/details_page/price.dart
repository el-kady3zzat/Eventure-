import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Price extends StatelessWidget {
  final String price;
  const Price({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          price,
          style: TextStyle(
            fontSize: SizeConfig.size(p: 20.sp, l: 8.sp),
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          '\$',
          style: TextStyle(
            fontSize: SizeConfig.size(p: 12.sp, l: 5.sp),
            fontWeight: FontWeight.bold,
            color: kPrimaryLight,
          ),
        ),
      ],
    );
  }
}
