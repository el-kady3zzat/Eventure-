import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/widgets/common/favorite_btn.dart';
import 'package:eventure/features/events/presentation/widgets/common/img.dart';
import 'package:eventure/features/events/domain/entities/event.dart';
import 'package:eventure/features/events/presentation/widgets/common/book_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Event event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;
    UI.context = context;

    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed('/details', arguments: event),
      child: Container(
        height: SizeConfig.size(p: 220.h, l: 340.h),
        width: !SizeConfig.isPortrait() ? 550.h : 1.sw,
        margin: REdgeInsets.only(
          bottom: 16,
          right: !SizeConfig.isPortrait() ? 16 : 0,
        ),
        child: Stack(
          children: [
            Img(url: event.cover),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FavoriteBtn(eventId: event.id),
                  Container(
                    height: SizeConfig.size(
                      p: ScreenUtil().pixelRatio! > 2 ? 70.h : 80.h,
                      l: 130.h,
                    ),
                    margin: REdgeInsets.symmetric(horizontal: 15),
                    child: Card(
                      elevation: 10,
                      shadowColor: kPrimaryLight,
                      margin: EdgeInsets.zero,
                      color: UI.isDarkMode() ? kDetails : kPrimaryLight,
                      child: Padding(
                        padding:
                            REdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: TextStyle(
                                    fontSize:
                                        SizeConfig.size(p: 16.sp, l: 7.sp),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today_rounded,
                                            color: Colors.white,
                                            size: SizeConfig.size(
                                              p: 12.sp,
                                              l: 6.sp,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            DateFormat('d MMM, yyyy')
                                                .format(event.dateTime),
                                            style: TextStyle(
                                              fontSize: SizeConfig.size(
                                                p: 12.sp,
                                                l: 5.sp,
                                              ),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time_rounded,
                                            color: Colors.white,
                                            size: SizeConfig.size(
                                              p: 12.sp,
                                              l: 6.sp,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            DateFormat('hh:mm a')
                                                .format(event.dateTime),
                                            style: TextStyle(
                                              fontSize: SizeConfig.size(
                                                p: 12.sp,
                                                l: 5.sp,
                                              ),
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            BookBtn(
                              eventId: event.id,
                              seats: event.seats,
                              registeredUsersCount:
                                  event.registeredUsers.length,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
