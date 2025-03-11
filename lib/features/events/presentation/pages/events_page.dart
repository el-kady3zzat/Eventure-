import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/constants/dummy_data.dart';
import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/features/events/presentation/widgets/common/event_card.dart';
import 'package:eventure/features/events/presentation/blocs/event/event_bloc.dart';
import 'package:eventure/features/events/presentation/widgets/events_page/main_app_bar.dart';
import 'package:eventure/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;
    UI.context = context;

    return Scaffold(
      appBar: MainAppBar(),
      body: BlocProvider(
        create: (context) => getIt<EventBloc>()..add(FetchEvents()),
        child: BlocConsumer<EventBloc, EventState>(
          listener: (context, state) {
            if (state is EventError) {
              UI.errorSnack(context, state.msg);
            }
          },
          builder: (context, state) {
            if (state is EventLoading) {
              final events = List.filled(3, kDummyEvent);
              return Skeletonizer(
                child: ListView.builder(
                  scrollDirection:
                      SizeConfig.isPortrait() ? Axis.vertical : Axis.horizontal,
                  padding: EdgeInsets.all(12),
                  itemCount: events.length,
                  itemBuilder: (context, index) => EventCard(
                    event: events[index],
                  ),
                ),
              );
            } else if (state is EventLoaded) {
              return ListView.builder(
                scrollDirection:
                    SizeConfig.isPortrait() ? Axis.vertical : Axis.horizontal,
                padding: EdgeInsets.all(12),
                itemCount: state.events.length,
                itemBuilder: (context, index) => EventCard(
                  event: state.events[index],
                ),
              );
            }
            return Center(
              child: Text('events.no_events'.tr()),
            );
          },
        ),
      ),
    );
  }
}
