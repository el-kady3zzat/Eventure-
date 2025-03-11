import 'package:easy_localization/easy_localization.dart';
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
          title: 'events.show_all_notifications'.tr(),
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
        Divider(color: kPrimaryDark, thickness: 1.5),
        NotificationSettingsItem(
          title: 'events.booked_events_reminder'.tr(),
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
          title: 'events.favorite_events_reminder'.tr(),
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
