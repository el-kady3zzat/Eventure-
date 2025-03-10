import 'package:eventure/core/utils/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// custom resuable widget implements every row in profile
class ProfileItem extends StatelessWidget {
  final String txt;
  final IconData icon;
  final bool? isObscure;

 
   ProfileItem({
    super.key,
    required this.txt,
    required this.icon,
    this.isObscure,
   
  
  });

  @override
  Widget build(BuildContext context) {

 final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDarkMode ? kWhite : kMainDark;
    final Color textColor = isDarkMode ? kWhite : kMainDark;

    return ListTile(
      title: Text(
        isObscure == true ? txt : txt.replaceAll(RegExp(r"."), "*"),
        style: TextStyle(
          fontSize: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 12.sp : 18.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      leading: Container(
        padding: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? EdgeInsets.all(5).w : EdgeInsets.all(9).w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          backgroundColor: bg,
          child: Icon(icon, color: kHeader, size: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 12.sp:  20.w),
        ),
      ),
    );
  }
}
