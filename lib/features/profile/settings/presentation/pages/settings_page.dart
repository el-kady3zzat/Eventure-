import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/pages/notifications_settings_page.dart';
import 'package:eventure/features/profile/settings/presentation/pages/settings_options/about_us_page.dart';
import 'package:eventure/features/profile/settings/presentation/pages/settings_options/change_password_page.dart';
import 'package:eventure/features/profile/settings/presentation/pages/settings_options/contact_screen.dart';
import 'package:eventure/features/profile/settings/presentation/pages/settings_options/privacy_page.dart';
import 'package:eventure/features/profile/settings/presentation/widgets/logout_button_widget.dart';
import 'package:eventure/features/profile/settings/presentation/widgets/settings_item.dart';
import 'package:eventure/features/profile/settings/presentation/widgets/settings_option_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? kPrimaryDark : kWhite;
    final textColor = isDarkMode ? kWhite : kPrimaryDark;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
              Text(
                'settings_screen.settings'.tr(),
                style: TextStyle(
                  fontSize: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 13.sp
                      : 17.sp,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: 25.h),

              // Settings Options
              SettingsOption(
                icon: LucideIcons.bell,
                title: 'settings_screen.notification_settings'.tr(),
                fun: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationsSettingsPage()),
                ),
              ),
              SettingsOption(
                icon: LucideIcons.fileLock,
                title: 'settings_screen.change_password'.tr(),
                fun: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                ),
              ),
              SettingsItem(title: 'events.theme'.tr(), icon: Icons.light),
              SettingsItem(title: 'events.language'.tr(), icon: Icons.language),
              SettingsOption(
                icon: LucideIcons.helpCircle,
                title: 'settings_screen.contact_us'.tr(),
                fun: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactUsScreen()),
                ),
              ),
              SettingsOption(
                icon: LucideIcons.lock,
                title: 'settings_screen.privacy_policy'.tr(),
                fun: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacyPage()),
                ),
              ),
              SettingsOption(
                icon: LucideIcons.info,
                title: 'settings_screen.about_us'.tr(),
                fun: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()),
                ),
              ),

              SizedBox(height: 20.h), // Added space

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: FittedBox(
                  child: LogoutButton(),
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
