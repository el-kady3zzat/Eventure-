import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationSettingsItem extends StatelessWidget {
  final String title;
  final bool state;
  final void Function(bool) onChanged;
  const NotificationSettingsItem({
    super.key,
    required this.title,
    required this.state,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;

    return Padding(
      padding: REdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: kWhite,
                fontSize: SizeConfig.size(p: 15.sp, l: 7.sp),
              ),
            ),
          ),
          Switch(
            value: state,
            onChanged: onChanged,
            activeColor: kWhite,
            activeTrackColor: kHeader,
            inactiveThumbColor: kDetails,
            inactiveTrackColor: kWhite,
          ),
        ],
      ),
    );
  }
}
