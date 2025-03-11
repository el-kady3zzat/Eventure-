import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/domain/entities/event.dart';
import 'package:eventure/features/events/presentation/blocs/scroll/scroll_bloc.dart';
import 'package:eventure/features/events/presentation/widgets/details_page/details_container.dart';
import 'package:eventure/features/events/presentation/widgets/details_page/details_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;
    Event event = ModalRoute.of(context)!.settings.arguments as Event;

    return Scaffold(
      backgroundColor: kSecondaryDark.withValues(alpha: 0.1),
      body: SizedBox(
        height: 1.sh,
        child: SizeConfig.isPortrait()
            ? Stack(
                children: [
                  SizedBox(
                    width: SizeConfig.size(p: 1.sw, l: 1.sw),
                    height: SizeConfig.size(p: 0.6.sh, l: 1.sw),
                    child: isValidUrl(event.cover)
                        ? CachedNetworkImage(
                            imageUrl: event.cover,
                            fit: BoxFit.cover,
                          )
                        : Image.memory(
                            base64Decode(event.cover),
                            fit: BoxFit.cover,
                          ),
                  ),
                  DetailsContainer(event: event),
                  DetailsHeader(eventId: event.id),
                ],
              )
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  context
                      .read<ScrollBloc>()
                      .add(ScrollUpdated(scrollInfo.metrics.pixels));
                  return true;
                },
                child: Stack(
                  children: [
                    SizedBox(
                      width: SizeConfig.size(p: 1.sw, l: 1.sw),
                      height: SizeConfig.size(p: 0.6.sh, l: 1.sw),
                      child: CachedNetworkImage(
                        imageUrl: event.cover,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          // Space before overlay appears
                          SizedBox(height: 300),
                          BlocBuilder<ScrollBloc, ScrollState>(
                            builder: (context, state) {
                              return SizedBox(
                                child: DetailsContainer(event: event),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    DetailsHeader(eventId: event.id),
                  ],
                ),
              ),
      ),
    );
  }

  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }
}
