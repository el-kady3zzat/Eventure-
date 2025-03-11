import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/domain/entities/event.dart';
import 'package:eventure/features/events/presentation/widgets/common/book_btn.dart';
import 'package:eventure/features/events/presentation/widgets/details_page/address.dart';
import 'package:eventure/features/events/presentation/widgets/details_page/participates.dart';
import 'package:eventure/features/events/presentation/widgets/details_page/price.dart';
import 'package:eventure/features/events/presentation/widgets/details_page/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsContainer extends StatelessWidget {
  final Event event;
  const DetailsContainer({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;

    return Container(
      height: SizeConfig.size(p: 1.sh, l: 1.sh),
      width: 1.sw,
      padding: REdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            kPrimaryDark.withValues(alpha: 0.1),
            kPrimaryDark.withValues(alpha: 0.2),
            kPrimaryDark.withValues(alpha: 0.3),
            kPrimaryDark.withValues(alpha: 0.4),
            kPrimaryDark.withValues(alpha: 0.9),
            kPrimaryDark.withValues(alpha: 1),
            kPrimaryDark.withValues(alpha: 1),
            kPrimaryDark.withValues(alpha: 1),
            kPrimaryDark.withValues(alpha: 1),
            kPrimaryDark.withValues(alpha: 1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailsTitle(
            eventId: event.id,
            title: event.title,
            description: event.description,
            address: event.address,
            dateTime: event.dateTime,
            seats: event.seats,
          ),
          Address(address: event.address, location: event.location),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Participates(eventId: event.id),
              Price(price: event.price),
            ],
          ),
          Center(
            child: SizedBox(
              width: SizeConfig.size(p: 1.sw, l: 1.sh),
              height: SizeConfig.size(p: 40.h, l: 80.h),
              child: BookBtn(
                eventId: event.id,
                seats: event.seats,
                registeredUsersCount: event.registeredUsers.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
