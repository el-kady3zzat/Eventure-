import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool showAllNotifications = true;
  bool liveNotification = false;
  bool invitationNotification = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainLight,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: kWhite,
                    size: 21.w,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Spacer(),
                Text("NOTIFICATION SETTINGS",
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: kWhite)),
                Spacer(),
              ],
            ),
            SizedBox(height: 25.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: kDetails,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: kWhite,
                          child: Icon(LucideIcons.bell,
                              color: kHeader, size: 20.w),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text("Show all Notifications",
                            style: TextStyle(color: kWhite, fontSize: 16.sp)),
                        Spacer(),
                        Switch(
                            value: showAllNotifications,
                            onChanged: (val) {
                              setState(() {
                                showAllNotifications = val;
                              });
                            },
                            activeColor: kHeader,
                            inactiveThumbColor: kDetails),
                      ],
                    ),
                    Divider(
                      color: kGrey,
                      thickness: 0.5.w,
                    ),
                    _buildNotificationItem(
                      title: "Live notification",
                      value: liveNotification,
                      onChanged: (val) {
                        setState(() {
                          liveNotification = val;
                        });
                      },
                    ),
                    _buildNotificationItem(
                      title: "Invitation notification",
                      value: invitationNotification,
                      onChanged: (val) {
                        setState(() {
                          invitationNotification = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: kGrey, fontSize: 15.sp),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: kHeader,
            inactiveThumbColor: kDetails,
          ),
        ],
      ),
    );
  }
}
