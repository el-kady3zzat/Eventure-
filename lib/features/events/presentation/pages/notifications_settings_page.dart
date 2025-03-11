import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/blocs/notification_settings/notification_settings_bloc.dart';
import 'package:eventure/features/events/presentation/widgets/common/pages_header.dart';
import 'package:eventure/features/events/presentation/widgets/notifications_settings_page/notification_settings_body.dart';
import 'package:eventure/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationsSettingsPage extends StatelessWidget {
  const NotificationsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;

    return Scaffold(
      backgroundColor: kSecondaryDark,
      body: BlocProvider(
        create: (context) =>
            getIt<NotificationSettingsBloc>()..add(FetchNotificationSettings()),
        child: SafeArea(
          child: Column(
            children: [
              PagesHeader(
                title: 'events.notification_settings'.tr(),
                hasBackBtn: true,
              ),
              Stack(
                children: [
                  Container(
                    margin: REdgeInsets.symmetric(horizontal: 20.w),
                    padding: REdgeInsets.fromLTRB(36, 16, 16, 16),
                    decoration: BoxDecoration(
                      color: kDetails,
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    child: BlocBuilder<NotificationSettingsBloc,
                        NotificationState>(
                      builder: (context, state) {
                        if (state is NotificationSettingsLoading ||
                            state is NotificationInitial) {
                          return Skeletonizer(
                            child: NotificationSettingsItems(settings: {}),
                          );
                        } else if (state is NotificationSettingsLoaded) {
                          final settings = state.notificationSettings;
                          return NotificationSettingsItems(settings: settings);
                        } else if (state is NotificationChannelUpdated) {
                          context
                              .read<NotificationSettingsBloc>()
                              .add(FetchNotificationSettings());
                          return Skeletonizer(
                            child: NotificationSettingsItems(settings: {}),
                          );
                        } else if (state is NotificationError) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'events.error_loading_settings'.tr(),
                                style: TextStyle(
                                    color: Colors.red, fontSize: 16.sp),
                              ),
                              SizedBox(height: 10.h),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<NotificationSettingsBloc>()
                                      .add(FetchNotificationSettings());
                                },
                                child: Text('events.retry'.tr()),
                              ),
                            ],
                          );
                        } else {
                          return Center(
                            child: Text(
                              'events.error_loading_settings'.tr(),
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 16.sp,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Transform.rotate(
                    angle: 12,
                    child: Container(
                      width: SizeConfig.size(p: 40.h, l: 80.h),
                      height: SizeConfig.size(p: 40.h, l: 80.h),
                      margin: REdgeInsets.only(top: 16),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(
                          Icons.notifications_outlined,
                          color: kPrimaryLight,
                          size: SizeConfig.size(p: 25.h, l: 50.h),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
