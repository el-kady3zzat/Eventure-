import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/core/utils/theme/theme_cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'dart:ui' as ui;

class SettingsItem extends StatelessWidget {
  final String title;
  final IconData icon;
  const SettingsItem({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;
    UI.context = context;

    return Stack(
      alignment: UI.uiAlign(context),
      children: [
        Container(
          margin: REdgeInsets.fromLTRB(
            SizeConfig.size(
              p: UI.uiDir(en: 36.w, ar: 16.w),
              l: UI.uiDir(en: 36.w, ar: 24.w),
            ),
            8,
            SizeConfig.size(
              p: UI.uiDir(en: 16.w, ar: 36),
              l: UI.uiDir(en: 24.w, ar: 36.w),
            ),
            8,
          ),
          padding: REdgeInsets.fromLTRB(
            UI.uiDir(en: 20.w, ar: 8.w),
            8,
            UI.uiDir(en: 8.w, ar: 36.w),
            8,
          ),
          decoration: BoxDecoration(
            color: kDetails,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: kWhite,
                  fontSize: SizeConfig.size(p: 13.sp, l: 6.sp),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (title == 'events.theme'.tr())
                IconButton(
                  padding: REdgeInsets.all(0),
                  icon: Icon(
                    UI.isDarkMode() ? Icons.light_mode : Icons.dark_mode,
                    color: kButton,
                  ),
                  onPressed: () {
                    context.read<ThemeCubit>().toggleTheme();
                    UI.infoSnack(context, 'settings.theme_changed'.tr());
                  },
                ),
              if (title == 'events.language'.tr())
                IconButton(
                  padding: REdgeInsets.all(0),
                  icon: Icon(
                    icon,
                    color: kButton,
                  ),
                  onPressed: () {
                    _showLanguageDialog(context);
                  },
                ),
            ],
          ),
        ),
        Container(
          width: SizeConfig.size(p: 40.h, l: 80.h),
          height: SizeConfig.size(p: 40.h, l: 80.h),
          margin: REdgeInsets.only(
            left: SizeConfig.size(
              p: UI.uiDir(en: 14, ar: 0),
              l: UI.uiDir(en: 46, ar: 0),
            ),
            right: SizeConfig.size(
              p: UI.uiDir(en: 0, ar: 14),
              l: UI.uiDir(en: 0, ar: 46),
            ),
          ),
          child: Card(
            color: UI.isDarkMode() ? kWhite : kSecondaryDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: BorderSide(
                color: UI.isDarkMode() ? kPrimaryDark : kWhite,
                width: 2,
              ),
            ),
            child: Icon(
              title == 'events.theme'.tr()
                  ? UI.isDarkMode()
                      ? Icons.light_mode
                      : Icons.dark_mode
                  : icon,
              color: kPrimaryLight,
              size: SizeConfig.size(p: 20.h, l: 50.h),
            ),
          ),
        )
      ],
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('settings.select_language'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                context.setLocale(const Locale('en'));
                Navigator.pop(context);
                UI.successSnack(
                  context,
                  'settings.language_changed'.tr(),
                );
              },
            ),
            ListTile(
              title: const Text('العربية'),
              onTap: () {
                context.setLocale(const Locale('ar'));
                Navigator.pop(context);
                UI.successSnack(
                  context,
                  'settings.language_changed'.tr(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
