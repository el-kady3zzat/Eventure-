import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/blocs/calendar_design/calendar_cubit.dart';
import 'package:eventure/features/events/presentation/widgets/schedule_page/arrow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class GridHeader extends StatelessWidget {
  final DateTime currentMonth;
  const GridHeader({super.key, required this.currentMonth});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;
    UI.context = context;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Arrow(
          icon: Icons.arrow_back_rounded,
          onPress: () => context.read<CalendarCubit>().selectMonth(
                DateTime(
                  currentMonth.year,
                  currentMonth.month - 1,
                ),
              ),
        ),
        Text(
          DateFormat.yMMM().format(currentMonth),
          style: TextStyle(
            fontSize: SizeConfig.size(p: 16.sp, l: 6.sp),
            fontWeight: FontWeight.bold,
            color: UI.isDarkMode() ? kWhite : kPrimaryLight,
          ),
        ),
        Arrow(
          icon: Icons.arrow_forward_rounded,
          onPress: () => context.read<CalendarCubit>().selectMonth(
                DateTime(currentMonth.year, currentMonth.month + 1),
              ),
        ),
      ],
    );
  }
}
