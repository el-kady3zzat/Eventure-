import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationItem extends StatelessWidget {
  final String title;
  final String eventId;
  final DateTime time;
  const NotificationItem({
    super.key,
    required this.title,
    required this.eventId,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: SizeConfig.size(p: 70.h, l: 150.h),
          margin: REdgeInsets.only(left: 40, right: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Card(
            color: kDetails,
            child: Padding(
              padding: REdgeInsets.only(
                left: SizeConfig.size(p: 40, l: 80),
                right: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: SizeConfig.size(p: 14.sp, l: 6.sp),
                      color: kWhite,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    timeago.format(time, locale: 'en_short'),
                    style: TextStyle(color: kWhite),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: SizeConfig.size(p: 45.h, l: 80.h),
          height: SizeConfig.size(p: 45.h, l: 80.h),
          margin: REdgeInsets.only(left: 16),
          child: CircleAvatar(),
        )
      ],
    );
  }
}
