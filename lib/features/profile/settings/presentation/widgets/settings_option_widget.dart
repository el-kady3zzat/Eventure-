import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function? fun;

  const SettingsOption(
      {required this.icon, required this.title, this.fun, super.key});

  @override
  Widget build(BuildContext context) {
     SizeConfig.mContext = context;
     UI.context = context;
    return InkWell(
      onTap: () {
        if (fun != null) {
          fun!();
        }
      },
      child: Stack(
      alignment: UI.uiAlign(context),
      children: [
        Container(
          margin:EdgeInsets.fromLTRB(
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
             
                IconButton(
                  padding: REdgeInsets.all(0),
                  icon: Icon(
                   Icons.arrow_forward_ios,
                    color: kButton,
                    size:  SizeConfig.size(p: 17.w, l: 11.w),
                  ),
                  onPressed: () {
                    if (fun != null) {
          fun!();
        }
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
            
                  icon,
              color: kPrimaryLight,
              size: SizeConfig.size(p: 20.h, l: 50.h),
            ),
          ),
        )
      ],
    )
    );
  }
}
