import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/widgets/common/pages_header.dart';
import 'package:eventure/features/events/presentation/widgets/notifications_settings_page/notification.dart';
import 'package:eventure/features/events/domain/entities/notification.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;
    UI.context = context;

    final notifications = ModalRoute.of(context)!.settings.arguments
        as List<EventureNotification>;

    return Scaffold(
      // backgroundColor: kSecondaryDark,
      body: SafeArea(
        child: Column(
          children: [
            PagesHeader(title: 'events.notifications'.tr(), hasBackBtn: true),
            Expanded(
              child: notifications.isNotEmpty
                  ? ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        return NotificationItem(
                          title: notifications[index].title,
                          eventId: notifications[index].eventId,
                          time: notifications[index].timestamp,
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'events.no_notifications'.tr(),
                        style: TextStyle(
                          color: UI.isDarkMode() ? kWhite : kPrimaryLight,
                        ),
                      ),
                    ),
            )

            // Expanded(
            //   child: BlocBuilder<NotificationsBloc, NotificationsState>(
            //     builder: (context, state) {
            //       if (state is NotificationsLoading) {
            //         return Center(child: CircularProgressIndicator());
            //       } else if (state is NotificationsLoaded) {
            //         return state.notifications.isNotEmpty
            //             ? ListView.builder(
            //                 itemCount: state.notifications.length,
            //                 itemBuilder: (context, index) {
            //                   final notification = state.notifications[index];
            //                   return NotificationItem(
            //                     title: notification.title,
            //                     eventId: notification.eventId,
            //                     time: notification.timestamp,
            //                   );
            //                 },
            //               )
            //             : Center(
            //                 child: Text(
            //                   'events.no_notifications'.tr(),
            //                   style: TextStyle(
            //                     color:
            //                         UI.isDarkMode() ? kWhite : kPrimaryLight,
            //                   ),
            //                 ),
            //               );
            //       } else if (state is NotificationError) {
            //         return Center(
            //           child: Text(
            //             '${'events.error'.tr()}: ${state.message}',
            //             style: TextStyle(
            //               color: UI.isDarkMode() ? kWhite : kPrimaryLight,
            //             ),
            //           ),
            //         );
            //       }
            //       return SizedBox.shrink();
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
