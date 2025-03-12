import 'package:eventure/core/utils/helper/ui.dart';
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
    UI.context = context;

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
              splashColor: kPrimaryLight,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: UI.isDarkMode() ? kWhite : kPrimaryLight,
                      width: 1, // Thickness of the underline
                    ),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: ListTile(
                  contentPadding: REdgeInsets.fromLTRB(8, 0, 8, 4),
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
                    style: TextStyle(
                      color: UI.isDarkMode() ? kWhite : kPrimaryLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    formatCustomDate(
                      events[index].dateTime,
                    ),
                    style: TextStyle(
                      color: UI.isDarkMode() ? kWhite : kPrimaryLight,
                      fontSize: 12.sp,
                    ),
                  ),
                  // shape: UnderlineInputBorder(
                  //   borderRadius:
                  // BorderRadius.only(
                  //     bottomLeft: Radius.circular(20),
                  //     bottomRight: Radius.circular(20),
                  //   ),
                  //   borderSide: BorderSide(
                  //     color: UI.isDarkMode() ? kWhite : kPrimaryLight,
                  //   ),
                  // ),
                ),
              ),
            ),
          );
        },
      ),
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
