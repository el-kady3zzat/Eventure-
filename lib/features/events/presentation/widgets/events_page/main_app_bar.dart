import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/blocs/user_data/user_data_cubit.dart';
import 'package:eventure/injection.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(
        SizeConfig.size(p: 140.h, l: 110.h),
      );

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;
    UI.context = context;
    double mainHeight = SizeConfig.size(p: 140.h, l: 110.h);
    double mainRadius = 20;

    return BlocProvider(
      create: (context) => getIt<UserDataCubit>()..getUserData(),
      child: BlocConsumer<UserDataCubit, UserDataState>(
        listener: (context, state) {
          if (state is UserDataError) {
            UI.errorSnack(context, state.msg);
          }
        },
        builder: (context, state) {
          UI.context = context;
          SizeConfig.mContext = context;
          bool isLoading = false;
          Map<String, dynamic> data = {};

          if (state is UserDataLoading) {
            isLoading = true;
          } else if (state is UserDataLoaded) {
            data = state.data;
          }
          return Skeletonizer(
            enabled: isLoading,
            child: Card(
              elevation: 10,
              shadowColor: kPrimaryLight,
              margin: REdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(mainRadius),
                  bottomRight: Radius.circular(mainRadius),
                ),
              ),
              child: AppBar(
                toolbarHeight: mainHeight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(mainRadius),
                    bottomRight: Radius.circular(mainRadius),
                  ),
                ),
                title: SizedBox(
                  height: mainHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: SizeConfig.size(p: 65.h, l: 100.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.place_outlined,
                                  color:
                                      UI.isDarkMode() ? kPrimaryLight : kWhite,
                                  size: SizeConfig.size(p: 25.h, l: 45.h),
                                ),
                                Text(
                                  data['location'] == null ||
                                          data['location'] == ''
                                      ? ' Egypt'
                                      : data['location'],
                                  style: TextStyle(
                                    color: kWhite,
                                    fontSize:
                                        SizeConfig.size(p: 14.sp, l: 6.sp),
                                  ),
                                ),
                              ],
                            ),
                            if (!SizeConfig.isPortrait())
                              Center(
                                child: Text(
                                  '${'events.hello'.tr()}, ${data['name'] == null || data['name'] == '' ? 'User' : data['name']}',
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    color: kWhite,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .pushNamed('/notification'),
                                  child: badges.Badge(
                                    badgeContent: Padding(
                                      padding: REdgeInsets.all(2.0.h),
                                      child: Text(
                                        '3',
                                        style: TextStyle(
                                          color: UI.isDarkMode()
                                              ? kPrimaryDark
                                              : kPrimaryLight,
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
                                      badgeColor: UI.isDarkMode()
                                          ? kPrimaryLight
                                          : kWhite,
                                      borderSide: BorderSide(
                                        width: 2.h,
                                        color: UI.isDarkMode()
                                            ? kPrimaryDark
                                            : kPrimaryLight,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.notifications_none_outlined,
                                      color: kWhite,
                                      size: SizeConfig.size(p: 25.h, l: 50.h),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                InkWell(
                                  onTap: () => Navigator.of(context)
                                      .pushNamed('/profile'),
                                  child: SizedBox(
                                    height: SizeConfig.size(p: 45.h, l: 85.h),
                                    width: SizeConfig.size(p: 45.h, l: 85.h),
                                    child: CircleAvatar(
                                      foregroundImage: data['image'] == null ||
                                              data['image'] == ''
                                          ? AssetImage(
                                              'assets/images/logo.webp')
                                          : CachedNetworkImageProvider(
                                              data['image']),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (SizeConfig.isPortrait())
                        SizedBox(
                          child: Text(
                            '${'events.hello'.tr()},\n${data.isEmpty ? 'User' : data['name']}',
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: kWhite,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      SizedBox(height: SizeConfig.size(p: 5.h, l: 0)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
