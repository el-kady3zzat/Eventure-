import 'package:eventure/core/utils/size/size_config.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/events/presentation/blocs/favorite_btn/favorite_btn_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteBtn extends StatelessWidget {
  final String eventId;
  const FavoriteBtn({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    SizeConfig.mContext = context;

    late bool isInFavorite;
    return SizedBox(
      height: SizeConfig.size(p: 65.h, l: 90.h),
      width: SizeConfig.size(p: 65.h, l: 90.h),
      child: Card(
        margin: REdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(150)),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: BlocBuilder<FavoriteBtnBloc, FavoriteBtnState>(
            builder: (context, state) {
              SizeConfig.mContext = context;

              isInFavorite = state is FavoriteBtnLoaded
                  ? state.eventsId.contains(eventId)
                  : false;
              return Icon(
                isInFavorite ? Icons.favorite : Icons.favorite_border,
                color: isInFavorite ? kHeader : null,
                size: SizeConfig.size(p: 20.h, l: 35.h),
              );
            },
          ),
          onPressed: () => _updateFavorite(context, isInFavorite),
        ),
      ),
    );
  }

  void _updateFavorite(BuildContext context, bool isInFavorite) {
    if (isInFavorite) {
      context.read<FavoriteBtnBloc>().add(RemoveFromFavoriteIds(eventId));
    } else {
      context.read<FavoriteBtnBloc>().add(AddToFavoriteIds(eventId));
    }
  }
}
