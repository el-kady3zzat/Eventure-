import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/pages/home_page.dart';
import 'package:eventure/features/profile/domain/managers/profile_manager.dart';
import 'package:eventure/features/profile/presentation/blocs/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileImage extends StatelessWidget {
  final ImageProvider<Object>? img;
  final BuildContext? con;

  ProfileImage({
    super.key,
    required this.img,
    this.con,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? kWhite : kPrimaryDark;
    final textColor = isDarkMode ? kPrimaryDark : kWhite;
    return StatefulBuilder(builder: (context, setState) {
      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
              radius:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 120.r
                      : 75.r,
              backgroundImage: img),
          InkWell(
            onTap: () {
              showBottomSheet(context, backgroundColor, textColor);
            },
            child: Container(
              padding:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? EdgeInsets.all(5.w)
                      : EdgeInsets.all(7.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryLight,
                border: Border.all(
                    color: kPrimaryDark,
                    width: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? 1.5.w
                        : 2.8.w),
              ),
              child: Icon(Icons.edit_outlined,
                  color: kWhite,
                  size: MediaQuery.of(context).orientation ==
                          Orientation.landscape
                      ? 12.w
                      : 20.w),
            ),
          ),
        ],
      );
    });
  }

  // Show bottom sheet for options (Camera, Gallery, Remove)
  void showBottomSheet(BuildContext context, Color bg, Color txt) {
    showModalBottomSheet(
      backgroundColor: bg,
      context: context,
      builder: (BuildContext modalContext) {
        return BlocProvider.value(
          // Ensure BlocProvider is available
          value: BlocProvider.of<EditProfileBloc>(context),
          child: Padding(
            padding: EdgeInsets.all(16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Colors.blue),
                  title: Text(
                    'profile.camera'.tr(),
                    style: TextStyle(color: txt),
                  ),
                  onTap: () {
                    ProfileManager().uploadImage(context, true);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library, color: Colors.green),
                  title: Text(
                    'profile.gallery'.tr(),
                    style: TextStyle(color: txt),
                  ),
                  onTap: () {
                    ProfileManager().uploadImage(context, false);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete_forever, color: Colors.red),
                  title: Text(
                    'profile.remove'.tr(),
                    style: TextStyle(color: txt),
                  ),
                  onTap: () {
                    ProfileManager().removeImage(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
