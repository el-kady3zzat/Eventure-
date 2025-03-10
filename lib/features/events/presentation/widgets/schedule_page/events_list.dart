import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/widgets/common/img.dart';
import 'package:eventure/features/events/domain/entities/event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class EventsList extends StatelessWidget {
  final List<Event> events;
  const EventsList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160.h,
      child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: REdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: () => Navigator.of(context)
                    .pushNamed('/details', arguments: events[index]),
                splashColor: kHeader,
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: SizedBox(
                      height: 100.h,
                      width: 55,
                      child: Img(url: events[index].cover),
                    ),
                  ),
                  title: Text(
                    events[index].title,
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Text(
                    formatCustomDate(
                      events[index].dateTime,
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  String formatCustomDate(DateTime date) {
    // Get day as a number
    String day = DateFormat('d').format(date);
    // Get suffix (st, nd, rd, th)
    String suffix = getDaySuffix(int.parse(day));
    // Get time like "11 PM"
    String formattedTime = DateFormat('h a').format(date);

    return '$day$suffix at $formattedTime';
  }

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
