import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/blocs/save_btn/save_btn_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

class DetailsTitle extends StatelessWidget {
  final String eventId;
  final String title;
  final String description;
  final String address;
  final DateTime dateTime;
  final int seats;
  const DetailsTitle({
    super.key,
    required this.eventId,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.seats,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;
    late bool isSaved;

    return SizedBox(
      height: SizeConfig.size(p: 100.h, l: 150.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: SizeConfig.size(p: 16.sp, l: 7.sp),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                icon: BlocBuilder<SaveBtnBloc, SaveBtnState>(
                  builder: (context, state) {
                    SizeConfig.mContext = context;
                    isSaved = state is SaveBtnLoaded
                        ? state.eventsId.contains(eventId)
                        : false;
                    return Icon(
                      isSaved ? Icons.bookmark : Icons.bookmark_add_outlined,
                      color: kButton,
                      size: SizeConfig.size(p: 20.h, l: 35.h),
                    );
                  },
                ),
                onPressed: () => _updateSave(context, isSaved),
              ),
              IconButton(
                  onPressed: () => shareEvent(),
                  icon: Icon(
                    Icons.share_rounded,
                    color: kButton,
                  )),
            ],
          ),
          Text(
            description,
            maxLines: 2,
            style: TextStyle(
              fontSize: SizeConfig.size(p: 12.sp, l: 6.sp),
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
                      DateFormat('d MMM, yyyy').format(dateTime),
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
                      DateFormat('hh:mm a').format(dateTime),
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
                      Icons.event_seat_rounded,
                      color: Colors.white,
                      size: SizeConfig.size(
                        p: 12.sp,
                        l: 6.sp,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '$seats',
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
    );
  }

  void _updateSave(BuildContext context, bool isSaved) {
    if (isSaved) {
      context.read<SaveBtnBloc>().add(RemoveFromSaveIds(eventId));
      UI.successSnack(context, 'events.event_removed'.tr());
    } else {
      context.read<SaveBtnBloc>().add(AddToSaveIds(eventId));
      UI.successSnack(context, 'events.event_added'.tr());
    }
  }

  void shareEvent() {
    final String shareText =
        '📅 Event: $title\n🗓 Date: ${DateFormat('d MMM, yyyy').format(dateTime)} ${DateFormat('hh:mm a').format(dateTime)}\n📍 Location: $address\nℹ️ Details: $description';

    Share.share(shareText);
  }
}
