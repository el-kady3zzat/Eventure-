import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/blocs/calendar/calendar_bloc.dart';
import 'package:eventure/features/events/presentation/widgets/schedule_page/calendar_grid.dart';
import 'package:eventure/features/events/presentation/widgets/schedule_page/events_list.dart';
import 'package:eventure/features/events/presentation/widgets/schedule_page/grid_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:eventure/features/events/domain/entities/event.dart';
import 'package:eventure/features/events/presentation/blocs/calendar_design/calendar_cubit.dart';
import 'package:eventure/injection.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SchedulePage extends StatelessWidget {
  SchedulePage({super.key});

  final Map<int, FocusNode> focusNodes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainLight,
      // appBar: CalendarAppBar(),
      body: SafeArea(
        child: BlocProvider(
          create: (_) => getIt<CalendarCubit>(),
          child: BlocBuilder<CalendarCubit, DateTime>(
            builder: (context, currentMonth) {
              SizeConfig.mContext = context;

              return SizedBox(
                height: 1.sh,
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.size(p: 70.h, l: 100.h),
                      child: Center(
                        child: Text(
                          'SCHEDULE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.size(p: 18.sp, l: 18.sp),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GridHeader(currentMonth: currentMonth),
                    SizedBox(height: SizeConfig.size(p: 20, l: 10)),
                    BlocProvider(
                      create: (context) =>
                          CalendarBloc()..add(FetchCalendarEvents()),
                      child: BlocConsumer<CalendarBloc, CalendarEventsState>(
                        listener: (context, state) {
                          if (state is CalendarError) {
                            UI.errorSnack(context, state.msg);
                          }
                        },
                        builder: (context, state) {
                          if (state is CalendarLoading) {
                            return Skeletonizer(
                              child: CalendarGrid(
                                currentMonth: currentMonth,
                                events: [],
                              ),
                            );
                          } else if (state is CalendarLoaded) {
                            List<Event> eventsOfCurrentMonth = [];
                            eventsOfCurrentMonth.addAll(
                              state.events.where(
                                (event) =>
                                    event.dateTime.month == currentMonth.month,
                              ),
                            );
                            eventsOfCurrentMonth.sort(
                              (a, b) =>
                                  a.dateTime.day.compareTo(b.dateTime.day),
                            );

                            return Expanded(
                              child: Column(
                                children: [
                                  CalendarGrid(
                                    currentMonth: currentMonth,
                                    events: state.events,
                                  ),
                                  Expanded(child: SizedBox()),
                                  if (SizeConfig.isPortrait())
                                    EventsList(
                                      events: eventsOfCurrentMonth,
                                    ),
                                ],
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
