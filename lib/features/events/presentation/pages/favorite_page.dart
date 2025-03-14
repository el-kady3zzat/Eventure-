import 'package:easy_localization/easy_localization.dart';
import 'package:eventure/core/utils/constants/dummy_data.dart';
import 'package:eventure/core/utils/helper/ui.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/features/events/presentation/widgets/common/event_card.dart';
import 'package:eventure/features/events/presentation/blocs/favorite/favorite_bloc.dart';
import 'package:eventure/features/events/presentation/widgets/common/pages_header.dart';
import 'package:eventure/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;

    return SafeArea(
      child: Scaffold(
        // backgroundColor: kSecondaryDark,
        body: SizedBox(
          height: 1.sh,
          child: Column(
            children: [
              PagesHeader(title: 'events.favorites'.tr()),
              Expanded(
                child: BlocProvider(
                  create: (context) =>
                      getIt<FavoriteBloc>()..add(FetchFavoriteEvents()),
                  child: BlocConsumer<FavoriteBloc, FavoriteState>(
                    listener: (context, state) {
                      if (state is FavoriteEventsError) {
                        UI.errorSnack(context, state.msg);
                      }
                    },
                    builder: (context, state) {
                      if (state is FavoriteEventsLoading) {
                        final events = List.filled(3, kDummyEvent);
                        return Skeletonizer(
                          child: ListView.builder(
                            scrollDirection: SizeConfig.isPortrait()
                                ? Axis.vertical
                                : Axis.horizontal,
                            padding: EdgeInsets.all(12),
                            itemCount: events.length,
                            itemBuilder: (context, index) => EventCard(
                              event: events[index],
                            ),
                          ),
                        );
                      } else if (state is FavoriteEventsLoaded) {
                        return state.events.isNotEmpty
                            ? ListView.builder(
                                scrollDirection: SizeConfig.isPortrait()
                                    ? Axis.vertical
                                    : Axis.horizontal,
                                padding: EdgeInsets.all(12),
                                itemCount: state.events.length,
                                itemBuilder: (context, index) => EventCard(
                                  event: state.events[index],
                                ),
                              )
                            : Center(
                                child: Text(
                                  'events.fav_list_empty'.tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        SizeConfig.size(p: 18.sp, l: 18.sp),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                      } else if (state is FavoriteEventsError) {
                        return Center(
                          child: Text(
                            '${'events.error_with_state'.tr()} $state',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
