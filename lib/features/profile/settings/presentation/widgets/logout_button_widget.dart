import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/auth/firebase/firebase_auth_services.dart';
import 'package:eventure/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: kButton,
            foregroundColor: kDetails,
            padding: EdgeInsets.symmetric(
              horizontal:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 18.w
                      : 24.w,
              vertical:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 10.h
                      : 14.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
          onPressed: () {
            FirebaseService().signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false, 
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min, 
            children: [
              Icon(
                Icons.power_settings_new,
                size:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? 20.w
                        : 24.w,
                color: kDetails,
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  'settings_screen.logout'.tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? 12.sp
                        : 17.sp,
                    color: kDetails,
                  ),
                  overflow: TextOverflow.ellipsis, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
