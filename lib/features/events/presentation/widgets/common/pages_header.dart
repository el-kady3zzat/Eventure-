import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PagesHeader extends StatelessWidget {
  final String title;
  final bool hasBackBtn;
  const PagesHeader({super.key, required this.title, this.hasBackBtn = false});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;

    return !hasBackBtn
        ? SizedBox(
            height: SizeConfig.size(p: 70.h, l: 100.h),
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kWhite,
                  fontSize: SizeConfig.size(p: 18.sp, l: 8.sp),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        : Stack(
            alignment: Alignment.centerLeft,
            children: [
              SizedBox(
                height: SizeConfig.size(p: 70.h, l: 100.h),
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.size(p: 18.sp, l: 8.sp),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              IconButton(
                padding: REdgeInsets.only(left: 8),
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: kWhite,
                  size: SizeConfig.size(p: 20.h, l: 40.h),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
  }
}
