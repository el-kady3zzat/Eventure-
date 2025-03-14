import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/domain/entities/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarGrid extends StatelessWidget {
  final DateTime currentMonth;
  final List<Event> events;
  const CalendarGrid(
      {super.key, required this.currentMonth, required this.events});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;
    UI.context = context;

    return GridView.builder(
      padding: REdgeInsets.symmetric(horizontal: 8),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: SizeConfig.size(p: 7, l: 14).toInt(),
        childAspectRatio: 1.2,
      ),
      itemCount: DateTime(
        currentMonth.year,
        currentMonth.month + 1,
        0,
      ).day,
      itemBuilder: (context, index) {
        DateTime date = DateTime(
          currentMonth.year,
          currentMonth.month,
          index + 1,
        );
        bool hasEvent = events.any(
          (event) => isSameDay(event.dateTime, date),
        );
        Event? event = hasEvent
            ? events.firstWhere((e) => isSameDay(e.dateTime, date))
            : null;

        return GestureDetector(
          onTap: () {
            if (hasEvent) {
              if (!SizeConfig.isPortrait()) {
                Navigator.of(context).pushNamed(
                  '/details',
                  arguments: event,
                );
              }
            }
          },
          child: Container(
            margin: REdgeInsets.all(4),
            decoration: BoxDecoration(
              color: hasEvent ? kButton : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: hasEvent
                    ? Colors.black
                    : UI.isDarkMode()
                        ? kWhite
                        : kPrimaryLight,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
