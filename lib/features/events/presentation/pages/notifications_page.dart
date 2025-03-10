import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:eventure/features/events/presentation/widgets/common/pages_header.dart';
import 'package:eventure/features/events/presentation/widgets/notifications_settings_page/notification.dart';
import 'package:eventure/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;

    return Scaffold(
      backgroundColor: kMainLight,
      body: BlocProvider(
        create: (context) =>
            getIt<NotificationsBloc>()..add(FetchNotifications()),
        child: SafeArea(
          child: Column(
            children: [
              PagesHeader(title: 'NOTIFICATIONS', hasBackBtn: true),
              Expanded(
                child: BlocBuilder<NotificationsBloc, NotificationsState>(
                  builder: (context, state) {
                    if (state is NotificationsLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is NotificationsLoaded) {
                      return ListView.builder(
                        itemCount: state.notifications.length,
                        itemBuilder: (context, index) {
                          final notification = state.notifications[index];
                          return NotificationItem(
                            title: notification.title,
                            eventId: notification.eventId,
                            time: notification.timestamp,
                          );
                        },
                      );
                    } else if (state is NotificationError) {
                      return Center(
                          child: Text(
                        'Error: ${state.message}',
                        style: TextStyle(color: kWhite),
                      ));
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
