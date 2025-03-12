import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/blocs/notifications/notifications_bloc.dart';
import 'package:eventure/injection.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationsBadge extends StatelessWidget {
  const NotificationsBadge({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;
    UI.context = context;

    return BlocProvider(
      create: (context) =>
          getIt<NotificationsBloc>()..add(FetchNotifications()),
      child: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          SizeConfig.mContext = context;
          UI.context = context;
          bool isLoading = false;
          List notifications = [];

          if (state is NotificationsLoading) {
            isLoading = true;
          } else if (state is NotificationsLoaded) {
            notifications = state.notifications;
          }

          return Skeletonizer(
            enabled: isLoading,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                '/notification',
                arguments: notifications,
              ),
              child: badges.Badge(
                badgeContent: Padding(
                  padding: REdgeInsets.all(2.0.h),
                  child: Text(
                    notifications.length.toString(),
                    style: TextStyle(
                      color: UI.isDarkMode() ? kPrimaryDark : kPrimaryLight,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.size(
                        p: 10.sp,
                        l: 4.sp,
                      ),
                    ),
                  ),
                ),
                position: badges.BadgePosition.topStart(
                  start: SizeConfig.size(p: 14.h, l: 28.h),
                ),
                badgeStyle: badges.BadgeStyle(
                  badgeColor: UI.isDarkMode() ? kPrimaryLight : kWhite,
                  borderSide: BorderSide(
                    width: 2.h,
                    color: UI.isDarkMode() ? kPrimaryDark : kPrimaryLight,
                  ),
                ),
                child: Icon(
                  Icons.notifications_none_outlined,
                  color: kWhite,
                  size: SizeConfig.size(p: 25.h, l: 50.h),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
