import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/blocs/nav_bar/nav_bar_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBarCubit, int>(
      builder: (context, pageIndex) {
        SizeConfig.mContext = context;
        UI.context = context;

        return AnimatedBottomNavigationBar(
          height: SizeConfig.size(p: 65.h, l: 95.h),
          backgroundColor: UI.isDarkMode() ? kPrimaryDark : kPrimaryLight,
          activeColor: UI.isDarkMode() ? kPrimaryLight : kButton,
          inactiveColor: kWhite,
          iconSize: SizeConfig.size(p: 30, l: 25),
          icons: [
            Icons.dashboard_rounded,
            Icons.calendar_month_rounded,
            Icons.favorite_rounded,
            Icons.settings_rounded,
          ],
          activeIndex: pageIndex,
          gapLocation: GapLocation.none,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          onTap: (index) => context.read<NavBarCubit>().changePage(index),
        );
      },
    );
  }
}
