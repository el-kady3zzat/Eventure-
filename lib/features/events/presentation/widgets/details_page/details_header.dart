import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/features/events/presentation/widgets/common/favorite_btn.dart';
import 'package:flutter/material.dart';

class DetailsHeader extends StatelessWidget {
  final String eventId;
  const DetailsHeader({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;

    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BackButton(
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          FavoriteBtn(eventId: eventId)
        ],
      ),
    );
  }
}
