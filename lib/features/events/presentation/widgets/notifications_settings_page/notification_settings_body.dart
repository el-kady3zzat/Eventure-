import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/blocs/notification_settings/notification_settings_bloc.dart';
import 'package:eventure/features/events/presentation/widgets/notifications_settings_page/notification_settings_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationSettingsItems extends StatelessWidget {
  final Map<String, bool> settings;
  const NotificationSettingsItems({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NotificationSettingsItem(
          title: 'Show all Notifications',
          state: settings['general_channel'] ?? true,
          onChanged: (val) {
            context.read<NotificationSettingsBloc>().add(
                  ToggleNotificationChannel(
                    'general_channel',
                    val,
                  ),
                );
          },
        ),
        Divider(color: kMainDark, thickness: 1.5),
        NotificationSettingsItem(
          title: 'Booked Events Reminder',
          state: settings['booked_events_channel'] ?? true,
          onChanged: (val) {
            context.read<NotificationSettingsBloc>().add(
                  ToggleNotificationChannel(
                    'booked_events_channel',
                    val,
                  ),
                );
          },
        ),
        NotificationSettingsItem(
          title: 'Favorite Events Reminder',
          state: settings['favorite_events_channel'] ?? true,
          onChanged: (val) {
            context.read<NotificationSettingsBloc>().add(
                  ToggleNotificationChannel(
                    'favorite_events_channel',
                    val,
                  ),
                );
          },
        ),
      ],
    );
  }
}
